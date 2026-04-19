package com.studyroom.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.SysSetting;
import com.studyroom.mapper.SysSettingMapper;
import com.studyroom.service.SysSettingService;
import org.springframework.stereotype.Service;

@Service
public class SysSettingServiceImpl extends ServiceImpl<SysSettingMapper, SysSetting> implements SysSettingService {
}