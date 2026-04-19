package com.studyroom.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.StudyRoom;
import com.studyroom.mapper.StudyRoomMapper;
import com.studyroom.service.StudyRoomService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StudyRoomServiceImpl extends ServiceImpl<StudyRoomMapper, StudyRoom> implements StudyRoomService {

    @Override
    public List<StudyRoom> getHotStudyRooms(int limit) {
        LambdaQueryWrapper<StudyRoom> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(StudyRoom::getStatus, 1)
               .orderByDesc(StudyRoom::getCapacity)
               .last("LIMIT " + limit);
        return list(wrapper);
    }
}
