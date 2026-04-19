package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("check_in_record")
public class CheckInRecord {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long reservationId;

    private Long seatId;

    private LocalDateTime checkInTime;

    private LocalDateTime checkOutTime;

    private Integer studyDuration;

    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

}
