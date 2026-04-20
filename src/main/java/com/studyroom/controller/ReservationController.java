package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.studyroom.common.Result;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.Seat;
import com.studyroom.entity.StudyRoom;
import com.studyroom.entity.SysSetting;
import com.studyroom.entity.User;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SeatService;
import com.studyroom.service.StudyRoomService;
import com.studyroom.service.SysSettingService;
import com.studyroom.service.UserMoralRecordService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/reservation")
public class ReservationController {

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private SysSettingService sysSettingService;

    @GetMapping("/my")
    public Result<List<Map<String, Object>>> getMyReservations(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, user.getId());
        wrapper.orderByDesc(Reservation::getCreateTime);
        List<Reservation> reservations = reservationService.list(wrapper);
        
        List<Map<String, Object>> result = new ArrayList<>();
        for (Reservation r : reservations) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            
            StudyRoom room = studyRoomService.getById(r.getRoomId());
            Seat seat = seatService.getById(r.getSeatId());
            
            map.put("roomName", room != null ? room.getName() : "未知");
            map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知");
            map.put("building", room != null ? room.getBuilding() : "未知");
            // status=3 且有cancelReason（定时任务自动违约）则标记为违约
            map.put("isViolation", r.getStatus() != null && r.getStatus() == 3
                    && r.getCancelReason() != null && !r.getCancelReason().isEmpty());

