package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@TableName("study_room")
public class StudyRoom {

    @TableId(type = IdType.AUTO)
    private Long id;

    private String name;

    private String building;

    private Integer floor;

    private String roomNumber;

    private String type;

    private Integer capacity;

    private Integer rowCount;

    private Integer colCount;

    private LocalTime openTime;

    private LocalTime closeTime;

    private Boolean hasAirCondition;

    private Boolean hasWifi;

    private Boolean hasPower;

    private String description;

    private String imageUrl;

    private Integer status;

    private Long adminId;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

    @TableLogic
    private Integer deleted;

}
