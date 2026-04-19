package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("notice")
public class Notice {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String title;

    private String content;

    private Long publisherId;

    private String publisherName;

    private Integer isTop;

    private Integer viewCount;

    private Integer status; // 0-草稿(自习室管理员上报) 1-一级审核通过 2-已发布(二级审核通过) 3-已关闭 4-已屏蔽

    private Integer publisherType; // 1-系统管理员 2-自习室管理员

    private LocalDateTime publishTime;

    private LocalDateTime createTime;

    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

}
