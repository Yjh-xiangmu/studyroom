package com.studyroom.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.studyroom.entity.Reservation;
import com.studyroom.entity.SysSetting;
import com.studyroom.entity.User;
import com.studyroom.entity.UserMoralRecord;
import com.studyroom.mapper.UserMoralRecordMapper;
import com.studyroom.service.ReservationService;
import com.studyroom.service.SysSettingService;
import com.studyroom.service.UserMoralRecordService;
import com.studyroom.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.Duration;
import java.util.List;

@Service
public class UserMoralRecordServiceImpl extends ServiceImpl<UserMoralRecordMapper, UserMoralRecord>
        implements UserMoralRecordService {

    // 段位名称
    private static final String[] RANK_NAMES = {"", "初学者", "进阶者", "学习达人", "自律标兵", "学霸", "学神"};
    // 默认各段位时长阈值（小时）
    private static final double[] DEFAULT_HOURS = {0, 10, 30, 60, 100, 150, 200};
    // 默认各段位奖励德育分
    private static final double[] DEFAULT_SCORES = {0, 0.5, 0.5, 1.0, 1.0, 1.0, 1.0};

    @Autowired
    private UserService userService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private SysSettingService sysSettingService;

    @Override
    @Transactional
    public void checkAndAwardMoralScore(Long userId) {
        User user = userService.getById(userId);
        if (user == null) return;

        // 计算累计学习时长
        LambdaQueryWrapper<Reservation> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Reservation::getUserId, userId).isNotNull(Reservation::getCheckInTime);
        List<Reservation> list = reservationService.list(wrapper);

        double totalHours = 0;
        for (Reservation r : list) {
            if (r.getCheckInTime() != null) {
                if (r.getCheckOutTime() != null) {
                    totalHours += Duration.between(r.getCheckInTime(), r.getCheckOutTime()).toMinutes() / 60.0;
                } else {
                    totalHours += 2.0;
                }
            }
        }

        // 读取系统配置的段位阈值
        double[] rankHours = new double[7];
        double[] rankScores = new double[7];
        for (int i = 1; i <= 6; i++) {
            rankHours[i] = getSettingDouble("moral_rank" + i + "_hours", DEFAULT_HOURS[i]);
            rankScores[i] = getSettingDouble("moral_rank" + i + "_score", DEFAULT_SCORES[i]);
        }

        // 已获最高段位
        int currentRank = user.getMoralRank() != null ? user.getMoralRank() : 0;

        // 检查是否解锁新段位
        int newRank = currentRank;
        for (int i = currentRank + 1; i <= 6; i++) {
            if (totalHours >= rankHours[i]) {
                newRank = i;
            } else {
                break;
            }
        }

        if (newRank <= currentRank) return;

        // 逐段位发放德育分（可能一次跨多个段位）
        BigDecimal totalScore = user.getMoralScore() != null ? user.getMoralScore() : BigDecimal.ZERO;
        for (int i = currentRank + 1; i <= newRank; i++) {
            BigDecimal award = BigDecimal.valueOf(rankScores[i]);
            // 不超过上限5分
            BigDecimal newTotal = totalScore.add(award);
            if (newTotal.compareTo(BigDecimal.valueOf(5.0)) > 0) {
                award = BigDecimal.valueOf(5.0).subtract(totalScore);
            }
            if (award.compareTo(BigDecimal.ZERO) <= 0) break;
            totalScore = totalScore.add(award);

            UserMoralRecord record = new UserMoralRecord();
            record.setUserId(userId);
            record.setRankLevel(i);
            record.setRankName(RANK_NAMES[i]);
            record.setScoreAwarded(award);
            record.setTotalHours(BigDecimal.valueOf(totalHours));
            save(record);
        }

        user.setMoralRank(newRank);
        user.setMoralScore(totalScore);
        userService.updateById(user);
    }

    private double getSettingDouble(String key, double defaultValue) {
        SysSetting setting = sysSettingService.getOne(
                new LambdaQueryWrapper<SysSetting>().eq(SysSetting::getSettingKey, key));
        if (setting != null) {
            try { return Double.parseDouble(setting.getSettingValue()); } catch (Exception ignored) {}
        }
        return defaultValue;
    }
}
