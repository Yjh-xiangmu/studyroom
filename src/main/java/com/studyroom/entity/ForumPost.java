package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("forum_post")
public class ForumPost {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long categoryId;

    private String title;

    private String content;

    private Integer postType;

    private Integer viewCount;

    private Integer replyCount;

    private Integer likeCount;

    private Integer isTop;

    private Integer isEssence;

    private Integer status;

    private String auditRemark;

    private LocalDateTime auditTime;

    private Long auditBy;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

}
