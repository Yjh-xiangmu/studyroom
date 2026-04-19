package com.studyroom.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.ForumReply;
import com.studyroom.mapper.ForumReplyMapper;
import com.studyroom.service.ForumReplyService;
import org.springframework.stereotype.Service;

@Service
public class ForumReplyServiceImpl extends ServiceImpl<ForumReplyMapper, ForumReply> implements ForumReplyService {
}
