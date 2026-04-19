package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("seat")
public class Seat {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long roomId;

    private String seatNumber;

    private Integer rowNum;

    private Integer colNum;

    private Integer status;

    // 自定义位置坐标（用于拖拽调座）
    private Integer positionX;

    private Integer positionY;

    // 座位类型：1-普通座位，2-过道/柱子，3-空隙/空白
    private Integer seatType;

    // 座位标签，JSON格式存储，如：["靠窗","有插座"]
    private String tags;

    // 自定义尺寸（用于过道/柱子）
    private Integer width;

    private Integer height;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}