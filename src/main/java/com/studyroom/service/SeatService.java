package com.studyroom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.studyroom.entity.Seat;

import java.util.List;

public interface SeatService extends IService<Seat> {
    
    /**
     * 根据自习室ID获取座位列表
     * @param roomId 自习室ID
     * @return 座位列表
     */
    List<Seat> getSeatsByRoomId(Long roomId);
}
