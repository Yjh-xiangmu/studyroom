package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.*;
import com.studyroom.service.*;
import com.studyroom.mapper.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/roomadmin")
public class RoomAdminController {

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private SeatTagMapper seatTagMapper;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private UserService userService;

    @Autowired
    private ForumPostService forumPostService;

    @Autowired
    private NoticeService noticeService;

    // ========== 控制台数据 ==========
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> getDashboardData(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Map<String, Object> data = new HashMap<>();

        // 获取管理的自习室
        LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(StudyRoom::getAdminId, user.getId());
        roomWrapper.eq(StudyRoom::getDeleted, 0);
        List<StudyRoom> rooms = studyRoomService.list(roomWrapper);
        data.put("managedRooms", rooms.size());

        // 今日预约数
        LambdaQueryWrapper<Reservation> todayResWrapper = new LambdaQueryWrapper<>();
        todayResWrapper.in(Reservation::getRoomId, rooms.stream().map(StudyRoom::getId).collect(Collectors.toList()));
        todayResWrapper.eq(Reservation::getReservationDate, LocalDate.now());
        todayResWrapper.ne(Reservation::getStatus, 3);
        data.put("todayReservations", reservationService.count(todayResWrapper));

        // 今日签到数
        LambdaQueryWrapper<Reservation> checkinWrapper = new LambdaQueryWrapper<>();
        checkinWrapper.in(Reservation::getRoomId, rooms.stream().map(StudyRoom::getId).collect(Collectors.toList()));
        checkinWrapper.eq(Reservation::getReservationDate, LocalDate.now());
        checkinWrapper.eq(Reservation::getStatus, 1);
        data.put("todayCheckIns", reservationService.count(checkinWrapper));

        // 总座位数
        int totalSeats = 0;
        for (StudyRoom room : rooms) {
            LambdaQueryWrapper<Seat> seatWrapper = new LambdaQueryWrapper<>();
            seatWrapper.eq(Seat::getRoomId, room.getId());
            totalSeats += seatService.count(seatWrapper);
        }
        data.put("totalSeats", totalSeats);

        // 待处理帖子
        LambdaQueryWrapper<ForumPost> postWrapper = new LambdaQueryWrapper<>();
        postWrapper.eq(ForumPost::getStatus, 1);
        data.put("pendingPosts", forumPostService.count(postWrapper));

        // 累计预约处理总数
        LambdaQueryWrapper<Reservation> totalResWrapper = new LambdaQueryWrapper<>();
        if (!rooms.isEmpty()) {
            totalResWrapper.in(Reservation::getRoomId, rooms.stream().map(StudyRoom::getId).collect(Collectors.toList()));
        }
        data.put("totalReservations", reservationService.count(totalResWrapper));

        // 已处理帖子（状态为2=已处理/3=已关闭）
        LambdaQueryWrapper<ForumPost> processedWrapper = new LambdaQueryWrapper<>();
        List<Integer> processedStatus = new ArrayList<>();
        processedStatus.add(2);
        processedStatus.add(3);
        processedWrapper.in(ForumPost::getStatus, processedStatus);
        data.put("processedPosts", forumPostService.count(processedWrapper));

        return Result.success(data);
    }

    // ========== 自习室管理 ==========
    @GetMapping("/rooms")
    public Result<List<StudyRoom>> getMyRooms(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        LambdaQueryWrapper<StudyRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudyRoom::getAdminId, user.getId());
        wrapper.eq(StudyRoom::getDeleted, 0);
        wrapper.orderByDesc(StudyRoom::getCreateTime);

