-- 座位位置自定义功能数据库迁移脚本
-- 为seat表添加position_x和position_y字段用于拖拽调座

USE studyroom;

-- 添加座位位置坐标字段
ALTER TABLE seat 
ADD COLUMN position_x INT DEFAULT NULL COMMENT '座位自定义X坐标（像素）',
ADD COLUMN position_y INT DEFAULT NULL COMMENT '座位自定义Y坐标（像素）';

-- 创建索引优化查询性能
CREATE INDEX idx_seat_room_position ON seat(room_id, position_x, position_y);

-- 更新说明
-- 已有数据的position_x和position_y保持为NULL，前端会根据row_num和col_num计算默认位置
-- 当管理员拖拽调整座位位置后，会保存到这两个字段中
