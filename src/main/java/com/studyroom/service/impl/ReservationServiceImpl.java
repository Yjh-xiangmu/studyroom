package com.studyroom.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.SysSetting;
import com.studyroom.entity.User;
import com.studyroom.mapper.ReservationMapper;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SysSettingService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ReservationServiceImpl extends ServiceImpl<ReservationMapper, Reservation> implements ReservationService {

    @Autowired
    private UserService userService;

    @Autowired
    private SysSettingService sysSettingService;

    @Override
    public boolean save(Reservation entity) {
        // 创建预约时，检查违约次数
        if (entity.getUserId() != null) {
            User user = userService.getById(entity.getUserId());
            LambdaQueryWrapper<SysSetting> wrapper = new LambdaQueryWrapper<>();
            wrapper.eq(SysSetting::getSettingKey, "max_violation_limit");
            SysSetting setting = sysSettingService.getOne(wrapper);

            int maxLimit = setting != null ? Integer.parseInt(setting.getSettingValue()) : 3;
            int userViolations = user.getViolationCount() != null ? user.getViolationCount() : 0;

            if (userViolations >= maxLimit) {
                throw new RuntimeException("您的违约次数已达上限，系统已自动限制您的预约权限，请联系管理员申诉。");
            }
        }
        return super.save(entity);
    }
}