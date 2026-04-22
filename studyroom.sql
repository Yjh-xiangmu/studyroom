/*
 Navicat Premium Data Transfer

 Source Server         : yjh
 Source Server Type    : MySQL
 Source Server Version : 80026
 Source Host           : localhost:3306
 Source Schema         : studyroom

 Target Server Type    : MySQL
 Target Server Version : 80026
 File Encoding         : 65001

 Date: 23/04/2026 01:51:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for forum_category
-- ----------------------------
DROP TABLE IF EXISTS `forum_category`;
CREATE TABLE `forum_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `sort_order` int NULL DEFAULT 0,
  `status` int NULL DEFAULT 1,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_category
-- ----------------------------
INSERT INTO `forum_category` VALUES (1, '学习交流', '学习经验方法分享', 1, 1, '2026-03-20 09:04:13', '2026-03-20 09:04:13', 0);
INSERT INTO `forum_category` VALUES (2, '经验分享', '图书馆使用经验', 2, 1, '2026-03-20 09:04:13', '2026-03-20 09:04:13', 0);
INSERT INTO `forum_category` VALUES (3, '问题求助', '遇到问题求助', 3, 1, '2026-03-20 09:04:13', '2026-03-20 09:04:13', 0);
INSERT INTO `forum_category` VALUES (4, '闲聊灌水', '轻松日常交流', 4, 1, '2026-03-20 09:04:13', '2026-03-20 09:04:13', 0);

-- ----------------------------
-- Table structure for forum_post
-- ----------------------------
DROP TABLE IF EXISTS `forum_post`;
CREATE TABLE `forum_post`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `category_id` bigint NULL DEFAULT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `post_type` int NULL DEFAULT 1,
  `view_count` int NULL DEFAULT 0,
  `reply_count` int NULL DEFAULT 0,
  `like_count` int NULL DEFAULT 0,
  `status` int NULL DEFAULT 1,
  `is_top` int NULL DEFAULT 0,
  `is_essence` int NULL DEFAULT 0,
  `audit_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `audit_time` datetime(0) NULL DEFAULT NULL,
  `audit_by` bigint NULL DEFAULT NULL,
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 73 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_post
-- ----------------------------
INSERT INTO `forum_post` VALUES (1, 4, 1, '考研复习经验分享', '经过半年的努力，终于考上了理想的研究生院校。分享一下我的复习经验：首先要制定详细的复习计划，其次要保持良好的作息习惯，最后要注意劳逸结合。希望这些经验对大家有帮助！', 1, 1256, 45, 128, 1, 0, 1, NULL, NULL, NULL, '2026-03-10 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (2, 5, 1, '如何提高学习效率？', '最近发现自己学习效率很低，经常坐了一下午却没什么收获。大家有什么提高学习效率的好方法吗？求分享！', 1, 856, 32, 67, 1, 0, 0, NULL, NULL, NULL, '2026-03-11 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (3, 6, 1, '图书馆最佳学习位置推荐', '经过长期观察，发现图书馆三楼靠窗的位置光线最好，而且比较安静。大家还有什么好的位置推荐吗？', 1, 2341, 78, 156, 1, 1, 0, NULL, NULL, NULL, '2026-03-12 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (4, 7, 1, '英语四六级备考攻略', '四六级考试快到了，分享一些备考经验：听力要每天坚持练习，阅读理解要注重词汇积累，写作要多背模板。祝大家都能顺利通过！', 1, 1567, 56, 98, 1, 0, 0, NULL, NULL, NULL, '2026-03-13 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (5, 8, 1, '编程学习路线分享', '作为计算机专业的学生，分享一下我的编程学习路线：先从C语言基础开始，然后学习数据结构和算法，接着可以学习Java或Python。希望对大家有帮助！', 1, 1890, 67, 134, 1, 0, 1, NULL, NULL, NULL, '2026-03-14 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (6, 9, 1, '期末考试复习计划', '期末考试快到了，制定了一个详细的复习计划。每天上午复习专业课，下午复习公共课，晚上做题巩固。有一起复习的同学吗？', 1, 678, 23, 45, 1, 0, 0, NULL, NULL, NULL, '2026-03-15 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (7, 10, 1, '如何克服拖延症？', '总是把任务拖到最后一刻才做，导致效率很低。大家有什么克服拖延症的好方法吗？', 1, 1234, 89, 112, 1, 0, 0, NULL, NULL, NULL, '2026-03-16 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (8, 11, 1, '读书笔记分享', '最近读了一本很好的书《深度学习》，做了一些读书笔记。有兴趣的同学可以一起交流！', 1, 445, 12, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-17 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (9, 12, 1, '寻找学习搭子', '想找几个志同道合的学习伙伴，一起监督学习。我一般晚上7点到10点在图书馆，有一起的吗？', 1, 890, 45, 67, 1, 0, 0, NULL, NULL, NULL, '2026-03-18 09:05:40', '2026-03-20 09:05:40', 0);
INSERT INTO `forum_post` VALUES (10, 13, 1, '学习方法总结', '总结了几种有效的学习方法：番茄工作法、费曼学习法、思维导图法等。大家可以根据自己的情况选择适合的方法。', 1, 1567, 34, 89, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (11, 4, 2, '图书馆使用小贴士', '来图书馆学习几年了，总结了一些小贴士：早上8点前来可以占到好位置，带个水杯可以接热水，记得带耳机避免打扰他人。', 1, 2346, 67, 189, 1, 1, 0, NULL, NULL, NULL, '2026-03-08 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (12, 5, 2, '自习室预约技巧', '分享一下预约自习室的小技巧：提前一天预约成功率更高，工作日的下午人比较少，可以选择靠窗的位置。', 1, 1567, 45, 98, 1, 0, 0, NULL, NULL, NULL, '2026-03-09 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (13, 5, 2, '如何找到安静的座位', '想要安静的学习环境，建议选择：角落位置、远离门口的位置、高层的座位。避开靠近讨论区和出入口的地方。', 1, 890, 23, 56, 1, 0, 0, NULL, NULL, NULL, '2026-03-10 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (14, 6, 2, '带什么去图书馆最合适', '分享一下我的图书馆必备物品：笔记本电脑、充电器、水杯、耳机、纸巾、小零食。不要带味道太大的食物哦！', 1, 1234, 34, 78, 1, 0, 0, NULL, NULL, NULL, '2026-03-11 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (15, 7, 2, '图书馆WiFi使用指南', '图书馆的WiFi覆盖很好，但是高峰期可能会慢。建议使用5G频段，或者错峰使用网络。遇到连接问题可以找管理员。', 1, 678, 12, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-12 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (16, 8, 2, '座位被占怎么办？', '遇到座位被占的情况，可以先礼貌地询问，如果对方确实预约了就让出。也可以找管理员协调，不要发生冲突。', 1, 1567, 56, 89, 1, 0, 0, NULL, NULL, NULL, '2026-03-13 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (17, 9, 2, '图书馆开放时间提醒', '提醒一下大家，图书馆平时8:00-22:00开放，周末9:00-21:00开放。节假日时间会有调整，请关注公告。', 1, 2341, 23, 112, 1, 0, 0, NULL, NULL, NULL, '2026-03-14 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (18, 10, 2, '如何保持专注', '在图书馆保持专注的方法：把手机调成静音，使用专注软件，设定学习目标，适当休息。大家还有什么好方法？', 1, 890, 45, 67, 1, 0, 0, NULL, NULL, NULL, '2026-03-15 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (19, 11, 2, '图书馆周边美食推荐', '学习累了可以去周边吃点东西。推荐几家不错的店：图书馆咖啡厅、校外小吃街、便利店。价格适中，味道不错。', 1, 1567, 78, 134, 1, 0, 0, NULL, NULL, NULL, '2026-03-16 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (20, 12, 2, '雨天图书馆避雨指南', '下雨天图书馆是个好去处。记得带伞，可以在一楼大厅避雨，等雨小一点再走。图书馆提供雨伞借用服务。', 1, 445, 12, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-17 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (21, 4, 3, '图书馆空调太冷怎么办？', '最近图书馆空调开得很低，坐一会儿就冷得受不了。大家有什么保暖的好方法吗？穿外套还是不够。', 1, 1234, 56, 89, 1, 0, 0, NULL, NULL, NULL, '2026-03-12 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (22, 5, 3, '预约系统登录不上', '今天想预约明天的座位，但是系统一直登录不上，显示密码错误。我确定密码是对的，有人遇到同样的问题吗？', 1, 678, 23, 45, 1, 0, 0, NULL, NULL, NULL, '2026-03-13 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (23, 6, 3, '座位插座没电', '预约的座位插座没有电，电脑快没电了。这种情况应该找谁处理？有没有备用插座可以用？', 1, 445, 34, 56, 1, 0, 0, NULL, NULL, NULL, '2026-03-14 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (24, 7, 3, '有人大声说话怎么办？', '自习室里有同学在大声讨论问题，影响其他人学习。提醒了几次还是这样，应该怎么办？', 1, 1567, 67, 112, 1, 0, 0, NULL, NULL, NULL, '2026-03-15 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (25, 8, 3, '忘记签退会被记录吗？', '昨天学习完忘记签退了，今天发现预约记录显示异常。这会影响我的信用吗？怎么补救？', 1, 890, 45, 78, 1, 0, 0, NULL, NULL, NULL, '2026-03-16 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (26, 9, 3, '图书馆可以带咖啡吗？', '习惯喝咖啡提神，不知道图书馆能不能带咖啡进去？会不会影响其他人？', 1, 1234, 34, 67, 1, 0, 0, NULL, NULL, NULL, '2026-03-17 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (27, 10, 3, '如何取消预约？', '临时有事去不了图书馆了，怎么取消预约？找不到取消按钮，求助！', 1, 567, 23, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-18 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (28, 11, 3, '图书馆有打印服务吗？', '需要打印一些资料，图书馆有打印服务吗？在哪里？怎么收费？', 1, 890, 12, 45, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (29, 12, 3, '占座现象严重', '早上来图书馆发现很多座位被书本占了但没人坐，这种现象太严重了。希望管理员能管管。', 1, 2354, 90, 156, 1, 1, 0, NULL, NULL, NULL, '2026-03-19 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (30, 13, 3, 'WiFi连接问题', '图书馆WiFi经常断线，影响学习效率。是网络问题还是我的设备问题？有人遇到同样情况吗？', 1, 678, 34, 56, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (31, 4, 4, '今天天气真好', '今天阳光明媚，适合来图书馆学习。大家今天都学了什么？分享一下吧！', 1, 445, 23, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-14 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (32, 5, 4, '图书馆的猫', '今天在图书馆门口看到一只可爱的橘猫，超级萌！有人拍照片了吗？', 1, 1234, 67, 189, 1, 0, 0, NULL, NULL, NULL, '2026-03-15 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (33, 5, 4, '学习累了来聊聊天', '学了一上午，脑瓜子嗡嗡的。来水区放松一下，大家最近在看什么剧？', 1, 678, 45, 78, 1, 0, 0, NULL, NULL, NULL, '2026-03-16 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (34, 6, 4, '图书馆最美瞬间', '夕阳西下的时候，阳光透过窗户洒在书桌上，那一刻真的很美。有人注意到吗？', 1, 1567, 34, 112, 1, 0, 0, NULL, NULL, NULL, '2026-03-17 09:05:41', '2026-03-20 09:05:41', 0);
INSERT INTO `forum_post` VALUES (35, 7, 4, '考试周加油！', '考试周到了，大家加油！熬过去就是美好的假期。一起努力吧！', 1, 2347, 89, 234, 1, 1, 0, NULL, NULL, NULL, '2026-03-18 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (36, 8, 4, '图书馆的早餐', '发现图书馆旁边的早餐店很不错，豆浆油条配包子，完美！推荐给大家。', 1, 890, 23, 56, 1, 0, 0, NULL, NULL, NULL, '2026-03-18 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (37, 9, 4, '周末图书馆人好少', '周末来图书馆发现人比平时少很多，很安静。喜欢这种氛围，可以专心学习。', 1, 567, 12, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (38, 10, 4, '图书馆偶遇', '今天在图书馆偶遇了高中同学，世界真小。大家有在图书馆遇到过熟人吗？', 1, 1234, 45, 89, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (39, 11, 4, '学习打卡第100天', '坚持来图书馆学习100天了！纪念一下，也激励自己继续努力。有一起打卡的吗？', 1, 1890, 78, 267, 1, 0, 1, NULL, NULL, NULL, '2026-03-19 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (40, 12, 4, '图书馆的夜晚', '晚上10点离开图书馆，看着灯火通明的自习室，感觉很充实。这就是青春吧！', 1, 2341, 56, 178, 1, 0, 0, NULL, NULL, NULL, '2026-03-19 09:05:42', '2026-03-20 09:05:42', 0);
INSERT INTO `forum_post` VALUES (41, 3, 1, '上报：图书馆A区102号座位电源损坏', '图书馆A区102号座位的电源插座已损坏，无法使用。请管理员尽快维修，谢谢。', 1, 17, 3, 3, 1, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (42, 4, 2, '投诉：有人长时间占座不在', '教学楼B区305室每天上午都有人用书包占座，但本人不在场，希望管理员加强巡查。', 1, 28, 5, 12, 1, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (43, 5, 3, '申诉：误判违约处理', '3月15日因临时有事无法准时签到，系统自动判定违约，希望管理员核实情况并取消违约记录。', 1, 22, 3, 8, 2, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (44, 6, 4, '建议增加夜间自习室开放时间', '希望学校能在考试周期间延长自习室开放时间至24:00，方便复习的同学。', 1, 56, 8, 23, 0, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (45, 7, 1, '上报：B区205自习室投影仪故障', 'B区205自习室的投影仪出现花屏问题，影响学习使用，请尽快维修。', 1, 19, 1, 4, 1, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (46, 8, 2, '反馈：自习室噪音问题', '图书馆B区经常有同学大声讲话，影响他人学习，建议加强管理力度。', 1, 33, 6, 15, 0, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (47, 9, 3, '申诉：系统操作错误导致违约', '使用手机预约时误操作取消了已签到的记录，导致系统显示违约，请核实处理。', 1, 21, 3, 6, 1, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (48, 10, 4, '建议：增加残疾人座位标识', '建议在自习室座位布局图中增加残疾人专用座位标识，方便有特殊需求的同学预约。', 1, 41, 4, 18, 0, 0, 0, NULL, NULL, NULL, '2026-03-20 09:30:22', '2026-03-20 09:30:22', 0);
INSERT INTO `forum_post` VALUES (49, 3, 1, '上报：图书馆A区102号座位电源损坏', '图书馆A区102号座位的电源插座已损坏，无法使用。请管理员尽快维修，谢谢。', 1, 15, 2, 3, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:15', 0);
INSERT INTO `forum_post` VALUES (50, 4, 2, '投诉：有人长时间占座不在', '教学楼B区305室每天上午都有人用书包占座，但本人不在场，希望管理员加强巡查。', 1, 28, 5, 12, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:14', 0);
INSERT INTO `forum_post` VALUES (51, 5, 3, '申诉：误判违约处理', '3月15日因临时有事无法准时签到，系统自动判定违约，希望管理员核实情况并取消违约记录。', 1, 22, 3, 8, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:10:47', 0);
INSERT INTO `forum_post` VALUES (52, 6, 4, '建议增加夜间自习室开放时间', '希望学校能在考试周期间延长自习室开放时间至24:00，方便复习的同学。', 1, 56, 8, 23, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:09', 0);
INSERT INTO `forum_post` VALUES (53, 7, 1, '上报：B区205自习室投影仪故障', 'B区205自习室的投影仪出现花屏问题，影响学习使用，请尽快维修。', 1, 19, 1, 4, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:13', 0);
INSERT INTO `forum_post` VALUES (54, 8, 2, '反馈：自习室噪音问题', '图书馆B区经常有同学大声讲话，影响他人学习，建议加强管理力度。', 1, 33, 6, 15, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:12', 0);
INSERT INTO `forum_post` VALUES (55, 9, 3, '申诉：系统操作错误导致违约', '使用手机预约时误操作取消了已签到的记录，导致系统显示违约，请核实处理。', 1, 18, 2, 6, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:11', 0);
INSERT INTO `forum_post` VALUES (56, 10, 4, '建议：增加残疾人座位标识', '建议在自习室座位布局图中增加残疾人专用座位标识，方便有特殊需求的同学预约。', 1, 41, 4, 18, 3, 0, 0, NULL, NULL, NULL, '2026-03-20 09:32:05', '2026-04-21 16:18:10', 0);
INSERT INTO `forum_post` VALUES (57, 3, 1, '如何提高学习效率？', '最近感觉学习效率很低，大家有什么好的方法推荐吗？', 4, 156, 8, 45, 1, 0, 0, NULL, NULL, NULL, '2026-03-15 09:00:00', '2026-03-15 09:00:00', 0);
INSERT INTO `forum_post` VALUES (58, 4, 2, '空调温度太低了', '图书馆空调温度设置得太低了，希望能调高一点。', 1, 89, 5, 12, 1, 0, 0, NULL, NULL, NULL, '2026-03-14 14:30:00', '2026-03-14 14:30:00', 0);
INSERT INTO `forum_post` VALUES (59, 5, 3, '有人占座一整天不见人', '早上8点来就看到座位上有书，现在下午5点了还没人来，太离谱了！', 3, 234, 15, 67, 1, 1, 0, NULL, NULL, NULL, '2026-03-13 17:00:00', '2026-04-21 16:19:34', 0);
INSERT INTO `forum_post` VALUES (60, 6, 4, '考研资料分享', '整理了一些考研资料，有需要的同学可以联系我。', 4, 568, 23, 189, 1, 0, 1, NULL, NULL, NULL, '2026-03-10 10:00:00', '2026-03-10 10:00:00', 0);
INSERT INTO `forum_post` VALUES (61, 7, 1, '图书馆WiFi不稳定', '最近WiFi经常断，影响学习效率，希望技术部门能处理一下。', 2, 123, 6, 18, 1, 0, 0, NULL, NULL, NULL, '2026-03-09 11:20:00', '2026-03-09 11:20:00', 0);
INSERT INTO `forum_post` VALUES (62, 8, 2, '周末自习室开放时间', '请问周末自习室开放到几点？', 1, 78, 4, 8, 1, 0, 0, NULL, NULL, NULL, '2026-03-08 16:45:00', '2026-03-08 16:45:00', 0);
INSERT INTO `forum_post` VALUES (63, 9, 3, '座位预约系统很好用', '新系统用起来很方便，预约座位再也不用担心没位置了。', 4, 345, 12, 56, 1, 0, 0, NULL, NULL, NULL, '2026-03-07 09:30:00', '2026-03-07 09:30:00', 0);
INSERT INTO `forum_post` VALUES (64, 10, 4, '寻找学习搭子', '有没有一起准备四六级的同学？可以互相监督学习。', 4, 234, 18, 34, 1, 0, 0, NULL, NULL, NULL, '2026-03-06 14:00:00', '2026-03-06 14:00:00', 0);
INSERT INTO `forum_post` VALUES (65, 4, 1, '灯光太暗了', 'B区有些座位灯光比较暗，希望能增加照明。', 1, 67, 3, 9, 1, 0, 0, NULL, NULL, NULL, '2026-03-05 10:15:00', '2026-03-05 10:15:00', 0);
INSERT INTO `forum_post` VALUES (66, 6, 2, '饮水机没水了', '三楼饮水机没水了，请及时补充。', 2, 45, 2, 5, 1, 0, 0, NULL, NULL, NULL, '2026-03-04 15:30:00', '2026-03-04 15:30:00', 0);
INSERT INTO `forum_post` VALUES (67, 3, NULL, '测试', '测试', 1, 2, 1, 0, 3, 0, 0, NULL, NULL, NULL, '2026-04-19 19:13:14', '2026-04-21 16:18:08', 0);
INSERT INTO `forum_post` VALUES (68, 2, NULL, '测', '测', 1, 2, 0, 0, 1, 0, 0, NULL, NULL, NULL, '2026-04-20 13:49:51', '2026-04-21 18:44:03', 0);
INSERT INTO `forum_post` VALUES (69, 3, NULL, '测试的', '测试功能', 1, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, '2026-04-22 23:07:59', '2026-04-22 23:07:59', 0);
INSERT INTO `forum_post` VALUES (70, 3, NULL, '啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊', '啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊', 1, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, '2026-04-22 23:08:17', '2026-04-22 23:08:17', 0);
INSERT INTO `forum_post` VALUES (71, 3, NULL, '啊啊啊啊啊啊啊啊', '啊啊啊啊啊啊啊啊啊', 1, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, '2026-04-22 23:09:07', '2026-04-22 23:09:07', 0);
INSERT INTO `forum_post` VALUES (72, 3, NULL, '啊啊啊', '啊啊啊啊啊', 1, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, '2026-04-22 23:09:30', '2026-04-22 23:09:30', 0);

-- ----------------------------
-- Table structure for forum_reply
-- ----------------------------
DROP TABLE IF EXISTS `forum_reply`;
CREATE TABLE `forum_reply`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `parent_id` bigint NULL DEFAULT NULL COMMENT '父回复ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '回复内容',
  `like_count` int NULL DEFAULT 0 COMMENT '点赞数',
  `is_accepted` tinyint NULL DEFAULT 0 COMMENT '是否被采纳',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：0-禁用 1-启用',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` tinyint NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_post_id`(`post_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '论坛回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_reply
-- ----------------------------
INSERT INTO `forum_reply` VALUES (1, 29, 4, NULL, '确实，我也经常遇到这种情况，希望能加强管理。', 0, 0, 1, '2026-03-19 10:30:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (2, 29, 6, NULL, '建议可以设置一个最长离开时间，超过就释放座位。', 0, 0, 1, '2026-03-19 11:15:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (3, 29, 7, NULL, '支持！或者可以贴个温馨提示。', 0, 0, 1, '2026-03-19 14:20:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (4, 35, 3, NULL, '考试周大家一起加油！', 0, 0, 1, '2026-03-18 10:00:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (5, 35, 5, NULL, '图书馆位置太难抢了，要提前预约。', 0, 0, 1, '2026-03-18 11:30:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (6, 3, 4, NULL, '推荐靠窗的位置，光线好！', 0, 0, 1, '2026-03-12 10:30:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (7, 11, 6, NULL, '谢谢分享，很有用！', 0, 0, 1, '2026-03-08 12:00:00', '2026-03-20 11:14:45', 0);
INSERT INTO `forum_reply` VALUES (8, 29, 3, NULL, '是的', 0, 0, 1, '2026-03-20 11:15:49', '2026-03-20 11:15:49', 0);
INSERT INTO `forum_reply` VALUES (9, 47, 3, NULL, '你好', 0, 0, 1, '2026-03-20 11:16:01', '2026-03-20 11:16:01', 0);
INSERT INTO `forum_reply` VALUES (10, 56, 5, NULL, '番茄工作法挺有效的，可以试试。', 0, 0, 1, '2026-03-15 09:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (11, 56, 6, NULL, '建议制定详细的学习计划。', 0, 0, 1, '2026-03-15 10:15:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (12, 56, 7, NULL, '找一个安静的环境很重要。', 0, 0, 1, '2026-03-15 11:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (13, 56, 8, NULL, '适当休息，劳逸结合。', 0, 0, 1, '2026-03-15 14:20:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (14, 57, 3, NULL, '确实有点冷，建议带件外套。', 0, 0, 1, '2026-03-14 15:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (15, 57, 5, NULL, '已向管理员反馈。', 0, 0, 1, '2026-03-14 16:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (16, 58, 4, NULL, '这种情况太常见了，应该加强巡查。', 0, 0, 1, '2026-03-13 18:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (17, 58, 6, NULL, '支持！建议设置离开超时机制。', 0, 0, 1, '2026-03-13 19:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (18, 59, 3, NULL, '求分享！', 0, 0, 1, '2026-03-10 11:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (19, 59, 4, NULL, '可以发到群里吗？', 0, 0, 1, '2026-03-10 12:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (20, 59, 5, NULL, '谢谢分享，辛苦了！', 0, 0, 1, '2026-03-10 14:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (21, 60, 4, NULL, '我也遇到过，重启一下WiFi就好了。', 0, 0, 1, '2026-03-09 12:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (22, 60, 5, NULL, '希望尽快修复。', 0, 0, 1, '2026-03-09 13:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (23, 61, 3, NULL, '周末开放到晚上10点。', 0, 0, 1, '2026-03-08 17:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (24, 62, 4, NULL, '确实好用，点赞！', 0, 0, 1, '2026-03-07 10:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (25, 63, 5, NULL, '我可以！一起准备六级。', 0, 0, 1, '2026-03-06 15:00:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (26, 63, 6, NULL, '加我一个，互相监督。', 0, 0, 1, '2026-03-06 16:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (27, 64, 3, NULL, 'A区也有这个问题。', 0, 0, 1, '2026-03-05 11:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (28, 65, 4, NULL, '已补充，谢谢提醒。', 0, 0, 1, '2026-03-04 16:30:00', '2026-03-20 11:18:50', 0);
INSERT INTO `forum_reply` VALUES (29, 41, 3, NULL, '啊\n', 0, 0, 1, '2026-04-19 19:13:04', '2026-04-19 19:13:04', 0);
INSERT INTO `forum_reply` VALUES (30, 67, 23, NULL, '1', 0, 0, 1, '2026-04-21 16:17:22', '2026-04-21 16:17:22', 0);

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容',
  `publisher_id` bigint NULL DEFAULT NULL COMMENT '发布人ID',
  `publisher_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发布人姓名',
  `publisher_type` int NULL DEFAULT 1 COMMENT '??????1-??????2-??????',
  `is_top` tinyint NULL DEFAULT 0 COMMENT '是否置顶：0-否 1-是',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览次数',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-草稿 1-已发布 2-已下架',
  `publish_time` datetime(0) NULL DEFAULT NULL COMMENT '发布时间',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` int NULL DEFAULT 0,
  `audit_status` int NULL DEFAULT 0 COMMENT '?????0-????1-?????2-?????',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_notice_publisher_id`(`publisher_id`) USING BTREE,
  CONSTRAINT `fk_notice_publisher_id` FOREIGN KEY (`publisher_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (1, '关于图书馆自习室开放时间的通知', '各位同学：图书馆自习室将于每日8:00-22:00开放，请大家合理安排学习时间。', 1, '系统管理员', 1, 1, 157, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (2, '期末考试期间自习室使用须知', '期末考试期间，自习室座位紧张，请大家提前预约，遵守自习室管理规定。', 2, '自习室管理员', 1, 1, 234, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (3, '新开放教学楼B301静音自习室', '为满足同学们的学习需求，现开放教学楼B301作为静音自习室，欢迎预约使用。', 2, '自习室管理员', 1, 0, 89, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 1, 1);
INSERT INTO `notice` VALUES (4, '自习室空调使用规范', '请节约用电，离开自习室时请关闭座位附近的空调和灯光。', 1, '系统管理员', 1, 0, 67, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (5, '关于预约违约的处理办法', '连续三次预约后未签到将被限制预约权限一周，请大家珍惜预约资源。', 1, '系统管理员', 1, 0, 145, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (6, '图书馆一楼自习室A维护通知', '图书馆一楼自习室A将于本周六进行设备维护，暂停开放一天。', 2, '自习室管理员', 1, 0, 78, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (7, '欢迎使用新的自习室预约系统', '全新的自习室智能管理系统上线啦！支持在线预约、签到打卡等功能。', 1, '系统管理员', 1, 1, 567, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (8, '自习室座位使用礼仪', '请保持安静，禁止占座，离开时带走个人物品和垃圾。', 2, '自习室管理员', 1, 0, 123, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (9, '节假日自习室开放安排', '节假日期间自习室正常开放，具体安排请关注后续通知。', 1, '系统管理员', 1, 0, 45, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (10, '图书馆WiFi升级完成', '图书馆区域WiFi已完成升级，网速更快更稳定，欢迎使用。', 1, '系统管理员', 1, 0, 234, 3, '2026-03-19 16:44:31', '2026-03-19 16:44:31', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (11, '图书馆自习室4月开放安排', '图书馆B座自习室将于4月1日起延长开放至23:00，请同学们注意安排学习计划。', 1, '系统管理员', 1, 0, 25, 3, NULL, '2026-03-20 09:30:21', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (12, '关于自习室设备维护通知', '教学楼C区101自习室将于3月25日进行空调维护，当日暂停预约，敬请谅解。', 1, '系统管理员', 1, 0, 18, 3, NULL, '2026-03-20 09:30:21', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (13, '新增自习室预约功能说明', '系统新增了座位收藏功能，用户可在自习室详情页收藏喜欢的座位，下次预约更方便。', 1, '系统管理员', 1, 0, 32, 3, NULL, '2026-03-20 09:30:21', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (14, '学期末考试周自习室安排', '期末考试周（6月15日至6月30日）各自习室将延长开放至23:30，请同学们合理安排学习时间。', 1, '系统管理员', 1, 0, 45, 3, NULL, '2026-03-20 09:30:21', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (15, '自习室卫生管理通知', '为营造整洁的学习环境，请各位同学使用自习室后及时清理桌面，爱护公共设施。', 1, '系统管理员', 1, 0, 12, 3, NULL, '2026-03-20 09:30:21', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (16, '图书馆自习室4月开放安排', '图书馆B座自习室将于4月1日起延长开放至23:00，请同学们注意安排学习计划。', 1, '系统管理员', 1, 0, 26, 3, NULL, '2026-03-20 09:32:05', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (17, '关于自习室设备维护通知', '教学楼C区101自习室将于3月25日进行空调维护，当日暂停预约，敬请谅解。', 1, '系统管理员', 1, 0, 18, 3, NULL, '2026-03-20 09:32:05', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (18, '新增自习室预约功能说明', '系统新增了座位收藏功能，用户可在自习室详情页收藏喜欢的座位，下次预约更方便。', 1, '系统管理员', 1, 0, 32, 3, NULL, '2026-03-20 09:32:05', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (19, '学期末考试周自习室安排', '期末考试周（6月15日至6月30日）各自习室将延长开放至23:30，请同学们合理安排学习时间。', 1, '系统管理员', 1, 0, 45, 3, NULL, '2026-03-20 09:32:05', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (20, '自习室卫生管理通知', '为营造整洁的学习环境，请各位同学使用自习室后及时清理桌面，爱护公共设施。', 1, '系统管理员', 1, 0, 12, 3, NULL, '2026-03-20 09:32:05', '2026-04-13 17:24:01', 0, 1);
INSERT INTO `notice` VALUES (21, '123', '123123', 1, '系统管理员', 1, 0, 0, 3, '2026-03-20 10:54:56', '2026-03-20 10:54:56', '2026-04-13 17:24:01', 1, 1);
INSERT INTO `notice` VALUES (22, ' 测试', '测试', 1, '系统管理员', 1, 0, 0, 2, '2026-04-19 19:17:00', '2026-04-19 18:46:05', '2026-04-19 19:17:00', 0, 0);
INSERT INTO `notice` VALUES (23, '测试', '测试', 1, '系统管理员', 1, 1, 0, 2, '2026-04-19 19:17:00', '2026-04-19 18:46:23', '2026-04-19 19:17:00', 0, 0);
INSERT INTO `notice` VALUES (24, ' 测试', '测试', 1, '系统管理员', 1, 0, 1, 2, '2026-04-19 19:17:00', '2026-04-19 19:10:06', '2026-04-19 19:17:00', 0, 0);

-- ----------------------------
-- Table structure for reservation
-- ----------------------------
DROP TABLE IF EXISTS `reservation`;
CREATE TABLE `reservation`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `room_id` bigint NOT NULL COMMENT '自习室ID',
  `seat_id` bigint NOT NULL COMMENT '座位ID',
  `reservation_date` date NOT NULL COMMENT '预约日期',
  `start_time` time(0) NOT NULL COMMENT '开始时间',
  `end_time` time(0) NOT NULL COMMENT '结束时间',
  `status` int NULL DEFAULT 0 COMMENT '状态：0-待签到 1-使用中 2-已完成 3-已违约 4-已取消',
  `check_in_time` datetime(0) NULL DEFAULT NULL COMMENT '签到时间',
  `check_out_time` datetime(0) NULL DEFAULT NULL COMMENT '签退时间',
  `cancel_time` datetime(0) NULL DEFAULT NULL COMMENT '取消时间',
  `cancel_reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '取消原因',
  `violation_count` int NULL DEFAULT 0 COMMENT '违约次数',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `appeal_status` int NULL DEFAULT 0 COMMENT '申诉状态：0-无申诉 1-待处理 2-申诉通过 3-申诉驳回',
  `appeal_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申诉理由',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_res_user_id`(`user_id`) USING BTREE,
  INDEX `fk_res_room_id`(`room_id`) USING BTREE,
  INDEX `fk_res_seat_id`(`seat_id`) USING BTREE,
  CONSTRAINT `fk_res_room_id` FOREIGN KEY (`room_id`) REFERENCES `study_room` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_res_seat_id` FOREIGN KEY (`seat_id`) REFERENCES `seat` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_res_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 50 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预约表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of reservation
-- ----------------------------
INSERT INTO `reservation` VALUES (1, 3, 1, 1, '2026-03-20', '08:00:00', '12:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (2, 4, 1, 2, '2026-03-20', '14:00:00', '18:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (3, 5, 2, 61, '2026-03-21', '09:00:00', '12:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (4, 6, 3, 101, '2026-03-19', '08:00:00', '12:00:00', 1, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (5, 7, 1, 3, '2026-03-19', '13:00:00', '17:00:00', 1, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (6, 8, 5, 221, '2026-03-18', '08:00:00', '12:00:00', 2, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (7, 9, 6, 271, '2026-03-18', '14:00:00', '18:00:00', 2, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (8, 10, 1, 4, '2026-03-17', '08:00:00', '12:00:00', 4, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (9, 11, 2, 62, '2026-03-17', '09:00:00', '12:00:00', 4, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (10, 12, 3, 102, '2026-03-22', '10:00:00', '14:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL);
INSERT INTO `reservation` VALUES (11, 3, 1, 8, '2026-03-19', '08:30:00', '09:30:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-19 18:32:15', '2026-03-19 18:32:15', 0, NULL);
INSERT INTO `reservation` VALUES (12, 3, 2, 66, '2026-03-19', '18:30:00', '19:00:00', 4, NULL, NULL, '2026-03-20 10:51:16', NULL, 0, '2026-03-19 18:32:55', '2026-04-19 19:30:33', 0, NULL);
INSERT INTO `reservation` VALUES (13, 5, 1, 10, '2026-03-10', '08:00:00', '10:00:00', 2, NULL, NULL, NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (14, 5, 1, 11, '2026-03-11', '14:00:00', '16:00:00', 2, '2026-03-11 14:05:00', '2026-03-11 15:58:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (15, 5, 2, 50, '2026-03-12', '09:00:00', '11:00:00', 2, '2026-03-12 09:10:00', '2026-03-12 11:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (16, 5, 3, 100, '2026-03-13', '19:00:00', '21:00:00', 2, '2026-03-13 19:05:00', '2026-03-13 21:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (17, 5, 1, 12, '2026-03-14', '08:00:00', '10:00:00', 2, '2026-03-14 08:02:00', '2026-03-14 10:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (18, 5, 2, 51, '2026-03-15', '10:00:00', '12:00:00', 2, '2026-03-15 10:08:00', '2026-03-15 12:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (19, 5, 1, 13, '2026-03-17', '14:00:00', '17:00:00', 2, '2026-03-17 14:03:00', '2026-03-17 17:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (20, 5, 3, 101, '2026-03-18', '19:00:00', '21:00:00', 2, '2026-03-18 19:01:00', '2026-03-18 21:00:00', NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (21, 6, 1, 14, '2026-03-19', '08:00:00', '10:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (22, 6, 2, 52, '2026-03-19', '14:00:00', '16:00:00', 1, '2026-03-20 09:32:04', NULL, NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (23, 7, 1, 15, '2026-03-20', '09:00:00', '11:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (24, 7, 3, 102, '2026-03-20', '19:00:00', '21:00:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-20 09:32:04', '2026-03-20 09:32:04', 0, NULL);
INSERT INTO `reservation` VALUES (25, 8, 1, 16, '2026-03-16', '08:00:00', '10:00:00', 2, '2026-03-16 08:05:00', '2026-03-16 10:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (26, 9, 2, 53, '2026-03-15', '16:00:00', '18:00:00', 2, '2026-03-15 16:04:00', '2026-03-15 18:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (27, 10, 3, 103, '2026-03-14', '10:00:00', '12:00:00', 2, '2026-03-14 10:06:00', '2026-03-14 12:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (28, 11, 1, 17, '2026-03-13', '08:00:00', '10:00:00', 2, '2026-03-13 08:03:00', '2026-03-13 10:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (29, 12, 2, 54, '2026-03-12', '14:00:00', '16:00:00', 2, '2026-03-12 14:05:00', '2026-03-12 16:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (30, 13, 3, 104, '2026-03-11', '19:00:00', '21:00:00', 2, '2026-03-11 19:02:00', '2026-03-11 21:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (31, 14, 1, 18, '2026-03-10', '14:00:00', '16:00:00', 2, '2026-03-10 14:04:00', '2026-03-10 16:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (32, 15, 2, 55, '2026-03-11', '09:00:00', '11:00:00', 2, '2026-03-11 09:07:00', '2026-03-11 11:00:00', NULL, NULL, 0, '2026-03-20 09:32:05', '2026-03-20 09:32:05', 0, NULL);
INSERT INTO `reservation` VALUES (33, 3, 1, 6, '2026-03-20', '10:00:00', '10:30:00', 0, NULL, NULL, NULL, NULL, 0, '2026-03-20 10:36:11', '2026-03-20 10:36:11', 0, NULL);
INSERT INTO `reservation` VALUES (34, 3, 2, 64, '2026-03-20', '11:00:00', '11:30:00', 2, '2026-03-20 10:51:05', '2026-03-20 10:51:06', NULL, NULL, 0, '2026-03-20 10:36:38', '2026-03-20 10:51:06', 0, NULL);
INSERT INTO `reservation` VALUES (35, 3, 1, 9, '2026-03-20', '11:00:00', '11:30:00', 2, '2026-03-20 10:51:33', '2026-03-20 10:51:34', NULL, NULL, 0, '2026-03-20 10:51:29', '2026-03-20 10:51:34', 0, NULL);
INSERT INTO `reservation` VALUES (36, 3, 1, 5, '2026-04-12', '08:00:00', '10:30:00', 4, NULL, NULL, '2026-04-12 11:35:10', '预约超时未签到，系统自动取消', 0, '2026-04-12 11:35:08', '2026-04-19 19:28:48', 0, NULL);
INSERT INTO `reservation` VALUES (37, 3, 1, 45, '2026-04-12', '11:30:00', '14:30:00', 4, NULL, NULL, '2026-04-19 18:49:53', '预约超时未签到，系统自动取消', 0, '2026-04-12 11:35:37', '2026-04-19 19:28:37', 0, NULL);
INSERT INTO `reservation` VALUES (38, 3, 1, 2, '2026-04-19', '18:30:00', '19:00:00', 3, '2026-04-19 18:50:29', '2026-04-19 18:51:13', NULL, NULL, 0, '2026-04-19 18:50:27', '2026-04-19 19:20:41', 0, NULL);
INSERT INTO `reservation` VALUES (39, 23, 1, 4, '2026-04-19', '18:30:00', '19:00:00', 4, NULL, NULL, '2026-04-19 19:01:12', '预约超时未签到，系统自动取消', 0, '2026-04-19 18:58:45', '2026-04-19 19:09:12', 2, '测试的');
INSERT INTO `reservation` VALUES (40, 3, 1, 2, '2026-04-20', '13:00:00', '14:30:00', 2, '2026-04-20 13:46:44', '2026-04-20 13:46:45', NULL, NULL, 0, '2026-04-20 13:31:03', '2026-04-20 13:46:45', 0, NULL);
INSERT INTO `reservation` VALUES (41, 3, 2, 61, '2026-04-20', '14:30:00', '15:00:00', 3, NULL, NULL, NULL, '预约超时未签到，系统自动违约', 0, '2026-04-20 14:05:44', '2026-04-20 14:31:52', 0, NULL);
INSERT INTO `reservation` VALUES (42, 3, 12, 405, '2026-04-20', '14:30:00', '15:30:00', 3, NULL, NULL, '2026-04-20 14:51:56', '预约超时未签到，系统自动违约', 0, '2026-04-20 14:31:41', '2026-04-20 15:45:49', 0, NULL);
INSERT INTO `reservation` VALUES (43, 23, 1, 2, '2026-04-20', '14:45:00', '15:30:00', 2, '2026-04-20 14:35:21', '2026-04-20 14:35:23', NULL, NULL, 0, '2026-04-20 14:35:07', '2026-04-20 15:05:43', 0, NULL);
INSERT INTO `reservation` VALUES (44, 23, 12, 409, '2026-04-20', '15:00:00', '19:00:00', 3, NULL, NULL, '2026-04-20 14:47:48', NULL, 0, '2026-04-20 14:42:05', '2026-04-20 14:47:48', 0, NULL);
INSERT INTO `reservation` VALUES (45, 23, 12, 408, '2026-04-20', '14:50:00', '15:40:00', 2, '2026-04-20 14:50:02', '2026-04-20 14:50:05', NULL, NULL, 0, '2026-04-20 14:49:33', '2026-04-20 14:50:05', 0, NULL);
INSERT INTO `reservation` VALUES (46, 23, 12, 408, '2026-04-20', '14:51:00', '14:53:00', 3, NULL, NULL, '2026-04-20 14:50:54', NULL, 0, '2026-04-20 14:50:41', '2026-04-20 14:50:54', 0, NULL);
INSERT INTO `reservation` VALUES (47, 23, 12, 408, '2026-04-20', '14:52:00', '14:59:00', 3, NULL, NULL, NULL, '预约超时未签到，系统自动违约', 0, '2026-04-20 14:51:38', '2026-04-20 15:08:00', 0, NULL);
INSERT INTO `reservation` VALUES (48, 3, 12, 405, '2026-04-20', '14:00:00', '15:36:00', 4, NULL, NULL, NULL, '预约超时未签到，系统自动违约', 0, '2026-04-20 15:07:35', '2026-04-20 15:13:46', 2, '已取消');
INSERT INTO `reservation` VALUES (49, 3, 12, 405, '2026-04-20', '15:32:00', '16:59:00', 4, '2026-04-20 15:31:45', '2026-04-20 15:58:56', NULL, NULL, 0, '2026-04-20 15:31:44', '2026-04-21 15:51:02', 0, NULL);

-- ----------------------------
-- Table structure for seat
-- ----------------------------
DROP TABLE IF EXISTS `seat`;
CREATE TABLE `seat`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL COMMENT '自习室ID',
  `seat_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '座位号',
  `row_num` int NOT NULL COMMENT '行号',
  `col_num` int NOT NULL COMMENT '列号',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-不可用 1-可用 2-占用中 3-维修中',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `position_x` int NULL DEFAULT NULL COMMENT '座位自定义X坐标',
  `position_y` int NULL DEFAULT NULL COMMENT '座位自定义Y坐标',
  `seat_type` int NULL DEFAULT 1 COMMENT '?????1-?????2-???3-??/??',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '?????JSON???????[\"??\",\"???\"]',
  `width` int NULL DEFAULT NULL COMMENT '自定义宽度（px），用于过道/柱子',
  `height` int NULL DEFAULT NULL COMMENT '自定义高度（px），用于过道/柱子',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_seat_room_id`(`room_id`) USING BTREE,
  CONSTRAINT `fk_seat_room_id` FOREIGN KEY (`room_id`) REFERENCES `study_room` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 412 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '座位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of seat
-- ----------------------------
INSERT INTO `seat` VALUES (1, 1, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1020, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (2, 1, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (3, 1, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 20, 120, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (4, 1, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (5, 1, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (6, 1, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (7, 1, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 20, 1, '[\"靠窗\"]', 80, 60);
INSERT INTO `seat` VALUES (8, 1, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 20, 1, '[\"靠门近\",\"宽敞\",\"角落位置\"]', 80, 60);
INSERT INTO `seat` VALUES (9, 1, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (10, 1, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (11, 1, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1020, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (12, 1, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (13, 1, 'B03', 2, 3, 3, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 20, 200, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (14, 1, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (15, 1, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (16, 1, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (17, 1, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (18, 1, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (19, 1, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (20, 1, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (21, 1, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1020, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (22, 1, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (23, 1, 'C03', 3, 3, 3, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 20, 280, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (24, 1, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (25, 1, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (26, 1, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (27, 1, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (28, 1, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (29, 1, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (30, 1, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (31, 1, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1120, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (32, 1, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (33, 1, 'D03', 4, 3, 3, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 20, 360, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (34, 1, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (35, 1, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (36, 1, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (37, 1, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (38, 1, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (39, 1, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (40, 1, 'D10', 4, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (41, 1, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1020, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (42, 1, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (43, 1, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 220, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (44, 1, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (45, 1, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (46, 1, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (47, 1, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (48, 1, 'E08', 5, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (49, 1, 'E09', 5, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (50, 1, 'E10', 5, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (51, 1, 'F01', 6, 1, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 1020, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (52, 1, 'F02', 6, 2, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 120, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (53, 1, 'F03', 6, 3, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 220, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (54, 1, 'F04', 6, 4, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 320, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (55, 1, 'F05', 6, 5, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 420, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (56, 1, 'F06', 6, 6, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 520, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (57, 1, 'F07', 6, 7, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 620, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (58, 1, 'F08', 6, 8, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 720, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (59, 1, 'F09', 6, 9, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 820, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (60, 1, 'F10', 6, 10, 1, '2026-03-19 16:44:31', '2026-04-20 15:30:00', 920, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (61, 2, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 20, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (62, 2, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 120, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (63, 2, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (64, 2, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 320, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (65, 2, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 420, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (66, 2, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 520, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (67, 2, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 620, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (68, 2, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-04-22 23:18:50', 920, 20, 1, '[\"靠窗\"]', 80, 60);
INSERT INTO `seat` VALUES (69, 2, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 20, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (70, 2, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 120, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (71, 2, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (72, 2, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 320, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (73, 2, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 420, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (74, 2, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 520, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (75, 2, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 620, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (76, 2, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 920, 100, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (77, 2, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 20, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (78, 2, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 120, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (79, 2, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (80, 2, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 320, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (81, 2, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 420, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (82, 2, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 520, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (83, 2, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 620, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (84, 2, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 920, 180, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (85, 2, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 20, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (86, 2, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 120, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (87, 2, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (88, 2, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 320, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (89, 2, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 420, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (90, 2, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 520, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (91, 2, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 620, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (92, 2, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 920, 260, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (93, 2, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 20, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (94, 2, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 120, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (95, 2, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (96, 2, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 320, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (97, 2, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 420, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (98, 2, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 520, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (99, 2, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 620, 340, 1, '[\"靠门近\",\"宽敞\",\"有插座\"]', 80, 60);
INSERT INTO `seat` VALUES (100, 2, 'E08', 5, 8, 3, '2026-03-19 16:44:31', '2026-04-22 23:16:20', 220, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (101, 3, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-04-20 13:53:01', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (102, 3, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-20 08:59:33', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (103, 3, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-20 08:59:30', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (104, 3, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (105, 3, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (106, 3, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (107, 3, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (108, 3, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (109, 3, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (110, 3, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-04-19 16:32:02', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (111, 3, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (112, 3, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (113, 3, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (114, 3, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (115, 3, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (116, 3, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (117, 3, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (118, 3, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (119, 3, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (120, 3, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (121, 3, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (122, 3, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (123, 3, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (124, 3, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (125, 3, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (126, 3, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (127, 3, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (128, 3, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (129, 3, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (130, 3, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (131, 3, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (132, 3, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (133, 3, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (134, 3, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (135, 3, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (136, 3, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (137, 3, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (138, 3, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (139, 3, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (140, 3, 'D10', 4, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (141, 3, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (142, 3, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (143, 3, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (144, 3, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (145, 3, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (146, 3, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (147, 3, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (148, 3, 'E08', 5, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (149, 3, 'E09', 5, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (150, 3, 'E10', 5, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (151, 3, 'F01', 6, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (152, 3, 'F02', 6, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (153, 3, 'F03', 6, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (154, 3, 'F04', 6, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (155, 3, 'F05', 6, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (156, 3, 'F06', 6, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (157, 3, 'F07', 6, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (158, 3, 'F08', 6, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (159, 3, 'F09', 6, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (160, 3, 'F10', 6, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (161, 3, 'G01', 7, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (162, 3, 'G02', 7, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (163, 3, 'G03', 7, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (164, 3, 'G04', 7, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (165, 3, 'G05', 7, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (166, 3, 'G06', 7, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (167, 3, 'G07', 7, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (168, 3, 'G08', 7, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (169, 3, 'G09', 7, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (170, 3, 'G10', 7, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (171, 3, 'H01', 8, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (172, 3, 'H02', 8, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (173, 3, 'H03', 8, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (174, 3, 'H04', 8, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (175, 3, 'H05', 8, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (176, 3, 'H06', 8, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (177, 3, 'H07', 8, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (178, 3, 'H08', 8, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (179, 3, 'H09', 8, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (180, 3, 'H10', 8, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (181, 4, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (182, 4, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (183, 4, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (184, 4, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (185, 4, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (186, 4, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (187, 4, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (188, 4, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (189, 4, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (190, 4, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (191, 4, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (192, 4, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (193, 4, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (194, 4, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (195, 4, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (196, 4, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (197, 4, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (198, 4, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (199, 4, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (200, 4, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (201, 4, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (202, 4, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (203, 4, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (204, 4, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (205, 4, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (206, 4, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (207, 4, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (208, 4, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (209, 4, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (210, 4, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (211, 5, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (212, 5, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (213, 5, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (214, 5, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (215, 5, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (216, 5, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (217, 5, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (218, 5, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (219, 5, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (220, 5, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (221, 5, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (222, 5, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (223, 5, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (224, 5, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (225, 5, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (226, 5, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (227, 5, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (228, 5, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (229, 5, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (230, 5, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (231, 5, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (232, 5, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (233, 5, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (234, 5, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (235, 5, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (236, 5, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (237, 5, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (238, 5, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (239, 5, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (240, 5, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (241, 5, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (242, 5, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (243, 5, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (244, 5, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (245, 5, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (246, 5, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (247, 5, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (248, 5, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (249, 5, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (250, 5, 'D10', 4, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (251, 5, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (252, 5, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (253, 5, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (254, 5, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (255, 5, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (256, 5, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (257, 5, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (258, 5, 'E08', 5, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (259, 5, 'E09', 5, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (260, 5, 'E10', 5, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (261, 6, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (262, 6, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (263, 6, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (264, 6, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (265, 6, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (266, 6, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (267, 6, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (268, 6, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (269, 6, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (270, 6, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (271, 6, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (272, 6, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (273, 6, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (274, 6, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (275, 6, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (276, 6, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (277, 6, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (278, 6, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (279, 6, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (280, 6, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (281, 6, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (282, 6, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (283, 6, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (284, 6, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (285, 6, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (286, 6, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (287, 6, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (288, 6, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (289, 6, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (290, 6, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (291, 6, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (292, 6, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (293, 6, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (294, 6, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (295, 6, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (296, 6, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (297, 6, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (298, 6, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (299, 6, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (300, 6, 'D10', 4, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (301, 6, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (302, 6, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (303, 6, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (304, 6, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (305, 6, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (306, 6, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (307, 6, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (308, 6, 'E08', 5, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (309, 6, 'E09', 5, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (310, 6, 'E10', 5, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (311, 7, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (312, 7, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (313, 7, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (314, 7, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (315, 7, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (316, 7, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (317, 7, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (318, 7, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (319, 7, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (320, 7, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (321, 7, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (322, 7, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (323, 7, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (324, 7, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (325, 7, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (326, 7, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (327, 7, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (328, 7, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (329, 7, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (330, 7, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (331, 7, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (332, 7, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (333, 7, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (334, 7, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (335, 7, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (336, 7, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (337, 7, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (338, 7, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (339, 7, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (340, 7, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (341, 7, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (342, 7, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (343, 7, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (344, 7, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (345, 7, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (346, 7, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (347, 7, 'E01', 5, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (348, 7, 'E02', 5, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (349, 7, 'E03', 5, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (350, 7, 'E04', 5, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (351, 7, 'E05', 5, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (352, 7, 'E06', 5, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (353, 7, 'E07', 5, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (354, 7, 'E08', 5, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (355, 7, 'E09', 5, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (356, 8, 'A01', 1, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (357, 8, 'A02', 1, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (358, 8, 'A03', 1, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (359, 8, 'A04', 1, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (360, 8, 'A05', 1, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (361, 8, 'A06', 1, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (362, 8, 'A07', 1, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (363, 8, 'A08', 1, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (364, 8, 'A09', 1, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (365, 8, 'A10', 1, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (366, 8, 'B01', 2, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (367, 8, 'B02', 2, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (368, 8, 'B03', 2, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (369, 8, 'B04', 2, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (370, 8, 'B05', 2, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (371, 8, 'B06', 2, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (372, 8, 'B07', 2, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (373, 8, 'B08', 2, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (374, 8, 'B09', 2, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (375, 8, 'B10', 2, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (376, 8, 'C01', 3, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (377, 8, 'C02', 3, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (378, 8, 'C03', 3, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (379, 8, 'C04', 3, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (380, 8, 'C05', 3, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (381, 8, 'C06', 3, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (382, 8, 'C07', 3, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (383, 8, 'C08', 3, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (384, 8, 'C09', 3, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (385, 8, 'C10', 3, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (386, 8, 'D01', 4, 1, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (387, 8, 'D02', 4, 2, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (388, 8, 'D03', 4, 3, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (389, 8, 'D04', 4, 4, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (390, 8, 'D05', 4, 5, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (391, 8, 'D06', 4, 6, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (392, 8, 'D07', 4, 7, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (393, 8, 'D08', 4, 8, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (394, 8, 'D09', 4, 9, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (395, 8, 'D10', 4, 10, 1, '2026-03-19 16:44:31', '2026-03-19 16:44:31', NULL, NULL, 1, NULL, NULL, NULL);
INSERT INTO `seat` VALUES (396, 1, '', 0, 0, 0, '2026-04-12 11:09:37', '2026-04-20 15:30:00', 1020, 20, 2, NULL, 80, 60);
INSERT INTO `seat` VALUES (397, 1, '', 0, 0, 0, '2026-04-12 11:09:55', '2026-04-20 15:30:00', 220, 20, 2, NULL, 80, 40);
INSERT INTO `seat` VALUES (398, 2, '', 0, 0, 0, '2026-04-12 11:20:57', '2026-04-22 23:16:20', 740, 120, 2, NULL, 80, 300);
INSERT INTO `seat` VALUES (399, 11, '', 0, 0, 0, '2026-04-19 18:43:57', '2026-04-19 18:44:39', 20, 20, 2, NULL, 80, 60);
INSERT INTO `seat` VALUES (400, 11, '', 0, 0, 0, '2026-04-19 18:44:01', '2026-04-19 18:44:39', 20, 20, 3, NULL, 80, 60);
INSERT INTO `seat` VALUES (401, 11, '', 0, 0, 0, '2026-04-19 18:44:27', '2026-04-19 18:44:39', 20, 20, 2, NULL, 80, 60);
INSERT INTO `seat` VALUES (402, 11, '', 0, 0, 0, '2026-04-19 18:44:38', '2026-04-19 18:44:39', 20, 20, 2, NULL, 80, 60);
INSERT INTO `seat` VALUES (403, 3, 'S081', 0, 0, 1, '2026-04-20 13:52:09', '2026-04-20 13:53:08', 20, 20, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (404, 3, 'S082', 0, 0, 1, '2026-04-20 13:52:13', '2026-04-20 13:52:59', 20, 20, 1, '[\"空调区\"]', 80, 60);
INSERT INTO `seat` VALUES (405, 12, 'S001', 0, 0, 1, '2026-04-20 14:19:45', '2026-04-21 15:50:32', 40, 40, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (406, 12, 'S002', 0, 0, 1, '2026-04-20 14:19:48', '2026-04-21 15:50:32', 40, 340, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (407, 12, 'S003', 0, 0, 1, '2026-04-20 14:19:50', '2026-04-21 15:50:33', 40, 420, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (408, 12, 'S004', 0, 0, 1, '2026-04-20 14:19:50', '2026-04-21 15:50:33', 40, 240, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (409, 12, 'S005', 0, 0, 1, '2026-04-20 14:19:50', '2026-04-21 15:50:33', 40, 140, 1, NULL, 80, 60);
INSERT INTO `seat` VALUES (410, 12, '', 0, 0, 0, '2026-04-21 15:50:26', '2026-04-21 15:50:33', 180, 40, 2, NULL, 80, 320);
INSERT INTO `seat` VALUES (411, 2, '', 0, 0, 0, '2026-04-22 23:15:51', '2026-04-22 23:16:20', 1080, 100, 2, NULL, 80, 60);

-- ----------------------------
-- Table structure for seat_tag
-- ----------------------------
DROP TABLE IF EXISTS `seat_tag`;
CREATE TABLE `seat_tag`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL COMMENT '???ID',
  `tag_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '????',
  `tag_color` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#409EFF' COMMENT '????',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_room_id`(`room_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '?????' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of seat_tag
-- ----------------------------
INSERT INTO `seat_tag` VALUES (3, 1, '靠窗', '#409EFF', '2026-04-12 11:10:23', '2026-04-12 11:10:23');

-- ----------------------------
-- Table structure for study_room
-- ----------------------------
DROP TABLE IF EXISTS `study_room`;
CREATE TABLE `study_room`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '自习室名称',
  `building` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '教学楼',
  `floor` int NOT NULL COMMENT '楼层',
  `room_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '房间号',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '普通' COMMENT '类型：普通/静音/讨论室',
  `capacity` int NOT NULL COMMENT '容量',
  `row_count` int NULL DEFAULT 5 COMMENT '座位行数',
  `col_count` int NULL DEFAULT 10 COMMENT '座位列数',
  `open_time` time(0) NULL DEFAULT '08:00:00' COMMENT '开放时间',
  `close_time` time(0) NULL DEFAULT '22:00:00' COMMENT '关闭时间',
  `has_air_condition` tinyint NULL DEFAULT 1 COMMENT '是否有空调',
  `has_wifi` tinyint NULL DEFAULT 1 COMMENT '是否有WiFi',
  `has_power` tinyint NULL DEFAULT 1 COMMENT '是否有电源',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片URL',
  `admin_id` bigint NULL DEFAULT NULL COMMENT '管理员ID',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-关闭 1-开放 2-维护中',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_sr_admin_id`(`admin_id`) USING BTREE,
  CONSTRAINT `fk_sr_admin_id` FOREIGN KEY (`admin_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '自习室表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of study_room
-- ----------------------------
INSERT INTO `study_room` VALUES (1, '图书馆一楼自习室A', '图书馆', 1, '101', '普通', 60, 6, 10, '08:00:00', '22:00:00', 1, 1, 1, '宽敞明亮的自习室，配备空调和WiFi', '/images/1.png', 24, 1, '2026-03-19 16:44:31', '2026-04-21 15:39:58', 0);
INSERT INTO `study_room` VALUES (2, '图书馆一楼自习室B', '图书馆', 1, '102', '静音', 40, 5, 8, '08:00:00', '22:00:00', 1, 1, 1, '静音自习室，适合深度学习', '/images/2.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (3, '图书馆二楼自习室A', '图书馆', 2, '201', '普通', 80, 8, 10, '08:00:00', '22:00:00', 1, 1, 1, '大型自习室，座位充足', '/images/3.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (4, '图书馆二楼自习室B', '图书馆', 2, '202', '讨论室', 30, 3, 10, '08:00:00', '22:00:00', 1, 1, 1, '小组讨论室，可小声交流', '/images/4.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (5, '教学楼A101', '教学楼A', 1, '101', '普通', 50, 5, 10, '08:00:00', '22:00:00', 1, 1, 1, '标准教室改造，环境舒适', '/images/5.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (6, '教学楼A201', '教学楼A', 2, '201', '普通', 50, 5, 10, '08:00:00', '22:00:00', 1, 1, 1, '配备投影仪，可观看学习视频', '/images/6.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (7, '教学楼B301', '教学楼B', 3, '301', '静音', 45, 5, 9, '08:00:00', '22:00:00', 1, 1, 1, '高层安静区域，视野开阔', '/images/7.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (8, '教学楼C101', '教学楼C', 1, '101', '普通', 40, 4, 10, '08:00:00', '22:00:00', 1, 1, 1, '靠近食堂，用餐方便', '/images/8.png', 2, 1, '2026-03-19 16:44:31', '2026-03-20 09:09:30', 0);
INSERT INTO `study_room` VALUES (9, '123', '123', 1, '', '静音', 50, 5, 10, '08:00:00', '22:00:00', 1, 1, 1, '', NULL, NULL, 1, '2026-03-20 10:56:14', '2026-03-20 10:59:10', 1);
INSERT INTO `study_room` VALUES (10, '测试', '测试', 1, '101', '普通', 50, 5, 10, '08:00:00', '22:00:00', 1, 1, 1, '', '/images/1.png', 2, 1, '2026-04-19 16:29:55', '2026-04-19 16:30:23', 1);
INSERT INTO `study_room` VALUES (11, '测试', '图书馆', 1, '303', '普通', 50, 5, 10, '08:00:00', '22:00:00', 1, 1, 1, '', '/images/1.png', 2, 1, '2026-04-19 16:34:17', '2026-04-20 13:29:28', 1);
INSERT INTO `study_room` VALUES (12, '测试', '测试', 1, '101', '普通', 55, 5, 10, '00:00:00', '23:59:00', 1, 1, 1, '1', NULL, 24, 1, '2026-04-20 13:50:11', '2026-04-22 22:38:27', 0);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色编码',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色描述',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '普通用户', 'ROLE_USER', '系统普通用户', '2026-03-19 16:44:31', '2026-03-19 16:44:31');
INSERT INTO `sys_role` VALUES (2, '自习室管理员', 'ROLE_ROOM_ADMIN', '自习室管理员', '2026-03-19 16:44:31', '2026-03-19 16:44:31');
INSERT INTO `sys_role` VALUES (3, '系统管理员', 'ROLE_SYS_ADMIN', '系统超级管理员', '2026-03-19 16:44:31', '2026-03-19 16:44:31');

-- ----------------------------
-- Table structure for sys_setting
-- ----------------------------
DROP TABLE IF EXISTS `sys_setting`;
CREATE TABLE `sys_setting`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `setting_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_key`(`setting_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_setting
-- ----------------------------
INSERT INTO `sys_setting` VALUES (1, 'max_violation_limit', '3', '达到该违约次数禁止预约');
INSERT INTO `sys_setting` VALUES (2, 'reward_checkin_days', '7', '连续签到多少天可导表加德育分');
INSERT INTO `sys_setting` VALUES (3, 'moral_rank1_hours', '10', '段位1-初学者：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (4, 'moral_rank2_hours', '30', '段位2-进阶者：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (5, 'moral_rank3_hours', '60', '段位3-学习达人：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (6, 'moral_rank4_hours', '100', '段位4-自律标兵：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (7, 'moral_rank5_hours', '150', '段位5-学霸：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (8, 'moral_rank6_hours', '200', '段位6-学神：累计学习时长阈值(小时)');
INSERT INTO `sys_setting` VALUES (9, 'moral_rank1_score', '0.5', '段位1-初学者：奖励德育分');
INSERT INTO `sys_setting` VALUES (10, 'moral_rank2_score', '0.5', '段位2-进阶者：奖励德育分');
INSERT INTO `sys_setting` VALUES (11, 'moral_rank3_score', '1.0', '段位3-学习达人：奖励德育分');
INSERT INTO `sys_setting` VALUES (12, 'moral_rank4_score', '1.0', '段位4-自律标兵：奖励德育分');
INSERT INTO `sys_setting` VALUES (13, 'moral_rank5_score', '1.0', '段位5-学霸：奖励德育分');
INSERT INTO `sys_setting` VALUES (14, 'moral_rank6_score', '1.0', '段位6-学神：奖励德育分');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `user_type` int NULL DEFAULT 1 COMMENT '用户类型：1-普通用户 2-自习室管理员 3-系统管理员',
  `status` int NULL DEFAULT 1 COMMENT '状态：0-禁用 1-启用',
  `last_login_time` datetime(0) NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  `update_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `deleted` int NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除 1-已删除',
  `student_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '学号',
  `department` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '院系',
  `major` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '专业',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `violation_count` int NULL DEFAULT 0 COMMENT '累计违约次数',
  `continuous_checkin_days` int NULL DEFAULT 0 COMMENT '连续签到天数',
  `moral_score` decimal(3, 1) NOT NULL DEFAULT 0.0 COMMENT '已获德育分（最高5分）',
  `moral_rank` int NOT NULL DEFAULT 0 COMMENT '当前德育段位(0=未入段,1~6)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$rzSkhzHtR8QjUQXvgsaFT.5rqrG3mME4WQtraH4bAQSbjLxqwShU2', '系统管理员', '13800138000', 'admin@studyroom.com', NULL, 3, 1, '2026-04-22 22:17:33', '2026-03-19 16:44:31', '2026-03-19 17:29:02', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (2, 'zxsadmin', 'admin', '自习室管理员', '13800138001', 'zxsadmin@studyroom.com', NULL, 2, 1, '2026-04-22 23:11:05', '2026-03-19 16:44:31', '2026-03-20 10:53:25', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (3, 'user', '$2a$10$/gjQhmjOG2hIAd2A7oYyeuVV4RtJpcv//0vD2zfgBBpVZaAFzO2TO', '测试用户', '13800138002', 'user@studyroom.com', NULL, 1, 1, '2026-04-22 23:07:37', '2026-03-19 16:44:31', '2026-04-19 19:27:05', 0, NULL, NULL, NULL, NULL, 2, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (4, 'zhangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '张三', '13900139001', 'zhangsan@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (5, 'lisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '李四', '13900139002', 'lisi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (6, 'wangwu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '王五', '13900139003', 'wangwu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (7, 'zhaoliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '赵六', '13900139004', 'zhaoliu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (8, 'sunqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '孙七', '13900139005', 'sunqi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (9, 'zhouba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '周八', '13900139006', 'zhouba@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (10, 'wujiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '吴九', '13900139007', 'wujiu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (11, 'zhengshi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '郑十', '13900139008', 'zhengshi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (12, 'chenyi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '陈一', '13900139009', 'chenyi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (13, 'linerm', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '林二', '13900139010', 'linerm@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (14, 'huangsan', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '黄三', '13900139011', 'huangsan@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (15, 'heisi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '何四', '13900139012', 'heisi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (16, 'gaowu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '高五', '13900139013', 'gaowu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (17, 'liuliu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '刘六', '13900139014', 'liuliu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (18, 'linqi', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '林七', '13900139015', 'linqi@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (19, 'guoba', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '郭八', '13900139016', 'guoba@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (20, 'luojiu', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EO', '罗九', '13900139017', 'luojiu@example.com', NULL, 1, 1, NULL, '2026-03-19 16:44:31', '2026-03-19 16:44:31', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (21, '123', '$2a$10$mXFO/NJoh0Lv3b8tgBFDG.SzckUMV1ISGuBFkenXJ4wXxrZEcH5Va', '1232', '15899999655', '', NULL, 1, 1, '2026-03-19 17:23:52', '2026-03-19 16:57:23', '2026-03-20 10:59:07', 1, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (22, '123456', '$2a$10$qt5cTcQ3wctht81iTvqBvetw1QN16WM2IThGzzWuBSCGdJR38yM3.', '123456', '123456', '123456@123456', NULL, 1, 1, '2026-04-12 11:36:02', '2026-04-12 11:35:58', '2026-04-12 11:35:58', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (23, 'yyy', '$2a$10$cYeDVC5wRqlEfrwn6f1sMuOlBZe5z1hEbkfZfPugZ7ZJWtT57eRkW', 'yyy', '1008611', '1828494518@qq.com', NULL, 1, 1, '2026-04-21 16:16:10', '2026-04-19 18:58:10', '2026-04-19 18:58:10', 0, NULL, NULL, NULL, NULL, 1, 0, 0.0, 0);
INSERT INTO `sys_user` VALUES (24, 'qqqq', '123456', '小Q', '10086', '10086@qq.com', NULL, 2, 1, '2026-04-21 15:50:13', '2026-04-21 15:39:38', '2026-04-21 15:47:16', 0, NULL, NULL, NULL, NULL, 0, 0, 0.0, 0);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `create_time` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_sur_user_id`(`user_id`) USING BTREE,
  INDEX `fk_sur_role_id`(`role_id`) USING BTREE,
  CONSTRAINT `fk_sur_role_id` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sur_user_id` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1, 3, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (2, 2, 2, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (3, 3, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (4, 4, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (5, 5, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (6, 6, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (7, 7, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (8, 8, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (9, 9, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (10, 10, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (11, 11, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (12, 12, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (13, 13, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (14, 14, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (15, 15, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (16, 16, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (17, 17, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (18, 18, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (19, 19, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (20, 20, 1, '2026-03-19 16:44:31');
INSERT INTO `sys_user_role` VALUES (21, 21, 1, '2026-03-19 16:57:23');
INSERT INTO `sys_user_role` VALUES (22, 22, 1, '2026-04-12 11:35:58');
INSERT INTO `sys_user_role` VALUES (23, 23, 1, '2026-04-19 18:58:10');
INSERT INTO `sys_user_role` VALUES (24, 24, 2, '2026-04-21 15:47:16');

-- ----------------------------
-- Table structure for user_moral_record
-- ----------------------------
DROP TABLE IF EXISTS `user_moral_record`;
CREATE TABLE `user_moral_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `rank_level` int NOT NULL COMMENT '达到的段位(1~6)',
  `rank_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '段位名称',
  `score_awarded` decimal(3, 1) NOT NULL COMMENT '本次奖励德育分',
  `total_hours` decimal(8, 1) NOT NULL COMMENT '达成时累计学习时长(小时)',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '获奖时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `fk_moral_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '德育分获取记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_moral_record
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
