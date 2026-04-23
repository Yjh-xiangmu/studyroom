package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.Seat;
import com.studyroom.entity.StudyRoom;
import com.studyroom.entity.SysSetting;
import com.studyroom.entity.User;
import com.studyroom.entity.UserMoralRecord;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SeatService;
import com.studyroom.service.StudyRoomService;
import com.studyroom.service.SysSettingService;
import com.studyroom.service.UserMoralRecordService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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

    @Autowired
    private SysSettingService sysSettingService;

    @Autowired
    private UserMoralRecordService userMoralRecordService;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @PostMapping("/change-password")
    public Result<String> changePassword(@RequestBody Map<String, String> params, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return Result.error(401, "未登录");
        }
        String oldPassword = params.get("oldPassword");
        String newPassword = params.get("newPassword");
        if (oldPassword == null || newPassword == null || newPassword.length() < 6) {
            return Result.error(400, "参数错误，新密码至少6位");
        }
        User user = userService.getById(currentUser.getId());
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            return Result.error(400, "原密码不正确");
        }
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setUpdateTime(LocalDateTime.now());
        userService.updateById(user);
        return Result.success("密码修改成功，请重新登录");
    }

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

        LambdaQueryWrapper<Reservation> reservationWrapper = new LambdaQueryWrapper<>();
        reservationWrapper.eq(Reservation::getUserId, user.getId());
        long totalReservations = reservationService.count(reservationWrapper);
        stats.put("totalReservations", totalReservations);

        LambdaQueryWrapper<Reservation> checkedWrapper = new LambdaQueryWrapper<>();
        checkedWrapper.eq(Reservation::getUserId, user.getId())
                .isNotNull(Reservation::getCheckInTime);
        List<Reservation> checkedReservations = reservationService.list(checkedWrapper);

        double totalHours = 0;
        Set<LocalDate> studyDays = new HashSet<>();
        for (Reservation r : checkedReservations) {
            if (r.getCheckInTime() != null) {
                studyDays.add(r.getCheckInTime().toLocalDate());
                if (r.getCheckOutTime() != null) {
                    Duration d = Duration.between(r.getCheckInTime(), r.getCheckOutTime());
                    totalHours += d.toMinutes() / 60.0;
                } else {
                    totalHours += 2.0;
                }
            }
        }
        stats.put("totalHours", Math.round(totalHours * 10) / 10.0);
        stats.put("totalDays", studyDays.size());

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

    @GetMapping("/violation-info")
    public Result<Map<String, Object>> getViolationInfo(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        User currentUser = userService.getById(user.getId());

        int maxViolation = 3;
        int rewardDays = 7;
        SysSetting maxSetting = sysSettingService.getOne(
                new LambdaQueryWrapper<SysSetting>().eq(SysSetting::getSettingKey, "max_violation_limit"));
        if (maxSetting != null) {
            try { maxViolation = Integer.parseInt(maxSetting.getSettingValue()); } catch (Exception ignored) {}
        }
        SysSetting rewardSetting = sysSettingService.getOne(
                new LambdaQueryWrapper<SysSetting>().eq(SysSetting::getSettingKey, "reward_checkin_days"));
        if (rewardSetting != null) {
            try { rewardDays = Integer.parseInt(rewardSetting.getSettingValue()); } catch (Exception ignored) {}
        }

        int violationCount = currentUser.getViolationCount() != null ? currentUser.getViolationCount() : 0;
        boolean isBanned = violationCount >= maxViolation;

        LambdaQueryWrapper<Reservation> checkinWrapper = new LambdaQueryWrapper<>();
        checkinWrapper.eq(Reservation::getUserId, currentUser.getId()).isNotNull(Reservation::getCheckInTime);
        List<Reservation> checkins = reservationService.list(checkinWrapper);
        Set<LocalDate> checkinDays = new HashSet<>();
        for (Reservation r : checkins) {
            checkinDays.add(r.getCheckInTime().toLocalDate());
        }
        int continuousDays = 0;
        LocalDate day = LocalDate.now();
        while (checkinDays.contains(day)) {
            continuousDays++;
            day = day.minusDays(1);
        }

        LambdaQueryWrapper<Reservation> violationWrapper = new LambdaQueryWrapper<>();
        violationWrapper.eq(Reservation::getUserId, currentUser.getId())
                .eq(Reservation::getStatus, 3)
                .isNotNull(Reservation::getCancelReason);
        List<Reservation> violations = reservationService.list(violationWrapper);
        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : violations) {
            Map<String, Object> rec = new HashMap<>();
            rec.put("id", r.getId());
            rec.put("reservationDate", r.getReservationDate());
            rec.put("startTime", r.getStartTime());
            rec.put("endTime", r.getEndTime());
            rec.put("appealStatus", r.getAppealStatus() != null ? r.getAppealStatus() : 0);
            rec.put("createTime", r.getCreateTime());
            StudyRoom room = studyRoomService.getById(r.getRoomId());
            rec.put("roomName", room != null ? room.getName() : "");
            Seat seat = seatService.getById(r.getSeatId());
            rec.put("seatNumber", seat != null ? seat.getSeatNumber() : "");
            records.add(rec);
        }

        Map<String, Object> data = new HashMap<>();
        data.put("violationCount", violationCount);
        data.put("continuousCheckinDays", continuousDays);
        data.put("isBanned", isBanned);
        data.put("maxViolation", maxViolation);
        data.put("rewardDays", rewardDays);
        data.put("records", records);
        return Result.success(data);
    }

    @GetMapping("/moral-info")
    public Result<Map<String, Object>> getMoralInfo(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) {
            return Result.error(401, "未登录");
        }
        User user = userService.getById(sessionUser.getId());

        int currentRank = user.getMoralRank() != null ? user.getMoralRank() : 0;
        double moralScore = user.getMoralScore() != null ? user.getMoralScore().doubleValue() : 0.0;

        double nextHours = -1;
        if (currentRank < 6) {
            SysSetting nextSetting = sysSettingService.getOne(
                    new LambdaQueryWrapper<SysSetting>().eq(SysSetting::getSettingKey,
                            "moral_rank" + (currentRank + 1) + "_hours"));
            if (nextSetting != null) {
                try { nextHours = Double.parseDouble(nextSetting.getSettingValue()); } catch (Exception ignored) {}
            }
        }

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, user.getId()).isNotNull(Reservation::getCheckInTime);
        List<Reservation> list = reservationService.list(wrapper);
        double totalHours = 0;
        for (Reservation r : list) {
            if (r.getCheckInTime() != null) {
                if (r.getCheckOutTime() != null) {
                    totalHours += java.time.Duration.between(r.getCheckInTime(), r.getCheckOutTime()).toMinutes() / 60.0;
                } else {
                    totalHours += 2.0;
                }
            }
        }
        totalHours = Math.round(totalHours * 10) / 10.0;

        LambdaQueryWrapper<UserMoralRecord> recordWrapper = new LambdaQueryWrapper<>();
        recordWrapper.eq(UserMoralRecord::getUserId, user.getId()).orderByAsc(UserMoralRecord::getRankLevel);
        List<UserMoralRecord> records = userMoralRecordService.list(recordWrapper);

        String[] rankNames = {"", "初学者", "进阶者", "学习达人", "自律标兵", "学霸", "学神"};

        Map<String, Object> data = new HashMap<>();
        data.put("currentRank", currentRank);
        data.put("rankName", currentRank > 0 ? rankNames[currentRank] : "未入段");
        data.put("moralScore", moralScore);
        data.put("totalHours", totalHours);
        data.put("nextRankHours", nextHours > 0 ? nextHours : null);
        data.put("hoursToNext", nextHours > 0 ? Math.max(0, Math.round((nextHours - totalHours) * 10) / 10.0) : null);
        data.put("records", records);
        return Result.success(data);
    }

    @GetMapping("/admin-contacts")
    public Result<Map<String, Object>> getAdminContacts() {
        Map<String, Object> result = new HashMap<>();

        // 查询所有分配了 adminId 的自习室
        List<Map<String, Object>> roomContacts = new ArrayList<>();
        List<StudyRoom> rooms = studyRoomService.list(
                new LambdaQueryWrapper<StudyRoom>()
                        .isNotNull(StudyRoom::getAdminId)
                        .eq(StudyRoom::getDeleted, 0)
        );

        for (StudyRoom room : rooms) {
            User admin = userService.getById(room.getAdminId());
            if (admin != null) {
                Map<String, Object> contact = new HashMap<>();
                contact.put("title", room.getName() + " (" + room.getBuilding() + ") 管理员");
                contact.put("name", admin.getRealName() != null ? admin.getRealName() : admin.getUsername());
                contact.put("phone", admin.getPhone() != null ? admin.getPhone() : "未留手机号");
                // 彻底去掉返回邮箱信息的代码
                roomContacts.add(contact);
            }
        }
        result.put("roomContacts", roomContacts);

        // 系统总管理员信息（基于ID=1账户）
        User sysAdmin = userService.getById(1L);
        Map<String, Object> sysContact = new HashMap<>();
        if (sysAdmin != null) {
            sysContact.put("title", "系统总管理员");
            sysContact.put("name", sysAdmin.getRealName() != null ? sysAdmin.getRealName() : sysAdmin.getUsername());
            sysContact.put("phone", sysAdmin.getPhone() != null ? sysAdmin.getPhone() : "未留手机号");
        }
        result.put("sysContact", sysContact);

        return Result.success(result);
    }
}