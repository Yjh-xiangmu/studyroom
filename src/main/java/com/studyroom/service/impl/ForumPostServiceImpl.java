package com.studyroom.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.ForumPost;
import com.studyroom.mapper.ForumPostMapper;
import com.studyroom.service.ForumPostService;
import org.springframework.stereotype.Service;

@Service
public class ForumPostServiceImpl extends ServiceImpl<ForumPostMapper, ForumPost> implements ForumPostService {
}
