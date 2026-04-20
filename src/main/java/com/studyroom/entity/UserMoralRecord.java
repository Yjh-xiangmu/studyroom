package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("user_moral_record")
public class UserMoralRecord {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Integer rankLevel;
    private String rankName;
    private BigDecimal scoreAwarded;
    private BigDecimal totalHours;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
}
