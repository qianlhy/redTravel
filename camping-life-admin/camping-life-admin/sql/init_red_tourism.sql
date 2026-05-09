-- ============================================================
-- 红色旅游网站 数据库完整初始化脚本
-- 数据库: red_tourism
-- 运行方式: source init_red_tourism.sql  或 手动粘贴执行
-- ============================================================

CREATE DATABASE IF NOT EXISTS red_tourism DEFAULT CHARACTER SET utf8mb4;
USE red_tourism;

-- ============================================================
-- 1. 管理员表 (admin_user)
-- ============================================================
DROP TABLE IF EXISTS admin_user;
CREATE TABLE admin_user (
    id           BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    username     VARCHAR(50) NOT NULL COMMENT '用户名',
    password     VARCHAR(200) NOT NULL COMMENT '密码（BCrypt加密）',
    real_name    VARCHAR(50)  DEFAULT '' COMMENT '真实姓名',
    phone        VARCHAR(20)  DEFAULT '' COMMENT '手机号',
    role         VARCHAR(20)  DEFAULT 'operator' COMMENT '角色：admin-超级管理员, operator-运营人员',
    status       TINYINT      DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    last_login_time DATETIME  DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip   VARCHAR(50) DEFAULT '' COMMENT '最后登录IP',
    create_time  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete    TINYINT      DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ============================================================
-- 2. 轮播图表 (banner_config)
-- ============================================================
DROP TABLE IF EXISTS banner_config;
CREATE TABLE banner_config (
    id           BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    title        VARCHAR(100) NOT NULL COMMENT '轮播图标题',
    image_url    VARCHAR(500) NOT NULL COMMENT '图片URL',
    link_type    VARCHAR(20)  DEFAULT 'None' COMMENT '跳转类型：attraction-景点, route-路线, custom-自定义, None-不跳转',
    link_value   VARCHAR(500) DEFAULT '' COMMENT '跳转值（URL或ID）',
    sort         INT          DEFAULT 0 COMMENT '排序（越大越靠前）',
    status       TINYINT      DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    create_time  DATETIME     DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete    TINYINT      DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    INDEX idx_status_sort (status, sort DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='轮播图配置表';

-- ============================================================
-- 3. 红色景点表 (red_attraction)
-- ============================================================
DROP TABLE IF EXISTS red_attraction;
CREATE TABLE red_attraction (
    id            BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    name          VARCHAR(200)   NOT NULL COMMENT '景点名称',
    cover_image   VARCHAR(500)   DEFAULT '' COMMENT '封面图片URL',
    images        JSON           DEFAULT NULL COMMENT '多图JSON数组',
    province      VARCHAR(50)    DEFAULT '' COMMENT '省份',
    city          VARCHAR(50)    DEFAULT '' COMMENT '城市',
    district      VARCHAR(50)    DEFAULT '' COMMENT '区县',
    address       VARCHAR(300)   DEFAULT '' COMMENT '详细地址',
    latitude      DECIMAL(10,6)  DEFAULT NULL COMMENT '纬度',
    longitude     DECIMAL(11,6)  DEFAULT NULL COMMENT '经度',
    open_time     VARCHAR(100)   DEFAULT '' COMMENT '开放时间',
    ticket_price  DECIMAL(10,2) DEFAULT 0.00 COMMENT '门票价格',
    description   TEXT           COMMENT '景点简介',
    history_story TEXT           COMMENT '历史故事',
    sort          INT            DEFAULT 0 COMMENT '排序',
    status        TINYINT        DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    create_time   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time   DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete     TINYINT        DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    INDEX idx_status_sort (status, sort DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='红色景点表';

-- ============================================================
-- 4. 旅游路线表 (travel_route)
-- ============================================================
DROP TABLE IF EXISTS travel_route;
CREATE TABLE travel_route (
    id              BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    name            VARCHAR(200)    NOT NULL COMMENT '路线名称',
    cover_image     VARCHAR(500)    DEFAULT '' COMMENT '封面图片URL',
    images          JSON            DEFAULT NULL COMMENT '多图JSON数组',
    theme           VARCHAR(50)     DEFAULT '' COMMENT '主题分类',
    duration_days   INT             DEFAULT 1 COMMENT '行程天数',
    group_size      INT             DEFAULT 30 COMMENT '建议人数',
    price           DECIMAL(10,2)   DEFAULT 0.00 COMMENT '价格（元/人）',
    original_price  DECIMAL(10,2)  DEFAULT 0.00 COMMENT '原价',
    summary         VARCHAR(500)    DEFAULT '' COMMENT '路线简介',
    highlights      JSON            DEFAULT NULL COMMENT '路线亮点JSON数组',
    included        JSON            DEFAULT NULL COMMENT '费用包含JSON数组',
    excluded        JSON            DEFAULT NULL COMMENT '费用不含JSON数组',
    tips            TEXT            DEFAULT NULL COMMENT '温馨提示',
    start_location  VARCHAR(200)    DEFAULT '' COMMENT '出发地',
    end_location    VARCHAR(200)    DEFAULT '' COMMENT '目的地',
    meeting_address VARCHAR(300)    DEFAULT '' COMMENT '集合地址',
    meeting_time    VARCHAR(20)     DEFAULT '' COMMENT '集合时间',
    status          TINYINT         DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    sort            INT             DEFAULT 0 COMMENT '排序',
    view_count      INT             DEFAULT 0 COMMENT '浏览量',
    collect_count   INT             DEFAULT 0 COMMENT '收藏量',
    create_time     DATETIME        DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete       TINYINT         DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    INDEX idx_status_sort (status, sort DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='旅游路线表';

-- ============================================================
-- 5. 路线景点关联表 (route_attraction_rel)
-- ============================================================
DROP TABLE IF EXISTS route_attraction_rel;
CREATE TABLE route_attraction_rel (
    id           BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    route_id     BIGINT      NOT NULL COMMENT '路线ID',
    attraction_id BIGINT    NOT NULL COMMENT '景点ID',
    day_index    INT         NOT NULL COMMENT '第几天',
    visit_order  INT         NOT NULL COMMENT '当天第几个景点',
    visit_time   VARCHAR(50) DEFAULT '' COMMENT '参观时段，如 09:00-11:00',
    stay_duration INT        DEFAULT 0 COMMENT '停留时长（分钟）',
    memo         VARCHAR(500) DEFAULT '' COMMENT '备注说明',
    create_time  DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete    TINYINT     DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    INDEX idx_route_id (route_id),
    INDEX idx_attraction_id (attraction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='路线景点关联表';

-- ============================================================
-- 6. 内容模块表 (content_block) — 统一管理六个分类内容
-- 分类编号: zkaju=走看聚, qflz=清风廉政, yffl=与法同行,
--          szxc=数字乡村, yxyp=一县一片, swxl=室外线路
-- ============================================================
DROP TABLE IF EXISTS content_block;
CREATE TABLE content_block (
    id            BIGINT         NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    category      VARCHAR(20)    NOT NULL COMMENT '分类编码: zkaju|qflz|yffl|szxc|yxyp|swxl',
    category_name VARCHAR(50)    NOT NULL COMMENT '分类名称',
    title         VARCHAR(200)   NOT NULL COMMENT '内容标题',
    subtitle      VARCHAR(200)   DEFAULT '' COMMENT '副标题/简介',
    content       TEXT           COMMENT '富文本/详细内容',
    cover_image   VARCHAR(500)   DEFAULT '' COMMENT '封面图片URL',
    images        JSON           DEFAULT NULL COMMENT '多图JSON数组',
    author        VARCHAR(100)   DEFAULT '' COMMENT '作者/来源',
    source        VARCHAR(200)   DEFAULT '' COMMENT '来源单位',
    publish_date  DATE           DEFAULT NULL COMMENT '发布日期',
    view_count    INT            DEFAULT 0 COMMENT '浏览量',
    sort          INT            DEFAULT 0 COMMENT '排序（越大越靠前）',
    status        TINYINT        DEFAULT 1 COMMENT '状态: 0=禁用, 1=启用',
    create_time   DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time   DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete     TINYINT        DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    INDEX idx_category (category),
    INDEX idx_status_sort (status, sort DESC),
    INDEX idx_publish_date (publish_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='内容模块表';

-- ============================================================
-- 7. 团队预约表 (team_booking)
-- ============================================================
DROP TABLE IF EXISTS team_booking;
CREATE TABLE team_booking (
    id              BIGINT        NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    order_no        VARCHAR(32)   NOT NULL COMMENT '订单编号',
    route_id        BIGINT        DEFAULT NULL COMMENT '关联路线ID',
    team_name       VARCHAR(200)  NOT NULL COMMENT '团队名称',
    contact_name    VARCHAR(50)    NOT NULL COMMENT '联系人姓名',
    contact_phone   VARCHAR(20)    NOT NULL COMMENT '联系人手机',
    contact_id_card VARCHAR(20)    DEFAULT '' COMMENT '联系人身份证',
    team_size       INT            NOT NULL COMMENT '团队人数',
    travel_date     DATE           NOT NULL COMMENT '出行日期',
    duration_days   INT            DEFAULT 1 COMMENT '行程天数',
    meeting_address VARCHAR(300)   DEFAULT '' COMMENT '集合地址',
    meeting_time    VARCHAR(20)    DEFAULT '' COMMENT '集合时间',
    remark          TEXT           DEFAULT NULL COMMENT '备注/特殊需求',
    status          TINYINT        DEFAULT 0 COMMENT '状态：0-待确认，1-已确认，2-已拒绝，3-已完成，4-已取消',
    status_remark  VARCHAR(500)    DEFAULT '' COMMENT '状态备注/拒绝原因',
    confirm_time    DATETIME       DEFAULT NULL COMMENT '确认时间',
    create_time     DATETIME       DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME       DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete       TINYINT        DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    INDEX idx_route_id (route_id),
    INDEX idx_status (status),
    INDEX idx_travel_date (travel_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='团队预约表';

-- ============================================================
-- 8. 会员用户表 (member_user)
-- ============================================================
DROP TABLE IF EXISTS member_user;
CREATE TABLE member_user (
    id              BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    openid          VARCHAR(100) DEFAULT '' COMMENT '微信openid',
    unionid         VARCHAR(100) DEFAULT '' COMMENT '微信unionid',
    nickname        VARCHAR(100)  DEFAULT '' COMMENT '昵称',
    avatar          VARCHAR(500)  DEFAULT '' COMMENT '头像URL',
    phone           VARCHAR(20)   DEFAULT '' COMMENT '手机号',
    gender          TINYINT       DEFAULT 0 COMMENT '性别：0-未知，1-男，2-女',
    birthday        DATE          DEFAULT NULL COMMENT '生日',
    province        VARCHAR(50)   DEFAULT '' COMMENT '省份',
    city            VARCHAR(50)   DEFAULT '' COMMENT '城市',
    status          TINYINT       DEFAULT 1 COMMENT '状态：1-正常，0-禁用',
    last_login_time DATETIME     DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip   VARCHAR(50)  DEFAULT '' COMMENT '最后登录IP',
    create_time     DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time     DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete       TINYINT       DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_openid (openid),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='会员用户表';

-- ============================================================
-- 9. 路线收藏表 (route_collect)
-- ============================================================
DROP TABLE IF EXISTS route_collect;
CREATE TABLE route_collect (
    id           BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    user_id      BIGINT      NOT NULL COMMENT '用户ID',
    route_id     BIGINT      NOT NULL COMMENT '路线ID',
    create_time  DATETIME    DEFAULT CURRENT_TIMESTAMP COMMENT '收藏时间',
    update_time  DATETIME    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    is_delete    TINYINT     DEFAULT 0 COMMENT '逻辑删除: 0=未删除, 1=已删除',
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_route (user_id, route_id),
    INDEX idx_route_id (route_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='路线收藏表';

-- ============================================================
-- 10. 系统配置表 (system_config)
-- ============================================================
DROP TABLE IF EXISTS system_config;
CREATE TABLE system_config (
    id           BIGINT      NOT NULL AUTO_INCREMENT COMMENT '主键ID',
    config_key   VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value TEXT          DEFAULT '' COMMENT '配置值',
    config_name  VARCHAR(100)  DEFAULT '' COMMENT '配置名称',
    config_desc  VARCHAR(500)  DEFAULT '' COMMENT '配置描述',
    group_name   VARCHAR(50)   DEFAULT 'default' COMMENT '配置分组',
    sort         INT            DEFAULT 0 COMMENT '排序',
    status       TINYINT        DEFAULT 1 COMMENT '状态：1-启用，0-禁用',
    create_time  DATETIME      DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time  DATETIME      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- ============================================================
-- ===================== 初始数据 ==============================
-- ============================================================

-- 管理员初始账号: admin / 123456（BCrypt加密）
INSERT INTO admin_user (username, password, real_name, phone, role, status, create_time, update_time, is_delete) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt7bX8C', '系统管理员', '13800138000', 'admin', 1, NOW(), NOW(), 0);

-- 轮播图
INSERT INTO banner_config (title, image_url, link_type, link_value, sort, status, create_time, update_time, is_delete) VALUES
('传承红色基因', 'https://picsum.photos/750/400?random=401', 'custom', '', 100, 1, NOW(), NOW(), 0),
('弘扬革命精神', 'https://picsum.photos/750/400?random=402', 'custom', '', 90, 1, NOW(), NOW(), 0),
('走进红色圣地', 'https://picsum.photos/750/400?random=403', 'custom', '', 80, 1, NOW(), NOW(), 0);

-- 红色景点
INSERT INTO red_attraction (name, cover_image, images, province, city, district, address, latitude, longitude, open_time, ticket_price, description, history_story, sort, status, create_time, update_time, is_delete) VALUES
('嘉兴南湖红船', 'https://picsum.photos/800/600?random=101', '["https://picsum.photos/800/600?random=101","https://picsum.photos/800/600?random=102","https://picsum.photos/800/600?random=103"]', '浙江省', '嘉兴市', '南湖区', '南湖路83号', 30.7522, 120.7650, '09:00-17:00', 0.00, '南湖位于浙江省嘉兴市，是中国共产党的诞生地。1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。', '1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。', 100, 1, NOW(), NOW(), 0),
('延安革命纪念馆', 'https://picsum.photos/800/600?random=201', '["https://picsum.photos/800/600?random=201","https://picsum.photos/800/600?random=202"]', '陕西省', '延安市', '宝塔区', '圣地路100号', 36.5853, 109.4898, '08:00-18:00', 0.00, '延安革命纪念馆是全国红色旅游经典景区，全面展示了党中央和毛泽东等老一辈革命家在延安十三年的光辉战斗历程。延安是中国革命圣地，是中国人民解放事业的总后方。', '延安是中国革命圣地。1935年到1948年，中共中央和毛泽东在这里领导了抗日战争和解放战争，培育了伟大的延安精神。这里有枣园、杨家岭、王家坪等众多革命旧址。', 95, 1, NOW(), NOW(), 0),
('井冈山茨坪革命旧址', 'https://picsum.photos/800/600?random=301', '["https://picsum.photos/800/600?random=301","https://picsum.photos/800/600?random=302"]', '江西省', '吉安市', '井冈山市', '茨坪镇', 26.5736, 114.1469, '08:00-17:30', 90.00, '井冈山是中国第一个农村革命根据地，被誉为"革命摇篮"。1927年10月，毛泽东等老一辈革命家在这里创建了第一个农村革命根据地，开辟了"农村包围城市、武装夺取政权"的正确革命道路。', '1927年10月，毛泽东率领秋收起义部队到达井冈山，创建了中国第一个农村革命根据地。1928年4月，朱德、陈毅率领南昌起义余部到达井冈山，与毛泽东胜利会师，组建了中国工农红军第四军。', 90, 1, NOW(), NOW(), 0),
('遵义会议纪念馆', 'https://picsum.photos/800/600?random=401', '["https://picsum.photos/800/600?random=401","https://picsum.photos/800/600?random=402"]', '贵州省', '遵义市', '红花岗区', '子尹路96号', 27.7255, 106.9232, '08:30-17:30', 0.00, '遵义会议纪念馆是全国红色旅游经典景区。1935年1月，中国共产党在遵义召开了中央政治局扩大会议，确立了毛泽东在党中央和红军的领导地位，在最危急关头挽救了党、挽救了红军、挽救了中国革命。', '1935年1月15日至17日，中共中央在遵义召开政治局扩大会议。会议结束了"左"倾教条主义错误，确立了毛泽东在党中央和红军的领导地位，是党的历史上一个生死攸关的转折点。', 85, 1, NOW(), NOW(), 0),
('西柏坡纪念馆', 'https://picsum.photos/800/600?random=501', '["https://picsum.photos/800/600?random=501","https://picsum.photos/800/600?random=502"]', '河北省', '石家庄市', '平山县', '西柏坡镇', 38.2529, 113.9332, '09:00-17:00', 0.00, '西柏坡曾是中共中央和中国人民解放军总部所在地。1948年5月至1949年3月，毛泽东等中央领导在西柏坡指挥了辽沈、淮海、平津三大战役，召开了七届二中全会，为新中国的建立奠定了基础。', '1948年5月，毛泽东率领中共中央机关移驻西柏坡。在此期间，党中央指挥了辽沈、淮海、平津三大战役，召开了具有历史意义的七届二中全会。1949年3月，毛泽东率中央机关离开西柏坡，进京"赶考"。', 80, 1, NOW(), NOW(), 0),
('中国人民革命军事博物馆', 'https://picsum.photos/800/600?random=601', '["https://picsum.photos/800/600?random=601","https://picsum.photos/800/600?random=602"]', '北京市', '北京市', '海淀区', '复兴路9号', 39.9072, 116.3019, '09:00-17:00（周一闭馆）', 0.00, '中国人民革命军事博物馆是中国第一个综合类军事博物馆，是进行爱国主义教育和国防教育的重要基地。收藏了大量珍贵的革命文物和军事史料。', '军事博物馆建于1958年，是向国庆10周年献礼的首都十大建筑之一。馆内收藏了土地革命战争、抗日战争、解放战争、抗美援朝战争等各个时期的珍贵文物。', 75, 1, NOW(), NOW(), 0);

-- 旅游路线
INSERT INTO travel_route (name, cover_image, images, theme, duration_days, group_size, price, original_price, summary, highlights, included, excluded, tips, start_location, end_location, meeting_address, meeting_time, status, sort, view_count, collect_count, create_time, update_time, is_delete) VALUES
('嘉兴南湖红船1日研学游', 'https://picsum.photos/800/500?random=201', '["https://picsum.photos/800/500?random=201","https://picsum.photos/800/500?random=202"]', '红色教育', 1, 30, 168.00, 198.00, '追寻红船足迹，传承建党精神', '["南湖红船精神","重温入党誓词","红色教育基地"]', '["全程正规旅游大巴","景区门票","研学导师讲解","研学手册","团队横幅","旅游意外险"]', '["午餐","个人消费"]', '穿着轻便运动装，携带身份证件，建议提前15分钟到达集合点', '上海人民广场', '嘉兴南湖', '上海市黄浦区人民广场集合', '07:30', 1, 100, 256, 45, NOW(), NOW(), 0),
('延安精神3日深度学习之旅', 'https://picsum.photos/800/500?random=301', '["https://picsum.photos/800/500?random=301","https://picsum.photos/800/500?random=302"]', '红色教育', 3, 25, 980.00, 1180.00, '走进革命圣地，感悟延安精神', '["延安革命纪念馆","枣园旧址","杨家岭革命旧址","宝塔山"]', '["全程正规旅游大巴","2晚酒店住宿（标间）","景区门票","研学导师讲解","3正2早","研学手册","团队横幅","旅游意外险"]', '["个人消费","单房差"]', '穿着轻便运动装，携带身份证件，延安昼夜温差大，请备好外套', '西安北站', '延安', '西安北站出站口集合', '08:00', 1, 95, 189, 32, NOW(), NOW(), 0),
('井冈山红色拓展5日训练营', 'https://picsum.photos/800/500?random=401', '["https://picsum.photos/800/500?random=401","https://picsum.photos/800/500?random=402"]', '历史追溯', 5, 20, 2380.00, 2680.00, '重上井冈山，传承红色基因', '["井冈山革命博物馆","茨坪旧址","黄洋界哨口","挑粮小道"]', '["全程正规旅游大巴","4晚酒店住宿（标间）","景区门票（不含观光车）","拓展教官","4早9正","研学手册","红军服体验","团队横幅","旅游意外险"]', '["个人消费","井冈山观光车85元/人（必须）"]', '身体要求：无心脏病、哮喘等不适合户外运动疾病；建议穿运动鞋，携带雨具', '南昌八一广场', '井冈山', '南昌市东湖区八一广场集合', '07:00', 1, 90, 145, 28, NOW(), NOW(), 0),
('遵义会议1日红色之旅', 'https://picsum.photos/800/500?random=501', '["https://picsum.photos/800/500?random=501","https://picsum.photos/800/500?random=502"]', '革命圣地', 1, 35, 198.00, 238.00, '转折之城，红色遵义', '["遵义会议纪念馆","红军山烈士陵园","娄山关战斗遗址"]', '["全程正规旅游大巴","景区门票","研学导师讲解","午餐","研学手册","团队横幅","旅游意外险"]', '["个人消费"]', '建议穿舒适运动鞋，携带防晒用品', '贵阳市区集合', '遵义', '贵阳市云岩区延安西路集合', '07:30', 1, 85, 98, 15, NOW(), NOW(), 0),
('西柏坡+正定2日红色研学', 'https://picsum.photos/800/500?random=601', '["https://picsum.photos/800/500?random=601","https://picsum.photos/800/500?random=602"]', '红色教育', 2, 30, 458.00, 558.00, '新中国从这里走来', '["西柏坡纪念馆","中共中央旧址","正定古城","塔元庄"]', '["全程正规旅游大巴","1晚酒店住宿","景区门票","研学导师讲解","1早3正","研学手册","团队横幅","旅游意外险"]', '["个人消费","D2午餐"]', '西柏坡景区需提前预约，请配合导游安排', '石家庄市区', '西柏坡', '石家庄市长安区人民广场集合', '07:30', 1, 80, 76, 12, NOW(), NOW(), 0);

-- 路线景点关联
INSERT INTO route_attraction_rel (route_id, attraction_id, day_index, visit_order, visit_time, stay_duration, memo, create_time, update_time, is_delete) VALUES
(1, 1, 1, 1, '09:00-11:00', 120, '参观南湖革命纪念馆，了解建党历史', NOW(), NOW(), 0),
(1, 1, 1, 2, '11:00-12:00', 60, '乘船游南湖，瞻仰红船', NOW(), NOW(), 0),
(1, 1, 1, 3, '13:30-15:00', 90, '重温入党誓词仪式', NOW(), NOW(), 0),
(1, 1, 1, 4, '15:30-16:30', 60, '参观嘉兴子城遗址', NOW(), NOW(), 0),
(2, 2, 1, 1, '14:00-17:00', 180, '抵达后游览延安革命纪念馆', NOW(), NOW(), 0),
(2, 2, 2, 1, '08:00-10:30', 150, '参观枣园旧址', NOW(), NOW(), 0),
(2, 2, 2, 2, '10:30-12:00', 90, '参观杨家岭革命旧址', NOW(), NOW(), 0),
(2, 2, 2, 3, '14:00-16:00', 120, '登宝塔山，俯瞰延安城', NOW(), NOW(), 0),
(2, 2, 3, 1, '08:00-11:00', 180, '参观王家坪革命旧址', NOW(), NOW(), 0),
(2, 2, 3, 2, '11:30-13:00', 90, '延安红色文化体验', NOW(), NOW(), 0),
(3, 3, 1, 1, '12:00-14:00', 120, '抵达井冈山，午餐后游览茨坪镇', NOW(), NOW(), 0),
(3, 3, 2, 1, '08:00-10:30', 150, '参观井冈山革命博物馆', NOW(), NOW(), 0),
(3, 3, 2, 2, '10:30-12:00', 90, '参观茨坪革命旧址群', NOW(), NOW(), 0),
(3, 3, 2, 3, '14:00-17:00', 180, '黄洋界哨口+挑粮小道体验', NOW(), NOW(), 0),
(3, 3, 3, 1, '08:00-12:00', 240, '茅坪八角楼+龙江书院', NOW(), NOW(), 0),
(3, 3, 3, 2, '14:00-17:00', 180, '红色拓展训练活动', NOW(), NOW(), 0),
(4, 4, 1, 1, '09:30-11:30', 120, '参观遵义会议纪念馆', NOW(), NOW(), 0),
(4, 4, 1, 2, '11:30-13:00', 90, '红军山烈士陵园', NOW(), NOW(), 0),
(4, 4, 1, 3, '14:30-17:00', 150, '娄山关战斗遗址', NOW(), NOW(), 0),
(5, 5, 1, 1, '10:00-12:00', 120, '参观西柏坡纪念馆', NOW(), NOW(), 0),
(5, 5, 1, 2, '14:00-17:00', 180, '参观中共中央旧址', NOW(), NOW(), 0),
(5, 5, 2, 1, '08:00-11:00', 180, '正定古城研学', NOW(), NOW(), 0),
(5, 5, 2, 2, '11:30-13:00', 90, '塔元庄村史馆', NOW(), NOW(), 0);

-- 内容模块（六个分类各3条）
INSERT INTO content_block (category, category_name, title, subtitle, content, cover_image, author, source, publish_date, sort, status, create_time) VALUES
-- 走看聚
('zkaju', '走看聚', '【走看聚】追寻红色足迹·走进南湖红船', '重温建党历史，传承红船精神', '<p>南湖位于浙江省嘉兴市，是中国共产党的诞生地。1921年7月，中国共产党第一次全国代表大会在上海秘密召开后，因遭到法租界巡捕袭扰，紧急转移至南湖一艘画舫上继续进行。</p><p>在这只小小的红船上，通过了中国共产党第一个纲领和第一个决议，选举产生了党的领导机构，中国共产党庄严宣告诞生。</p><p>红船精神是中国革命精神之源，习近平总书记概括为"开天辟地、敢为人先的首创精神，坚定理想、百折不挠的奋斗精神，立党为公、忠诚为民的奉献精神"。</p>', 'https://picsum.photos/800/500?random=101', '红色旅游研学组', '嘉兴市文化广电旅游局', '2024-06-01', 100, 1, NOW()),
('zkaju', '走看聚', '【走看聚】延安精神永放光芒', '走进革命圣地，感悟延安精神', '<p>延安革命纪念馆是全国红色旅游经典景区，全面展示了党中央和毛泽东等老一辈革命家在延安十三年的光辉战斗历程。</p><p>延安是中国革命圣地，是中国人民解放事业的总后方。1935年到1948年，中共中央和毛泽东在这里领导了抗日战争和解放战争，培育了伟大的延安精神。</p>', 'https://picsum.photos/800/500?random=102', '研学导师部', '延安市文化和旅游局', '2024-06-05', 95, 1, NOW()),
('zkaju', '走看聚', '【走看聚】井冈山：革命摇篮，星火燎原', '重上井冈山，传承红色基因', '<p>井冈山是中国第一个农村革命根据地，被誉为"革命摇篮"。1927年10月，毛泽东等老一辈革命家在这里创建了第一个农村革命根据地，开辟了"农村包围城市、武装夺取政权"的正确革命道路。</p>', 'https://picsum.photos/800/500?random=103', '红色教育基地', '井冈山管理局', '2024-06-10', 90, 1, NOW()),
-- 清风廉政
('qflz', '清风廉政', '【清风廉政】学习《中国共产党纪律处分条例》', '严守党的纪律，永葆政治本色', '<p>《中国共产党纪律处分条例》是根据《中国共产党章程》制定的党内法规，对维护党的章程、严肃党的纪律、保证党的路线方针政策的贯彻执行发挥着重要作用。</p><p>本次学习重点围绕政治纪律、组织纪律、廉洁纪律、群众纪律、工作纪律、生活纪律"六大纪律"展开，要求全体党员知敬畏、存戒惧、守底线。</p>', 'https://picsum.photos/800/500?random=201', '纪委办公室', '中共XX县纪律检查委员会', '2024-05-20', 100, 1, NOW()),
('qflz', '清风廉政', '【清风廉政】廉政教育基地参观学习活动', '以案为鉴，警钟长鸣', '<p>为深入推进党风廉政建设，筑牢党员干部拒腐防变思想防线，近日组织全体党员干部前往廉政教育基地开展警示教育活动。</p><p>通过观看警示教育展板、聆听典型案例讲解，大家深刻认识到腐败行为对党和国家事业以及家庭、个人的严重危害。</p>', 'https://picsum.photos/800/500?random=202', '党建办', '中共XX镇纪律检查委员会', '2024-05-25', 95, 1, NOW()),
('qflz', '清风廉政', '【清风廉政】党纪学习教育专题党课', '学条例、守纪律、担使命', '<p>开展党纪学习教育，是加强党的纪律建设、推动全面从严治党向纵深发展的重要举措。本次专题党课围绕新修订的《中国共产党纪律处分条例》进行解读。</p>', 'https://picsum.photos/800/500?random=203', '党支部书记', 'XX党支部', '2024-06-01', 90, 1, NOW()),
-- 与法同行
('yffl', '与法同行', '【与法同行】宪法宣传周系列活动纪实', '弘扬宪法精神，建设法治社会', '<p>在国家宪法宣传周期间，各单位积极开展宪法学习宣传活动，通过专题讲座、法治宣传、宪法知识竞赛等多种形式，营造浓厚的学法用法氛围。</p><p>本次活动覆盖机关、学校、社区、企业等多领域，受众人群超过5000人次，有效提升了全民宪法意识和法治素养。</p>', 'https://picsum.photos/800/500?random=301', '普法办', 'XX县司法局', '2024-12-04', 100, 1, NOW()),
('yffl', '与法同行', '【与法同行】民法典进社区宣讲活动', '让民法典走进千家万户', '<p>为深入学习贯彻《中华人民共和国民法典》，进一步提高居民法律意识，县司法局组织法律服务团深入社区开展民法典宣讲活动。</p><p>宣讲内容涵盖婚姻家庭、继承、侵权责任等与群众生活密切相关的法律知识，现场解答群众咨询100余人次。</p>', 'https://picsum.photos/800/500?random=302', '法律服务团', 'XX县司法局', '2024-11-15', 95, 1, NOW()),
('yffl', '与法同行', '【与法同行】预防电信网络诈骗专题讲座', '守住钱袋子，护好幸福家', '<p>针对当前电信网络诈骗高发态势，县公安局联合银行、通信运营商开展防范电信诈骗专题讲座进社区活动。</p><p>通过真实案例分析，揭露常见诈骗手法，提醒居民不轻信、不转账、不汇款，提高防骗识骗能力。</p>', 'https://picsum.photos/800/500?random=303', '反诈中心', 'XX县公安局', '2024-10-20', 90, 1, NOW()),
-- 数字乡村
('szxc', '数字乡村', '【数字乡村】智慧农业助推乡村振兴', '科技赋能农业，农村焕发新活力', '<p>数字乡村建设是乡村振兴战略的重要组成部分。近年来，各地积极推进智慧农业建设，通过物联网、大数据、人工智能等技术手段，提升农业生产效率和农产品质量。</p><p>智能灌溉系统、无人机植保、农产品溯源平台等数字化应用正在改变传统农业生产方式，为农民增收致富开辟了新路径。</p>', 'https://picsum.photos/800/500?random=401', '乡村振兴办', 'XX县农业农村局', '2024-06-10', 100, 1, NOW()),
('szxc', '数字乡村', '【数字乡村】农村电商拓宽致富路', '手机成新农具，直播成新农活', '<p>随着网络基础设施的完善和智能手机的普及，农村电商蓬勃发展，越来越多的农民通过直播带货把家乡的优质农产品卖向全国。</p><p>从田间地头到餐桌，城市消费者可以直接购买到新鲜优质的农产品，实现了生产者和消费者的双赢。</p>', 'https://picsum.photos/800/500?random=402', '电商服务中心', 'XX县商务局', '2024-05-28', 95, 1, NOW()),
('szxc', '数字乡村', '【数字乡村】数字政务服务进乡村', '数据多跑路，群众少跑腿', '<p>数字政务平台向乡村延伸，让村民在家门口就能办理社保、医保、营业执照等多项政务服务，真正实现了"数据多跑路、群众少跑腿"。</p><p>村级便民服务站配备的自助服务终端，可以办理100多项高频民生事项，极大地方便了农村群众。</p>', 'https://picsum.photos/800/500?random=403', '政务服务中心', 'XX县政务服务管理局', '2024-05-15', 90, 1, NOW()),
-- 一县一片
('yxyp', '一县一片', '【一县一片】红二十五军长征出发地——罗山县', '豫南革命老区的红色印记', '<p>罗山县是红二十五军长征出发地。1934年11月16日，红二十五军近3000名将士在罗山县何家冲集结出发，开始了艰苦卓绝的长征。</p><p>红二十五军是长征中平均年龄最轻的一支队伍，也是最先到达陕北的一支红军主力部队，为中国革命立下了不朽功勋。</p>', 'https://picsum.photos/800/500?random=501', '县史志办', 'XX县史志研究室', '2024-07-01', 100, 1, NOW()),
('yxyp', '一县一片', '【一县一片】淮海战役主战场——萧县', '决战决胜的红色热土', '<p>萧县是淮海战役的主战场之一。在这场决定中国命运的大决战中，萧县人民全力支前，谱写了一曲军民鱼水情深的壮丽篇章。</p><p>淮海战役的胜利，靠的是人民群众用小车推出来的。陈毅元帅曾深情地说："淮海战役的胜利，是人民群众用小车推出来的。"</p>', 'https://picsum.photos/800/500?random=502', '文旅局', 'XX县文化和旅游局', '2024-06-20', 95, 1, NOW()),
('yxyp', '一县一片', '【一县一片】刘邓大军千里跃进大别山纪念地', '逐鹿中原的红色丰碑', '<p>1947年6月30日，刘伯承、邓小平率领晋冀鲁豫野战军主力12万余人，在张秋镇至临濮集地段强渡黄河，揭开了人民解放军战略进攻的序幕。</p><p>千里跃进大别山，是解放战争的一个伟大转折，是历史上一件震动世界的大事。</p>', 'https://picsum.photos/800/500?random=503', '党史研究室', 'XX县委党史研究室', '2024-06-15', 90, 1, NOW()),
-- 室外线路
('swxl', '室外线路', '【室外线路】"重走长征路"红色徒步一日行', '体验长征艰辛，感悟革命精神', '<p>本次徒步线路全程约15公里，模拟红军长征部分路段。参与者沿着当年红军的行军路线，徒步行走，亲身体验长征路上的艰难险阻。</p><p>活动设置了多个打卡点和任务点，参与者需要在行进中完成党史知识问答、红色歌曲演唱等任务，增强了活动的趣味性和教育意义。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>18-55周岁，身体健康者<br/><strong>装备建议：</strong>舒适运动鞋、防晒用品、充足饮用水</p>', 'https://picsum.photos/800/500?random=601', '户外拓展部', 'XX县红色教育基地', '2024-05-01', 100, 1, NOW()),
('swxl', '室外线路', '【室外线路】山地自行车红色骑行之旅', '骑游红色路线，倡导绿色出行', '<p>本线路串联县域内多个红色教育基地和美丽乡村示范点，全程约60公里。线路途经多个革命旧址和红色纪念地，让骑行者在运动中接受红色教育。</p><p>沿途设置多个补给点和休息点，提供自行车租赁和维修服务，适合各年龄段骑行爱好者参与。</p><p><strong>线路时长：</strong>1天<br/><strong>线路难度：</strong>中等<br/><strong>适合人群：</strong>16-60周岁，会骑自行车者<br/><strong>装备建议：</strong>自行车（可租赁）、头盔、手套</p>', 'https://picsum.photos/800/500?random=602', '体育中心', 'XX县体育局', '2024-04-15', 95, 1, NOW()),
('swxl', '室外线路', '【室外线路】红色拓展训练营（2天1夜）', '团队协作，磨砺意志', '<p>本拓展训练营以红色历史为背景，设计了多款红色主题拓展项目：重温入党誓词、穿越封锁线、伤员救护、运送物资、胜利会师等。</p><p>通过模拟革命战争时期的真实场景，让参与者在协作与挑战中感悟革命先辈的奋斗精神，增强团队凝聚力和执行力。</p><p><strong>线路时长：</strong>2天1夜<br/><strong>线路难度：</strong>中低<br/><strong>适合人群：</strong>机关企事业单位团体、学校班级<br/><strong>费用包含：</strong>培训费、场地费、1晚住宿（标间）、3正1早、拓展器材、保险</p>', 'https://picsum.photos/800/500?random=603', '拓展训练基地', 'XX县党员教育培训中心', '2024-03-20', 90, 1, NOW());

-- ============================================================
-- 执行完成
-- ============================================================
SELECT 'SQL执行完成，共建表10张，数据已全部导入！' AS message;
