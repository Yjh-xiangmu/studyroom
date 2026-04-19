-- 公告表增强：添加发布者类型字段，修改状态枚举
ALTER TABLE notice 
ADD COLUMN publisher_type INT DEFAULT 1 COMMENT '发布者类型：1-系统管理员，2-自习室管理员' AFTER publisher_name;

-- 更新现有公告数据
UPDATE notice SET publisher_type = 1 WHERE publisher_type IS NULL;

-- 状态字段重新定义：
-- 0-草稿(自习室管理员上报)
-- 1-一级审核通过
-- 2-已发布(二级审核通过)
-- 3-已关闭
-- 4-已屏蔽

-- 将原有状态映射到新状态
-- 原0(草稿) -> 新0(草稿)
-- 原1(已发布) -> 新2(已发布)
-- 原2(已下架) -> 新3(已关闭)
UPDATE notice SET status = 2 WHERE status = 1;
UPDATE notice SET status = 3 WHERE status = 2;
