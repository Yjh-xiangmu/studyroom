package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Data
@TableName("reservation")
public class Reservation {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private Long roomId;

    private Long seatId;

    private LocalDate reservationDate;

    private LocalTime startTime;

    private LocalTime endTime;

    private Integer status;

    private LocalDateTime checkInTime;

    private LocalDateTime checkOutTime;

    private LocalDateTime cancelTime;

    private String cancelReason;

    private Integer violationCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
