package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("seat_tag")
public class SeatTag {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long roomId;

    private String tagName;

    private String tagColor;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
