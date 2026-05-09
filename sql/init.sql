-- ============================================================
-- 红色旅游小网站 数据库初始化脚本
-- 数据库名: red_tourism
-- 编码: UTF-8MB4
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. 创建数据库
-- ----------------------------
DROP DATABASE IF EXISTS `red_tourism`;
CREATE DATABASE `red_tourism` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `red_tourism`;

-- ----------------------------
-- 2. 管理员表
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` VARCHAR(50) NOT NULL COMMENT '登录账号',
  `password` VARCHAR(255) NOT NULL COMMENT '密码（BCrypt加密）',
  `real_name` VARCHAR(50) DEFAULT NULL COMMENT '真实姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `role` VARCHAR(20) NOT NULL DEFAULT 'admin' COMMENT '角色：admin-超级管理员,operator-运营人员',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
  `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` VARCHAR(50) DEFAULT NULL COMMENT '最后登录IP',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员用户表';

INSERT INTO `admin_user` (`username`, `password`, `real_name`, `role`, `status`) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', 'admin', 1),
('operator', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '运营人员', 'operator', 1);

-- ----------------------------
-- 3. 红色景点表
-- ----------------------------
DROP TABLE IF EXISTS `red_attraction`;
CREATE TABLE `red_attraction` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` VARCHAR(100) NOT NULL COMMENT '景点名称',
  `cover_image` VARCHAR(500) NOT NULL COMMENT '封面图片URL',
  `images` TEXT COMMENT '图片JSON数组',
  `province` VARCHAR(50) DEFAULT NULL COMMENT '省份',
  `city` VARCHAR(50) DEFAULT NULL COMMENT '城市',
  `district` VARCHAR(50) DEFAULT NULL COMMENT '区县',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '详细地址',
  `latitude` DECIMAL(10,6) DEFAULT NULL COMMENT '纬度',
  `longitude` DECIMAL(10,6) DEFAULT NULL COMMENT '经度',
  `open_time` VARCHAR(100) DEFAULT NULL COMMENT '开放时间',
  `ticket_price` DECIMAL(10,2) DEFAULT 0.00 COMMENT '门票价格',
  `description` TEXT COMMENT '景点简介',
  `history_story` TEXT COMMENT '红色历史故事',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`),
  KEY `idx_province_city` (`province`, `city`),
  KEY `idx_sort_status` (`sort`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='红色景点表';

INSERT INTO `red_attraction` (`name`, `cover_image`, `province`, `city`, `district`, `address`, `open_time`, `ticket_price`, `description`, `history_story`, `sort`, `status`) VALUES
('嘉兴南湖红船', 'https://picsum.photos/800/400?random=101', '浙江省', '嘉兴市', '南湖区', '南湖路83号', '09:00-17:00', 0.00, '中国共产党第一次全国代表大会在这里胜利闭幕，中国共产党宣告诞生。', '1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，转移至南湖一艘画舫上继续进行，并在这里诞生了中国共产党第一个纲领和第一个决议，宣告了中国共产党的成立。', 100, 1),
('延安革命纪念馆', 'https://picsum.photos/800/400?random=102', '陕西省', '延安市', '宝塔区', '延河北路58号', '08:00-18:00', 0.00, '全面系统地展示了党中央和毛泽东等老一辈革命家在延安领导中国革命的丰功伟绩。', '延安是中国革命的圣地，从1935年到1948年，毛泽东等老一辈无产阶级革命家在这里生活和战斗了13个春秋，领导了抗日战争和解放战争，培育了永放光芒的延安精神。', 99, 1),
('井冈山茨坪革命旧址', 'https://picsum.photos/800/400?random=103', '江西省', '吉安市', '井冈山市', '茨坪镇红军路', '08:00-17:30', 90.00, '中国第一个农村革命根据地的中心，这里保存着大量的革命旧址和珍贵文物。', '1927年10月，毛泽东率领秋收起义部队来到井冈山，创建了中国第一个农村革命根据地，开辟了农村包围城市、武装夺取政权的革命道路。', 98, 1),
('遵义会议纪念馆', 'https://picsum.photos/800/400?random=104', '贵州省', '遵义市', '红花岗区', '子尹路96号', '08:30-17:30', 0.00, '1935年1月，中国共产党在这里召开了著名的遵义会议。', '1935年1月15日至17日，中共中央政治局在遵义召开了扩大会议，结束了左倾教条主义错误在中央的统治，确立了毛泽东在红军和党中央的领导地位，在危急关头挽救了党、挽救了红军、挽救了中国革命。', 97, 1),
('西柏坡革命圣地', 'https://picsum.photos/800/400?random=105', '河北省', '石家庄市', '平山县', '西柏坡镇', '09:00-17:00', 0.00, '解放战争后期中共中央和中国人民解放军总部所在地。', '1948年5月至1949年3月，毛泽东、朱德、刘少奇、周恩来、任弼时等老一辈革命家在西柏坡指挥了辽沈、淮海、平津三大战役，召开了党的七届二中全会，描绘了新中国的宏伟蓝图。', 96, 1),
('天安门广场人民英雄纪念碑', 'https://picsum.photos/800/400?random=106', '北京市', '北京市', '东城区', '天安门广场内', '05:00-22:00', 0.00, '世界上最大的城市广场，是中华人民共和国的心脏。', '人民英雄纪念碑位于天安门广场中央，是为了纪念近代以来为中国人民解放事业牺牲的英雄们而建立的。1949年9月30日，毛泽东主席亲自为纪念碑奠基并题词人民英雄永垂不朽。', 95, 1);

-- ----------------------------
-- 4. 旅游路线表
-- ----------------------------
DROP TABLE IF EXISTS `travel_route`;
CREATE TABLE `travel_route` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '路线ID',
  `name` VARCHAR(100) NOT NULL COMMENT '路线名称',
  `cover_image` VARCHAR(500) NOT NULL COMMENT '封面图片',
  `images` TEXT COMMENT '图片JSON数组',
  `theme` VARCHAR(50) DEFAULT NULL COMMENT '主题（红色教育/历史追溯/研学旅行）',
  `duration_days` INT NOT NULL DEFAULT 1 COMMENT '行程天数',
  `group_size` INT DEFAULT NULL COMMENT '建议人数',
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '价格（元/人）',
  `original_price` DECIMAL(10,2) DEFAULT NULL COMMENT '原价',
  `summary` VARCHAR(500) DEFAULT NULL COMMENT '路线简介',
  `highlights` TEXT COMMENT '路线亮点（JSON数组）',
  `included` TEXT COMMENT '费用包含（JSON数组）',
  `excluded` TEXT COMMENT '费用不含（JSON数组）',
  `tips` TEXT COMMENT '温馨提示',
  `start_location` VARCHAR(200) DEFAULT NULL COMMENT '出发地',
  `end_location` VARCHAR(200) DEFAULT NULL COMMENT '目的地',
  `meeting_address` VARCHAR(255) DEFAULT NULL COMMENT '集合地点',
  `meeting_time` VARCHAR(100) DEFAULT NULL COMMENT '集合时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-上架，0-下架',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `view_count` INT NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `collect_count` INT NOT NULL DEFAULT 0 COMMENT '收藏次数',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_status_sort` (`status`, `sort`),
  KEY `idx_theme` (`theme`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旅游路线表';

INSERT INTO `travel_route` (`name`, `cover_image`, `theme`, `duration_days`, `group_size`, `price`, `original_price`, `summary`, `highlights`, `included`, `excluded`, `tips`, `start_location`, `end_location`, `meeting_address`, `meeting_time`, `sort`, `status`) VALUES
('嘉兴南湖红船1日研学游', 'https://picsum.photos/800/400?random=201', '红色教育', 1, 30, 168.00, 198.00, '探访中国共产党诞生地，重温入党誓词，感受红船精神。', '["瞻仰南湖红船","重温入党誓词","参观南湖革命纪念馆","红船精神专题讲座"]', '["全程正规旅游大巴","景区门票","研学导师讲解","午餐","研学手册","团队横幅","旅游意外险"]', '["个人消费","私人开销","纪念品购买"]', '穿着轻便运动装，携带身份证件，建议提前15分钟到达集合点', '上海人民广场', '嘉兴南湖', '上海市人民广场博物馆西大门（武胜路）', '07:30', 100, 1),
('延安精神3日深度学习之旅', 'https://picsum.photos/800/400?random=202', '红色教育', 3, 25, 980.00, 1280.00, '走进革命圣地延安，深入学习延安精神，传承红色基因。', '["延安革命纪念馆深度参观","枣园、杨家岭旧址探访","观看《延安保育院》演出","宝塔山主题党课","与老红军后代面对面交流"]', '["全程大巴交通","准四星酒店2晚住宿","全程用餐（2早5正）","景区门票及讲解","专题党课费用","旅游意外险"]', '["单房差","个人消费","纪念品"]', '携带党史学习笔记本，着正装或深色服装，注意高原气候变化', '西安北站', '延安', '西安北站南广场集合', '08:00', 99, 1),
('井冈山红色拓展5日训练营', 'https://picsum.photos/800/400?random=203', '历史追溯', 5, 20, 2380.00, 2680.00, '重走红军路，体验革命艰辛，锤炼党性修养。', '["黄洋界哨口遗址","八角楼现场教学","红军挑粮小道徒步","井冈山革命博物馆","篝火晚会红歌会"]', '["全程交通（空调大巴）","农家乐及酒店住宿4晚","全程用餐（4早9正）","景区门票","拓展训练器材","专业教官及讲解","人身意外险"]', '["个人消费","行程外费用","单房差"]', '准备登山或徒步装备，带好常用药品，行程强度较大请根据身体状况报名', '南昌八一广场', '井冈山', '南昌八一广场纪念塔下', '07:00', 98, 1);

-- ----------------------------
-- 5. 路线景点关联表
-- ----------------------------
DROP TABLE IF EXISTS `route_attraction_rel`;
CREATE TABLE `route_attraction_rel` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `route_id` BIGINT UNSIGNED NOT NULL COMMENT '路线ID',
  `attraction_id` BIGINT UNSIGNED NOT NULL COMMENT '景点ID',
  `day_index` INT NOT NULL DEFAULT 1 COMMENT '第几天',
  `visit_order` INT NOT NULL DEFAULT 1 COMMENT '当天第几个景点',
  `visit_time` VARCHAR(100) DEFAULT NULL COMMENT '参观时段（如：09:00-11:30）',
  `stay_duration` INT DEFAULT NULL COMMENT '停留时长（分钟）',
  `memo` VARCHAR(255) DEFAULT NULL COMMENT '备注说明',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_route_id` (`route_id`),
  KEY `idx_attraction_id` (`attraction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='路线景点关联表';

INSERT INTO `route_attraction_rel` (`route_id`, `attraction_id`, `day_index`, `visit_order`, `visit_time`, `stay_duration`, `memo`) VALUES
(1, 1, 1, 1, '09:00-11:30', 150, '瞻仰红船，重温入党誓词'),
(1, 2, 1, 2, '13:00-16:00', 180, '参观纪念馆，聆听革命历史'),
(2, 2, 1, 1, '09:00-12:00', 180, '抵达延安，参观革命纪念馆'),
(2, 2, 2, 2, '14:00-17:00', 180, '枣园、杨家岭旧址探访'),
(2, 2, 3, 3, '19:00-21:00', 120, '观看红色演出'),
(2, 2, 1, 4, '08:30-10:30', 120, '宝塔山主题党课，重温入党誓词'),
(3, 3, 1, 1, '10:00-12:00', 120, '抵达茨坪，革命传统教育'),
(3, 3, 2, 2, '13:00-16:00', 180, '八角楼现场教学'),
(3, 3, 3, 3, '08:30-11:30', 180, '黄洋界哨口遗址徒步'),
(3, 3, 4, 4, '14:00-16:00', 120, '井冈山革命博物馆');

-- ----------------------------
-- 6. 团队预约表
-- ----------------------------
DROP TABLE IF EXISTS `team_booking`;
CREATE TABLE `team_booking` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `order_no` VARCHAR(32) NOT NULL COMMENT '订单编号',
  `route_id` BIGINT UNSIGNED DEFAULT NULL COMMENT '预约路线ID',
  `team_name` VARCHAR(100) NOT NULL COMMENT '团队名称',
  `contact_name` VARCHAR(50) NOT NULL COMMENT '联系人姓名',
  `contact_phone` VARCHAR(20) NOT NULL COMMENT '联系人手机',
  `contact_id_card` VARCHAR(20) DEFAULT NULL COMMENT '联系人身份证号',
  `team_size` INT NOT NULL COMMENT '团队人数',
  `travel_date` DATE DEFAULT NULL COMMENT '计划出行日期',
  `duration_days` INT DEFAULT NULL COMMENT '行程天数',
  `meeting_address` VARCHAR(255) DEFAULT NULL COMMENT '集合地点',
  `meeting_time` VARCHAR(100) DEFAULT NULL COMMENT '集合时间',
  `remark` TEXT COMMENT '备注/特殊需求',
  `status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态：0-待确认，1-已确认，2-已拒绝，3-已完成，4-已取消',
  `status_remark` VARCHAR(255) DEFAULT NULL COMMENT '状态变更说明',
  `confirm_time` DATETIME DEFAULT NULL COMMENT '确认时间',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_route_id` (`route_id`),
  KEY `idx_contact_phone` (`contact_phone`),
  KEY `idx_status` (`status`),
  KEY `idx_travel_date` (`travel_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队预约表';

INSERT INTO `team_booking` (`order_no`, `route_id`, `team_name`, `contact_name`, `contact_phone`, `contact_id_card`, `team_size`, `travel_date`, `duration_days`, `meeting_address`, `meeting_time`, `remark`, `status`, `create_time`) VALUES
('TB20250107001', 1, '浙江工业大学马克思主义学院党支部', '张建国', '13800138001', '330101197501011234', 28, '2025-02-15', 1, '上海市人民广场博物馆西大门（武胜路）', '07:30', '请安排一名随团医护人员', 1, '2025-01-07 09:30:00'),
('TB20250107002', 2, '华为技术有限公司华东党支部', '李明华', '13900139002', '310101198003021567', 22, '2025-02-20', 3, '西安北站南广场集合', '08:00', '团队成员多为党员，请安排专题党课', 0, '2025-01-07 14:22:00'),
('TB20250108001', 3, '复旦大学历史系教职工党支部', '王芳', '13700137003', '310101198506151890', 18, '2025-03-01', 5, '南昌八一广场纪念塔下', '07:00', '需全程安排党史讲解，请提供扩音设备', 3, '2025-01-08 10:15:00'),
('TB20250108002', 1, '杭州中学团委学生会', '刘小红', '13600136004', '330102199002121345', 35, '2025-03-05', 1, '杭州市西湖断桥残雪集合点', '07:00', '学生为主，请注意行程安全', 2, '2025-01-08 16:40:00'),
('TB20250109001', 2, '中国银行上海分行党委', '陈海燕', '13500135005', '310115198812030456', 25, '2025-03-08', 3, '中国银行上海分行大楼前', '07:30', '提供大巴车牌号及司机联系方式', 1, '2025-01-09 08:55:00');

-- ----------------------------
-- 7. 会员用户表
-- ----------------------------
DROP TABLE IF EXISTS `member_user`;
CREATE TABLE `member_user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `openid` VARCHAR(100) DEFAULT NULL COMMENT '微信OpenID',
  `unionid` VARCHAR(100) DEFAULT NULL COMMENT '微信UnionID',
  `nickname` VARCHAR(100) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `gender` TINYINT DEFAULT 0 COMMENT '性别：0-未知，1-男，2-女',
  `birthday` DATE DEFAULT NULL COMMENT '生日',
  `province` VARCHAR(50) DEFAULT NULL COMMENT '省份',
  `city` VARCHAR(50) DEFAULT NULL COMMENT '城市',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
  `last_login_time` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` VARCHAR(50) DEFAULT NULL COMMENT '最后登录IP',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_openid` (`openid`),
  UNIQUE KEY `uk_unionid` (`unionid`),
  UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员用户表';

INSERT INTO `member_user` (`openid`, `nickname`, `avatar`, `phone`, `gender`, `province`, `city`, `create_time`) VALUES
('oTest001_xxxxxxxxx', '红色游客001', 'https://picsum.photos/200/200?random=301', '13800138001', 1, '上海市', '上海市', '2025-01-05 10:00:00'),
('oTest002_xxxxxxxxx', '延安精神传承者', 'https://picsum.photos/200/200?random=302', '13900139002', 2, '陕西省', '西安市', '2025-01-06 11:30:00'),
('oTest003_xxxxxxxxx', '红船后辈', 'https://picsum.photos/200/200?random=303', '13700137003', 1, '浙江省', '杭州市', '2025-01-07 09:00:00');

-- ----------------------------
-- 8. 路线收藏表
-- ----------------------------
DROP TABLE IF EXISTS `route_collect`;
CREATE TABLE `route_collect` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  `route_id` BIGINT UNSIGNED NOT NULL COMMENT '路线ID',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_route` (`user_id`, `route_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_route_id` (`route_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='路线收藏表';

INSERT INTO `route_collect` (`user_id`, `route_id`, `create_time`) VALUES
(1, 1, '2025-01-06 14:00:00'),
(1, 2, '2025-01-07 10:30:00'),
(2, 3, '2025-01-07 16:00:00'),
(3, 1, '2025-01-08 08:00:00');

-- ----------------------------
-- 9. 轮播图配置表
-- ----------------------------
DROP TABLE IF EXISTS `banner_config`;
CREATE TABLE `banner_config` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `title` VARCHAR(100) NOT NULL COMMENT '标题',
  `image_url` VARCHAR(500) NOT NULL COMMENT '图片URL',
  `link_type` VARCHAR(20) DEFAULT NULL COMMENT '跳转类型：attraction-景点,route-路线,custom-自定义URL,None-不跳转',
  `link_value` VARCHAR(500) DEFAULT NULL COMMENT '跳转值',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete` TINYINT NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`),
  KEY `idx_status_sort` (`status`, `sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图配置表';

INSERT INTO `banner_config` (`title`, `image_url`, `link_type`, `link_value`, `sort`, `status`) VALUES
('传承红色基因', 'https://picsum.photos/750/400?random=401', 'custom', '', 100, 1),
('庆祝建党百年', 'https://picsum.photos/750/400?random=402', 'custom', '', 90, 1),
('红色旅游精品路线', 'https://picsum.photos/750/400?random=403', 'route', '1', 80, 1);

-- ----------------------------
-- 10. 系统配置表
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `config_value` TEXT COMMENT '配置值',
  `config_name` VARCHAR(100) DEFAULT NULL COMMENT '配置名称',
  `config_desc` VARCHAR(255) DEFAULT NULL COMMENT '配置描述',
  `group_name` VARCHAR(50) DEFAULT 'default' COMMENT '配置分组',
  `sort` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

INSERT INTO `system_config` (`config_key`, `config_value`, `config_name`, `config_desc`, `group_name`, `sort`, `status`) VALUES
('site_name', '红色旅游小网站', '网站名称', '显示在页面标题等位置', 'base', 1, 1),
('site_logo', 'https://picsum.photos/200/200?random=501', '网站Logo', '网站Logo图片地址', 'base', 2, 1),
('contact_phone', '400-888-9999', '客服电话', '显示在底部或联系页面', 'contact', 1, 1),
('contact_wechat', 'redtourism2025', '微信公众号', '微信公众号名称或二维码', 'contact', 2, 1),
('about_us', '红色旅游小网站致力于传播红色文化，传承革命精神，为用户提供优质的红色旅游服务和研学体验。', '关于我们', '网站底部关于我们的内容', 'content', 1, 1);

-- ----------------------------
-- 10. 内容模块表（content_block）
-- 统一管理六个分类内容
-- 分类编码: zkaju=走看聚, qflz=清风廉政, yffl=与法同行,
--          szxc=数字乡村, yxyp=一县一片, swxl=室外线路
-- ----------------------------
DROP TABLE IF EXISTS `content_block`;
CREATE TABLE `content_block` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `category`      VARCHAR(20)     NOT NULL COMMENT '分类编码: zkaju|qflz|yffl|szxc|yxyp|swxl',
  `category_name` VARCHAR(50)    NOT NULL COMMENT '分类名称',
  `title`         VARCHAR(200)    NOT NULL COMMENT '内容标题',
  `subtitle`      VARCHAR(200)    DEFAULT NULL COMMENT '副标题/简介',
  `content`       TEXT            COMMENT '富文本/详细内容',
  `cover_image`   VARCHAR(500)    DEFAULT NULL COMMENT '封面图片URL',
  `images`        TEXT            COMMENT '多图JSON数组',
  `author`        VARCHAR(100)    DEFAULT NULL COMMENT '作者/来源',
  `source`        VARCHAR(200)    DEFAULT NULL COMMENT '来源单位',
  `publish_date`  DATE           DEFAULT NULL COMMENT '发布日期',
  `view_count`    INT            NOT NULL DEFAULT 0 COMMENT '浏览量',
  `sort`          INT            NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status`        TINYINT        NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `create_time`   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `is_delete`     TINYINT        NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_status_sort` (`status`, `sort`),
  KEY `idx_publish_date` (`publish_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='内容模块表';

-- 内容模块初始数据（六个分类各3条）
INSERT INTO `content_block` (`category`, `category_name`, `title`, `subtitle`, `content`, `cover_image`, `author`, `source`, `publish_date`, `sort`, `status`) VALUES
-- 走看聚
('zkaju', '走看聚', '【走看聚】追寻红色足迹·走进南湖红船', '重温建党历史，传承红船精神', '<p>南湖位于浙江省嘉兴市，是中国共产党的诞生地。1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。</p><p>在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。</p><p>红船精神是中国革命精神之源，习近平总书记概括为"开天辟地、敢为人先的首创精神，坚定理想、百折不挠的奋斗精神，立党为公、忠诚为民的奉献精神"。</p>', 'https://picsum.photos/800/500?random=101', '红色旅游研学组', '嘉兴市文化广电旅游局', '2024-06-01', 100, 1),
('zkaju', '走看聚', '【走看聚】延安精神永放光芒', '走进革命圣地，感悟延安精神', '<p>延安革命纪念馆是全国红色旅游经典景区，全面展示了党中央和毛泽东等老一辈革命家在延安十三年的光辉战斗历程。</p><p>延安是中国革命圣地，是中国人民解放事业的总后方。1935年到1948年，中共中央和毛泽东在这里领导了抗日战争和解放战争，培育了伟大的延安精神。</p>', 'https://picsum.photos/800/500?random=102', '研学导师部', '延安市文化和旅游局', '2024-06-05', 95, 1),
('zkaju', '走看聚', '【走看聚】井冈山：革命摇篮，星火燎原', '重上井冈山，传承红色基因', '<p>井冈山是中国第一个农村革命根据地，被誉为"革命摇篮"。1927年10月，毛泽东等老一辈革命家在这里创建了第一个农村革命根据地，开辟了"农村包围城市、武装夺取政权"的正确革命道路。</p>', 'https://picsum.photos/800/500?random=103', '红色教育基地', '井冈山管理局', '2024-06-10', 90, 1),
-- 清风廉政
('qflz', '清风廉政', '【清风廉政】学习《中国共产党纪律处分条例》', '严守党的纪律，永葆政治本色', '<p>《中国共产党纪律处分条例》是根据《中国共产党章程》制定的党内法规，对维护党的章程、严肃党的纪律、保证党的路线方针政策的贯彻执行发挥着重要作用。</p><p>本次学习重点围绕政治纪律、组织纪律、廉洁纪律、群众纪律、工作纪律、生活纪律"六大纪律"展开，要求全体党员知敬畏、存戒惧、守底线。</p>', 'https://picsum.photos/800/500?random=201', '纪委办公室', '中共XX县纪律检查委员会', '2024-05-20', 100, 1),
('qflz', '清风廉政', '【清风廉政】廉政教育基地参观学习活动', '以案为鉴，警钟长鸣', '<p>为深入推进党风廉政建设，筑牢党员干部拒腐防变思想防线，近日组织全体党员干部前往廉政教育基地开展警示教育活动。</p><p>通过观看警示教育展板、聆听典型案例讲解，大家深刻认识到腐败行为对党和国家事业以及家庭、个人的严重危害。</p>', 'https://picsum.photos/800/500?random=202', '党建办', '中共XX镇纪律检查委员会', '2024-05-25', 95, 1),
('qflz', '清风廉政', '【清风廉政】党纪学习教育专题党课', '学条例、守纪律、担使命', '<p>开展党纪学习教育，是加强党的纪律建设、推动全面从严治党向纵深发展的重要举措。本次专题党课围绕新修订的《中国共产党纪律处分条例》进行解读。</p>', 'https://picsum.photos/800/500?random=203', '党支部书记', 'XX党支部', '2024-06-01', 90, 1),
-- 与法同行
('yffl', '与法同行', '【与法同行】宪法宣传周系列活动纪实', '弘扬宪法精神，建设法治社会', '<p>在国家宪法宣传周期间，各单位积极开展宪法学习宣传活动，通过专题讲座、法治宣传、宪法知识竞赛等多种形式，营造浓厚的学法用法氛围。</p><p>本次活动覆盖机关、学校、社区、企业等多领域，受众人群超过5000人次，有效提升了全民宪法意识和法治素养。</p>', 'https://picsum.photos/800/500?random=301', '普法办', 'XX县司法局', '2024-12-04', 100, 1),
('yffl', '与法同行', '【与法同行】民法典进社区宣讲活动', '让民法典走进千家万户', '<p>为深入学习贯彻《中华人民共和国民法典》，进一步提高居民法律意识，县司法局组织法律服务团深入社区开展民法典宣讲活动。</p><p>宣讲内容涵盖婚姻家庭、继承、侵权责任等与群众生活密切相关的法律知识，现场解答群众咨询100余人次。</p>', 'https://picsum.photos/800/500?random=302', '法律服务团', 'XX县司法局', '2024-11-15', 95, 1),
('yffl', '与法同行', '【与法同行】预防电信网络诈骗专题讲座', '守住钱袋子，护好幸福家', '<p>针对当前电信网络诈骗高发态势，县公安局联合银行、通信运营商开展防范电信诈骗专题讲座进社区活动。</p><p>通过真实案例分析，揭露常见诈骗手法，提醒居民不轻信、不转账、不汇款，提高防骗识骗能力。</p>', 'https://picsum.photos/800/500?random=303', '反诈中心', 'XX县公安局', '2024-10-20', 90, 1),
-- 数字乡村
('szxc', '数字乡村', '【数字乡村】智慧农业助推乡村振兴', '科技赋能农业，农村焕发新活力', '<p>数字乡村建设是乡村振兴战略的重要组成部分。近年来，各地积极推进智慧农业建设，通过物联网、大数据、人工智能等技术手段，提升农业生产效率和农产品质量。</p><p>智能灌溉系统、无人机植保、农产品溯源平台等数字化应用正在改变传统农业生产方式，为农民增收致富开辟了新路径。</p>', 'https://picsum.photos/800/500?random=401', '乡村振兴办', 'XX县农业农村局', '2024-06-10', 100, 1),
('szxc', '数字乡村', '【数字乡村】农村电商拓宽致富路', '手机成新农具，直播成新农活', '<p>随着网络基础设施的完善和智能手机的普及，农村电商蓬勃发展，越来越多的农民通过直播带货把家乡的优质农产品卖向全国。</p><p>从田间地头到餐桌，城市消费者可以直接购买到新鲜优质的农产品，实现了生产者和消费者的双赢。</p>', 'https://picsum.photos/800/500?random=402', '电商服务中心', 'XX县商务局', '2024-05-28', 95, 1),
('szxc', '数字乡村', '【数字乡村】数字政务服务进乡村', '数据多跑路，群众少跑腿', '<p>数字政务平台向乡村延伸，让村民在家门口就能办理社保、医保、营业执照等多项政务服务，真正实现了"数据多跑路、群众少跑腿"。</p><p>村级便民服务站配备的自助服务终端，可以办理100多项高频民生事项，极大地方便了农村群众。</p>', 'https://picsum.photos/800/500?random=403', '政务服务中心', 'XX县政务服务管理局', '2024-05-15', 90, 1),
-- 一县一片
('yxyp', '一县一片', '【一县一片】红二十五军长征出发地——罗山县', '豫南革命老区的红色印记', '<p>罗山县是红二十五军长征出发地。1934年11月16日，红二十五军近3000名将士在罗山县何家冲集结出发，开始了艰苦卓绝的长征。</p><p>红二十五军是长征中平均年龄最轻的一支队伍，也是最先到达陕北的一支红军主力部队，为中国革命立下了不朽功勋。</p>', 'https://picsum.photos/800/500?random=501', '县史志办', 'XX县史志研究室', '2024-07-01', 100, 1),
('yxyp', '一县一片', '【一县一片】淮海战役主战场——萧县', '决战决胜的红色热土', '<p>萧县是淮海战役的主战场之一。在这场决定中国命运的大决战中，萧县人民全力支前，谱写了一曲军民鱼水情深的壮丽篇章。</p><p>淮海战役的胜利，靠的是人民群众用小车推出来的。陈毅元帅曾深情地说："淮海战役的胜利，是人民群众用小车推出来的。"</p>', 'https://picsum.photos/800/500?random=502', '文旅局', 'XX县文化和旅游局', '2024-06-20', 95, 1),
('yxyp', '一县一片', '【一县一片】刘邓大军千里跃进大别山纪念地', '逐鹿中原的红色丰碑', '<p>1947年6月30日，刘伯承、邓小平率领晋冀鲁豫野战军主力12万余人，在张秋镇至临濮集地段强渡黄河，揭开了人民解放军战略进攻的序幕。</p><p>千里跃进大别山，是解放战争的一个伟大转折，是历史上一件震动世界的大事。</p>', 'https://picsum.photos/800/500?random=503', '党史研究室', 'XX县委党史研究室', '2024-06-15', 90, 1),
-- 室外线路
('swxl', '室外线路', '【室外线路】"重走长征路"红色徒步一日行', '体验长征艰辛，感悟革命精神', '<p>本次徒步线路全程约15公里，模拟红军长征部分路段。参与者沿着当年红军的行军路线，徒步行走，亲身体验长征路上的艰难险阻。</p><p>活动设置了多个打卡点和任务点，参与者需要在行进中完成党史知识问答、红色歌曲演唱等任务，增强了活动的趣味性和教育意义。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>18-55周岁，身体健康者<br/><strong>装备建议：</strong>舒适运动鞋、防晒用品、充足饮用水</p>', 'https://picsum.photos/800/500?random=601', '户外拓展部', 'XX县红色教育基地', '2024-05-01', 100, 1),
('swxl', '室外线路', '【室外线路】山地自行车红色骑行之旅', '骑游红色路线，倡导绿色出行', '<p>本线路串联县域内多个红色教育基地和美丽乡村示范点，全程约60公里。线路途经多个革命旧址和红色纪念地，让骑行者在运动中接受红色教育。</p><p>沿途设置多个补给点和休息点，提供自行车租赁和维修服务，适合各年龄段骑行爱好者参与。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>16-60周岁，会骑自行车者<br/><strong>装备建议：</strong>自行车（可租赁）、头盔、手套</p>', 'https://picsum.photos/800/500?random=602', '体育中心', 'XX县体育局', '2024-04-15', 95, 1),
('swxl', '室外线路', '【室外线路】红色拓展训练营（2天1夜）', '团队协作，磨砺意志', '<p>本拓展训练营以红色历史为背景，设计了多款红色主题拓展项目：重温入党誓词、穿越封锁线、伤员救护、运送物资、胜利会师等。</p><p>通过模拟革命战争时期的真实场景，让参与者在协作与挑战中感悟革命先辈的奋斗精神，增强团队凝聚力和执行力。</p><p><strong>线路时长：</strong>2天1夜<br/><strong>线路难度：</strong>中低<br/><strong>适合人群：</strong>机关企事业单位团体、学校班级<br/><strong>费用包含：</strong>培训费、场地费、1晚住宿（标间）、3正1早、拓展器材、保险</p>', 'https://picsum.photos/800/500?random=603', '拓展训练基地', 'XX县党员教育培训中心', '2024-03-20', 90, 1);

SET FOREIGN_KEY_CHECKS = 1;
