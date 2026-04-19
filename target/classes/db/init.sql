-- 高校自习室智能管理系统数据库初始化脚本

-- 创建数据库
CREATE DATABASE IF NOT EXISTS studyroom CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE studyroom;

-- 角色表
CREATE TABLE sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_code VARCHAR(50) NOT NULL UNIQUE COMMENT '角色编码',
    description VARCHAR(200) COMMENT '角色描述',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 用户表
CREATE TABLE sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(100) NOT NULL COMMENT '密码',
    real_name VARCHAR(50) COMMENT '真实姓名',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    avatar VARCHAR(200) COMMENT '头像URL',
    user_type INT DEFAULT 1 COMMENT '用户类型：1-普通用户 2-自习室管理员 3-系统管理员',
    status INT DEFAULT 1 COMMENT '状态：0-禁用 1-启用',
    last_login_time DATETIME COMMENT '最后登录时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0 COMMENT '逻辑删除：0-未删除 1-已删除'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 用户角色关联表
CREATE TABLE sys_user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sur_user_id FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_sur_role_id FOREIGN KEY (role_id) REFERENCES sys_role(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户角色关联表';

-- 自习室表
CREATE TABLE study_room (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '自习室名称',
    building VARCHAR(50) NOT NULL COMMENT '教学楼',
    floor INT NOT NULL COMMENT '楼层',
    room_number VARCHAR(20) COMMENT '房间号',
    type VARCHAR(20) DEFAULT '普通' COMMENT '类型：普通/静音/讨论室',
    capacity INT NOT NULL COMMENT '容量',
    row_count INT DEFAULT 5 COMMENT '座位行数',
    col_count INT DEFAULT 10 COMMENT '座位列数',
    open_time TIME DEFAULT '08:00:00' COMMENT '开放时间',
    close_time TIME DEFAULT '22:00:00' COMMENT '关闭时间',
    has_air_condition TINYINT DEFAULT 1 COMMENT '是否有空调',
    has_wifi TINYINT DEFAULT 1 COMMENT '是否有WiFi',
    has_power TINYINT DEFAULT 1 COMMENT '是否有电源',
    description TEXT COMMENT '描述',
    image_url VARCHAR(500) COMMENT '图片URL',
    admin_id BIGINT COMMENT '管理员ID',
    status INT DEFAULT 1 COMMENT '状态：0-关闭 1-开放 2-维护中',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    CONSTRAINT fk_sr_admin_id FOREIGN KEY (admin_id) REFERENCES sys_user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='自习室表';

-- 座位表
CREATE TABLE seat (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    room_id BIGINT NOT NULL COMMENT '自习室ID',
    seat_number VARCHAR(20) NOT NULL COMMENT '座位号',
    row_num INT NOT NULL COMMENT '行号',
    col_num INT NOT NULL COMMENT '列号',
    status INT DEFAULT 1 COMMENT '状态：0-不可用 1-可用 2-占用中 3-维修中',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_seat_room_id FOREIGN KEY (room_id) REFERENCES study_room(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位表';

-- 预约表
CREATE TABLE reservation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    room_id BIGINT NOT NULL COMMENT '自习室ID',
    seat_id BIGINT NOT NULL COMMENT '座位ID',
    reservation_date DATE NOT NULL COMMENT '预约日期',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    status INT DEFAULT 0 COMMENT '状态：0-待签到 1-使用中 2-已完成 3-已违约 4-已取消',
    check_in_time DATETIME COMMENT '签到时间',
    check_out_time DATETIME COMMENT '签退时间',
    cancel_time DATETIME COMMENT '取消时间',
    cancel_reason VARCHAR(200) COMMENT '取消原因',
    violation_count INT DEFAULT 0 COMMENT '违约次数',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_res_user_id FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    CONSTRAINT fk_res_room_id FOREIGN KEY (room_id) REFERENCES study_room(id) ON DELETE CASCADE,
    CONSTRAINT fk_res_seat_id FOREIGN KEY (seat_id) REFERENCES seat(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预约表';

-- 公告表
CREATE TABLE notice (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content TEXT NOT NULL COMMENT '内容',
    publisher_id BIGINT COMMENT '发布人ID',
    publisher_name VARCHAR(50) COMMENT '发布人姓名',
    is_top TINYINT DEFAULT 0 COMMENT '是否置顶：0-否 1-是',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    status INT DEFAULT 1 COMMENT '状态：0-草稿 1-已发布 2-已下架',
    publish_time DATETIME COMMENT '发布时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0,
    CONSTRAINT fk_notice_publisher_id FOREIGN KEY (publisher_id) REFERENCES sys_user(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';

-- 论坛分类表
CREATE TABLE forum_category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL COMMENT '分类名称',
    description VARCHAR(200) COMMENT '分类描述',
    sort_order INT DEFAULT 0 COMMENT '排序',
    status INT DEFAULT 1 COMMENT '状态：0-禁用 1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted INT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='论坛分类表';

-- 初始化论坛分类
INSERT INTO forum_category (id, name, description, sort_order, status) VALUES
(1, '学习交流', '学习经验、方法分享交流', 1, 1),
(2, '经验分享', '图书馆使用经验、技巧分享', 2, 1),
(3, '问题求助', '遇到问题寻求帮助', 3, 1),
(4, '闲聊灌水', '轻松话题、日常交流', 4, 1);

-- 初始化角色数据
INSERT INTO sys_role (id, role_name, role_code, description) VALUES
(1, '普通用户', 'ROLE_USER', '系统普通用户'),
(2, '自习室管理员', 'ROLE_ROOM_ADMIN', '自习室管理员'),
(3, '系统管理员', 'ROLE_SYS_ADMIN', '系统超级管理员');

-- 初始化用户数据（密码为BCrypt加密后的值）
-- 密码：admin
INSERT INTO sys_user (id, username, password, real_name, phone, email, user_type, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '系统管理员', '13800138000', 'admin@studyroom.com', 3, 1);

-- 密码：zxsadmin
INSERT INTO sys_user (id, username, password, real_name, phone, email, user_type, status) VALUES
(2, 'zxsadmin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '自习室管理员', '13800138001', 'zxsadmin@studyroom.com', 2, 1);

-- 密码：user
INSERT INTO sys_user (id, username, password, real_name, phone, email, user_type, status) VALUES
(3, 'user', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '测试用户', '13800138002', 'user@studyroom.com', 1, 1);

-- 分配角色
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 3), -- admin -> ROLE_SYS_ADMIN
(2, 2), -- zxsadmin -> ROLE_ROOM_ADMIN
(3, 1); -- user -> ROLE_USER

-- 初始化自习室数据
INSERT INTO study_room (id, name, building, floor, room_number, type, capacity, row_count, col_count, description, admin_id, status) VALUES
(1, '图书馆一楼自习室A', '图书馆', 1, '101', '普通', 60, 6, 10, '宽敞明亮的自习室，配备空调和WiFi', 2, 1),
(2, '图书馆一楼自习室B', '图书馆', 1, '102', '静音', 40, 5, 8, '静音自习室，适合深度学习', 2, 1),
(3, '图书馆二楼自习室A', '图书馆', 2, '201', '普通', 80, 8, 10, '大型自习室，座位充足', 2, 1),
(4, '图书馆二楼自习室B', '图书馆', 2, '202', '讨论室', 30, 3, 10, '小组讨论室，可小声交流', 2, 1),
(5, '教学楼A101', '教学楼A', 1, '101', '普通', 50, 5, 10, '标准教室改造，环境舒适', 2, 1),
(6, '教学楼A201', '教学楼A', 2, '201', '普通', 50, 5, 10, '配备投影仪，可观看学习视频', 2, 1),
(7, '教学楼B301', '教学楼B', 3, '301', '静音', 45, 5, 9, '高层安静区域，视野开阔', 2, 1),
(8, '教学楼C101', '教学楼C', 1, '101', '普通', 40, 4, 10, '靠近食堂，用餐方便', 2, 1);

-- 初始化座位数据（每个自习室生成座位）
-- 图书馆一楼自习室A (60座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(1, 'A01', 1, 1, 1), (1, 'A02', 1, 2, 1), (1, 'A03', 1, 3, 1), (1, 'A04', 1, 4, 1), (1, 'A05', 1, 5, 1),
(1, 'A06', 1, 6, 1), (1, 'A07', 1, 7, 1), (1, 'A08', 1, 8, 1), (1, 'A09', 1, 9, 1), (1, 'A10', 1, 10, 1),
(1, 'B01', 2, 1, 1), (1, 'B02', 2, 2, 1), (1, 'B03', 2, 3, 1), (1, 'B04', 2, 4, 1), (1, 'B05', 2, 5, 1),
(1, 'B06', 2, 6, 1), (1, 'B07', 2, 7, 1), (1, 'B08', 2, 8, 1), (1, 'B09', 2, 9, 1), (1, 'B10', 2, 10, 1),
(1, 'C01', 3, 1, 1), (1, 'C02', 3, 2, 1), (1, 'C03', 3, 3, 1), (1, 'C04', 3, 4, 1), (1, 'C05', 3, 5, 1),
(1, 'C06', 3, 6, 1), (1, 'C07', 3, 7, 1), (1, 'C08', 3, 8, 1), (1, 'C09', 3, 9, 1), (1, 'C10', 3, 10, 1),
(1, 'D01', 4, 1, 1), (1, 'D02', 4, 2, 1), (1, 'D03', 4, 3, 1), (1, 'D04', 4, 4, 1), (1, 'D05', 4, 5, 1),
(1, 'D06', 4, 6, 1), (1, 'D07', 4, 7, 1), (1, 'D08', 4, 8, 1), (1, 'D09', 4, 9, 1), (1, 'D10', 4, 10, 1),
(1, 'E01', 5, 1, 1), (1, 'E02', 5, 2, 1), (1, 'E03', 5, 3, 1), (1, 'E04', 5, 4, 1), (1, 'E05', 5, 5, 1),
(1, 'E06', 5, 6, 1), (1, 'E07', 5, 7, 1), (1, 'E08', 5, 8, 1), (1, 'E09', 5, 9, 1), (1, 'E10', 5, 10, 1),
(1, 'F01', 6, 1, 1), (1, 'F02', 6, 2, 1), (1, 'F03', 6, 3, 1), (1, 'F04', 6, 4, 1), (1, 'F05', 6, 5, 1),
(1, 'F06', 6, 6, 1), (1, 'F07', 6, 7, 1), (1, 'F08', 6, 8, 1), (1, 'F09', 6, 9, 1), (1, 'F10', 6, 10, 1);

-- 图书馆一楼自习室B (40座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(2, 'A01', 1, 1, 1), (2, 'A02', 1, 2, 1), (2, 'A03', 1, 3, 1), (2, 'A04', 1, 4, 1), (2, 'A05', 1, 5, 1),
(2, 'A06', 1, 6, 1), (2, 'A07', 1, 7, 1), (2, 'A08', 1, 8, 1),
(2, 'B01', 2, 1, 1), (2, 'B02', 2, 2, 1), (2, 'B03', 2, 3, 1), (2, 'B04', 2, 4, 1), (2, 'B05', 2, 5, 1),
(2, 'B06', 2, 6, 1), (2, 'B07', 2, 7, 1), (2, 'B08', 2, 8, 1),
(2, 'C01', 3, 1, 1), (2, 'C02', 3, 2, 1), (2, 'C03', 3, 3, 1), (2, 'C04', 3, 4, 1), (2, 'C05', 3, 5, 1),
(2, 'C06', 3, 6, 1), (2, 'C07', 3, 7, 1), (2, 'C08', 3, 8, 1),
(2, 'D01', 4, 1, 1), (2, 'D02', 4, 2, 1), (2, 'D03', 4, 3, 1), (2, 'D04', 4, 4, 1), (2, 'D05', 4, 5, 1),
(2, 'D06', 4, 6, 1), (2, 'D07', 4, 7, 1), (2, 'D08', 4, 8, 1),
(2, 'E01', 5, 1, 1), (2, 'E02', 5, 2, 1), (2, 'E03', 5, 3, 1), (2, 'E04', 5, 4, 1), (2, 'E05', 5, 5, 1),
(2, 'E06', 5, 6, 1), (2, 'E07', 5, 7, 1), (2, 'E08', 5, 8, 1);

-- 图书馆二楼自习室A (80座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(3, 'A01', 1, 1, 1), (3, 'A02', 1, 2, 1), (3, 'A03', 1, 3, 1), (3, 'A04', 1, 4, 1), (3, 'A05', 1, 5, 1),
(3, 'A06', 1, 6, 1), (3, 'A07', 1, 7, 1), (3, 'A08', 1, 8, 1), (3, 'A09', 1, 9, 1), (3, 'A10', 1, 10, 1),
(3, 'B01', 2, 1, 1), (3, 'B02', 2, 2, 1), (3, 'B03', 2, 3, 1), (3, 'B04', 2, 4, 1), (3, 'B05', 2, 5, 1),
(3, 'B06', 2, 6, 1), (3, 'B07', 2, 7, 1), (3, 'B08', 2, 8, 1), (3, 'B09', 2, 9, 1), (3, 'B10', 2, 10, 1),
(3, 'C01', 3, 1, 1), (3, 'C02', 3, 2, 1), (3, 'C03', 3, 3, 1), (3, 'C04', 3, 4, 1), (3, 'C05', 3, 5, 1),
(3, 'C06', 3, 6, 1), (3, 'C07', 3, 7, 1), (3, 'C08', 3, 8, 1), (3, 'C09', 3, 9, 1), (3, 'C10', 3, 10, 1),
(3, 'D01', 4, 1, 1), (3, 'D02', 4, 2, 1), (3, 'D03', 4, 3, 1), (3, 'D04', 4, 4, 1), (3, 'D05', 4, 5, 1),
(3, 'D06', 4, 6, 1), (3, 'D07', 4, 7, 1), (3, 'D08', 4, 8, 1), (3, 'D09', 4, 9, 1), (3, 'D10', 4, 10, 1),
(3, 'E01', 5, 1, 1), (3, 'E02', 5, 2, 1), (3, 'E03', 5, 3, 1), (3, 'E04', 5, 4, 1), (3, 'E05', 5, 5, 1),
(3, 'E06', 5, 6, 1), (3, 'E07', 5, 7, 1), (3, 'E08', 5, 8, 1), (3, 'E09', 5, 9, 1), (3, 'E10', 5, 10, 1),
(3, 'F01', 6, 1, 1), (3, 'F02', 6, 2, 1), (3, 'F03', 6, 3, 1), (3, 'F04', 6, 4, 1), (3, 'F05', 6, 5, 1),
(3, 'F06', 6, 6, 1), (3, 'F07', 6, 7, 1), (3, 'F08', 6, 8, 1), (3, 'F09', 6, 9, 1), (3, 'F10', 6, 10, 1),
(3, 'G01', 7, 1, 1), (3, 'G02', 7, 2, 1), (3, 'G03', 7, 3, 1), (3, 'G04', 7, 4, 1), (3, 'G05', 7, 5, 1),
(3, 'G06', 7, 6, 1), (3, 'G07', 7, 7, 1), (3, 'G08', 7, 8, 1), (3, 'G09', 7, 9, 1), (3, 'G10', 7, 10, 1),
(3, 'H01', 8, 1, 1), (3, 'H02', 8, 2, 1), (3, 'H03', 8, 3, 1), (3, 'H04', 8, 4, 1), (3, 'H05', 8, 5, 1),
(3, 'H06', 8, 6, 1), (3, 'H07', 8, 7, 1), (3, 'H08', 8, 8, 1), (3, 'H09', 8, 9, 1), (3, 'H10', 8, 10, 1);

-- 图书馆二楼自习室B (30座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(4, 'A01', 1, 1, 1), (4, 'A02', 1, 2, 1), (4, 'A03', 1, 3, 1), (4, 'A04', 1, 4, 1), (4, 'A05', 1, 5, 1),
(4, 'A06', 1, 6, 1), (4, 'A07', 1, 7, 1), (4, 'A08', 1, 8, 1), (4, 'A09', 1, 9, 1), (4, 'A10', 1, 10, 1),
(4, 'B01', 2, 1, 1), (4, 'B02', 2, 2, 1), (4, 'B03', 2, 3, 1), (4, 'B04', 2, 4, 1), (4, 'B05', 2, 5, 1),
(4, 'B06', 2, 6, 1), (4, 'B07', 2, 7, 1), (4, 'B08', 2, 8, 1), (4, 'B09', 2, 9, 1), (4, 'B10', 2, 10, 1),
(4, 'C01', 3, 1, 1), (4, 'C02', 3, 2, 1), (4, 'C03', 3, 3, 1), (4, 'C04', 3, 4, 1), (4, 'C05', 3, 5, 1),
(4, 'C06', 3, 6, 1), (4, 'C07', 3, 7, 1), (4, 'C08', 3, 8, 1), (4, 'C09', 3, 9, 1), (4, 'C10', 3, 10, 1);

-- 教学楼A101 (50座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(5, 'A01', 1, 1, 1), (5, 'A02', 1, 2, 1), (5, 'A03', 1, 3, 1), (5, 'A04', 1, 4, 1), (5, 'A05', 1, 5, 1),
(5, 'A06', 1, 6, 1), (5, 'A07', 1, 7, 1), (5, 'A08', 1, 8, 1), (5, 'A09', 1, 9, 1), (5, 'A10', 1, 10, 1),
(5, 'B01', 2, 1, 1), (5, 'B02', 2, 2, 1), (5, 'B03', 2, 3, 1), (5, 'B04', 2, 4, 1), (5, 'B05', 2, 5, 1),
(5, 'B06', 2, 6, 1), (5, 'B07', 2, 7, 1), (5, 'B08', 2, 8, 1), (5, 'B09', 2, 9, 1), (5, 'B10', 2, 10, 1),
(5, 'C01', 3, 1, 1), (5, 'C02', 3, 2, 1), (5, 'C03', 3, 3, 1), (5, 'C04', 3, 4, 1), (5, 'C05', 3, 5, 1),
(5, 'C06', 3, 6, 1), (5, 'C07', 3, 7, 1), (5, 'C08', 3, 8, 1), (5, 'C09', 3, 9, 1), (5, 'C10', 3, 10, 1),
(5, 'D01', 4, 1, 1), (5, 'D02', 4, 2, 1), (5, 'D03', 4, 3, 1), (5, 'D04', 4, 4, 1), (5, 'D05', 4, 5, 1),
(5, 'D06', 4, 6, 1), (5, 'D07', 4, 7, 1), (5, 'D08', 4, 8, 1), (5, 'D09', 4, 9, 1), (5, 'D10', 4, 10, 1),
(5, 'E01', 5, 1, 1), (5, 'E02', 5, 2, 1), (5, 'E03', 5, 3, 1), (5, 'E04', 5, 4, 1), (5, 'E05', 5, 5, 1),
(5, 'E06', 5, 6, 1), (5, 'E07', 5, 7, 1), (5, 'E08', 5, 8, 1), (5, 'E09', 5, 9, 1), (5, 'E10', 5, 10, 1);

-- 教学楼A201 (50座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(6, 'A01', 1, 1, 1), (6, 'A02', 1, 2, 1), (6, 'A03', 1, 3, 1), (6, 'A04', 1, 4, 1), (6, 'A05', 1, 5, 1),
(6, 'A06', 1, 6, 1), (6, 'A07', 1, 7, 1), (6, 'A08', 1, 8, 1), (6, 'A09', 1, 9, 1), (6, 'A10', 1, 10, 1),
(6, 'B01', 2, 1, 1), (6, 'B02', 2, 2, 1), (6, 'B03', 2, 3, 1), (6, 'B04', 2, 4, 1), (6, 'B05', 2, 5, 1),
(6, 'B06', 2, 6, 1), (6, 'B07', 2, 7, 1), (6, 'B08', 2, 8, 1), (6, 'B09', 2, 9, 1), (6, 'B10', 2, 10, 1),
(6, 'C01', 3, 1, 1), (6, 'C02', 3, 2, 1), (6, 'C03', 3, 3, 1), (6, 'C04', 3, 4, 1), (6, 'C05', 3, 5, 1),
(6, 'C06', 3, 6, 1), (6, 'C07', 3, 7, 1), (6, 'C08', 3, 8, 1), (6, 'C09', 3, 9, 1), (6, 'C10', 3, 10, 1),
(6, 'D01', 4, 1, 1), (6, 'D02', 4, 2, 1), (6, 'D03', 4, 3, 1), (6, 'D04', 4, 4, 1), (6, 'D05', 4, 5, 1),
(6, 'D06', 4, 6, 1), (6, 'D07', 4, 7, 1), (6, 'D08', 4, 8, 1), (6, 'D09', 4, 9, 1), (6, 'D10', 4, 10, 1),
(6, 'E01', 5, 1, 1), (6, 'E02', 5, 2, 1), (6, 'E03', 5, 3, 1), (6, 'E04', 5, 4, 1), (6, 'E05', 5, 5, 1),
(6, 'E06', 5, 6, 1), (6, 'E07', 5, 7, 1), (6, 'E08', 5, 8, 1), (6, 'E09', 5, 9, 1), (6, 'E10', 5, 10, 1);

-- 教学楼B301 (45座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(7, 'A01', 1, 1, 1), (7, 'A02', 1, 2, 1), (7, 'A03', 1, 3, 1), (7, 'A04', 1, 4, 1), (7, 'A05', 1, 5, 1),
(7, 'A06', 1, 6, 1), (7, 'A07', 1, 7, 1), (7, 'A08', 1, 8, 1), (7, 'A09', 1, 9, 1),
(7, 'B01', 2, 1, 1), (7, 'B02', 2, 2, 1), (7, 'B03', 2, 3, 1), (7, 'B04', 2, 4, 1), (7, 'B05', 2, 5, 1),
(7, 'B06', 2, 6, 1), (7, 'B07', 2, 7, 1), (7, 'B08', 2, 8, 1), (7, 'B09', 2, 9, 1),
(7, 'C01', 3, 1, 1), (7, 'C02', 3, 2, 1), (7, 'C03', 3, 3, 1), (7, 'C04', 3, 4, 1), (7, 'C05', 3, 5, 1),
(7, 'C06', 3, 6, 1), (7, 'C07', 3, 7, 1), (7, 'C08', 3, 8, 1), (7, 'C09', 3, 9, 1),
(7, 'D01', 4, 1, 1), (7, 'D02', 4, 2, 1), (7, 'D03', 4, 3, 1), (7, 'D04', 4, 4, 1), (7, 'D05', 4, 5, 1),
(7, 'D06', 4, 6, 1), (7, 'D07', 4, 7, 1), (7, 'D08', 4, 8, 1), (7, 'D09', 4, 9, 1),
(7, 'E01', 5, 1, 1), (7, 'E02', 5, 2, 1), (7, 'E03', 5, 3, 1), (7, 'E04', 5, 4, 1), (7, 'E05', 5, 5, 1),
(7, 'E06', 5, 6, 1), (7, 'E07', 5, 7, 1), (7, 'E08', 5, 8, 1), (7, 'E09', 5, 9, 1);

-- 教学楼C101 (40座)
INSERT INTO seat (room_id, seat_number, row_num, col_num, status) VALUES
(8, 'A01', 1, 1, 1), (8, 'A02', 1, 2, 1), (8, 'A03', 1, 3, 1), (8, 'A04', 1, 4, 1), (8, 'A05', 1, 5, 1),
(8, 'A06', 1, 6, 1), (8, 'A07', 1, 7, 1), (8, 'A08', 1, 8, 1), (8, 'A09', 1, 9, 1), (8, 'A10', 1, 10, 1),
(8, 'B01', 2, 1, 1), (8, 'B02', 2, 2, 1), (8, 'B03', 2, 3, 1), (8, 'B04', 2, 4, 1), (8, 'B05', 2, 5, 1),
(8, 'B06', 2, 6, 1), (8, 'B07', 2, 7, 1), (8, 'B08', 2, 8, 1), (8, 'B09', 2, 9, 1), (8, 'B10', 2, 10, 1),
(8, 'C01', 3, 1, 1), (8, 'C02', 3, 2, 1), (8, 'C03', 3, 3, 1), (8, 'C04', 3, 4, 1), (8, 'C05', 3, 5, 1),
(8, 'C06', 3, 6, 1), (8, 'C07', 3, 7, 1), (8, 'C08', 3, 8, 1), (8, 'C09', 3, 9, 1), (8, 'C10', 3, 10, 1),
(8, 'D01', 4, 1, 1), (8, 'D02', 4, 2, 1), (8, 'D03', 4, 3, 1), (8, 'D04', 4, 4, 1), (8, 'D05', 4, 5, 1),
(8, 'D06', 4, 6, 1), (8, 'D07', 4, 7, 1), (8, 'D08', 4, 8, 1), (8, 'D09', 4, 9, 1), (8, 'D10', 4, 10, 1);

-- 初始化公告数据
INSERT INTO notice (id, title, content, publisher_id, publisher_name, is_top, view_count, status, publish_time) VALUES
(1, '关于图书馆自习室开放时间的通知', '各位同学：图书馆自习室将于每日8:00-22:00开放，请大家合理安排学习时间。', 1, '系统管理员', 1, 156, 1, NOW()),
(2, '期末考试期间自习室使用须知', '期末考试期间，自习室座位紧张，请大家提前预约，遵守自习室管理规定。', 2, '自习室管理员', 1, 234, 1, NOW()),
(3, '新开放教学楼B301静音自习室', '为满足同学们的学习需求，现开放教学楼B301作为静音自习室，欢迎预约使用。', 2, '自习室管理员', 0, 89, 1, NOW()),
(4, '自习室空调使用规范', '请节约用电，离开自习室时请关闭座位附近的空调和灯光。', 1, '系统管理员', 0, 67, 1, NOW()),
(5, '关于预约违约的处理办法', '连续三次预约后未签到将被限制预约权限一周，请大家珍惜预约资源。', 1, '系统管理员', 0, 145, 1, NOW()),
(6, '图书馆一楼自习室A维护通知', '图书馆一楼自习室A将于本周六进行设备维护，暂停开放一天。', 2, '自习室管理员', 0, 78, 1, NOW()),
(7, '欢迎使用新的自习室预约系统', '全新的自习室智能管理系统上线啦！支持在线预约、签到打卡等功能。', 1, '系统管理员', 1, 567, 1, NOW()),
(8, '自习室座位使用礼仪', '请保持安静，禁止占座，离开时带走个人物品和垃圾。', 2, '自习室管理员', 0, 123, 1, NOW()),
(9, '节假日自习室开放安排', '节假日期间自习室正常开放，具体安排请关注后续通知。', 1, '系统管理员', 0, 45, 1, NOW()),
(10, '图书馆WiFi升级完成', '图书馆区域WiFi已完成升级，网速更快更稳定，欢迎使用。', 1, '系统管理员', 0, 234, 1, NOW());

-- 添加更多用户数据（普通用户）
INSERT INTO sys_user (id, username, password, real_name, phone, email, user_type, status) VALUES
(4, 'zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '张三', '13900139001', 'zhangsan@example.com', 1, 1),
(5, 'lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '李四', '13900139002', 'lisi@example.com', 1, 1),
(6, 'wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '王五', '13900139003', 'wangwu@example.com', 1, 1),
(7, 'zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '赵六', '13900139004', 'zhaoliu@example.com', 1, 1),
(8, 'sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '孙七', '13900139005', 'sunqi@example.com', 1, 1),
(9, 'zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '周八', '13900139006', 'zhouba@example.com', 1, 1),
(10, 'wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '吴九', '13900139007', 'wujiu@example.com', 1, 1),
(11, 'zhengshi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '郑十', '13900139008', 'zhengshi@example.com', 1, 1),
(12, 'chenyi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '陈一', '13900139009', 'chenyi@example.com', 1, 1),
(13, 'linerm', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '林二', '13900139010', 'linerm@example.com', 1, 1),
(14, 'huangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '黄三', '13900139011', 'huangsan@example.com', 1, 1),
(15, 'heisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '何四', '13900139012', 'heisi@example.com', 1, 1),
(16, 'gaowu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '高五', '13900139013', 'gaowu@example.com', 1, 1),
(17, 'liuliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '刘六', '13900139014', 'liuliu@example.com', 1, 1),
(18, 'linqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '林七', '13900139015', 'linqi@example.com', 1, 1),
(19, 'guoba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '郭八', '13900139016', 'guoba@example.com', 1, 1),
(20, 'luojiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '罗九', '13900139017', 'luojiu@example.com', 1, 1);

-- 为新用户分配角色
INSERT INTO sys_user_role (user_id, role_id) VALUES
(4, 1), (5, 1), (6, 1), (7, 1), (8, 1),
(9, 1), (10, 1), (11, 1), (12, 1), (13, 1),
(14, 1), (15, 1), (16, 1), (17, 1), (18, 1),
(19, 1), (20, 1);

-- 添加预约数据
INSERT INTO reservation (user_id, room_id, seat_id, reservation_date, start_time, end_time, status, create_time) VALUES
(3, 1, 1, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '08:00:00', '12:00:00', 0, NOW()),
(4, 1, 2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '18:00:00', 0, NOW()),
(5, 2, 61, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '09:00:00', '12:00:00', 0, NOW()),
(6, 3, 101, CURDATE(), '08:00:00', '12:00:00', 1, NOW()),
(7, 1, 3, CURDATE(), '13:00:00', '17:00:00', 1, NOW()),
(8, 5, 221, DATE_ADD(CURDATE(), INTERVAL -1 DAY), '08:00:00', '12:00:00', 2, NOW()),
(9, 6, 271, DATE_ADD(CURDATE(), INTERVAL -1 DAY), '14:00:00', '18:00:00', 2, NOW()),
(10, 1, 4, DATE_ADD(CURDATE(), INTERVAL -2 DAY), '08:00:00', '12:00:00', 4, NOW()),
(11, 2, 62, DATE_ADD(CURDATE(), INTERVAL -2 DAY), '09:00:00', '12:00:00', 4, NOW()),
(12, 3, 102, DATE_ADD(CURDATE(), INTERVAL 3 DAY), '10:00:00', '14:00:00', 0, NOW());

-- 添加论坛帖子数据 - 学习交流分类(10条)
INSERT INTO forum_post (user_id, category_id, title, content, post_type, view_count, reply_count, like_count, status, is_top, is_essence, create_time) VALUES
(4, 1, '考研复习经验分享', '经过半年的努力，终于考上了理想的研究生院校。分享一下我的复习经验：首先要制定详细的复习计划，其次要保持良好的作息习惯，最后要注意劳逸结合。希望这些经验对大家有帮助！', 1, 1256, 45, 128, 1, 0, 1, DATE_ADD(NOW(), INTERVAL -10 DAY)),
(5, 1, '如何提高学习效率？', '最近发现自己学习效率很低，经常坐了一下午却没什么收获。大家有什么提高学习效率的好方法吗？求分享！', 1, 856, 32, 67, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -9 DAY)),
(6, 1, '图书馆最佳学习位置推荐', '经过长期观察，发现图书馆三楼靠窗的位置光线最好，而且比较安静。大家还有什么好的位置推荐吗？', 1, 2341, 78, 156, 1, 1, 0, DATE_ADD(NOW(), INTERVAL -8 DAY)),
(7, 1, '英语四六级备考攻略', '四六级考试快到了，分享一些备考经验：听力要每天坚持练习，阅读理解要注重词汇积累，写作要多背模板。祝大家都能顺利通过！', 1, 1567, 56, 98, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -7 DAY)),
(8, 1, '编程学习路线分享', '作为计算机专业的学生，分享一下我的编程学习路线：先从C语言基础开始，然后学习数据结构和算法，接着可以学习Java或Python。希望对大家有帮助！', 1, 1890, 67, 134, 1, 0, 1, DATE_ADD(NOW(), INTERVAL -6 DAY)),
(9, 1, '期末考试复习计划', '期末考试快到了，制定了一个详细的复习计划。每天上午复习专业课，下午复习公共课，晚上做题巩固。有一起复习的同学吗？', 1, 678, 23, 45, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -5 DAY)),
(10, 1, '如何克服拖延症？', '总是把任务拖到最后一刻才做，导致效率很低。大家有什么克服拖延症的好方法吗？', 1, 1234, 89, 112, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -4 DAY)),
(11, 1, '读书笔记分享', '最近读了一本很好的书《深度学习》，做了一些读书笔记。有兴趣的同学可以一起交流！', 1, 445, 12, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -3 DAY)),
(12, 1, '寻找学习搭子', '想找几个志同道合的学习伙伴，一起监督学习。我一般晚上7点到10点在图书馆，有一起的吗？', 1, 890, 45, 67, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -2 DAY)),
(13, 1, '学习方法总结', '总结了几种有效的学习方法：番茄工作法、费曼学习法、思维导图法等。大家可以根据自己的情况选择适合的方法。', 1, 1567, 34, 89, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY));

-- 经验分享分类(10条)
INSERT INTO forum_post (user_id, category_id, title, content, post_type, view_count, reply_count, like_count, status, is_top, is_essence, create_time) VALUES
(4, 2, '图书馆使用小贴士', '来图书馆学习几年了，总结了一些小贴士：早上8点前来可以占到好位置，带个水杯可以接热水，记得带耳机避免打扰他人。', 1, 2345, 67, 189, 1, 1, 0, DATE_ADD(NOW(), INTERVAL -12 DAY)),
(5, 2, '自习室预约技巧', '分享一下预约自习室的小技巧：提前一天预约成功率更高，工作日的下午人比较少，可以选择靠窗的位置。', 1, 1567, 45, 98, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -11 DAY)),
(5, 2, '如何找到安静的座位', '想要安静的学习环境，建议选择：角落位置、远离门口的位置、高层的座位。避开靠近讨论区和出入口的地方。', 1, 890, 23, 56, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -10 DAY)),
(6, 2, '带什么去图书馆最合适', '分享一下我的图书馆必备物品：笔记本电脑、充电器、水杯、耳机、纸巾、小零食。不要带味道太大的食物哦！', 1, 1234, 34, 78, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -9 DAY)),
(7, 2, '图书馆WiFi使用指南', '图书馆的WiFi覆盖很好，但是高峰期可能会慢。建议使用5G频段，或者错峰使用网络。遇到连接问题可以找管理员。', 1, 678, 12, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -8 DAY)),
(8, 2, '座位被占怎么办？', '遇到座位被占的情况，可以先礼貌地询问，如果对方确实预约了就让出。也可以找管理员协调，不要发生冲突。', 1, 1567, 56, 89, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -7 DAY)),
(9, 2, '图书馆开放时间提醒', '提醒一下大家，图书馆平时8:00-22:00开放，周末9:00-21:00开放。节假日时间会有调整，请关注公告。', 1, 2341, 23, 112, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -6 DAY)),
(10, 2, '如何保持专注', '在图书馆保持专注的方法：把手机调成静音，使用专注软件，设定学习目标，适当休息。大家还有什么好方法？', 1, 890, 45, 67, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -5 DAY)),
(11, 2, '图书馆周边美食推荐', '学习累了可以去周边吃点东西。推荐几家不错的店：图书馆咖啡厅、校外小吃街、便利店。价格适中，味道不错。', 1, 1567, 78, 134, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -4 DAY)),
(12, 2, '雨天图书馆避雨指南', '下雨天图书馆是个好去处。记得带伞，可以在一楼大厅避雨，等雨小一点再走。图书馆提供雨伞借用服务。', 1, 445, 12, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -3 DAY));

-- 问题求助分类(10条)
INSERT INTO forum_post (user_id, category_id, title, content, post_type, view_count, reply_count, like_count, status, is_top, is_essence, create_time) VALUES
(4, 3, '图书馆空调太冷怎么办？', '最近图书馆空调开得很低，坐一会儿就冷得受不了。大家有什么保暖的好方法吗？穿外套还是不够。', 1, 1234, 56, 89, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -8 DAY)),
(5, 3, '预约系统登录不上', '今天想预约明天的座位，但是系统一直登录不上，显示密码错误。我确定密码是对的，有人遇到同样的问题吗？', 1, 678, 23, 45, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -7 DAY)),
(6, 3, '座位插座没电', '预约的座位插座没有电，电脑快没电了。这种情况应该找谁处理？有没有备用插座可以用？', 1, 445, 34, 56, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -6 DAY)),
(7, 3, '有人大声说话怎么办？', '自习室里有同学在大声讨论问题，影响其他人学习。提醒了几次还是这样，应该怎么办？', 1, 1567, 67, 112, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -5 DAY)),
(8, 3, '忘记签退会被记录吗？', '昨天学习完忘记签退了，今天发现预约记录显示异常。这会影响我的信用吗？怎么补救？', 1, 890, 45, 78, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -4 DAY)),
(9, 3, '图书馆可以带咖啡吗？', '习惯喝咖啡提神，不知道图书馆能不能带咖啡进去？会不会影响其他人？', 1, 1234, 34, 67, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -3 DAY)),
(10, 3, '如何取消预约？', '临时有事去不了图书馆了，怎么取消预约？找不到取消按钮，求助！', 1, 567, 23, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -2 DAY)),
(11, 3, '图书馆有打印服务吗？', '需要打印一些资料，图书馆有打印服务吗？在哪里？怎么收费？', 1, 890, 12, 45, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY)),
(12, 3, '占座现象严重', '早上来图书馆发现很多座位被书本占了但没人坐，这种现象太严重了。希望管理员能管管。', 1, 2345, 89, 156, 1, 1, 0, DATE_ADD(NOW(), INTERVAL -1 DAY)),
(13, 3, 'WiFi连接问题', '图书馆WiFi经常断线，影响学习效率。是网络问题还是我的设备问题？有人遇到同样情况吗？', 1, 678, 34, 56, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY));

-- 闲聊灌水分类(10条)
INSERT INTO forum_post (user_id, category_id, title, content, post_type, view_count, reply_count, like_count, status, is_top, is_essence, create_time) VALUES
(4, 4, '今天天气真好', '今天阳光明媚，适合来图书馆学习。大家今天都学了什么？分享一下吧！', 1, 445, 23, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -6 DAY)),
(5, 4, '图书馆的猫', '今天在图书馆门口看到一只可爱的橘猫，超级萌！有人拍照片了吗？', 1, 1234, 67, 189, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -5 DAY)),
(5, 4, '学习累了来聊聊天', '学了一上午，脑瓜子嗡嗡的。来水区放松一下，大家最近在看什么剧？', 1, 678, 45, 78, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -4 DAY)),
(6, 4, '图书馆最美瞬间', '夕阳西下的时候，阳光透过窗户洒在书桌上，那一刻真的很美。有人注意到吗？', 1, 1567, 34, 112, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -3 DAY)),
(7, 4, '考试周加油！', '考试周到了，大家加油！熬过去就是美好的假期。一起努力吧！', 1, 2345, 89, 234, 1, 1, 0, DATE_ADD(NOW(), INTERVAL -2 DAY)),
(8, 4, '图书馆的早餐', '发现图书馆旁边的早餐店很不错，豆浆油条配包子，完美！推荐给大家。', 1, 890, 23, 56, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -2 DAY)),
(9, 4, '周末图书馆人好少', '周末来图书馆发现人比平时少很多，很安静。喜欢这种氛围，可以专心学习。', 1, 567, 12, 34, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY)),
(10, 4, '图书馆偶遇', '今天在图书馆偶遇了高中同学，世界真小。大家有在图书馆遇到过熟人吗？', 1, 1234, 45, 89, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY)),
(11, 4, '学习打卡第100天', '坚持来图书馆学习100天了！纪念一下，也激励自己继续努力。有一起打卡的吗？', 1, 1890, 78, 267, 1, 0, 1, DATE_ADD(NOW(), INTERVAL -1 DAY)),
(12, 4, '图书馆的夜晚', '晚上10点离开图书馆，看着灯火通明的自习室，感觉很充实。这就是青春吧！', 1, 2341, 56, 178, 1, 0, 0, DATE_ADD(NOW(), INTERVAL -1 DAY));
