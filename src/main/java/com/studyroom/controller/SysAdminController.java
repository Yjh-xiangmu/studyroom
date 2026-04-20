package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.ForumPost;
import com.studyroom.service.ForumPostService;
import com.studyroom.entity.Notice;
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
import com.studyroom.service.NoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/sysadmin")
public class SysAdminController {

    @Autowired
    private UserService userService;

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private SysSettingService sysSettingService;

    @Autowired
    private UserMoralRecordService userMoralRecordService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private NoticeService noticeService;

    // ========== 用户管理 ==========

    @GetMapping("/user/admins")
    public Result<List<User>> getRoomAdmins() {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0).eq(User::getUserType, 2).orderByAsc(User::getUsername);
        List<User> admins = userService.list(wrapper);
        admins.forEach(u -> u.setPassword(null));
        return Result.success(admins);
    }

    @GetMapping("/user/list")
    public Result<Page<User>> getUserList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) Integer userType) {
        
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0);
        
        if (username != null && !username.isEmpty()) {
            wrapper.like(User::getUsername, username);
        }
        if (realName != null && !realName.isEmpty()) {
            wrapper.like(User::getRealName, realName);
        }
        if (userType != null) {
            wrapper.eq(User::getUserType, userType);
        }
        
        wrapper.orderByDesc(User::getCreateTime);
        Page<User> pageResult = userService.page(new Page<>(page, size), wrapper);
        
        // 清除密码
        pageResult.getRecords().forEach(user -> user.setPassword(null));
        
        return Result.success(pageResult);
    }

    @PostMapping("/user")
    public Result<User> addUser(@RequestBody User user) {
        // 检查用户名是否已存在
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, user.getUsername());
        if (userService.getOne(wrapper) != null) {
            return Result.error(400, "用户名已存在");
        }
        
        // 设置默认密码
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            user.setPassword("admin");
        }
        
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        user.setDeleted(0);
        
        boolean success = userService.save(user);
        if (success) {
            user.setPassword(null);
            return Result.success("新增成功", user);
        }
        return Result.error(500, "新增失败");
    }

    @PutMapping("/user/{id}")
    public Result<User> updateUser(@PathVariable Long id, @RequestBody User user) {
        user.setId(id);
        user.setUpdateTime(LocalDateTime.now());
        // 不更新密码
        user.setPassword(null);
        
        boolean success = userService.updateById(user);
        if (success) {
            return Result.success("更新成功", user);
        }
        return Result.error(500, "更新失败");
    }

    @DeleteMapping("/user/{id}")
    public Result<String> deleteUser(@PathVariable Long id) {
        // 使用 removeById 触发 MyBatis-Plus 逻辑删除
        boolean success = userService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error(500, "删除失败");
    }

    @PutMapping("/user/{id}/status")
    public Result<String> updateUserStatus(@PathVariable Long id, @RequestBody Map<String, Integer> params) {
        User user = new User();
        user.setId(id);
        user.setStatus(params.get("status"));
        user.setUpdateTime(LocalDateTime.now());
        
        boolean success = userService.updateById(user);
        if (success) {
            return Result.success("状态更新成功");
        }
        return Result.error(500, "状态更新失败");
    }

    // ========== 自习室管理 ==========

    @GetMapping("/studyroom/list")
    public Result<Page<StudyRoom>> getStudyRoomList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String building,
            @RequestParam(required = false) Integer status) {
        
        LambdaQueryWrapper<StudyRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudyRoom::getDeleted, 0);
        
        if (name != null && !name.isEmpty()) {
            wrapper.like(StudyRoom::getName, name);
        }
        if (building != null && !building.isEmpty()) {
            wrapper.like(StudyRoom::getBuilding, building);
        }
        if (status != null) {
            wrapper.eq(StudyRoom::getStatus, status);
        }
        
        wrapper.orderByDesc(StudyRoom::getCreateTime);
        Page<StudyRoom> pageResult = studyRoomService.page(new Page<>(page, size), wrapper);
        return Result.success(pageResult);
    }

    @PostMapping("/studyroom")
    public Result<StudyRoom> addStudyRoom(@RequestBody StudyRoom studyRoom) {
        studyRoom.setCreateTime(LocalDateTime.now());
        studyRoom.setUpdateTime(LocalDateTime.now());
        studyRoom.setDeleted(0);
        
        boolean success = studyRoomService.save(studyRoom);
        if (success) {
            return Result.success("新增成功", studyRoom);
        }
        return Result.error(500, "新增失败");
    }

    @PutMapping("/studyroom/{id}")
    public Result<StudyRoom> updateStudyRoom(@PathVariable Long id, @RequestBody StudyRoom studyRoom) {
        studyRoom.setId(id);
        studyRoom.setUpdateTime(LocalDateTime.now());
        
        boolean success = studyRoomService.updateById(studyRoom);
        if (success) {
            return Result.success("更新成功", studyRoom);
        }
        return Result.error(500, "更新失败");
    }

    @DeleteMapping("/studyroom/{id}")
    public Result<String> deleteStudyRoom(@PathVariable Long id) {
        // 使用 removeById 触发 MyBatis-Plus 逻辑删除
        boolean success = studyRoomService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error(500, "删除失败");
    }

    // ========== 控制台统计数据 ==========

    @GetMapping("/dashboard/stats")
    public Result<Map<String, Object>> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 总用户数
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.eq(User::getDeleted, 0);
        stats.put("userCount", userService.count(userWrapper));
        
        // 本周新增注册用户数
        LocalDate weekAgo = LocalDate.now().minusDays(7);
        LambdaQueryWrapper<User> weekUserWrapper = new LambdaQueryWrapper<>();
        weekUserWrapper.eq(User::getDeleted, 0)
                       .ge(User::getCreateTime, weekAgo.atStartOfDay());
        stats.put("weekNewUserCount", userService.count(weekUserWrapper));
        
        // 待处理预约数（待签到的预约）
        LambdaQueryWrapper<Reservation> pendingWrapper = new LambdaQueryWrapper<>();
        pendingWrapper.eq(Reservation::getStatus, 0)
                      .ge(Reservation::getReservationDate, LocalDate.now());
        stats.put("pendingReservationCount", reservationService.count(pendingWrapper));
        
        // 本周签到率
        LocalDate weekStart = LocalDate.now().minusDays(7);
        LambdaQueryWrapper<Reservation> weekReservationWrapper = new LambdaQueryWrapper<>();
        weekReservationWrapper.ge(Reservation::getReservationDate, weekStart)
                              .le(Reservation::getReservationDate, LocalDate.now())
                              .in(Reservation::getStatus, 1, 2, 3); // 已签到、已完成、已取消（已结束的预约）
        long weekTotal = reservationService.count(weekReservationWrapper);
        
        LambdaQueryWrapper<Reservation> weekCheckInWrapper = new LambdaQueryWrapper<>();
        weekCheckInWrapper.ge(Reservation::getReservationDate, weekStart)
                          .le(Reservation::getReservationDate, LocalDate.now())
                          .in(Reservation::getStatus, 1, 2); // 已签到或已完成
        long weekCheckIn = reservationService.count(weekCheckInWrapper);
        
        int checkInRate = weekTotal > 0 ? (int) (weekCheckIn * 100 / weekTotal) : 0;
        stats.put("weekCheckInRate", checkInRate);
        
        return Result.success(stats);
    }

    @GetMapping("/dashboard/recent-users")
    public Result<List<User>> getRecentUsers() {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0);
        wrapper.orderByDesc(User::getCreateTime);
        wrapper.last("LIMIT 5");
        List<User> users = userService.list(wrapper);
        users.forEach(user -> user.setPassword(null));
        return Result.success(users);
    }

    @GetMapping("/dashboard/today-reservations")
    public Result<List<Map<String, Object>>> getTodayReservations() {
        // 查询今日预约
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getReservationDate, LocalDate.now())
               .orderByDesc(Reservation::getCreateTime)
               .last("LIMIT 10");
        
        List<Reservation> reservations = reservationService.list(wrapper);
        if (reservations.isEmpty()) {
            return Result.success(new ArrayList<>());
        }
        
        // 获取相关用户信息
        List<Long> userIds = reservations.stream()
                .map(Reservation::getUserId).distinct().collect(Collectors.toList());
        Map<Long, User> userMap = new HashMap<>();
        if (!userIds.isEmpty()) {
            LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
            userWrapper.in(User::getId, userIds);
            userService.list(userWrapper).forEach(u -> userMap.put(u.getId(), u));
        }
        
        // 获取自习室信息
        List<Long> roomIds = reservations.stream()
                .map(Reservation::getRoomId).distinct().collect(Collectors.toList());
        Map<Long, StudyRoom> roomMap = new HashMap<>();
        if (!roomIds.isEmpty()) {
            LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
            roomWrapper.in(StudyRoom::getId, roomIds);
            studyRoomService.list(roomWrapper).forEach(r -> roomMap.put(r.getId(), r));
        }
        
        // 组装结果
        List<Map<String, Object>> result = new ArrayList<>();
        for (Reservation r : reservations) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            
            User user = userMap.get(r.getUserId());
            map.put("userName", user != null ? user.getUsername() : "未知用户");
            
            StudyRoom room = roomMap.get(r.getRoomId());
            map.put("roomName", room != null ? room.getName() : "未知自习室");
            
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("createTime", r.getCreateTime());
            
            result.add(map);
        }
        
        return Result.success(result);
    }

    // ========== 预约管理 ==========

    @GetMapping("/reservation/list")
    public Result<Page<Map<String, Object>>> getReservationList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) String roomName,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String date) {
        
        // 查询预约列表
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        
        if (status != null) {
            wrapper.eq(Reservation::getStatus, status);
        }
        if (date != null && !date.isEmpty()) {
            wrapper.eq(Reservation::getReservationDate, LocalDate.parse(date));
        }
        
        wrapper.orderByDesc(Reservation::getCreateTime);
        Page<Reservation> pageParam = new Page<>(page, size);
        Page<Reservation> reservationPage = reservationService.page(pageParam, wrapper);
        
        // 获取所有相关用户ID、自习室ID、座位ID
        List<Long> userIds = reservationPage.getRecords().stream()
                .map(Reservation::getUserId).distinct().collect(Collectors.toList());
        List<Long> roomIds = reservationPage.getRecords().stream()
                .map(Reservation::getRoomId).distinct().collect(Collectors.toList());
        List<Long> seatIds = reservationPage.getRecords().stream()
                .map(Reservation::getSeatId).distinct().collect(Collectors.toList());
        
        // 批量查询用户信息
        Map<Long, User> userMap = new HashMap<>();
        if (!userIds.isEmpty()) {
            LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
            userWrapper.in(User::getId, userIds);
            userService.list(userWrapper).forEach(u -> userMap.put(u.getId(), u));
        }
        
        // 批量查询自习室信息
        Map<Long, StudyRoom> roomMap = new HashMap<>();
        if (!roomIds.isEmpty()) {
            LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
            roomWrapper.in(StudyRoom::getId, roomIds);
            studyRoomService.list(roomWrapper).forEach(r -> roomMap.put(r.getId(), r));
        }
        
        // 批量查询座位信息
        Map<Long, Seat> seatMap = new HashMap<>();
        if (!seatIds.isEmpty()) {
            LambdaQueryWrapper<Seat> seatWrapper = new LambdaQueryWrapper<>();
            seatWrapper.in(Seat::getId, seatIds);
            seatService.list(seatWrapper).forEach(s -> seatMap.put(s.getId(), s));
        }
        
        // 组装结果
        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : reservationPage.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("reservationNo", "RES" + String.format("%08d", r.getId()));
            
            User user = userMap.get(r.getUserId());
            map.put("userId", r.getUserId());
            map.put("userName", user != null ? user.getUsername() : "未知用户");
            
            StudyRoom room = roomMap.get(r.getRoomId());
            map.put("roomId", r.getRoomId());
            map.put("roomName", room != null ? room.getName() : "未知自习室");
            
            Seat seat = seatMap.get(r.getSeatId());
            map.put("seatId", r.getSeatId());
            map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知座位");
            
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("checkInTime", r.getCheckInTime());
            map.put("checkOutTime", r.getCheckOutTime());
            map.put("cancelTime", r.getCancelTime());
            map.put("cancelReason", r.getCancelReason());
            map.put("createTime", r.getCreateTime());
            
            // 过滤条件
            if (userName != null && !userName.isEmpty()) {
                if (user == null || !user.getUsername().contains(userName)) continue;
            }
            if (roomName != null && !roomName.isEmpty()) {
                if (room == null || !room.getName().contains(roomName)) continue;
            }
            
            records.add(map);
        }
        
        // 创建新的分页结果
        Page<Map<String, Object>> resultPage = new Page<>(page, size, records.size());
        resultPage.setRecords(records);
        
        return Result.success(resultPage);
    }

    @PutMapping("/reservation/{id}/cancel")
    public Result<String> cancelReservation(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error(404, "预约不存在");
        }
        
        if (reservation.getStatus() != 0) {
            return Result.error(400, "只能取消待签到的预约");
        }
        
        reservation.setStatus(3); // 已取消
        reservation.setCancelTime(LocalDateTime.now());
        reservation.setCancelReason("管理员取消");
        reservation.setUpdateTime(LocalDateTime.now());
        
        boolean success = reservationService.updateById(reservation);
        if (success) {
            return Result.success("取消成功");
        }
        return Result.error(500, "取消失败");
    }

    // ========== 公告管理 ==========

    @GetMapping("/notice/list")
    public Result<Page<Notice>> getNoticeList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Integer status) {
        
        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notice::getDeleted, 0);
        wrapper.eq(Notice::getPublisherType, 1); // 只显示系统管理员发布的公告

        if (title != null && !title.isEmpty()) {
            wrapper.like(Notice::getTitle, title);
        }
        if (status != null) {
            wrapper.eq(Notice::getStatus, status);
        }
        
        // 置顶的先显示，然后按创建时间倒序
        wrapper.orderByDesc(Notice::getIsTop);
        wrapper.orderByDesc(Notice::getCreateTime);
        
        Page<Notice> pageResult = noticeService.page(new Page<>(page, size), wrapper);
        return Result.success(pageResult);
    }

    @PostMapping("/notice")
    public Result<Notice> addNotice(@RequestBody Notice notice, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) return Result.error(401, "未登录");

        notice.setPublisherId(currentUser.getId());
        notice.setPublisherName(currentUser.getRealName() != null ? currentUser.getRealName() : currentUser.getUsername());
        // userType=3 是系统管理员，publisherType 约定 1=系统管理员
        notice.setPublisherType(1);
        notice.setViewCount(0);
        notice.setStatus(2); // 系统管理员直接发布
        notice.setPublishTime(LocalDateTime.now());
        notice.setCreateTime(LocalDateTime.now());
        notice.setUpdateTime(LocalDateTime.now());

        boolean success = noticeService.save(notice);
        return success ? Result.success("发布成功", notice) : Result.error(500, "发布失败");
    }

    // 一级审核通过（自习室管理员上报 → 一级审核）
    @PutMapping("/notice/{id}/audit1")
    public Result<String> audit1Notice(@PathVariable Long id) {
        Notice notice = new Notice();
        notice.setId(id);
        notice.setStatus(1); // 一级审核通过
        notice.setUpdateTime(LocalDateTime.now());
        
        boolean success = noticeService.updateById(notice);
        if (success) {
            return Result.success("一级审核通过");
        }
        return Result.error(500, "审核失败");
    }

    // 二级审核通过/发布（一级审核通过 → 正式发布）
    @PutMapping("/notice/{id}/publish")
    public Result<String> publishNotice(@PathVariable Long id) {
        Notice notice = new Notice();
        notice.setId(id);
        notice.setStatus(2); // 已发布
        notice.setPublishTime(LocalDateTime.now());
        notice.setUpdateTime(LocalDateTime.now());
        
        boolean success = noticeService.updateById(notice);
        if (success) {
            return Result.success("发布成功");
        }
        return Result.error(500, "发布失败");
    }

    // 关闭公告
    @PutMapping("/notice/{id}/close")
    public Result<String> closeNotice(@PathVariable Long id) {
        Notice notice = new Notice();
        notice.setId(id);
        notice.setStatus(3); // 已关闭
        notice.setUpdateTime(LocalDateTime.now());
        
        boolean success = noticeService.updateById(notice);
        if (success) {
            return Result.success("关闭成功");
        }
        return Result.error(500, "关闭失败");
    }

    // 屏蔽公告
    @PutMapping("/notice/{id}/block")
    public Result<String> blockNotice(@PathVariable Long id) {
        Notice notice = new Notice();
        notice.setId(id);
        notice.setStatus(4); // 已屏蔽
        notice.setUpdateTime(LocalDateTime.now());
        
        boolean success = noticeService.updateById(notice);
        return success ? Result.success("屏蔽成功") : Result.error(500, "屏蔽失败");
    }

    // 删除公告
    @DeleteMapping("/notice/{id}")
    public Result<String> deleteNotice(@PathVariable Long id) {
        boolean success = noticeService.removeById(id);
        return success ? Result.success("删除成功") : Result.error(500, "删除失败");
    }

    // 修改公告（含置顶选项）
    @PutMapping("/notice/{id}")
    public Result<String> updateNotice(@PathVariable Long id, @RequestBody Notice notice) {
        Notice existing = noticeService.getById(id);
        if (existing == null) return Result.error(404, "公告不存在");
        if (notice.getTitle() != null) existing.setTitle(notice.getTitle());
        if (notice.getContent() != null) existing.setContent(notice.getContent());
        if (notice.getIsTop() != null) existing.setIsTop(notice.getIsTop());
        existing.setUpdateTime(LocalDateTime.now());
        boolean success = noticeService.updateById(existing);
        return success ? Result.success("修改成功") : Result.error(500, "修改失败");
    }

    // ========== 数据统计 ==========

    @GetMapping("/statistics/overview")
    public Result<Map<String, Object>> getStatisticsOverview() {
        Map<String, Object> stats = new HashMap<>();
        
        // 总用户数
        LambdaQueryWrapper<User> userWrapper = new LambdaQueryWrapper<>();
        userWrapper.eq(User::getDeleted, 0);
        stats.put("userCount", userService.count(userWrapper));
        
        // 总自习室数
        LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(StudyRoom::getDeleted, 0);
        stats.put("roomCount", studyRoomService.count(roomWrapper));
        
        // 本月预约数
        LocalDate firstDayOfMonth = LocalDate.now().withDayOfMonth(1);
        LambdaQueryWrapper<Reservation> monthWrapper = new LambdaQueryWrapper<>();
        monthWrapper.ge(Reservation::getReservationDate, firstDayOfMonth);
        stats.put("monthReservationCount", reservationService.count(monthWrapper));
        
        // 座位使用率（简化计算：今日预约数 / 总座位数 * 100）
        LambdaQueryWrapper<Reservation> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.eq(Reservation::getReservationDate, LocalDate.now());
        long todayReservationCount = reservationService.count(todayWrapper);
        
        // 获取总座位数
        long totalSeats = seatService.count();
        int usageRate = totalSeats > 0 ? (int) (todayReservationCount * 100 / totalSeats) : 0;
        stats.put("seatUsageRate", Math.min(usageRate, 100));
        
        return Result.success(stats);
    }

    // ========== 论坛管理（上诉申请审核） ==========
    @Autowired
    private ForumPostService forumPostService;

    @GetMapping("/forum/posts")
    public Result<Page<Map<String, Object>>> getForumPosts(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String keyword) {

        LambdaQueryWrapper<ForumPost> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(ForumPost::getStatus, status);
        }
        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(ForumPost::getTitle, keyword);
        }
        wrapper.orderByDesc(ForumPost::getCreateTime);

        Page<ForumPost> pageResult = forumPostService.page(new Page<>(page, size), wrapper);

        List<Map<String, Object>> records = new ArrayList<>();
        for (ForumPost post : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", post.getId());
            map.put("title", post.getTitle());
            map.put("content", post.getContent());
            map.put("viewCount", post.getViewCount());
            map.put("replyCount", post.getReplyCount());
            map.put("likeCount", post.getLikeCount());
            map.put("status", post.getStatus());
            map.put("categoryId", post.getCategoryId());
            map.put("createTime", post.getCreateTime());
            map.put("updateTime", post.getUpdateTime());
            User author = userService.getById(post.getUserId());
            map.put("authorName", author != null ? (author.getRealName() != null ? author.getRealName() : author.getUsername()) : "未知用户");
            map.put("userType", author != null ? author.getUserType() : 0);
            records.add(map);
        }

        Page<Map<String, Object>> result = new Page<>();
        result.setCurrent(pageResult.getCurrent());
        result.setSize(pageResult.getSize());
        result.setTotal(pageResult.getTotal());
        result.setRecords(records);
        return Result.success(result);
    }

    @PutMapping("/forum/post/{id}/status")
    public Result<String> updatePostStatus(@PathVariable Long id, @RequestParam Integer status) {
        ForumPost post = forumPostService.getById(id);
        if (post == null) return Result.error(404, "帖子不存在");
        post.setStatus(status);
        post.setUpdateTime(LocalDateTime.now());
        forumPostService.updateById(post);
        return Result.success("操作成功");
    }

    @DeleteMapping("/forum/post/{id}")
    public Result<String> deletePost(@PathVariable Long id) {
        ForumPost post = forumPostService.getById(id);
        if (post == null) return Result.error(404, "帖子不存在");
        forumPostService.removeById(id);
        return Result.success("删除成功");
    }

    @PostMapping("/forum/post")
    public Result<String> createPost(@RequestBody Map<String, Object> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error(401, "未登录");
        }
        
        ForumPost post = new ForumPost();
        post.setUserId(user.getId());
        post.setTitle((String) params.get("title"));
        post.setContent((String) params.get("content"));
        post.setCategoryId(params.get("categoryId") != null ? Long.valueOf(params.get("categoryId").toString()) : 1L);
        post.setViewCount(0);
        post.setReplyCount(0);
        post.setLikeCount(0);
        post.setStatus(0); // 正常状态
        post.setIsTop(0);
        post.setCreateTime(LocalDateTime.now());
        post.setUpdateTime(LocalDateTime.now());
        
        boolean success = forumPostService.save(post);
        if (success) {
            return Result.success("发布成功");
        }
        return Result.error(500, "发布失败");
    }

    // ========== 出勤管理 ==========

    @GetMapping("/attendance/list")
    public Result<Page<Map<String, Object>>> getAttendanceList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String userName,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String date) {

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        if (status != null) wrapper.eq(Reservation::getStatus, status);
        if (date != null && !date.isEmpty()) wrapper.eq(Reservation::getReservationDate, LocalDate.parse(date));
        wrapper.orderByDesc(Reservation::getCreateTime);

        Page<Reservation> pageResult = reservationService.page(new Page<>(page, size), wrapper);

        List<Long> userIds = pageResult.getRecords().stream().map(Reservation::getUserId).distinct().collect(Collectors.toList());
        List<Long> roomIds = pageResult.getRecords().stream().map(Reservation::getRoomId).distinct().collect(Collectors.toList());
        List<Long> seatIds = pageResult.getRecords().stream().map(Reservation::getSeatId).distinct().collect(Collectors.toList());

        Map<Long, User> userMap = new HashMap<>();
        if (!userIds.isEmpty()) {
            LambdaQueryWrapper<User> uq = new LambdaQueryWrapper<>();
            uq.in(User::getId, userIds);
            userService.list(uq).forEach(u -> userMap.put(u.getId(), u));
        }
        Map<Long, StudyRoom> roomMap = new HashMap<>();
        if (!roomIds.isEmpty()) {
            LambdaQueryWrapper<StudyRoom> rq = new LambdaQueryWrapper<>();
            rq.in(StudyRoom::getId, roomIds);
            studyRoomService.list(rq).forEach(r -> roomMap.put(r.getId(), r));
        }
        Map<Long, Seat> seatMap = new HashMap<>();
        if (!seatIds.isEmpty()) {
            LambdaQueryWrapper<Seat> sq = new LambdaQueryWrapper<>();
            sq.in(Seat::getId, seatIds);
            seatService.list(sq).forEach(s -> seatMap.put(s.getId(), s));
        }

        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : pageResult.getRecords()) {
            User user = userMap.get(r.getUserId());
            if (userName != null && !userName.isEmpty() && (user == null || !user.getUsername().contains(userName))) continue;
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("userId", r.getUserId());
            map.put("userName", user != null ? user.getUsername() : "未知");
            map.put("realName", user != null ? user.getRealName() : "");
            map.put("userViolationCount", user != null && user.getViolationCount() != null ? user.getViolationCount() : 0);
            map.put("continuousCheckinDays", user != null && user.getContinuousCheckinDays() != null ? user.getContinuousCheckinDays() : 0);
            StudyRoom room = roomMap.get(r.getRoomId());
            map.put("roomName", room != null ? room.getName() : "未知");
            Seat seat = seatMap.get(r.getSeatId());
            map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知");
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("checkInTime", r.getCheckInTime());
            map.put("checkOutTime", r.getCheckOutTime());
            map.put("appealStatus", r.getAppealStatus());
            map.put("appealReason", r.getAppealReason());
            map.put("createTime", r.getCreateTime());
            records.add(map);
        }

        Page<Map<String, Object>> resultPage = new Page<>(page, size, pageResult.getTotal());
        resultPage.setRecords(records);
        return Result.success(resultPage);
    }

    @GetMapping("/attendance/users")
    public Result<Page<Map<String, Object>>> getAttendanceUsers(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String username) {

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0).eq(User::getUserType, 1);
        if (username != null && !username.isEmpty()) wrapper.like(User::getUsername, username);
        wrapper.orderByDesc(User::getViolationCount);

        Page<User> pageResult = userService.page(new Page<>(page, size), wrapper);

        LambdaQueryWrapper<SysSetting> sq = new LambdaQueryWrapper<>();
        sq.eq(SysSetting::getSettingKey, "max_violation_limit");
        SysSetting setting = sysSettingService.getOne(sq);
        int maxLimit = setting != null ? Integer.parseInt(setting.getSettingValue()) : 3;

        List<Map<String, Object>> records = new ArrayList<>();
        for (User u : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", u.getId());
            map.put("username", u.getUsername());
            map.put("realName", u.getRealName());
            map.put("studentId", u.getStudentId());
            map.put("department", u.getDepartment());
            map.put("violationCount", u.getViolationCount() != null ? u.getViolationCount() : 0);
            map.put("continuousCheckinDays", u.getContinuousCheckinDays() != null ? u.getContinuousCheckinDays() : 0);
            map.put("isBanned", (u.getViolationCount() != null && u.getViolationCount() >= maxLimit));
            map.put("status", u.getStatus());
            records.add(map);
        }

        Page<Map<String, Object>> resultPage = new Page<>(page, size, pageResult.getTotal());
        resultPage.setRecords(records);
        return Result.success(resultPage);
    }

    @GetMapping("/attendance/appeals")
    public Result<Page<Map<String, Object>>> getPendingAppeals(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getAppealStatus, 1).orderByDesc(Reservation::getCreateTime);

        Page<Reservation> pageResult = reservationService.page(new Page<>(page, size), wrapper);

        List<Long> userIds = pageResult.getRecords().stream().map(Reservation::getUserId).distinct().collect(Collectors.toList());
        List<Long> roomIds = pageResult.getRecords().stream().map(Reservation::getRoomId).distinct().collect(Collectors.toList());
        Map<Long, User> userMap = new HashMap<>();
        if (!userIds.isEmpty()) {
            LambdaQueryWrapper<User> uq = new LambdaQueryWrapper<>();
            uq.in(User::getId, userIds);
            userService.list(uq).forEach(u -> userMap.put(u.getId(), u));
        }
        Map<Long, StudyRoom> roomMap = new HashMap<>();
        if (!roomIds.isEmpty()) {
            LambdaQueryWrapper<StudyRoom> rq = new LambdaQueryWrapper<>();
            rq.in(StudyRoom::getId, roomIds);
            studyRoomService.list(rq).forEach(r -> roomMap.put(r.getId(), r));
        }

        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            User user = userMap.get(r.getUserId());
            map.put("userName", user != null ? user.getUsername() : "未知");
            map.put("realName", user != null ? user.getRealName() : "");
            StudyRoom room = roomMap.get(r.getRoomId());
            map.put("roomName", room != null ? room.getName() : "未知");
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("appealStatus", r.getAppealStatus());
            map.put("appealReason", r.getAppealReason());
            map.put("createTime", r.getCreateTime());
            records.add(map);
        }

        Page<Map<String, Object>> resultPage = new Page<>(page, size, pageResult.getTotal());
        resultPage.setRecords(records);
        return Result.success(resultPage);
    }

    @PutMapping("/attendance/appeal/{id}/approve")
    public Result<String> approveAppeal(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) return Result.error(404, "记录不存在");
        if (reservation.getAppealStatus() != 1) return Result.error(400, "该申诉不在待处理状态");

        boolean wasViolation = reservation.getStatus() == 3;
        reservation.setAppealStatus(2); // 申诉通过
        reservation.setStatus(wasViolation ? 4 : 3); // 4=已取消(非违约) or 3=已违约
        reservation.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(reservation);

        // 调整用户违约次数
        User user = userService.getById(reservation.getUserId());
        if (user != null) {
            if (wasViolation) {
                // 原来是违约，申诉通过后取消违约，减少违约次数
                int count = user.getViolationCount() != null ? user.getViolationCount() : 0;
                user.setViolationCount(Math.max(0, count - 1));
            } else {
                // 原来不是违约，申诉通过后改为违约，增加违约次数
                int count = user.getViolationCount() != null ? user.getViolationCount() : 0;
                user.setViolationCount(count + 1);
                reservation.setStatus(3);
                reservationService.updateById(reservation);
            }
            userService.updateById(user);
        }
        return Result.success("申诉已通过");
    }

    @PutMapping("/attendance/appeal/{id}/reject")
    public Result<String> rejectAppeal(@PathVariable Long id) {
        Reservation reservation = reservationService.getById(id);
        if (reservation == null) return Result.error(404, "记录不存在");
        if (reservation.getAppealStatus() != 1) return Result.error(400, "该申诉不在待处理状态");

        reservation.setAppealStatus(3); // 申诉驳回
        reservation.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(reservation);
        return Result.success("申诉已驳回");
    }

    @GetMapping("/settings")
    public Result<List<SysSetting>> getSettings() {
        return Result.success(sysSettingService.list());
    }

    @PutMapping("/settings/{key}")
    public Result<String> updateSetting(@PathVariable String key, @RequestBody Map<String, String> params) {
        LambdaQueryWrapper<SysSetting> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SysSetting::getSettingKey, key);
        SysSetting setting = sysSettingService.getOne(wrapper);
        if (setting == null) {
            setting = new SysSetting();
            setting.setSettingKey(key);
            setting.setSettingValue(params.get("value"));
            sysSettingService.save(setting);
        } else {
            setting.setSettingValue(params.get("value"));
            sysSettingService.updateById(setting);
        }
        return Result.success("设置已更新");
    }

    @GetMapping("/attendance/export")
    public ResponseEntity<byte[]> exportContinuousUsers(@RequestParam(defaultValue = "7") Integer minDays) {
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0).eq(User::getUserType, 1)
               .ge(User::getContinuousCheckinDays, minDays)
               .orderByDesc(User::getContinuousCheckinDays);
        List<User> users = userService.list(wrapper);

        StringBuilder csv = new StringBuilder("学号,姓名,用户名,院系,连续签到天数\n");
        for (User u : users) {
            csv.append(nullSafe(u.getStudentId())).append(",")
               .append(nullSafe(u.getRealName())).append(",")
               .append(nullSafe(u.getUsername())).append(",")
               .append(nullSafe(u.getDepartment())).append(",")
               .append(u.getContinuousCheckinDays() != null ? u.getContinuousCheckinDays() : 0).append("\n");
        }

        byte[] bytes = csv.toString().getBytes(StandardCharsets.UTF_8);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        String filename = "连续签到用户_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
        headers.setContentDispositionFormData("attachment", new String(filename.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        return ResponseEntity.ok().headers(headers).body(bytes);
    }

    private String nullSafe(String s) {
        return s != null ? s.replace(",", "，") : "";
    }

    // ============ 德育分管理 ============

    @GetMapping("/moral/list")
    public Result<List<Map<String, Object>>> getMoralList(HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || admin.getUserType() != 3) return Result.error(403, "无权限");

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0).eq(User::getUserType, 1)
               .orderByDesc(User::getMoralScore);
        List<User> users = userService.list(wrapper);

        List<Map<String, Object>> result = new ArrayList<>();
        String[] rankNames = {"", "初学者", "进阶者", "学习达人", "自律标兵", "学霸", "学神"};
        for (User u : users) {
            Map<String, Object> row = new HashMap<>();
            row.put("id", u.getId());
            row.put("username", u.getUsername());
            row.put("realName", u.getRealName());
            row.put("studentId", u.getStudentId());
            row.put("department", u.getDepartment());
            int rank = u.getMoralRank() != null ? u.getMoralRank() : 0;
            row.put("moralRank", rank);
            row.put("rankName", rank > 0 ? rankNames[rank] : "未入段");
            row.put("moralScore", u.getMoralScore() != null ? u.getMoralScore() : 0);
            result.add(row);
        }
        return Result.success(result);
    }

    @GetMapping("/moral/export")
    public ResponseEntity<byte[]> exportMoralList(HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || admin.getUserType() != 3) {
            return ResponseEntity.status(403).build();
        }

        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getDeleted, 0).eq(User::getUserType, 1)
               .orderByDesc(User::getMoralScore);
        List<User> users = userService.list(wrapper);

        String[] rankNames = {"", "初学者", "进阶者", "学习达人", "自律标兵", "学霸", "学神"};
        StringBuilder csv = new StringBuilder("学号,姓名,用户名,院系,段位,德育加分\n");
        for (User u : users) {
            int rank = u.getMoralRank() != null ? u.getMoralRank() : 0;
            csv.append(nullSafe(u.getStudentId())).append(",")
               .append(nullSafe(u.getRealName())).append(",")
               .append(nullSafe(u.getUsername())).append(",")
               .append(nullSafe(u.getDepartment())).append(",")
               .append(rank > 0 ? rankNames[rank] : "未入段").append(",")
               .append(u.getMoralScore() != null ? u.getMoralScore() : 0).append("\n");
        }

        byte[] bytes = csv.toString().getBytes(StandardCharsets.UTF_8);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
        String filename = "德育分名单_" + LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".csv";
        headers.setContentDispositionFormData("attachment", new String(filename.getBytes(StandardCharsets.UTF_8), StandardCharsets.ISO_8859_1));
        return ResponseEntity.ok().headers(headers).body(bytes);
    }
}
