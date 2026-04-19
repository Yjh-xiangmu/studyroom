package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("study_statistics")
public class StudyStatistics {

    @TableId(type = IdType.AUTO)
    private Long id;

    private Long userId;

    private LocalDate statisticsDate;

    private Integer studyDuration;

    private Integer checkInCount;

    private Integer reservationCount;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;

}
