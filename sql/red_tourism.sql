/*
 Navicat Premium Data Transfer

 Source Server         : A-new-start
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : red_tourism

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 10/05/2026 09:26:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin_user
-- ----------------------------
DROP TABLE IF EXISTS `admin_user`;
CREATE TABLE `admin_user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '管理员ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录账号',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（BCrypt加密）',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '真实姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'admin' COMMENT '角色：admin-超级管理员,operator-运营人员',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
  `last_login_time` datetime(0) DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin_user
-- ----------------------------
INSERT INTO `admin_user` VALUES (1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '系统管理员', NULL, 'admin', 1, NULL, NULL, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `admin_user` VALUES (2, 'operator', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', '运营人员', NULL, 'operator', 1, NULL, NULL, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);

-- ----------------------------
-- Table structure for banner_config
-- ----------------------------
DROP TABLE IF EXISTS `banner_config`;
CREATE TABLE `banner_config`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '轮播图ID',
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标题',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '图片URL',
  `link_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转类型：attraction-景点,route-路线,custom-自定义URL,None-不跳转',
  `link_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '跳转值',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '轮播图配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of banner_config
-- ----------------------------
INSERT INTO `banner_config` VALUES (1, '传承红色基因', 'https://picsum.photos/750/400?random=401', 'custom', '', 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `banner_config` VALUES (2, '庆祝建党百年', 'https://picsum.photos/750/400?random=402', 'custom', '', 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `banner_config` VALUES (3, '红色旅游精品路线', 'https://picsum.photos/750/400?random=403', 'route', '1', 80, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);

-- ----------------------------
-- Table structure for content_block
-- ----------------------------
DROP TABLE IF EXISTS `content_block`;
CREATE TABLE `content_block`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类编码: zkaju|qflz|yffl|szxc|yxyp|swxl',
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '分类名称',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '内容标题',
  `subtitle` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '副标题/简介',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '富文本/详细内容',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '封面图片URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '多图JSON数组',
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '作者/来源',
  `source` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源单位',
  `publish_date` date DEFAULT NULL COMMENT '发布日期',
  `view_count` int(11) NOT NULL DEFAULT 0 COMMENT '浏览量',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort`) USING BTREE,
  INDEX `idx_publish_date`(`publish_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '内容模块表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of content_block
-- ----------------------------
INSERT INTO `content_block` VALUES (1, 'zkaju', '走看聚', '【走看聚】追寻红色足迹·走进南湖红船', '重温建党历史，传承红船精神', '<p>南湖位于浙江省嘉兴市，是中国共产党的诞生地。1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。</p><p>在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。</p><p>红船精神是中国革命精神之源，习近平总书记概括为\"开天辟地、敢为人先的首创精神，坚定理想、百折不挠的奋斗精神，立党为公、忠诚为民的奉献精神\"。</p>', 'https://picsum.photos/800/500?random=101', NULL, '红色旅游研学组', '嘉兴市文化广电旅游局', '2024-06-01', 1, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (2, 'zkaju', '走看聚', '【走看聚】延安精神永放光芒', '走进革命圣地，感悟延安精神', '<p>延安革命纪念馆是全国红色旅游经典景区，全面展示了党中央和毛泽东等老一辈革命家在延安十三年的光辉战斗历程。</p><p>延安是中国革命圣地，是中国人民解放事业的总后方。1935年到1948年，中共中央和毛泽东在这里领导了抗日战争和解放战争，培育了伟大的延安精神。</p>', 'https://picsum.photos/800/500?random=102', NULL, '研学导师部', '延安市文化和旅游局', '2024-06-05', 0, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (3, 'zkaju', '走看聚', '【走看聚】井冈山：革命摇篮，星火燎原', '重上井冈山，传承红色基因', '<p>井冈山是中国第一个农村革命根据地，被誉为\"革命摇篮\"。1927年10月，毛泽东等老一辈革命家在这里创建了第一个农村革命根据地，开辟了\"农村包围城市、武装夺取政权\"的正确革命道路。</p>', 'https://picsum.photos/800/500?random=103', NULL, '红色教育基地', '井冈山管理局', '2024-06-10', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (4, 'qflz', '清风廉政', '【清风廉政】学习《中国共产党纪律处分条例》', '严守党的纪律，永葆政治本色', '<p>《中国共产党纪律处分条例》是根据《中国共产党章程》制定的党内法规，对维护党的章程、严肃党的纪律、保证党的路线方针政策的贯彻执行发挥着重要作用。</p><p>本次学习重点围绕政治纪律、组织纪律、廉洁纪律、群众纪律、工作纪律、生活纪律\"六大纪律\"展开，要求全体党员知敬畏、存戒惧、守底线。</p>', 'https://picsum.photos/800/500?random=201', NULL, '纪委办公室', '中共XX县纪律检查委员会', '2024-05-20', 0, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (5, 'qflz', '清风廉政', '【清风廉政】廉政教育基地参观学习活动', '以案为鉴，警钟长鸣', '<p>为深入推进党风廉政建设，筑牢党员干部拒腐防变思想防线，近日组织全体党员干部前往廉政教育基地开展警示教育活动。</p><p>通过观看警示教育展板、聆听典型案例讲解，大家深刻认识到腐败行为对党和国家事业以及家庭、个人的严重危害。</p>', 'https://picsum.photos/800/500?random=202', NULL, '党建办', '中共XX镇纪律检查委员会', '2024-05-25', 0, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (6, 'qflz', '清风廉政', '【清风廉政】党纪学习教育专题党课', '学条例、守纪律、担使命', '<p>开展党纪学习教育，是加强党的纪律建设、推动全面从严治党向纵深发展的重要举措。本次专题党课围绕新修订的《中国共产党纪律处分条例》进行解读。</p>', 'https://picsum.photos/800/500?random=203', NULL, '党支部书记', 'XX党支部', '2024-06-01', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (7, 'yffl', '与法同行', '【与法同行】宪法宣传周系列活动纪实', '弘扬宪法精神，建设法治社会', '<p>在国家宪法宣传周期间，各单位积极开展宪法学习宣传活动，通过专题讲座、法治宣传、宪法知识竞赛等多种形式，营造浓厚的学法用法氛围。</p><p>本次活动覆盖机关、学校、社区、企业等多领域，受众人群超过5000人次，有效提升了全民宪法意识和法治素养。</p>', 'https://picsum.photos/800/500?random=301', NULL, '普法办', 'XX县司法局', '2024-12-04', 0, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (8, 'yffl', '与法同行', '【与法同行】民法典进社区宣讲活动', '让民法典走进千家万户', '<p>为深入学习贯彻《中华人民共和国民法典》，进一步提高居民法律意识，县司法局组织法律服务团深入社区开展民法典宣讲活动。</p><p>宣讲内容涵盖婚姻家庭、继承、侵权责任等与群众生活密切相关的法律知识，现场解答群众咨询100余人次。</p>', 'https://picsum.photos/800/500?random=302', NULL, '法律服务团', 'XX县司法局', '2024-11-15', 0, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (9, 'yffl', '与法同行', '【与法同行】预防电信网络诈骗专题讲座', '守住钱袋子，护好幸福家', '<p>针对当前电信网络诈骗高发态势，县公安局联合银行、通信运营商开展防范电信诈骗专题讲座进社区活动。</p><p>通过真实案例分析，揭露常见诈骗手法，提醒居民不轻信、不转账、不汇款，提高防骗识骗能力。</p>', 'https://picsum.photos/800/500?random=303', NULL, '反诈中心', 'XX县公安局', '2024-10-20', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (10, 'szxc', '数字乡村', '【数字乡村】智慧农业助推乡村振兴', '科技赋能农业，农村焕发新活力', '<p>数字乡村建设是乡村振兴战略的重要组成部分。近年来，各地积极推进智慧农业建设，通过物联网、大数据、人工智能等技术手段，提升农业生产效率和农产品质量。</p><p>智能灌溉系统、无人机植保、农产品溯源平台等数字化应用正在改变传统农业生产方式，为农民增收致富开辟了新路径。</p>', 'https://picsum.photos/800/500?random=401', NULL, '乡村振兴办', 'XX县农业农村局', '2024-06-10', 0, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (11, 'szxc', '数字乡村', '【数字乡村】农村电商拓宽致富路', '手机成新农具，直播成新农活', '<p>随着网络基础设施的完善和智能手机的普及，农村电商蓬勃发展，越来越多的农民通过直播带货把家乡的优质农产品卖向全国。</p><p>从田间地头到餐桌，城市消费者可以直接购买到新鲜优质的农产品，实现了生产者和消费者的双赢。</p>', 'https://picsum.photos/800/500?random=402', NULL, '电商服务中心', 'XX县商务局', '2024-05-28', 1, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (12, 'szxc', '数字乡村', '【数字乡村】数字政务服务进乡村', '数据多跑路，群众少跑腿', '<p>数字政务平台向乡村延伸，让村民在家门口就能办理社保、医保、营业执照等多项政务服务，真正实现了\"数据多跑路、群众少跑腿\"。</p><p>村级便民服务站配备的自助服务终端，可以办理100多项高频民生事项，极大地方便了农村群众。</p>', 'https://picsum.photos/800/500?random=403', NULL, '政务服务中心', 'XX县政务服务管理局', '2024-05-15', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (13, 'yxyp', '一县一片', '【一县一片】红二十五军长征出发地——罗山县', '豫南革命老区的红色印记', '<p>罗山县是红二十五军长征出发地。1934年11月16日，红二十五军近3000名将士在罗山县何家冲集结出发，开始了艰苦卓绝的长征。</p><p>红二十五军是长征中平均年龄最轻的一支队伍，也是最先到达陕北的一支红军主力部队，为中国革命立下了不朽功勋。</p>', 'https://picsum.photos/800/500?random=501', NULL, '县史志办', 'XX县史志研究室', '2024-07-01', 0, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (14, 'yxyp', '一县一片', '【一县一片】淮海战役主战场——萧县', '决战决胜的红色热土', '<p>萧县是淮海战役的主战场之一。在这场决定中国命运的大决战中，萧县人民全力支前，谱写了一曲军民鱼水情深的壮丽篇章。</p><p>淮海战役的胜利，靠的是人民群众用小车推出来的。陈毅元帅曾深情地说：\"淮海战役的胜利，是人民群众用小车推出来的。\"</p>', 'https://picsum.photos/800/500?random=502', NULL, '文旅局', 'XX县文化和旅游局', '2024-06-20', 0, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (15, 'yxyp', '一县一片', '【一县一片】刘邓大军千里跃进大别山纪念地', '逐鹿中原的红色丰碑', '<p>1947年6月30日，刘伯承、邓小平率领晋冀鲁豫野战军主力12万余人，在张秋镇至临濮集地段强渡黄河，揭开了人民解放军战略进攻的序幕。</p><p>千里跃进大别山，是解放战争的一个伟大转折，是历史上一件震动世界的大事。</p>', 'https://picsum.photos/800/500?random=503', NULL, '党史研究室', 'XX县委党史研究室', '2024-06-15', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (16, 'swxl', '室外线路', '【室外线路】\"重走长征路\"红色徒步一日行', '体验长征艰辛，感悟革命精神', '<p>本次徒步线路全程约15公里，模拟红军长征部分路段。参与者沿着当年红军的行军路线，徒步行走，亲身体验长征路上的艰难险阻。</p><p>活动设置了多个打卡点和任务点，参与者需要在行进中完成党史知识问答、红色歌曲演唱等任务，增强了活动的趣味性和教育意义。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>18-55周岁，身体健康者<br/><strong>装备建议：</strong>舒适运动鞋、防晒用品、充足饮用水</p>', 'https://picsum.photos/800/500?random=601', NULL, '户外拓展部', 'XX县红色教育基地', '2024-05-01', 0, 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (17, 'swxl', '室外线路', '【室外线路】山地自行车红色骑行之旅', '骑游红色路线，倡导绿色出行', '<p>本线路串联县域内多个红色教育基地和美丽乡村示范点，全程约60公里。线路途经多个革命旧址和红色纪念地，让骑行者在运动中接受红色教育。</p><p>沿途设置多个补给点和休息点，提供自行车租赁和维修服务，适合各年龄段骑行爱好者参与。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>16-60周岁，会骑自行车者<br/><strong>装备建议：</strong>自行车（可租赁）、头盔、手套</p>', 'https://picsum.photos/800/500?random=602', NULL, '体育中心', 'XX县体育局', '2024-04-15', 0, 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (18, 'swxl', '室外线路', '【室外线路】红色拓展训练营（2天1夜）', '团队协作，磨砺意志', '<p>本拓展训练营以红色历史为背景，设计了多款红色主题拓展项目：重温入党誓词、穿越封锁线、伤员救护、运送物资、胜利会师等。</p><p>通过模拟革命战争时期的真实场景，让参与者在协作与挑战中感悟革命先辈的奋斗精神，增强团队凝聚力和执行力。</p><p><strong>线路时长：</strong>2天1夜<br/><strong>线路难度：</strong>中低<br/><strong>适合人群：</strong>机关企事业单位团体、学校班级<br/><strong>费用包含：</strong>培训费、场地费、1晚住宿（标间）、3正1早、拓展器材、保险</p>', 'https://picsum.photos/800/500?random=603', NULL, '拓展训练基地', 'XX县党员教育培训中心', '2024-03-20', 0, 90, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `content_block` VALUES (19, 'zkaju', '走看聚', '红色党建张家港线', '', '“海棠益家”实境课堂位于张家港市乐余镇永利村党史学习教育沉浸式体验园内，面积约2000平方米，阵地采用开放式建筑布局，以“互动、共享、融合、创新”为核心理念，百年党史奋斗篇、档案忆空间、文化四合院等板块自然衔接。结合“永利开心农场”,将红色文化与自然田园风光相结合，形成党史学习教育沉浸式体验项目，通过互动体验提升学习成效。\n\n张家港市家风教育基地\n\n张家港家风教育基地由杨氏孝坊、碑苑、榜眼府三处古建筑组成，是以“注重家庭、注重家教、注重家风”为主旨的廉政教育馆，集家风教育、文旅体验、文史研习、文明实践等功能于一体，主要展示以恬庄杨氏家风为典型的地方优秀家风，以古鉴今，由家及国，旨在让广大党员干部和市民传承中华家风，积极开展新时代家风建设，以良好家风涵养清风正气，共塑家风正、民风淳、政风清、党风端的社会主义文明新风尚。\n\n \n\n备注：行程时间仅供参考，可根据客户需求相应调整（提前预约），具体以当天实际情况为准。', '', NULL, '', '', NULL, 1, 0, 1, '2026-05-09 22:36:20', '2026-05-09 22:36:20', 0);

-- ----------------------------
-- Table structure for member_user
-- ----------------------------
DROP TABLE IF EXISTS `member_user`;
CREATE TABLE `member_user`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '微信OpenID',
  `unionid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '微信UnionID',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '头像URL',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '手机号',
  `gender` tinyint(4) DEFAULT 0 COMMENT '性别：0-未知，1-男，2-女',
  `birthday` date DEFAULT NULL COMMENT '生日',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '城市',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
  `last_login_time` datetime(0) DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后登录IP',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid`) USING BTREE,
  UNIQUE INDEX `uk_unionid`(`unionid`) USING BTREE,
  UNIQUE INDEX `uk_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '会员用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of member_user
-- ----------------------------
INSERT INTO `member_user` VALUES (1, 'oTest001_xxxxxxxxx', NULL, '红色游客001', 'https://picsum.photos/200/200?random=301', '13800138001', 1, NULL, '上海市', '上海市', 1, NULL, NULL, '2025-01-05 10:00:00', '2026-05-09 22:36:13', 0);
INSERT INTO `member_user` VALUES (2, 'oTest002_xxxxxxxxx', NULL, '延安精神传承者', 'https://picsum.photos/200/200?random=302', '13900139002', 2, NULL, '陕西省', '西安市', 1, NULL, NULL, '2025-01-06 11:30:00', '2026-05-09 22:36:13', 0);
INSERT INTO `member_user` VALUES (3, 'oTest003_xxxxxxxxx', NULL, '红船后辈', 'https://picsum.photos/200/200?random=303', '13700137003', 1, NULL, '浙江省', '杭州市', 1, NULL, NULL, '2025-01-07 09:00:00', '2026-05-09 22:36:13', 0);

-- ----------------------------
-- Table structure for red_attraction
-- ----------------------------
DROP TABLE IF EXISTS `red_attraction`;
CREATE TABLE `red_attraction`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '景点名称',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '封面图片URL',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '图片JSON数组',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '城市',
  `district` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '区县',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `latitude` decimal(10, 6) DEFAULT NULL COMMENT '纬度',
  `longitude` decimal(10, 6) DEFAULT NULL COMMENT '经度',
  `open_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '开放时间',
  `ticket_price` decimal(10, 2) DEFAULT 0.00 COMMENT '门票价格',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '景点简介',
  `history_story` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '红色历史故事',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_province_city`(`province`, `city`) USING BTREE,
  INDEX `idx_sort_status`(`sort`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '红色景点表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of red_attraction
-- ----------------------------
INSERT INTO `red_attraction` VALUES (1, '嘉兴南湖红船', 'https://picsum.photos/800/400?random=101', NULL, '浙江省', '嘉兴市', '南湖区', '南湖路83号', NULL, NULL, '09:00-17:00', 0.00, '中国共产党第一次全国代表大会在这里胜利闭幕，中国共产党宣告诞生。', '1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，转移至南湖一艘画舫上继续进行，并在这里诞生了中国共产党第一个纲领和第一个决议，宣告了中国共产党的成立。', 100, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `red_attraction` VALUES (2, '延安革命纪念馆', 'https://picsum.photos/800/400?random=102', NULL, '陕西省', '延安市', '宝塔区', '延河北路58号', NULL, NULL, '08:00-18:00', 0.00, '全面系统地展示了党中央和毛泽东等老一辈革命家在延安领导中国革命的丰功伟绩。', '延安是中国革命的圣地，从1935年到1948年，毛泽东等老一辈无产阶级革命家在这里生活和战斗了13个春秋，领导了抗日战争和解放战争，培育了永放光芒的延安精神。', 99, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `red_attraction` VALUES (3, '井冈山茨坪革命旧址', 'https://picsum.photos/800/400?random=103', NULL, '江西省', '吉安市', '井冈山市', '茨坪镇红军路', NULL, NULL, '08:00-17:30', 90.00, '中国第一个农村革命根据地的中心，这里保存着大量的革命旧址和珍贵文物。', '1927年10月，毛泽东率领秋收起义部队来到井冈山，创建了中国第一个农村革命根据地，开辟了农村包围城市、武装夺取政权的革命道路。', 98, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `red_attraction` VALUES (4, '遵义会议纪念馆', 'https://picsum.photos/800/400?random=104', NULL, '贵州省', '遵义市', '红花岗区', '子尹路96号', NULL, NULL, '08:30-17:30', 0.00, '1935年1月，中国共产党在这里召开了著名的遵义会议。', '1935年1月15日至17日，中共中央政治局在遵义召开了扩大会议，结束了左倾教条主义错误在中央的统治，确立了毛泽东在红军和党中央的领导地位，在危急关头挽救了党、挽救了红军、挽救了中国革命。', 97, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `red_attraction` VALUES (5, '西柏坡革命圣地', 'https://picsum.photos/800/400?random=105', NULL, '河北省', '石家庄市', '平山县', '西柏坡镇', NULL, NULL, '09:00-17:00', 0.00, '解放战争后期中共中央和中国人民解放军总部所在地。', '1948年5月至1949年3月，毛泽东、朱德、刘少奇、周恩来、任弼时等老一辈革命家在西柏坡指挥了辽沈、淮海、平津三大战役，召开了党的七届二中全会，描绘了新中国的宏伟蓝图。', 96, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `red_attraction` VALUES (6, '天安门广场人民英雄纪念碑', 'https://picsum.photos/800/400?random=106', NULL, '北京市', '北京市', '东城区', '天安门广场内', NULL, NULL, '05:00-22:00', 0.00, '世界上最大的城市广场，是中华人民共和国的心脏。', '人民英雄纪念碑位于天安门广场中央，是为了纪念近代以来为中国人民解放事业牺牲的英雄们而建立的。1949年9月30日，毛泽东主席亲自为纪念碑奠基并题词人民英雄永垂不朽。', 95, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);

-- ----------------------------
-- Table structure for route_attraction_rel
-- ----------------------------
DROP TABLE IF EXISTS `route_attraction_rel`;
CREATE TABLE `route_attraction_rel`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `route_id` bigint(20) UNSIGNED NOT NULL COMMENT '路线ID',
  `attraction_id` bigint(20) UNSIGNED NOT NULL COMMENT '景点ID',
  `day_index` int(11) NOT NULL DEFAULT 1 COMMENT '第几天',
  `visit_order` int(11) NOT NULL DEFAULT 1 COMMENT '当天第几个景点',
  `visit_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '参观时段（如：09:00-11:30）',
  `stay_duration` int(11) DEFAULT NULL COMMENT '停留时长（分钟）',
  `memo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注说明',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_route_id`(`route_id`) USING BTREE,
  INDEX `idx_attraction_id`(`attraction_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '路线景点关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of route_attraction_rel
-- ----------------------------
INSERT INTO `route_attraction_rel` VALUES (1, 1, 1, 1, 1, '09:00-11:30', 150, '瞻仰红船，重温入党誓词', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (2, 1, 2, 1, 2, '13:00-16:00', 180, '参观纪念馆，聆听革命历史', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (3, 2, 2, 1, 1, '09:00-12:00', 180, '抵达延安，参观革命纪念馆', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (4, 2, 2, 2, 2, '14:00-17:00', 180, '枣园、杨家岭旧址探访', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (5, 2, 2, 3, 3, '19:00-21:00', 120, '观看红色演出', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (6, 2, 2, 1, 4, '08:30-10:30', 120, '宝塔山主题党课，重温入党誓词', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (7, 3, 3, 1, 1, '10:00-12:00', 120, '抵达茨坪，革命传统教育', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (8, 3, 3, 2, 2, '13:00-16:00', 180, '八角楼现场教学', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (9, 3, 3, 3, 3, '08:30-11:30', 180, '黄洋界哨口遗址徒步', '2026-05-09 22:36:13');
INSERT INTO `route_attraction_rel` VALUES (10, 3, 3, 4, 4, '14:00-16:00', 120, '井冈山革命博物馆', '2026-05-09 22:36:13');

-- ----------------------------
-- Table structure for route_collect
-- ----------------------------
DROP TABLE IF EXISTS `route_collect`;
CREATE TABLE `route_collect`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint(20) UNSIGNED NOT NULL COMMENT '用户ID',
  `route_id` bigint(20) UNSIGNED NOT NULL COMMENT '路线ID',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_route`(`user_id`, `route_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_route_id`(`route_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '路线收藏表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of route_collect
-- ----------------------------
INSERT INTO `route_collect` VALUES (1, 1, 1, '2025-01-06 14:00:00');
INSERT INTO `route_collect` VALUES (2, 1, 2, '2025-01-07 10:30:00');
INSERT INTO `route_collect` VALUES (3, 2, 3, '2025-01-07 16:00:00');
INSERT INTO `route_collect` VALUES (4, 3, 1, '2025-01-08 08:00:00');

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '配置值',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置名称',
  `config_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '配置描述',
  `group_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'default' COMMENT '配置分组',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES (1, 'site_name', '红色旅游小网站', '网站名称', '显示在页面标题等位置', 'base', 1, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13');
INSERT INTO `system_config` VALUES (2, 'site_logo', 'https://picsum.photos/200/200?random=501', '网站Logo', '网站Logo图片地址', 'base', 2, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13');
INSERT INTO `system_config` VALUES (3, 'contact_phone', '400-888-9999', '客服电话', '显示在底部或联系页面', 'contact', 1, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13');
INSERT INTO `system_config` VALUES (4, 'contact_wechat', 'redtourism2025', '微信公众号', '微信公众号名称或二维码', 'contact', 2, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13');
INSERT INTO `system_config` VALUES (5, 'about_us', '红色旅游小网站致力于传播红色文化，传承革命精神，为用户提供优质的红色旅游服务和研学体验。', '关于我们', '网站底部关于我们的内容', 'content', 1, 1, '2026-05-09 22:36:13', '2026-05-09 22:36:13');

-- ----------------------------
-- Table structure for team_booking
-- ----------------------------
DROP TABLE IF EXISTS `team_booking`;
CREATE TABLE `team_booking`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '预约ID',
  `order_no` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '订单编号',
  `route_id` bigint(20) UNSIGNED DEFAULT NULL COMMENT '预约路线ID',
  `team_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '团队名称',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系人手机',
  `contact_id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系人身份证号',
  `team_size` int(11) NOT NULL COMMENT '团队人数',
  `travel_date` date DEFAULT NULL COMMENT '计划出行日期',
  `duration_days` int(11) DEFAULT NULL COMMENT '行程天数',
  `meeting_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集合地点',
  `meeting_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集合时间',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '备注/特殊需求',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '状态：0-待确认，1-已确认，2-已拒绝，3-已完成，4-已取消',
  `status_remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '状态变更说明',
  `confirm_time` datetime(0) DEFAULT NULL COMMENT '确认时间',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '下单时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no`) USING BTREE,
  INDEX `idx_route_id`(`route_id`) USING BTREE,
  INDEX `idx_contact_phone`(`contact_phone`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_travel_date`(`travel_date`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '团队预约表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of team_booking
-- ----------------------------
INSERT INTO `team_booking` VALUES (1, 'TB20250107001', 1, '浙江工业大学马克思主义学院党支部', '张建国', '13800138001', '330101197501011234', 28, '2025-02-15', 1, '上海市人民广场博物馆西大门（武胜路）', '07:30', '请安排一名随团医护人员', 1, NULL, NULL, '2025-01-07 09:30:00', '2026-05-09 22:36:13', 0);
INSERT INTO `team_booking` VALUES (2, 'TB20250107002', 2, '华为技术有限公司华东党支部', '李明华', '13900139002', '310101198003021567', 22, '2025-02-20', 3, '西安北站南广场集合', '08:00', '团队成员多为党员，请安排专题党课', 0, NULL, NULL, '2025-01-07 14:22:00', '2026-05-09 22:36:13', 0);
INSERT INTO `team_booking` VALUES (3, 'TB20250108001', 3, '复旦大学历史系教职工党支部', '王芳', '13700137003', '310101198506151890', 18, '2025-03-01', 5, '南昌八一广场纪念塔下', '07:00', '需全程安排党史讲解，请提供扩音设备', 3, NULL, NULL, '2025-01-08 10:15:00', '2026-05-09 22:36:13', 0);
INSERT INTO `team_booking` VALUES (4, 'TB20250108002', 1, '杭州中学团委学生会', '刘小红', '13600136004', '330102199002121345', 35, '2025-03-05', 1, '杭州市西湖断桥残雪集合点', '07:00', '学生为主，请注意行程安全', 2, NULL, NULL, '2025-01-08 16:40:00', '2026-05-09 22:36:13', 0);
INSERT INTO `team_booking` VALUES (5, 'TB20250109001', 2, '中国银行上海分行党委', '陈海燕', '13500135005', '310115198812030456', 25, '2025-03-08', 3, '中国银行上海分行大楼前', '07:30', '提供大巴车牌号及司机联系方式', 1, NULL, NULL, '2025-01-09 08:55:00', '2026-05-09 22:36:13', 0);

-- ----------------------------
-- Table structure for travel_route
-- ----------------------------
DROP TABLE IF EXISTS `travel_route`;
CREATE TABLE `travel_route`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '路线ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '路线名称',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '封面图片',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '图片JSON数组',
  `theme` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '主题（红色教育/历史追溯/研学旅行）',
  `duration_days` int(11) NOT NULL DEFAULT 1 COMMENT '行程天数',
  `group_size` int(11) DEFAULT NULL COMMENT '建议人数',
  `price` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '价格（元/人）',
  `original_price` decimal(10, 2) DEFAULT NULL COMMENT '原价',
  `summary` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '路线简介',
  `highlights` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '路线亮点（JSON数组）',
  `included` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '费用包含（JSON数组）',
  `excluded` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '费用不含（JSON数组）',
  `tips` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT '温馨提示',
  `start_location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '出发地',
  `end_location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '目的地',
  `meeting_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集合地点',
  `meeting_time` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '集合时间',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：1-上架，0-下架',
  `sort` int(11) NOT NULL DEFAULT 0 COMMENT '排序',
  `view_count` int(11) NOT NULL DEFAULT 0 COMMENT '浏览次数',
  `collect_count` int(11) NOT NULL DEFAULT 0 COMMENT '收藏次数',
  `create_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `is_delete` tinyint(4) NOT NULL DEFAULT 0 COMMENT '逻辑删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status_sort`(`status`, `sort`) USING BTREE,
  INDEX `idx_theme`(`theme`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '旅游路线表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of travel_route
-- ----------------------------
INSERT INTO `travel_route` VALUES (1, '嘉兴南湖红船1日研学游', 'https://picsum.photos/800/400?random=201', NULL, '红色教育', 1, 30, 168.00, 198.00, '探访中国共产党诞生地，重温入党誓词，感受红船精神。', '[\"瞻仰南湖红船\",\"重温入党誓词\",\"参观南湖革命纪念馆\",\"红船精神专题讲座\"]', '[\"全程正规旅游大巴\",\"景区门票\",\"研学导师讲解\",\"午餐\",\"研学手册\",\"团队横幅\",\"旅游意外险\"]', '[\"个人消费\",\"私人开销\",\"纪念品购买\"]', '穿着轻便运动装，携带身份证件，建议提前15分钟到达集合点', '上海人民广场', '嘉兴南湖', '上海市人民广场博物馆西大门（武胜路）', '07:30', 1, 100, 0, 0, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `travel_route` VALUES (2, '延安精神3日深度学习之旅', 'https://picsum.photos/800/400?random=202', NULL, '红色教育', 3, 25, 980.00, 1280.00, '走进革命圣地延安，深入学习延安精神，传承红色基因。', '[\"延安革命纪念馆深度参观\",\"枣园、杨家岭旧址探访\",\"观看《延安保育院》演出\",\"宝塔山主题党课\",\"与老红军后代面对面交流\"]', '[\"全程大巴交通\",\"准四星酒店2晚住宿\",\"全程用餐（2早5正）\",\"景区门票及讲解\",\"专题党课费用\",\"旅游意外险\"]', '[\"单房差\",\"个人消费\",\"纪念品\"]', '携带党史学习笔记本，着正装或深色服装，注意高原气候变化', '西安北站', '延安', '西安北站南广场集合', '08:00', 1, 99, 0, 0, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);
INSERT INTO `travel_route` VALUES (3, '井冈山红色拓展5日训练营', 'https://picsum.photos/800/400?random=203', NULL, '历史追溯', 5, 20, 2380.00, 2680.00, '重走红军路，体验革命艰辛，锤炼党性修养。', '[\"黄洋界哨口遗址\",\"八角楼现场教学\",\"红军挑粮小道徒步\",\"井冈山革命博物馆\",\"篝火晚会红歌会\"]', '[\"全程交通（空调大巴）\",\"农家乐及酒店住宿4晚\",\"全程用餐（4早9正）\",\"景区门票\",\"拓展训练器材\",\"专业教官及讲解\",\"人身意外险\"]', '[\"个人消费\",\"行程外费用\",\"单房差\"]', '准备登山或徒步装备，带好常用药品，行程强度较大请根据身体状况报名', '南昌八一广场', '井冈山', '南昌八一广场纪念塔下', '07:00', 1, 98, 0, 0, '2026-05-09 22:36:13', '2026-05-09 22:36:13', 0);

SET FOREIGN_KEY_CHECKS = 1;
