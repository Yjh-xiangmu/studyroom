package com.studyroom.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("sys_user")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String phone;
    private String email;
    private String avatar;
    private String studentId;
    private String department;
    private String major;
    private Integer status;
    private Integer userType;
    private LocalDateTime lastLoginTime;
    private String lastLoginIp;

    // 新增：违约次数和连续签到天数
    private Integer violationCount;
    private Integer continuousCheckinDays;

    // 德育分
    private BigDecimal moralScore;
    private Integer moralRank;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    @TableLogic
    private Integer deleted;
}