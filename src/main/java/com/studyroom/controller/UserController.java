package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.Seat;
import com.studyroom.entity.StudyRoom;
import com.studyroom.entity.User;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SeatService;
import com.studyroom.service.StudyRoomService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/info")
    public Result<User> getUserInfo(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        User currentUser = userService.getById(user.getId());
        currentUser.setPassword(null);
        return Result.success(currentUser);
    }

    @PutMapping("/profile")
    public Result<User> updateProfile(@RequestBody User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        user.setId(currentUser.getId());
        user.setUpdateTime(LocalDateTime.now());
        boolean success = userService.updateById(user);
        if (success) {
            return Result.success("更新成功", user);
        }
        return Result.error(500, "更新失败");
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getUserStats(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        Map<String, Object> stats = new HashMap<>();
        
        // 累计预约次数
        LambdaQueryWrapper<Reservation> reservationWrapper = new LambdaQueryWrapper<>();
        reservationWrapper.eq(Reservation::getUserId, user.getId());
        long totalReservations = reservationService.count(reservationWrapper);
        stats.put("totalReservations", totalReservations);
        
        // 已签到的预约（签到时间不为空即有效学习时长）
        LambdaQueryWrapper<Reservation> checkedWrapper = new LambdaQueryWrapper<>();
        checkedWrapper.eq(Reservation::getUserId, user.getId())
                      .isNotNull(Reservation::getCheckInTime);
        List<Reservation> checkedReservations = reservationService.list(checkedWrapper);
        
        // 计算学习时长（小时）：已签到且已签退的累计时间
        double totalHours = 0;
        Set<LocalDate> studyDays = new HashSet<>();
        for (Reservation r : checkedReservations) {
            if (r.getCheckInTime() != null) {
                studyDays.add(r.getCheckInTime().toLocalDate());
                if (r.getCheckOutTime() != null) {
                    Duration d = Duration.between(r.getCheckInTime(), r.getCheckOutTime());
                    totalHours += d.toMinutes() / 60.0;
                } else {
                    // 未签退按2小时计算
                    totalHours += 2.0;
                }
            }
        }
        stats.put("totalHours", Math.round(totalHours * 10) / 10.0);
        stats.put("totalDays", studyDays.size());
        
        // 连续天数（从今天往前连续）
        int streak = 0;
        LocalDate day = LocalDate.now();
        while (studyDays.contains(day)) {
            streak++;
            day = day.minusDays(1);
        }
        stats.put("streak", streak);
        
        return Result.success(stats);
    }

    @GetMapping("/chart")
    public Result<Map<String, Object>> getUserChart(HttpSession session,
            @RequestParam(defaultValue = "week") String type) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, user.getId())
               .isNotNull(Reservation::getCheckInTime);
        List<Reservation> list = reservationService.list(wrapper);
        
        // 按日期分组统计学习时长
        Map<LocalDate, Double> dailyHours = new HashMap<>();
        for (Reservation r : list) {
            if (r.getCheckInTime() != null) {
                LocalDate d = r.getCheckInTime().toLocalDate();
                double hours = 2.0;
                if (r.getCheckOutTime() != null) {
                    hours = Duration.between(r.getCheckInTime(), r.getCheckOutTime()).toMinutes() / 60.0;
                }
                dailyHours.merge(d, hours, Double::sum);
            }
        }
        
        if ("week".equals(type)) {
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MM/dd");
            LocalDate today = LocalDate.now();
            for (int i = 6; i >= 0; i--) {
                LocalDate d = today.minusDays(i);
                labels.add(d.format(fmt));
                data.add(Math.round(dailyHours.getOrDefault(d, 0.0) * 10) / 10.0);
            }
        } else {
            // 近30天按周汇总
            DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MM/dd");
            LocalDate today = LocalDate.now();
            for (int w = 3; w >= 0; w--) {
                LocalDate weekStart = today.minusDays((long) w * 7 + 6);
                LocalDate weekEnd = today.minusDays((long) w * 7);
                double sum = 0;
                for (int d = 0; d <= 6; d++) {
                    sum += dailyHours.getOrDefault(weekStart.plusDays(d), 0.0);
                }
                labels.add(weekStart.format(fmt) + "~" + weekEnd.format(fmt));
                data.add(Math.round(sum * 10) / 10.0);
            }
        }
        
        result.put("labels", labels);
        result.put("data", data);
        return Result.success(result);
    }
}
