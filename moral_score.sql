-- =============================================
-- 德育分系统 SQL 脚本
-- 执行前请备份数据库
-- =============================================

-- 1. sys_user 表新增德育分字段
ALTER TABLE `sys_user`
    ADD COLUMN `moral_score` DECIMAL(3,1) NOT NULL DEFAULT 0.0 COMMENT '已获德育分（最高5分）',
    ADD COLUMN `moral_rank` INT NOT NULL DEFAULT 0 COMMENT '当前德育段位(0=未入段,1~6)';

-- 2. 德育分段位配置（写入 sys_setting）
-- 各段位所需累计学习时长（单位：小时）
INSERT INTO `sys_setting` (`setting_key`, `setting_value`, `description`) VALUES
('moral_rank1_hours', '10',  '段位1-初学者：累计学习时长阈值(小时)'),
('moral_rank2_hours', '30',  '段位2-进阶者：累计学习时长阈值(小时)'),
('moral_rank3_hours', '60',  '段位3-学习达人：累计学习时长阈值(小时)'),
('moral_rank4_hours', '100', '段位4-自律标兵：累计学习时长阈值(小时)'),
('moral_rank5_hours', '150', '段位5-学霸：累计学习时长阈值(小时)'),
('moral_rank6_hours', '200', '段位6-学神：累计学习时长阈值(小时)');

-- 各段位奖励德育分
INSERT INTO `sys_setting` (`setting_key`, `setting_value`, `description`) VALUES
('moral_rank1_score', '0.5', '段位1-初学者：奖励德育分'),
('moral_rank2_score', '0.5', '段位2-进阶者：奖励德育分'),
('moral_rank3_score', '1.0', '段位3-学习达人：奖励德育分'),
('moral_rank4_score', '1.0', '段位4-自律标兵：奖励德育分'),
('moral_rank5_score', '1.0', '段位5-学霸：奖励德育分'),
('moral_rank6_score', '1.0', '段位6-学神：奖励德育分');

-- 3. 德育分获取记录表
CREATE TABLE `user_moral_record` (
    `id`           BIGINT NOT NULL AUTO_INCREMENT,
    `user_id`      BIGINT NOT NULL COMMENT '用户ID',
    `rank_level`   INT NOT NULL COMMENT '达到的段位(1~6)',
    `rank_name`    VARCHAR(20) NOT NULL COMMENT '段位名称',
    `score_awarded` DECIMAL(3,1) NOT NULL COMMENT '本次奖励德育分',
    `total_hours`  DECIMAL(8,1) NOT NULL COMMENT '达成时累计学习时长(小时)',
    `create_time`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '获奖时间',
    PRIMARY KEY (`id`),
    KEY `idx_user_id` (`user_id`),
    CONSTRAINT `fk_moral_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='德育分获取记录';
