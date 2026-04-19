package com.studyroom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.studyroom.entity.StudyRoom;

import java.util.List;

public interface StudyRoomService extends IService<StudyRoom> {
    
    /**
     * 获取热门自习室
     * @param limit 数量限制
     * @return 自习室列表
     */
    List<StudyRoom> getHotStudyRooms(int limit);
}
