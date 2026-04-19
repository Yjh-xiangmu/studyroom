package com.studyroom.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.studyroom.common.Result;
import com.studyroom.entity.Seat;
import com.studyroom.entity.StudyRoom;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SeatService;
import com.studyroom.service.StudyRoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/studyroom")
public class StudyRoomController {

    @Autowired
    private StudyRoomService studyRoomService;

    @Autowired
    private SeatService seatService;

    @Autowired
    private ReservationService reservationService;

    @GetMapping("/list")
    public Result<Page<StudyRoom>> getStudyRoomList(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String building,
            @RequestParam(required = false) Integer floor) {
        
        LambdaQueryWrapper<StudyRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudyRoom::getDeleted, 0);
        wrapper.eq(StudyRoom::getStatus, 1);
        
        if (name != null && !name.isEmpty()) {
            wrapper.like(StudyRoom::getName, name);
        }
        if (building != null && !building.isEmpty()) {
            wrapper.eq(StudyRoom::getBuilding, building);
        }
        if (floor != null) {
            wrapper.eq(StudyRoom::getFloor, floor);
        }
        
        wrapper.orderByDesc(StudyRoom::getCreateTime);
        Page<StudyRoom> pageResult = studyRoomService.page(new Page<>(page, size), wrapper);
        return Result.success(pageResult);
    }

    @GetMapping("/{id}")
    public Result<StudyRoom> getStudyRoomById(@PathVariable Long id) {
        StudyRoom room = studyRoomService.getById(id);
        if (room == null) {
            return Result.error(404, "自习室不存在");
        }
        return Result.success(room);
    }

    @GetMapping("/{id}/seats")
    public Result<List<Seat>> getSeatsByRoomId(@PathVariable Long id) {
        List<Seat> seats = seatService.getSeatsByRoomId(id);
        return Result.success(seats);
    }
    
    @GetMapping("/seat/{seatId}")
    public Result<Seat> getSeatById(@PathVariable Long seatId) {
        Seat seat = seatService.getById(seatId);
        if (seat == null) {
            return Result.error(404, "座位不存在");
        }
        return Result.success(seat);
    }
}