        return Result.success(studyRoomService.list(wrapper));
    }

    @GetMapping("/room/{id}")
    public Result<StudyRoom> getRoomDetail(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        return Result.success(room);
    }

    @PutMapping("/room/{id}")
    public Result<String> updateRoom(@PathVariable Long id, @RequestBody StudyRoom room, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom existing = studyRoomService.getById(id);
        if (existing == null || !existing.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        room.setId(id);
        room.setUpdateTime(LocalDateTime.now());
        boolean success = studyRoomService.updateById(room);

        if (success) {
            return Result.success("更新成功");
        }
        return Result.error(500, "更新失败");
    }

    // ========== 座位管理 ==========
    @GetMapping("/room/{id}/seats")
    public Result<List<Seat>> getRoomSeats(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        LambdaQueryWrapper<Seat> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Seat::getRoomId, id);
        wrapper.orderByAsc(Seat::getRowNum);
        wrapper.orderByAsc(Seat::getColNum);

        return Result.success(seatService.list(wrapper));
    }

    @PutMapping("/seat/{id}/status")
    public Result<String> updateSeatStatus(@PathVariable Long id, @RequestParam Integer status, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Seat seat = seatService.getById(id);
        if (seat == null) {
            return Result.error(404, "座位不存在");
        }

        StudyRoom room = studyRoomService.getById(seat.getRoomId());
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(403, "无权限");
        }

        seat.setStatus(status);
        seat.setUpdateTime(LocalDateTime.now());
        boolean success = seatService.updateById(seat);

        if (success) {
            return Result.success("更新成功");
        }
        return Result.error(500, "更新失败");
    }

    // 批量更新座位位置（拖拽调座）
    @PutMapping("/room/{id}/seats/positions")
    public Result<String> updateSeatPositions(@PathVariable Long id, @RequestBody List<Seat> seats, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        // 验证所有座位是否属于该自习室
        for (Seat seat : seats) {
            Seat existingSeat = seatService.getById(seat.getId());
            if (existingSeat == null || !existingSeat.getRoomId().equals(id)) {
                return Result.error(400, "座位数据异常");
            }
        }

        // 批量更新座位位置
        boolean success = seatService.updateBatchById(seats);

        if (success) {
            return Result.success("座位位置更新成功");
        }
        return Result.error(500, "更新失败");
    }

    // ========== 座位标签管理 ==========
    @GetMapping("/room/{id}/seat-tags")
    public Result<List<SeatTag>> getSeatTags(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        LambdaQueryWrapper<SeatTag> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(SeatTag::getRoomId, id);
        return Result.success(seatTagMapper.selectList(wrapper));
    }

    @PostMapping("/room/{id}/seat-tag")
    public Result<String> addSeatTag(@PathVariable Long id, @RequestBody SeatTag tag, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        tag.setRoomId(id);
        tag.setCreateTime(LocalDateTime.now());
        tag.setUpdateTime(LocalDateTime.now());
        seatTagMapper.insert(tag);
        return Result.success("添加成功");
    }

    @DeleteMapping("/seat-tag/{tagId}")
    public Result<String> deleteSeatTag(@PathVariable Long tagId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        seatTagMapper.deleteById(tagId);
        return Result.success("删除成功");
    }

    // 更新座位标签
    @PutMapping("/seat/{id}/tags")
    public Result<String> updateSeatTags(@PathVariable Long id, @RequestBody Map<String, Object> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Seat seat = seatService.getById(id);
        if (seat == null) {
            return Result.error(404, "座位不存在");
        }

        StudyRoom room = studyRoomService.getById(seat.getRoomId());
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(403, "无权限");
        }

        String tags = (String) data.get("tags");
        seat.setTags(tags);
        seat.setUpdateTime(LocalDateTime.now());
        seatService.updateById(seat);
        return Result.success("更新成功");
    }

    // 添加过道/空隙
    @PostMapping("/room/{id}/seat-special")
    public Result<String> addSpecialSeat(@PathVariable Long id, @RequestBody Seat seat, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        StudyRoom room = studyRoomService.getById(id);
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(404, "自习室不存在");
        }

        seat.setRoomId(id);
        seat.setStatus(0);
        // 过道和空隙不需要 row_num 和 col_num，设置为 0
        if (seat.getRowNum() == null) {
            seat.setRowNum(0);
        }
        if (seat.getColNum() == null) {
            seat.setColNum(0);
        }
        seat.setCreateTime(LocalDateTime.now());
        seat.setUpdateTime(LocalDateTime.now());
        seatService.save(seat);
        return Result.success("添加成功");
    }

    // 删除座位
    @DeleteMapping("/seat/{id}")
    public Result<String> deleteSeat(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Seat seat = seatService.getById(id);
        if (seat == null) {
            return Result.error(404, "座位不存在");
        }

        StudyRoom room = studyRoomService.getById(seat.getRoomId());
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(403, "无权限");
        }

        seatService.removeById(id);
        return Result.success("删除成功");
    }

    // ========== 预约管理 ==========
    @GetMapping("/reservations")
    public Result<Page<Map<String, Object>>> getReservations(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Long roomId,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String date,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        // 获取管理的自习室ID列表
        LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(StudyRoom::getAdminId, user.getId());
        roomWrapper.eq(StudyRoom::getDeleted, 0);
        List<StudyRoom> rooms = studyRoomService.list(roomWrapper);
        List<Long> roomIds = rooms.stream().map(StudyRoom::getId).collect(Collectors.toList());

        if (roomIds.isEmpty()) {
            return Result.success(new Page<>());
        }

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(Reservation::getRoomId, roomIds);

        if (roomId != null) {
            wrapper.eq(Reservation::getRoomId, roomId);
        }
        if (status != null) {
            wrapper.eq(Reservation::getStatus, status);
        }
        if (date != null && !date.isEmpty()) {
            wrapper.eq(Reservation::getReservationDate, LocalDate.parse(date));
        }

        wrapper.orderByDesc(Reservation::getCreateTime);
        Page<Reservation> pageResult = reservationService.page(new Page<>(page, size), wrapper);

        // 组装数据
        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("checkInTime", r.getCheckInTime());
            map.put("checkOutTime", r.getCheckOutTime());

            StudyRoom room = studyRoomService.getById(r.getRoomId());
            Seat seat = seatService.getById(r.getSeatId());
            User u = userService.getById(r.getUserId());

            map.put("roomName", room != null ? room.getName() : "未知");
            map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知");
            map.put("userName", u != null ? (u.getRealName() != null ? u.getRealName() : u.getUsername()) : "未知");

            records.add(map);
        }

        Page<Map<String, Object>> result = new Page<>();
        result.setCurrent(pageResult.getCurrent());
        result.setSize(pageResult.getSize());
        result.setTotal(pageResult.getTotal());
        result.setRecords(records);

        return Result.success(result);
    }

    // ========== 预约管理增强 ==========
    @DeleteMapping("/reservation/{id}")
    public Result<String> deleteReservation(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Reservation reservation = reservationService.getById(id);
        if (reservation == null) {
            return Result.error(404, "预约不存在");
        }

        StudyRoom room = studyRoomService.getById(reservation.getRoomId());
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(403, "无权限");
        }

        reservation.setStatus(3);
        reservation.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(reservation);
        return Result.success("取消成功");
    }

    @PutMapping("/reservation/{id}")
    public Result<String> updateReservation(@PathVariable Long id, @RequestBody Reservation reservation, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        Reservation existing = reservationService.getById(id);
        if (existing == null) return Result.error(404, "预约不存在");

        StudyRoom room = studyRoomService.getById(existing.getRoomId());
        if (room == null || !room.getAdminId().equals(user.getId())) {
            return Result.error(403, "无权限");
        }

        Integer newStatus = reservation.getStatus();
        Integer oldStatus = existing.getStatus();

        // 只允许以下状态变更：取消(→4)、标记违约(→3)、恢复待签到(→0)
        if (newStatus != 4 && newStatus != 3 && newStatus != 0) {
            return Result.error(400, "不允许直接将状态改为该值，请通过出勤管理操作");
        }

        existing.setStatus(newStatus);
        existing.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(existing);

        // 同步用户违约次数
        User targetUser = userService.getById(existing.getUserId());
        if (targetUser != null) {
            if (newStatus == 3 && oldStatus != 3) {
                // 变为违约：+1
                targetUser.setViolationCount(targetUser.getViolationCount() == null ? 1 : targetUser.getViolationCount() + 1);
                userService.updateById(targetUser);
            } else if (oldStatus == 3 && newStatus != 3) {
                // 从违约恢复：-1（最小为0）
                int count = targetUser.getViolationCount() == null ? 0 : targetUser.getViolationCount();
                targetUser.setViolationCount(Math.max(0, count - 1));
                userService.updateById(targetUser);
            }
        }

        return Result.success("更新成功");
    }

    // ========== 出勤管理 ==========
    @GetMapping("/attendance")
    public Result<Map<String, Object>> getAttendance(
            @RequestParam(required = false) String date,
            @RequestParam(required = false) Long roomId,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        LocalDate queryDate = date != null ? LocalDate.parse(date) : LocalDate.now();

        // 获取管理的自习室
        LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(StudyRoom::getAdminId, user.getId());
        roomWrapper.eq(StudyRoom::getDeleted, 0);
        if (roomId != null) {
            roomWrapper.eq(StudyRoom::getId, roomId);
        }
        List<StudyRoom> rooms = studyRoomService.list(roomWrapper);
        List<Long> roomIds = rooms.stream().map(StudyRoom::getId).collect(Collectors.toList());

        Map<String, Object> data = new HashMap<>();

        // 今日预约总数
        LambdaQueryWrapper<Reservation> resWrapper = new LambdaQueryWrapper<>();
        resWrapper.in(Reservation::getRoomId, roomIds);
        resWrapper.eq(Reservation::getReservationDate, queryDate);
        resWrapper.ne(Reservation::getStatus, 3);
        data.put("totalReservations", reservationService.count(resWrapper));

        // 已签到数
        LambdaQueryWrapper<Reservation> checkinWrapper = new LambdaQueryWrapper<>();
        checkinWrapper.in(Reservation::getRoomId, roomIds);
        checkinWrapper.eq(Reservation::getReservationDate, queryDate);
        checkinWrapper.eq(Reservation::getStatus, 1);
        data.put("checkedIn", reservationService.count(checkinWrapper));

        // 已完成数
        LambdaQueryWrapper<Reservation> completeWrapper = new LambdaQueryWrapper<>();
        completeWrapper.in(Reservation::getRoomId, roomIds);
        completeWrapper.eq(Reservation::getReservationDate, queryDate);
        completeWrapper.eq(Reservation::getStatus, 2);
        data.put("completed", reservationService.count(completeWrapper));

        // 未签到数（待签到）
        LambdaQueryWrapper<Reservation> pendingWrapper = new LambdaQueryWrapper<>();
        pendingWrapper.in(Reservation::getRoomId, roomIds);
        pendingWrapper.eq(Reservation::getReservationDate, queryDate);
        pendingWrapper.eq(Reservation::getStatus, 0);
        data.put("pending", reservationService.count(pendingWrapper));

        return Result.success(data);
    }

    // ========== 出勤管理增强 ==========
    @GetMapping("/attendance/detail")
    public Result<Page<Map<String, Object>>> getAttendanceDetail(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String date,
            @RequestParam(required = false) Long roomId,
            @RequestParam(required = false) Integer status,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        LocalDate queryDate = date != null ? LocalDate.parse(date) : LocalDate.now();

        LambdaQueryWrapper<StudyRoom> roomWrapper = new LambdaQueryWrapper<>();
        roomWrapper.eq(StudyRoom::getAdminId, user.getId());
        roomWrapper.eq(StudyRoom::getDeleted, 0);
        if (roomId != null) {
            roomWrapper.eq(StudyRoom::getId, roomId);
        }
        List<StudyRoom> rooms = studyRoomService.list(roomWrapper);
        List<Long> roomIds = rooms.stream().map(StudyRoom::getId).collect(Collectors.toList());

        if (roomIds.isEmpty()) {
            return Result.success(new Page<>());
        }

        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.in(Reservation::getRoomId, roomIds);
        wrapper.eq(Reservation::getReservationDate, queryDate);
        
        if (status != null) {
            wrapper.eq(Reservation::getStatus, status);
        }

        wrapper.orderByDesc(Reservation::getCreateTime);
        Page<Reservation> pageResult = reservationService.page(new Page<>(page, size), wrapper);

        List<Map<String, Object>> records = new ArrayList<>();
        for (Reservation r : pageResult.getRecords()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", r.getId());
            map.put("reservationDate", r.getReservationDate());
            map.put("startTime", r.getStartTime());
            map.put("endTime", r.getEndTime());
            map.put("status", r.getStatus());
            map.put("checkInTime", r.getCheckInTime());
            map.put("checkOutTime", r.getCheckOutTime());

            StudyRoom room = studyRoomService.getById(r.getRoomId());
            Seat seat = seatService.getById(r.getSeatId());
            User u = userService.getById(r.getUserId());

            map.put("roomName", room != null ? room.getName() : "未知");
            map.put("seatNumber", seat != null ? seat.getSeatNumber() : "未知");
            map.put("userName", u != null ? (u.getRealName() != null ? u.getRealName() : u.getUsername()) : "未知");
            map.put("appealStatus", r.getAppealStatus());
            map.put("appealReason", r.getAppealReason());

            records.add(map);
        }

        Page<Map<String, Object>> result = new Page<>();
        result.setCurrent(pageResult.getCurrent());
        result.setSize(pageResult.getSize());
        result.setTotal(pageResult.getTotal());
        result.setRecords(records);

        return Result.success(result);
    }

    // ========== 出勤申诉 ==========
    @PutMapping("/reservation/{id}/appeal")
    public Result<String> submitAppeal(@PathVariable Long id, @RequestBody Map<String, String> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) return Result.error(403, "无权限");

        Reservation reservation = reservationService.getById(id);
        if (reservation == null) return Result.error(404, "记录不存在");
        if (reservation.getStatus() != 3) return Result.error(400, "只能对违约记录提交申诉");
        if (reservation.getAppealStatus() != null && reservation.getAppealStatus() == 1) return Result.error(400, "该记录已有待处理申诉");

        reservation.setAppealStatus(1);
        reservation.setAppealReason(params.get("reason"));
        reservation.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(reservation);
        return Result.success("申诉已提交，等待系统管理员审核");
    }

    @PutMapping("/reservation/{id}/mark-violation")
    public Result<String> markViolation(@PathVariable Long id, @RequestBody Map<String, String> params, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) return Result.error(403, "无权限");

        Reservation reservation = reservationService.getById(id);
        if (reservation == null) return Result.error(404, "记录不存在");
        if (reservation.getStatus() == 3) return Result.error(400, "该记录已是违约状态");

        int oldStatus = reservation.getStatus();
        reservation.setStatus(3); // 标记为违约
        reservation.setAppealStatus(0);
        reservation.setUpdateTime(LocalDateTime.now());
        reservationService.updateById(reservation);

        // 增加用户违约次数
        User targetUser = userService.getById(reservation.getUserId());
        if (targetUser != null) {
            targetUser.setViolationCount(targetUser.getViolationCount() == null ? 1 : targetUser.getViolationCount() + 1);
            userService.updateById(targetUser);
        }
        return Result.success("已标记为违规");
    }
    @GetMapping("/posts")
    public Result<Page<Map<String, Object>>> getPosts(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) Integer status,
            HttpSession session) {

        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        LambdaQueryWrapper<ForumPost> wrapper = new LambdaQueryWrapper<>();
        if (status != null) {
            wrapper.eq(ForumPost::getStatus, status);
        }
        wrapper.orderByDesc(ForumPost::getCreateTime);

        Page<ForumPost> pageResult = forumPostService.page(new Page<>(page, size), wrapper);
        
        // 组装数据，添加作者名称
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
            map.put("createTime", post.getCreateTime());
            map.put("updateTime", post.getUpdateTime());
            
            // 获取作者名称
            User author = userService.getById(post.getUserId());
            map.put("authorName", author != null ? (author.getRealName() != null ? author.getRealName() : author.getUsername()) : "未知用户");
            
            records.add(map);
        }
        
        Page<Map<String, Object>> result = new Page<>();
        result.setCurrent(pageResult.getCurrent());
        result.setSize(pageResult.getSize());
        result.setTotal(pageResult.getTotal());
        result.setRecords(records);

        return Result.success(result);
    }

    @PutMapping("/post/{id}/status")
    public Result<String> updatePostStatus(@PathVariable Long id, @RequestParam Integer status, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        ForumPost post = forumPostService.getById(id);
        if (post == null) {
            return Result.error(404, "帖子不存在");
        }

        post.setStatus(status);
        post.setUpdateTime(LocalDateTime.now());
        boolean success = forumPostService.updateById(post);

        if (success) {
            return Result.success("操作成功");
        }
        return Result.error(500, "操作失败");
    }

    // ========== 论坛发帖 ==========
    @PostMapping("/post")
    public Result<String> createPost(@RequestBody ForumPost post, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        post.setUserId(user.getId());
        post.setStatus(1);
        post.setViewCount(0);
        post.setReplyCount(0);
        post.setLikeCount(0);
        post.setCreateTime(LocalDateTime.now());
        post.setUpdateTime(LocalDateTime.now());

        boolean success = forumPostService.save(post);
        if (success) {
            return Result.success("发布成功");
        }
        return Result.error(500, "发布失败");
    }

    // ========== 公告上报（自习室管理员） ==========
    @GetMapping("/notices")
    public Result<Page<Notice>> getMyNotices(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        LambdaQueryWrapper<Notice> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notice::getDeleted, 0);
        // 自习室管理员只能看到自己上报的公告
        wrapper.eq(Notice::getPublisherId, user.getId());
        wrapper.orderByDesc(Notice::getCreateTime);

        Page<Notice> pageResult = noticeService.page(new Page<>(page, size), wrapper);
        return Result.success(pageResult);
    }

    @PostMapping("/notice")
    public Result<String> submitNotice(@RequestBody Notice notice, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        notice.setPublisherId(user.getId());
        notice.setPublisherName(user.getRealName() != null ? user.getRealName() : user.getUsername());
        notice.setPublisherType(2); // 自习室管理员
        notice.setViewCount(0);
        notice.setStatus(0); // 草稿状态，待系统管理员审核
        notice.setCreateTime(LocalDateTime.now());
        notice.setUpdateTime(LocalDateTime.now());

        boolean success = noticeService.save(notice);
        if (success) {
            return Result.success("上报成功，等待系统管理员审核");
        }
        return Result.error(500, "上报失败");
    }

    @PutMapping("/notice/{id}")
    public Result<String> updateNotice(@PathVariable Long id, @RequestBody Notice notice, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        // 只能修改自己上报且未审核的公告
        Notice existing = noticeService.getById(id);
        if (existing == null || !existing.getPublisherId().equals(user.getId())) {
            return Result.error(403, "无权限修改此公告");
        }
        if (existing.getStatus() != 0) {
            return Result.error(400, "只能修改待审核的公告");
        }

        existing.setTitle(notice.getTitle());
        existing.setContent(notice.getContent());
        existing.setIsTop(notice.getIsTop());
        existing.setUpdateTime(LocalDateTime.now());

        boolean success = noticeService.updateById(existing);
        if (success) {
            return Result.success("修改成功");
        }
        return Result.error(500, "修改失败");
    }

    @DeleteMapping("/notice/{id}")
    public Result<String> deleteNotice(@PathVariable Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }

        // 只能删除自己上报且未审核的公告
        Notice existing = noticeService.getById(id);
        if (existing == null || !existing.getPublisherId().equals(user.getId())) {
            return Result.error(403, "无权限删除此公告");
        }
        if (existing.getStatus() != 0) {
            return Result.error(400, "只能删除待审核的公告");
        }

        boolean success = noticeService.removeById(id);
        if (success) {
            return Result.success("删除成功");
        }
        return Result.error(500, "删除失败");
    }

    // ========== 系统管理员信息 ==========
    @GetMapping("/sysadmin-info")
    public Result<Map<String, Object>> getSysAdminInfo(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getUserType() != 2) {
            return Result.error(403, "无权限");
        }
        // 查询系统管理员（userType=3）
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUserType, 3);
        wrapper.last("LIMIT 1");
        User sysAdmin = userService.getOne(wrapper);
        Map<String, Object> result = new HashMap<>();
        if (sysAdmin != null) {
            result.put("username", sysAdmin.getUsername());
            result.put("realName", sysAdmin.getRealName());
            result.put("email", sysAdmin.getEmail());
            result.put("phone", sysAdmin.getPhone());
        }
        return Result.success(result);
    }
}
