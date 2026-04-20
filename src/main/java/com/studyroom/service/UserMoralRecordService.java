package com.studyroom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.studyroom.entity.UserMoralRecord;

public interface UserMoralRecordService extends IService<UserMoralRecord> {
    /**
     * 签退后触发：检查用户累计学习时长，发放新段位德育分
     * @param userId 用户ID
     */
    void checkAndAwardMoralScore(Long userId);
}
