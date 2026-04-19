package com.studyroom.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.studyroom.entity.Notice;

import java.util.List;

public interface NoticeService extends IService<Notice> {
    
    /**
     * 获取最新的公告
     * @param limit 数量限制
     * @return 公告列表
     */
    List<Notice> getLatestNotices(int limit);
}
