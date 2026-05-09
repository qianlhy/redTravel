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

SET FOREIGN_KEY_CHECKS = 1;
