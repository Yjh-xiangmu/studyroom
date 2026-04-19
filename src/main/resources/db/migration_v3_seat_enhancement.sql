-- 座位表增强：添加座位类型和标签字段
ALTER TABLE seat 
ADD COLUMN seat_type INT DEFAULT 1 COMMENT '座位类型：1-普通座位，2-过道/柱子，3-空隙/空白',
ADD COLUMN tags VARCHAR(500) DEFAULT NULL COMMENT '座位标签，JSON格式存储，如：["靠窗","有插座"]';

-- 座位表添加自定义尺寸字段（用于过道/柱子）
ALTER TABLE seat 
ADD COLUMN width INT DEFAULT NULL COMMENT '自定义宽度（px），用于过道/柱子',
ADD COLUMN height INT DEFAULT NULL COMMENT '自定义高度（px），用于过道/柱子';

-- 座位标签表
CREATE TABLE IF NOT EXISTS seat_tag (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    room_id BIGINT NOT NULL COMMENT '自习室ID',
    tag_name VARCHAR(50) NOT NULL COMMENT '标签名称',
    tag_color VARCHAR(20) DEFAULT '#409EFF' COMMENT '标签颜色',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_room_id (room_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位标签表';
