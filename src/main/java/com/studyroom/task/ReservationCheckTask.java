package com.studyroom.task;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.Seat;
import com.studyroom.entity.User;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SeatService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Component
public class ReservationCheckTask {

    @Autowired
    private ReservationService reservationService;
    @Autowired
    private UserService userService;
    @Autowired
    private SeatService seatService;

    // 每分钟执行一次，扫描迟到15分钟未签到的记录
    @Scheduled(cron = "0 * * * * ?")
    public void checkOverdueReservations() {
        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now();

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getStatus, 0)
                .eq(Reservation::getReservationDate, today)
                .lt(Reservation::getStartTime, now.minusMinutes(15));

        List<Reservation> overdueList = reservationService.list(wrapper);
        for (Reservation res : overdueList) {
            // 设置为违约(3)
            res.setStatus(3);
            res.setUpdateTime(LocalDateTime.now());
            reservationService.updateById(res);

            // 释放座位
            Seat seat = seatService.getById(res.getSeatId());
            if (seat != null) {
                seat.setStatus(1);
                seatService.updateById(seat);
            }

            // 增加用户违约次数，连续签到清零
            User user = userService.getById(res.getUserId());
            if (user != null) {
                user.setViolationCount(user.getViolationCount() == null ? 1 : user.getViolationCount() + 1);
                user.setContinuousCheckinDays(0);
                userService.updateById(user);
            }
        }
    }
}