            result.add(map);
        }
        
        return Result.success(result);
    }

    @GetMapping("/active")
    public Result<Map<String, Object>> getActiveReservation(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, user.getId());
        wrapper.eq(Reservation::getReservationDate, LocalDate.now());
        wrapper.in(Reservation::getStatus, 0, 1);
        wrapper.orderByDesc(Reservation::getCreateTime);
        wrapper.last("LIMIT 1");
        
        Reservation reservation = reservationService.getOne(wrapper);
        if (reservation == null) {
            return Result.success(null);
        }
        
        Map<String, Object> map = new HashMap<>();
        map.put("id", reservation.getId());
        map.put("status", reservation.getStatus());
        map.put("reservationDate", reservation.getReservationDate());
        map.put("startTime", reservation.getStartTime());
        map.put("endTime", reservation.getEndTime());
        
        StudyRoom room = studyRoomService.getById(reservation.getRoomId());
        Seat seat = seatService.getById(reservation.getSeatId());
        
        map.put("roomName", room != null ? room.getName() : "未知");
        map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知");
        
        // 判断是否可以签到（在预约时间范围内）
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startDateTime = LocalDateTime.of(reservation.getReservationDate(), reservation.getStartTime());
        LocalDateTime endDateTime = LocalDateTime.of(reservation.getReservationDate(), reservation.getEndTime());
        
        // 预约当天开始前30分钟到结束时间之间都可以签到
        boolean canCheckIn = reservation.getStatus() == 0 && 
                            now.isAfter(startDateTime.minusMinutes(30)) && 
                            now.isBefore(endDateTime);
        map.put("canCheckIn", canCheckIn);
        
        return Result.success(map);
    }

    /**
     * 获取座位的已被预约时间段（简化版）
     */
    @GetMapping("/seat/{seatId}/occupied-times")
    public Result<List<Map<String, Object>>> getSeatOccupiedTimes(@PathVariable Long seatId, 
                                                                   @RequestParam String date,
                                                                   HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        LocalDate reservationDate = LocalDate.parse(date);
        
        // 查询该座位在该日期的所有有效预约（非取消状态）
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getSeatId, seatId);
        wrapper.eq(Reservation::getReservationDate, reservationDate);
        wrapper.notIn(Reservation::getStatus, 3, 4); // 排除已违约/已取消
        
        List<Reservation> reservations = reservationService.list(wrapper);
        
        List<Map<String, Object>> result = reservations.stream().map(r -> {
            Map<String, Object> map = new HashMap<>();
            map.put("startTime", r.getStartTime().toString());
            map.put("endTime", r.getEndTime().toString());
            map.put("status", r.getStatus());
            return map;
        }).collect(Collectors.toList());
        
        return Result.success(result);
    }
    
    /**
     * 获取座位的已预约列表（包含用户信息）
     */
    @Autowired
    private UserService userService;

    @Autowired
    private UserMoralRecordService userMoralRecordService;
    
    @GetMapping("/seat/{seatId}/occupied-list")
    public Result<List<Map<String, Object>>> getSeatOccupiedList(@PathVariable Long seatId, 
                                                                  @RequestParam String date,
                                                                  HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        
        LocalDate reservationDate = LocalDate.parse(date);
        
        // 查询该座位在该日期的所有有效预约（非取消状态）
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getSeatId, seatId);
        wrapper.eq(Reservation::getReservationDate, reservationDate);
        wrapper.notIn(Reservation::getStatus, 3, 4); // 排除已违约/已取消
        wrapper.orderByAsc(Reservation::getStartTime);
        
        List<Reservation> reservations = reservationService.list(wrapper);
        
        List<Map<String, Object>> result = new ArrayList<>();
        for (Reservation r : reservations) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("userId", r.getUserId());
            map.put("startTime", r.getStartTime().toString());
            map.put("endTime", r.getEndTime().toString());
            // 已完成的预约：实际占用到签退时间，之后的时段可重新预约
            String effectiveEndTime = r.getEndTime().toString();
            if (r.getStatus() == 2 && r.getCheckOutTime() != null) {
                effectiveEndTime = r.getCheckOutTime().toLocalTime().toString();
            }
            map.put("effectiveEndTime", effectiveEndTime);
            map.put("status", r.getStatus());
            
            // 获取用户信息
            User user = userService.getById(r.getUserId());
            if (user != null) {
                // 保护隐私：如果不是当前用户，隐藏真实姓名，只显示昵称或部分信息
                if (r.getUserId().equals(currentUser.getId())) {
                    map.put("userName", "我");
                    map.put("isMine", true);
                } else {
                    // 显示为"用户XXX"，保护隐私
                    map.put("userName", "用户" + user.getId());
                    map.put("isMine", false);
                }
            } else {
                map.put("userName", "未知用户");
                map.put("isMine", false);
            }
            
            result.add(map);
        }
        
        return Result.success(result);
    }

    @PostMapping("/create")
    public Result<String> createReservation(@RequestBody Map<String, Object> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }

        // 检查用户是否被禁约
        User currentUser = userService.getById(user.getId());
        int maxViolation = 3;
        SysSetting maxSetting = sysSettingService.getOne(
                new LambdaQueryWrapper<SysSetting>().eq(SysSetting::getSettingKey, "max_violation_limit"));
        if (maxSetting != null) {
            try { maxViolation = Integer.parseInt(maxSetting.getSettingValue()); } catch (Exception ignored) {}
        }
        int violationCount = currentUser.getViolationCount() != null ? currentUser.getViolationCount() : 0;
        if (violationCount >= maxViolation) {
            return Result.error(403, "您的违约次数已达上限，暂时无法预约");
        }
        
        Long roomId = Long.valueOf(params.get("roomId").toString());
        Long seatId = Long.valueOf(params.get("seatId").toString());
        LocalDate reservationDate = LocalDate.parse(params.get("reservationDate").toString());
        LocalTime startTime = LocalTime.parse(params.get("startTime").toString());
        LocalTime endTime = LocalTime.parse(params.get("endTime").toString());
        
        // 1. 禁止预约过去时间
        LocalDate today = LocalDate.now();
        if (reservationDate.isBefore(today)) {
            return Result.error(400, "不能预约过去的日期");
        }
        if (reservationDate.equals(today) && startTime.isBefore(LocalTime.now())) {
            return Result.error(400, "不能预约已过去的时间段");
        }

        // 2. 检查时间合理性
        if (startTime.isAfter(endTime) || startTime.equals(endTime)) {
            return Result.error(400, "结束时间必须晚于开始时间");
        }
        
        // 3. 检查预约时长（最多4小时）
        if (java.time.Duration.between(startTime, endTime).toHours() > 4) {
            return Result.error(400, "单次预约时长不能超过4小时");
        }
        
        // 4. 检查座位是否存在且可用
        Seat seat = seatService.getById(seatId);
        if (seat == null || seat.getStatus() == 0) {
            return Result.error(400, "该座位不可用");
        }
        
        // 5. 检查时段冲突 - 该座位在该时间段是否已被预约
        LambdaQueryWrapper<Reservation> conflictWrapper = new LambdaQueryWrapper<>();
        conflictWrapper.eq(Reservation::getSeatId, seatId);
        conflictWrapper.eq(Reservation::getReservationDate, reservationDate);
        conflictWrapper.notIn(Reservation::getStatus, 3, 4); // 排除已违约和已取消

        List<Reservation> existingReservations = reservationService.list(conflictWrapper);

        for (Reservation existing : existingReservations) {
            // 已完成的预约：以实际签退时间为准（签退后立即释放剩余时段）
            LocalTime effectiveEnd = existing.getEndTime();
            if (existing.getStatus() == 2 && existing.getCheckOutTime() != null) {
                effectiveEnd = existing.getCheckOutTime().toLocalTime();
            }
            if (isTimeOverlap(startTime, endTime, existing.getStartTime(), effectiveEnd)) {
                return Result.error(400, "该时间段已被预约，请选择其他时段或座位");
            }
        }

        // 6. 检查用户是否有冲突的预约
        LambdaQueryWrapper<Reservation> userConflictWrapper = new LambdaQueryWrapper<>();
        userConflictWrapper.eq(Reservation::getUserId, user.getId());
        userConflictWrapper.eq(Reservation::getReservationDate, reservationDate);
        userConflictWrapper.notIn(Reservation::getStatus, 3, 4);

        List<Reservation> userReservations = reservationService.list(userConflictWrapper);
        for (Reservation existing : userReservations) {
            LocalTime effectiveEnd = existing.getEndTime();
            if (existing.getStatus() == 2 && existing.getCheckOutTime() != null) {
                effectiveEnd = existing.getCheckOutTime().toLocalTime();
            }
            if (isTimeOverlap(startTime, endTime, existing.getStartTime(), effectiveEnd)) {
                return Result.error(400, "您在该时间段已有其他预约，不能重复预约");
            }
        }
        
        // 创建预约
        Reservation reservation = new Reservation();
        reservation.setUserId(user.getId());
        reservation.setRoomId(roomId);
        reservation.setSeatId(seatId);
        reservation.setReservationDate(reservationDate);
        reservation.setStartTime(startTime);
        reservation.setEndTime(endTime);
        reservation.setStatus(0);
        reservation.setCreateTime(LocalDateTime.now());
        reservation.setUpdateTime(LocalDateTime.now());
        
        boolean success = reservationService.save(reservation);
        if (success) {
            return Result.success("预约成功");
        }
        return Result.error(500, "预约失败");
    }
    
    /**
     * 检查两个时间段是否重叠
     */
    private boolean isTimeOverlap(LocalTime start1, LocalTime end1, LocalTime start2, LocalTime end2) {
        // 时间段1在时间段2之前结束，不重叠
        if (end1.isBefore(start2) || end1.equals(start2)) {
            return false;
        }
        // 时间段1在时间段2之后开始，不重叠
        if (start1.isAfter(end2) || start1.equals(end2)) {
            return false;
        }
        // 其他情况都重叠
        return true;
    }

    @PostMapping("/{id}/checkin")
    public Result<String> checkIn(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        Reservation reservation = reservationService.getById(id);
        if (reservation == null || !reservation.getUserId().equals(user.getId())) {
            return Result.error(404, "预约不存在");
        }
        
        // 检查是否在预约时间段内
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime startDateTime = LocalDateTime.of(reservation.getReservationDate(), reservation.getStartTime());
        LocalDateTime endDateTime = LocalDateTime.of(reservation.getReservationDate(), reservation.getEndTime());
        
        // 允许提前30分钟签到
        LocalDateTime earliestCheckIn = startDateTime.minusMinutes(30);
        
        if (now.isBefore(earliestCheckIn)) {
            return Result.error(400, "签到时间未到，请在预约开始前30分钟内签到");
        }
        
        // 预约结束后不能签到，自动释放座位
        if (now.isAfter(endDateTime)) {
            // 自动取消该预约
            reservation.setStatus(3);
            reservation.setCancelTime(now);
            reservation.setCancelReason("预约超时未签到，系统自动取消");
            reservation.setUpdateTime(now);
            reservationService.updateById(reservation);
            return Result.error(400, "预约已过期，座位已释放，请重新预约");
        }
        
        reservation.setStatus(1);
        reservation.setCheckInTime(now);
        reservation.setUpdateTime(now);

        boolean success = reservationService.updateById(reservation);
        if (success) {
            Seat checkInSeat = seatService.getById(reservation.getSeatId());
            if (checkInSeat != null) { checkInSeat.setStatus(2); seatService.updateById(checkInSeat); }
            return Result.success("签到成功");
        }
        return Result.error(500, "签到失败");
    }

    @PostMapping("/{id}/checkout")
    public Result<String> checkOut(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        Reservation reservation = reservationService.getById(id);
        if (reservation == null || !reservation.getUserId().equals(user.getId())) {
            return Result.error(404, "预约不存在");
        }
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime endDateTime = LocalDateTime.of(reservation.getReservationDate(), reservation.getEndTime());
        
        // 如果超过预约结束时间，提示已超出预约时间
        if (now.isAfter(endDateTime)) {
            return Result.error(400, "你已经超出预约时间，无法签退");
        }
        
        reservation.setStatus(2);
        reservation.setCheckOutTime(now);
        reservation.setUpdateTime(now);

        boolean success = reservationService.updateById(reservation);
        if (success) {
            Seat checkOutSeat = seatService.getById(reservation.getSeatId());
            if (checkOutSeat != null) { checkOutSeat.setStatus(1); seatService.updateById(checkOutSeat); }
            userMoralRecordService.checkAndAwardMoralScore(user.getId());
            return Result.success("签退成功");
        }
        return Result.error(500, "签退失败");
    }

    @PostMapping("/{id}/cancel")
    public Result<String> cancelReservation(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        Reservation reservation = reservationService.getById(id);
        if (reservation == null || !reservation.getUserId().equals(user.getId())) {
            return Result.error(404, "预约不存在");
        }
        
        reservation.setStatus(4);
        reservation.setCancelTime(LocalDateTime.now());
        reservation.setUpdateTime(LocalDateTime.now());

        boolean success = reservationService.updateById(reservation);
        if (success) {
            Seat cancelSeat = seatService.getById(reservation.getSeatId());
            if (cancelSeat != null) { cancelSeat.setStatus(1); seatService.updateById(cancelSeat); }
            return Result.success("取消成功");
        }
        return Result.error(500, "取消失败");
    }
}