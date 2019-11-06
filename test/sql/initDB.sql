
-- USE master
-- 如果数据库存在则删除

DROP DATABASE IF EXISTS ChenAnDB;

-- 创建数据库 默认字符集utf8 默认数据库校对规则utf8_bin（区分大小写校对）
CREATE DATABASE ChenAnDB DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;

USE ChenAnDB;

-- 创建产品表
DROP TABLE IF EXISTS ChenAnDB_goods;
CREATE TABLE ChenAnDB_goods
(
  -- 产品编号，产品唯一标识，主键
  sku INT NOT NULL AUTO_INCREMENT,
  -- 产品名称
  goods_name TEXT NOT NULL,
  -- 产品描述
  pro_desc TEXT NULL,
  -- 产品视频
  video TEXT NULL,
  -- 产品图片，数组 用分号分割
  images MEDIUMTEXT NULL,
  -- 产品分类 category表外键
  category_id VARCHAR(80) NOT NULL,
  -- 数据抓取时间
  catch_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- 原价
  owner_price FLOAT NOT NULL,
  -- 售价
  sale_price FLOAT NOT NULL,
  -- 代理商价格
  agent_price FLOAT NOT NULL,
  -- 置顶等级，产品排序
  top_level TINYINT(10) DEFAULT 0,
  -- 显示等级，全显示：2； 仅root可见：0； 仅代理商可见：1；
  show_level TINYINT(10) DEFAULT 0,
  -- 抓取时获取的产品ID，用以标识爬虫结束匹配
  owner_goods_id VARCHAR(80) NOT NULL,
  -- 抓取之前的原始数据中更新的时间
  owner_server_time TIMESTAMP NOT NULL,
  -- 跳转到原始数据的产品链接
  out_jump_link TEXT NULL,
  -- 原数据中所属花农的id，花农表外键
  owner_shop_id VARCHAR(80) NOT NULL,
  PRIMARY KEY(`sku`)
) ENGINE = InnoDB AUTO_INCREMENT=1000000;

-- 创建产品分类表
DROP TABLE IF EXISTS ChenAnDB_category;
CREATE TABLE ChenAnDB_category
(
  -- 产品编号，UUID，产品唯一标识，主键
  id VARCHAR(50) NOT NULL,
  category_name VARCHAR(50) NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time TIMESTAMP NULL,
  PRIMARY KEY(`id`)
) ENGINE = InnoDB;

-- 创建原始数据拥有者表（如微商原店铺数据）
DROP TABLE IF EXISTS ChenAnDB_owner_shop;
CREATE TABLE ChenAnDB_owner_shop
(
  -- 继承于原始数据的id
  shop_id VARCHAR(50) NOT NULL,
  shop_name VARCHAR(50) NOT NULL,
  -- 抓取的数据来源于哪个app
  source VARCHAR(50) NOT NULL,
  shop_icon TEXT NULL,
  -- 哪个账号抓取的数据
  under_account VARCHAR(50) NOT NULL,
  -- 店铺链接
  shop_url TEXT NULL,
  -- 产品总数
  goods_count INT DEFAULT 0,
  -- 上新产品总数
  new_goods_count INT DEFAULT 0,
  -- 店铺当前状态 0: 失效 1：有效
  shop_status TINYINT(2) DEFAULT 1,
  PRIMARY KEY(`shop_id`)
)ENGINE = InnoDB;

-- 订单信息表
DROP TABLE IF EXISTS ChenAnDB_orde_info;
CREATE TABLE ChenAnDB_orde_info
(
  -- UUID 主键
  order_id VARCHAR(50) NOT NULL,
  -- 所属顾客
  customer_id BIGINT NOT NULL,
  -- 所属店铺 外键
  shop_id VARCHAR(50) NOT NULL,
  -- 所属代理商
  agent_id INT NULL,
  -- 地址id
  address_id VARCHAR(50) NOT NULL,
  -- 商品总额
  goods_total INT NOT NULL,
  -- 运费
  freight INT DEFAULT 0,
  -- 应付金额
  payment_total INT NOT NULL,
  -- 创建时间
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- 支付方式
  payment_way INT NULL,
  payment_time VARCHAR(50) NULL,
  order_status INT NOT NULL,
  PRIMARY KEY(`order_id`)
)ENGINE = InnoDB;

-- 订单商品信息表
DROP TABLE IF EXISTS ChenAnDB_orde_goods;
CREATE TABLE ChenAnDB_orde_goods
(
  -- UUID 主键
  order_id VARCHAR(50) NOT NULL,
  -- 产品
  sku INT NOT NULL,
  -- 商品信息
  goods_name TEXT NOT NULL,
  -- 此订单中该商品数量
  goods_count INT NOT NULL,
  -- 此订单中该项产品下单总额
  goods_price INT NOT NULL,
  -- 商品所属shop_id
  shop_id VARCHAR(50) NOT NULL
) ENGINE = InnoDB;

-- 支付方式映射
DROP TABLE IF EXISTS ChenAnDB_payment_way_mapping;
CREATE TABLE ChenAnDB_payment_way_mapping
(
  payment_way_id INT NOT NULL,
  payment_way_desc VARCHAR(20) NOT NULL
) ENGINE = InnoDB;

INSERT INTO ChenAnDB_payment_way_mapping
  (payment_way_id, payment_way_desc)
VALUES
  (1000, '支付宝'),
  (1001, '微信'),
  (1002, '银行卡');


-- 订单状态映射
DROP TABLE IF EXISTS ChenAnDB_order_status_mapping;
CREATE TABLE ChenAnDB_order_status_mapping
(
  order_status_id INT NOT NULL,
  order_status_desc VARCHAR(20) NOT NULL
) ENGINE = InnoDB;

INSERT INTO ChenAnDB_order_status_mapping
  (order_status_id, order_status_desc)
VALUES
  (10100, '待付款'),
  (10200, '已付款'),
  (10300, '待发货'),
  (10400, '已发货'),
  (10500, '已收货'),
  (9000, '退单');


-- address 表
DROP TABLE IF EXISTS ChenAnDB_address;
CREATE TABLE ChenAnDB_address
(
  province_id INT NOT NULL,
  province_name VARCHAR(20) NOT NULL,
  city_id INT NOT NULL,
  city_name VARCHAR(20) NOT NULL,
  county_id INT NOT NULL,
  county_name VARCHAR(20) NOT NULL,
  detail VARCHAR(255) NOT NULL,
  contact VARCHAR(20) NOT NULL,
  receiver VARCHAR(50) NOT NULL,
  customer_id BIGINT NOT NULL,
  address_id VARCHAR(50) NOT NULL,
  PRIMARY KEY(`address_id`)
) ENGINE = InnoDB;

-- 省市县 表
DROP TABLE IF EXISTS pub_address_inf;
CREATE TABLE pub_address_inf
(
  ADD_ID VARCHAR(80) NOT NULL,
  ADD_CODE VARCHAR(80) NOT NULL,
  ADD_NAME VARCHAR(80) NOT NULL,
  ADD_CITYCODE VARCHAR(80) NOT NULL,
  PRIMARY KEY(`ADD_ID`)
) ENGINE = InnoDB;

-- 物流表
DROP TABLE IF EXISTS ChenAnDB_order_logistics;
CREATE TABLE ChenAnDB_order_logistics
(
  order_id VARCHAR(50) NOT NULL,
  logistics_company_id VARCHAR(80) NULL,
  logistics_id VARCHAR(80) NOT NULL,
  delivery_time TIMESTAMP NULL,
  arrival_time TIMESTAMP NULL,
  PRIMARY KEY(`logistics_id`)
) ENGINE = InnoDB;

-- 物流追踪表
DROP TABLE IF EXISTS ChenAnDB_order_logistics_flow;
CREATE TABLE ChenAnDB_order_logistics_flow
(
  order_id VARCHAR(50) NOT NULL,
  logistics_company_id VARCHAR(80) NULL,
  logistics_id VARCHAR(80) NOT NULL,
  remark LONGTEXT NULL,
  PRIMARY KEY(`logistics_id`)
) ENGINE = InnoDB;

-- 评价表
DROP TABLE IF EXISTS ChenAnDB_order_goods_comments;
CREATE TABLE ChenAnDB_order_goods_comments
(
  comment_id VARCHAR(80) NOT NULL,
  sku INT NOT NULL,
  customer_id BIGINT NOT NULL,
  nick_name VARCHAR(50) NULL,
  -- 点赞数
  liked INT DEFAULT 1,
  comment TEXT NULL,
  -- 评分
  star TINYINT(5) DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  image_url TEXT NULL,
  -- 0：仅root可见，1：卖家可见，2：所有人可见
  public_level TINYINT(10) DEFAULT 0,
  PRIMARY KEY(`comment_id`)
) ENGINE = InnoDB;

-- user表
DROP TABLE IF EXISTS ChenAnDB_user;
CREATE TABLE ChenAnDB_user
(
  -- (100: root 30: agent 0: customer)
  identify TINYINT(100) DEFAULT 0,
  user_name VARCHAR(100) NOT NULL,
  nick_name VARCHAR(100) NULL,
  phone_number VARCHAR(50) NULL,
  email VARCHAR(100) NULL,
  head_image TEXT NULL,
  password VARCHAR(80) NOT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  union_id VARCHAR(50) NULL,
  customer_id BIGINT AUTO_INCREMENT,
  -- (10: 正常状态，0：失效状态)
  status TINYINT
  (10) DEFAULT 10,
  PRIMARY KEY
  (`customer_id`, `user_name`)
) ENGINE = MyISAM AUTO_INCREMENT=10000000001;

-- user和微信第三方应用的映射表
DROP TABLE IF EXISTS ChenAnDB_user_weixin;
CREATE TABLE ChenAnDB_user_weixin
(
  customer_id BIGINT NOT NULL,
  -- (10: 正常状态，0：失效状态)
  union_id VARCHAR(50) NOT NULL,
  PRIMARY KEY(`union_id`)
) ENGINE = InnoDB;


INSERT INTO ChenAnDB_user
  (
  identify,
  user_name,
  password
  )
VALUES(100, 'root', '111111');

-- 插入省市县数据
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1', '110000', '北京市', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2', '110101', '东城区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3', '110102', '西城区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('4', '110105', '朝阳区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('5', '110106', '丰台区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('6', '110107', '石景山区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('7', '110108', '海淀区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('8', '110109', '门头沟区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('9', '110111', '房山区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('10', '110112', '通州区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('11', '110113', '顺义区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('12', '110114', '昌平区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('13', '110115', '大兴区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('14', '110116', '怀柔区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('15', '110117', '平谷区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('16', '110118', '密云区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('17', '110119', '延庆区', '110000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('18', '120000', '天津市', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('19', '120101', '和平区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('20', '120102', '河东区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('21', '120103', '河西区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('22', '120104', '南开区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('23', '120105', '河北区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('24', '120106', '红桥区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('25', '120110', '东丽区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('26', '120111', '西青区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('27', '120112', '津南区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('28', '120113', '北辰区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('29', '120114', '武清区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('30', '120115', '宝坻区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('31', '120116', '滨海新区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('32', '120117', '宁河区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('33', '120118', '静海区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('34', '120119', '蓟州区', '120000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('35', '130000', '河北省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('36', '130100', '石家庄市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('37', '130102', '长安区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('38', '130104', '桥西区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('39', '130105', '新华区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('40', '130107', '井陉矿区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('41', '130108', '裕华区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('42', '130109', '藁城区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('43', '130110', '鹿泉区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('44', '130111', '栾城区', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('45', '130121', '井陉县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('46', '130123', '正定县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('47', '130125', '行唐县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('48', '130126', '灵寿县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('49', '130127', '高邑县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('50', '130128', '深泽县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('51', '130129', '赞皇县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('52', '130130', '无极县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('53', '130131', '平山县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('54', '130132', '元氏县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('55', '130133', '赵县', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('56', '130183', '晋州市', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('57', '130184', '新乐市', '130100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('58', '130200', '唐山市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('59', '130202', '路南区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('60', '130203', '路北区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('61', '130204', '古冶区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('62', '130205', '开平区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('63', '130207', '丰南区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('64', '130208', '丰润区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('65', '130209', '曹妃甸区', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('66', '130223', '滦县', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('67', '130224', '滦南县', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('68', '130225', '乐亭县', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('69', '130227', '迁西县', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('70', '130229', '玉田县', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('71', '130281', '遵化市', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('72', '130283', '迁安市', '130200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('73', '130300', '秦皇岛市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('74', '130302', '海港区', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('75', '130303', '山海关区', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('76', '130304', '北戴河区', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('77', '130306', '抚宁区', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('78', '130321', '青龙满族自治县', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('79', '130322', '昌黎县', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('80', '130324', '卢龙县', '130300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('81', '130400', '邯郸市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('82', '130402', '邯山区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('83', '130403', '丛台区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('84', '130404', '复兴区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('85', '130406', '峰峰矿区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('86', '130407', '肥乡区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('87', '130408', '永年区', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('88', '130423', '临漳县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('89', '130424', '成安县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('90', '130425', '大名县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('91', '130426', '涉县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('92', '130427', '磁县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('93', '130430', '邱县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('94', '130431', '鸡泽县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('95', '130432', '广平县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('96', '130433', '馆陶县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('97', '130434', '魏县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('98', '130435', '曲周县', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('99', '130481', '武安市', '130400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('100', '130500', '邢台市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('101', '130502', '桥东区', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('102', '130503', '桥西区', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('103', '130521', '邢台县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('104', '130522', '临城县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('105', '130523', '内丘县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('106', '130524', '柏乡县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('107', '130525', '隆尧县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('108', '130526', '任县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('109', '130527', '南和县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('110', '130528', '宁晋县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('111', '130529', '巨鹿县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('112', '130530', '新河县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('113', '130531', '广宗县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('114', '130532', '平乡县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('115', '130533', '威县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('116', '130534', '清河县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('117', '130535', '临西县', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('118', '130581', '南宫市', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('119', '130582', '沙河市', '130500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('120', '130600', '保定市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('121', '130602', '竞秀区', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('122', '130606', '莲池区', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('123', '130607', '满城区', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('124', '130608', '清苑区', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('125', '130609', '徐水区', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('126', '130623', '涞水县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('127', '130624', '阜平县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('128', '130626', '定兴县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('129', '130627', '唐县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('130', '130628', '高阳县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('131', '130629', '容城县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('132', '130630', '涞源县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('133', '130631', '望都县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('134', '130632', '安新县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('135', '130633', '易县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('136', '130634', '曲阳县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('137', '130635', '蠡县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('138', '130636', '顺平县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('139', '130637', '博野县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('140', '130638', '雄县', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('141', '130681', '涿州市', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('142', '130683', '安国市', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('143', '130684', '高碑店市', '130600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('144', '130700', '张家口市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('145', '130702', '桥东区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('146', '130703', '桥西区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('147', '130705', '宣化区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('148', '130706', '下花园区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('149', '130708', '万全区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('150', '130709', '崇礼区', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('151', '130722', '张北县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('152', '130723', '康保县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('153', '130724', '沽源县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('154', '130725', '尚义县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('155', '130726', '蔚县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('156', '130727', '阳原县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('157', '130728', '怀安县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('158', '130730', '怀来县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('159', '130731', '涿鹿县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('160', '130732', '赤城县', '130700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('161', '130800', '承德市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('162', '130802', '双桥区', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('163', '130803', '双滦区', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('164', '130804', '鹰手营子矿区', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('165', '130821', '承德县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('166', '130822', '兴隆县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('167', '130824', '滦平县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('168', '130825', '隆化县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('169', '130826', '丰宁满族自治县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('170', '130827', '宽城满族自治县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('171', '130828', '围场满族蒙古族自治县', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('172', '130881', '平泉市', '130800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('173', '130900', '沧州市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('174', '130902', '新华区', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('175', '130903', '运河区', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('176', '130921', '沧县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('177', '130922', '青县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('178', '130923', '东光县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('179', '130924', '海兴县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('180', '130925', '盐山县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('181', '130926', '肃宁县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('182', '130927', '南皮县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('183', '130928', '吴桥县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('184', '130929', '献县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('185', '130930', '孟村回族自治县', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('186', '130981', '泊头市', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('187', '130982', '任丘市', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('188', '130983', '黄骅市', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('189', '130984', '河间市', '130900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('190', '131000', '廊坊市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('191', '131002', '安次区', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('192', '131003', '广阳区', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('193', '131022', '固安县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('194', '131023', '永清县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('195', '131024', '香河县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('196', '131025', '大城县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('197', '131026', '文安县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('198', '131028', '大厂回族自治县', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('199', '131081', '霸州市', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('200', '131082', '三河市', '131000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('201', '131100', '衡水市', '130000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('202', '131102', '桃城区', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('203', '131103', '冀州区', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('204', '131121', '枣强县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('205', '131122', '武邑县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('206', '131123', '武强县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('207', '131124', '饶阳县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('208', '131125', '安平县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('209', '131126', '故城县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('210', '131127', '景县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('211', '131128', '阜城县', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('212', '131182', '深州市', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('213', '139001', '定州市', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('214', '139002', '辛集市', '131100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('215', '140000', '山西省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('216', '140100', '太原市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('217', '140105', '小店区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('218', '140106', '迎泽区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('219', '140107', '杏花岭区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('220', '140108', '尖草坪区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('221', '140109', '万柏林区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('222', '140110', '晋源区', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('223', '140121', '清徐县', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('224', '140122', '阳曲县', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('225', '140123', '娄烦县', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('226', '140181', '古交市', '140100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('227', '140200', '大同市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('228', '140202', '城区', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('229', '140203', '矿区', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('230', '140211', '南郊区', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('231', '140212', '新荣区', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('232', '140221', '阳高县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('233', '140222', '天镇县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('234', '140223', '广灵县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('235', '140224', '灵丘县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('236', '140225', '浑源县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('237', '140226', '左云县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('238', '140227', '大同县', '140200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('239', '140300', '阳泉市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('240', '140302', '城区', '140300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('241', '140303', '矿区', '140300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('242', '140311', '郊区', '140300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('243', '140321', '平定县', '140300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('244', '140322', '盂县', '140300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('245', '140400', '长治市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('246', '140402', '城区', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('247', '140411', '郊区', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('248', '140421', '长治县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('249', '140423', '襄垣县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('250', '140424', '屯留县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('251', '140425', '平顺县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('252', '140426', '黎城县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('253', '140427', '壶关县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('254', '140428', '长子县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('255', '140429', '武乡县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('256', '140430', '沁县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('257', '140431', '沁源县', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('258', '140481', '潞城市', '140400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('259', '140500', '晋城市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('260', '140502', '城区', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('261', '140521', '沁水县', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('262', '140522', '阳城县', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('263', '140524', '陵川县', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('264', '140525', '泽州县', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('265', '140581', '高平市', '140500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('266', '140600', '朔州市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('267', '140602', '朔城区', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('268', '140603', '平鲁区', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('269', '140621', '山阴县', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('270', '140622', '应县', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('271', '140623', '右玉县', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('272', '140624', '怀仁县', '140600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('273', '140700', '晋中市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('274', '140702', '榆次区', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('275', '140721', '榆社县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('276', '140722', '左权县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('277', '140723', '和顺县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('278', '140724', '昔阳县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('279', '140725', '寿阳县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('280', '140726', '太谷县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('281', '140727', '祁县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('282', '140728', '平遥县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('283', '140729', '灵石县', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('284', '140781', '介休市', '140700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('285', '140800', '运城市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('286', '140802', '盐湖区', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('287', '140821', '临猗县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('288', '140822', '万荣县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('289', '140823', '闻喜县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('290', '140824', '稷山县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('291', '140825', '新绛县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('292', '140826', '绛县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('293', '140827', '垣曲县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('294', '140828', '夏县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('295', '140829', '平陆县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('296', '140830', '芮城县', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('297', '140881', '永济市', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('298', '140882', '河津市', '140800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('299', '140900', '忻州市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('300', '140902', '忻府区', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('301', '140921', '定襄县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('302', '140922', '五台县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('303', '140923', '代县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('304', '140924', '繁峙县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('305', '140925', '宁武县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('306', '140926', '静乐县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('307', '140927', '神池县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('308', '140928', '五寨县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('309', '140929', '岢岚县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('310', '140930', '河曲县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('311', '140931', '保德县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('312', '140932', '偏关县', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('313', '140981', '原平市', '140900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('314', '141000', '临汾市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('315', '141002', '尧都区', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('316', '141021', '曲沃县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('317', '141022', '翼城县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('318', '141023', '襄汾县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('319', '141024', '洪洞县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('320', '141025', '古县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('321', '141026', '安泽县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('322', '141027', '浮山县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('323', '141028', '吉县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('324', '141029', '乡宁县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('325', '141030', '大宁县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('326', '141031', '隰县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('327', '141032', '永和县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('328', '141033', '蒲县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('329', '141034', '汾西县', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('330', '141081', '侯马市', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('331', '141082', '霍州市', '141000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('332', '141100', '吕梁市', '140000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('333', '141102', '离石区', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('334', '141121', '文水县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('335', '141122', '交城县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('336', '141123', '兴县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('337', '141124', '临县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('338', '141125', '柳林县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('339', '141126', '石楼县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('340', '141127', '岚县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('341', '141128', '方山县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('342', '141129', '中阳县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('343', '141130', '交口县', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('344', '141181', '孝义市', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('345', '141182', '汾阳市', '141100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('346', '150000', '内蒙古自治区', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('347', '150100', '呼和浩特市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('348', '150102', '新城区', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('349', '150103', '回民区', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('350', '150104', '玉泉区', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('351', '150105', '赛罕区', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('352', '150121', '土默特左旗', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('353', '150122', '托克托县', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('354', '150123', '和林格尔县', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('355', '150124', '清水河县', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('356', '150125', '武川县', '150100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('357', '150200', '包头市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('358', '150202', '东河区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('359', '150203', '昆都仑区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('360', '150204', '青山区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('361', '150205', '石拐区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('362', '150206', '白云鄂博矿区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('363', '150207', '九原区', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('364', '150221', '土默特右旗', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('365', '150222', '固阳县', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('366', '150223', '达尔罕茂明安联合旗', '150200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('367', '150300', '乌海市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('368', '150302', '海勃湾区', '150300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('369', '150303', '海南区', '150300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('370', '150304', '乌达区', '150300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('371', '150400', '赤峰市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('372', '150402', '红山区', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('373', '150403', '元宝山区', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('374', '150404', '松山区', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('375', '150421', '阿鲁科尔沁旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('376', '150422', '巴林左旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('377', '150423', '巴林右旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('378', '150424', '林西县', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('379', '150425', '克什克腾旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('380', '150426', '翁牛特旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('381', '150428', '喀喇沁旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('382', '150429', '宁城县', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('383', '150430', '敖汉旗', '150400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('384', '150500', '通辽市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('385', '150502', '科尔沁区', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('386', '150521', '科尔沁左翼中旗', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('387', '150522', '科尔沁左翼后旗', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('388', '150523', '开鲁县', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('389', '150524', '库伦旗', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('390', '150525', '奈曼旗', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('391', '150526', '扎鲁特旗', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('392', '150581', '霍林郭勒市', '150500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('393', '150600', '鄂尔多斯市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('394', '150602', '东胜区', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('395', '150603', '康巴什区', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('396', '150621', '达拉特旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('397', '150622', '准格尔旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('398', '150623', '鄂托克前旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('399', '150624', '鄂托克旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('400', '150625', '杭锦旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('401', '150626', '乌审旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('402', '150627', '伊金霍洛旗', '150600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('403', '150700', '呼伦贝尔市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('404', '150702', '海拉尔区', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('405', '150703', '扎赉诺尔区', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('406', '150721', '阿荣旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('407', '150722', '莫力达瓦达斡尔族自治旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('408', '150723', '鄂伦春自治旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('409', '150724', '鄂温克族自治旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('410', '150725', '陈巴尔虎旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('411', '150726', '新巴尔虎左旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('412', '150727', '新巴尔虎右旗', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('413', '150781', '满洲里市', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('414', '150782', '牙克石市', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('415', '150783', '扎兰屯市', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('416', '150784', '额尔古纳市', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('417', '150785', '根河市', '150700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('418', '150800', '巴彦淖尔市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('419', '150802', '临河区', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('420', '150821', '五原县', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('421', '150822', '磴口县', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('422', '150823', '乌拉特前旗', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('423', '150824', '乌拉特中旗', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('424', '150825', '乌拉特后旗', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('425', '150826', '杭锦后旗', '150800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('426', '150900', '乌兰察布市', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('427', '150902', '集宁区', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('428', '150921', '卓资县', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('429', '150922', '化德县', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('430', '150923', '商都县', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('431', '150924', '兴和县', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('432', '150925', '凉城县', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('433', '150926', '察哈尔右翼前旗', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('434', '150927', '察哈尔右翼中旗', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('435', '150928', '察哈尔右翼后旗', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('436', '150929', '四子王旗', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('437', '150981', '丰镇市', '150900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('438', '152200', '兴安盟', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('439', '152201', '乌兰浩特市', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('440', '152202', '阿尔山市', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('441', '152221', '科尔沁右翼前旗', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('442', '152222', '科尔沁右翼中旗', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('443', '152223', '扎赉特旗', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('444', '152224', '突泉县', '152200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('445', '152500', '锡林郭勒盟', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('446', '152501', '二连浩特市', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('447', '152502', '锡林浩特市', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('448', '152522', '阿巴嘎旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('449', '152523', '苏尼特左旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('450', '152524', '苏尼特右旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('451', '152525', '东乌珠穆沁旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('452', '152526', '西乌珠穆沁旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('453', '152527', '太仆寺旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('454', '152528', '镶黄旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('455', '152529', '正镶白旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('456', '152530', '正蓝旗', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('457', '152531', '多伦县', '152500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('458', '152900', '阿拉善盟', '150000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('459', '152921', '阿拉善左旗', '152900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('460', '152922', '阿拉善右旗', '152900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('461', '152923', '额济纳旗', '152900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('462', '210000', '辽宁省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('463', '210100', '沈阳市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('464', '210102', '和平区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('465', '210103', '沈河区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('466', '210104', '大东区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('467', '210105', '皇姑区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('468', '210106', '铁西区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('469', '210111', '苏家屯区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('470', '210112', '浑南区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('471', '210113', '沈北新区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('472', '210114', '于洪区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('473', '210115', '辽中区', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('474', '210123', '康平县', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('475', '210124', '法库县', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('476', '210181', '新民市', '210100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('477', '210200', '大连市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('478', '210202', '中山区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('479', '210203', '西岗区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('480', '210204', '沙河口区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('481', '210211', '甘井子区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('482', '210212', '旅顺口区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('483', '210213', '金州区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('484', '210214', '普兰店区', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('485', '210224', '长海县', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('486', '210281', '瓦房店市', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('487', '210283', '庄河市', '210200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('488', '210300', '鞍山市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('489', '210302', '铁东区', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('490', '210303', '铁西区', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('491', '210304', '立山区', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('492', '210311', '千山区', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('493', '210321', '台安县', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('494', '210323', '岫岩满族自治县', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('495', '210381', '海城市', '210300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('496', '210400', '抚顺市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('497', '210402', '新抚区', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('498', '210403', '东洲区', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('499', '210404', '望花区', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('500', '210411', '顺城区', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('501', '210421', '抚顺县', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('502', '210422', '新宾满族自治县', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('503', '210423', '清原满族自治县', '210400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('504', '210500', '本溪市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('505', '210502', '平山区', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('506', '210503', '溪湖区', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('507', '210504', '明山区', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('508', '210505', '南芬区', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('509', '210521', '本溪满族自治县', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('510', '210522', '桓仁满族自治县', '210500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('511', '210600', '丹东市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('512', '210602', '元宝区', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('513', '210603', '振兴区', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('514', '210604', '振安区', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('515', '210624', '宽甸满族自治县', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('516', '210681', '东港市', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('517', '210682', '凤城市', '210600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('518', '210700', '锦州市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('519', '210702', '古塔区', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('520', '210703', '凌河区', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('521', '210711', '太和区', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('522', '210726', '黑山县', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('523', '210727', '义县', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('524', '210781', '凌海市', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('525', '210782', '北镇市', '210700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('526', '210800', '营口市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('527', '210802', '站前区', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('528', '210803', '西市区', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('529', '210804', '鲅鱼圈区', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('530', '210811', '老边区', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('531', '210881', '盖州市', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('532', '210882', '大石桥市', '210800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('533', '210900', '阜新市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('534', '210902', '海州区', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('535', '210903', '新邱区', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('536', '210904', '太平区', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('537', '210905', '清河门区', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('538', '210911', '细河区', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('539', '210921', '阜新蒙古族自治县', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('540', '210922', '彰武县', '210900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('541', '211000', '辽阳市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('542', '211002', '白塔区', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('543', '211003', '文圣区', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('544', '211004', '宏伟区', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('545', '211005', '弓长岭区', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('546', '211011', '太子河区', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('547', '211021', '辽阳县', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('548', '211081', '灯塔市', '211000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('549', '211100', '盘锦市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('550', '211102', '双台子区', '211100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('551', '211103', '兴隆台区', '211100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('552', '211104', '大洼区', '211100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('553', '211122', '盘山县', '211100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('554', '211200', '铁岭市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('555', '211202', '银州区', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('556', '211204', '清河区', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('557', '211221', '铁岭县', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('558', '211223', '西丰县', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('559', '211224', '昌图县', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('560', '211281', '调兵山市', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('561', '211282', '开原市', '211200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('562', '211300', '朝阳市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('563', '211302', '双塔区', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('564', '211303', '龙城区', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('565', '211321', '朝阳县', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('566', '211322', '建平县', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('567', '211324', '喀喇沁左翼蒙古族自治县', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('568', '211381', '北票市', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('569', '211382', '凌源市', '211300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('570', '211400', '葫芦岛市', '210000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('571', '211402', '连山区', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('572', '211403', '龙港区', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('573', '211404', '南票区', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('574', '211421', '绥中县', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('575', '211422', '建昌县', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('576', '211481', '兴城市', '211400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('577', '220000', '吉林省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('578', '220100', '长春市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('579', '220102', '南关区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('580', '220103', '宽城区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('581', '220104', '朝阳区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('582', '220105', '二道区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('583', '220106', '绿园区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('584', '220112', '双阳区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('585', '220113', '九台区', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('586', '220122', '农安县', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('587', '220182', '榆树市', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('588', '220183', '德惠市', '220100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('589', '220200', '吉林市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('590', '220202', '昌邑区', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('591', '220203', '龙潭区', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('592', '220204', '船营区', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('593', '220211', '丰满区', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('594', '220221', '永吉县', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('595', '220281', '蛟河市', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('596', '220282', '桦甸市', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('597', '220283', '舒兰市', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('598', '220284', '磐石市', '220200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('599', '220300', '四平市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('600', '220302', '铁西区', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('601', '220303', '铁东区', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('602', '220322', '梨树县', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('603', '220323', '伊通满族自治县', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('604', '220381', '公主岭市', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('605', '220382', '双辽市', '220300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('606', '220400', '辽源市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('607', '220402', '龙山区', '220400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('608', '220403', '西安区', '220400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('609', '220421', '东丰县', '220400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('610', '220422', '东辽县', '220400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('611', '220500', '通化市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('612', '220502', '东昌区', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('613', '220503', '二道江区', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('614', '220521', '通化县', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('615', '220523', '辉南县', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('616', '220524', '柳河县', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('617', '220581', '梅河口市', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('618', '220582', '集安市', '220500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('619', '220600', '白山市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('620', '220602', '浑江区', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('621', '220605', '江源区', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('622', '220621', '抚松县', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('623', '220622', '靖宇县', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('624', '220623', '长白朝鲜族自治县', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('625', '220681', '临江市', '220600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('626', '220700', '松原市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('627', '220702', '宁江区', '220700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('628', '220721', '前郭尔罗斯蒙古族自治县', '220700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('629', '220722', '长岭县', '220700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('630', '220723', '乾安县', '220700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('631', '220781', '扶余市', '220700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('632', '220800', '白城市', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('633', '220802', '洮北区', '220800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('634', '220821', '镇赉县', '220800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('635', '220822', '通榆县', '220800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('636', '220881', '洮南市', '220800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('637', '220882', '大安市', '220800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('638', '222400', '延边朝鲜族自治州', '220000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('639', '222401', '延吉市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('640', '222402', '图们市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('641', '222403', '敦化市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('642', '222404', '珲春市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('643', '222405', '龙井市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('644', '222406', '和龙市', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('645', '222424', '汪清县', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('646', '222426', '安图县', '222400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('647', '230000', '黑龙江省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('648', '230100', '哈尔滨市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('649', '230102', '道里区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('650', '230103', '南岗区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('651', '230104', '道外区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('652', '230108', '平房区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('653', '230109', '松北区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('654', '230110', '香坊区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('655', '230111', '呼兰区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('656', '230112', '阿城区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('657', '230113', '双城区', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('658', '230123', '依兰县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('659', '230124', '方正县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('660', '230125', '宾县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('661', '230126', '巴彦县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('662', '230127', '木兰县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('663', '230128', '通河县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('664', '230129', '延寿县', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('665', '230183', '尚志市', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('666', '230184', '五常市', '230100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('667', '230200', '齐齐哈尔市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('668', '230202', '龙沙区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('669', '230203', '建华区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('670', '230204', '铁锋区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('671', '230205', '昂昂溪区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('672', '230206', '富拉尔基区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('673', '230207', '碾子山区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('674', '230208', '梅里斯达斡尔族区', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('675', '230221', '龙江县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('676', '230223', '依安县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('677', '230224', '泰来县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('678', '230225', '甘南县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('679', '230227', '富裕县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('680', '230229', '克山县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('681', '230230', '克东县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('682', '230231', '拜泉县', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('683', '230281', '讷河市', '230200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('684', '230300', '鸡西市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('685', '230302', '鸡冠区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('686', '230303', '恒山区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('687', '230304', '滴道区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('688', '230305', '梨树区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('689', '230306', '城子河区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('690', '230307', '麻山区', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('691', '230321', '鸡东县', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('692', '230381', '虎林市', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('693', '230382', '密山市', '230300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('694', '230400', '鹤岗市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('695', '230402', '向阳区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('696', '230403', '工农区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('697', '230404', '南山区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('698', '230405', '兴安区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('699', '230406', '东山区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('700', '230407', '兴山区', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('701', '230421', '萝北县', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('702', '230422', '绥滨县', '230400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('703', '230500', '双鸭山市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('704', '230502', '尖山区', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('705', '230503', '岭东区', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('706', '230505', '四方台区', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('707', '230506', '宝山区', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('708', '230521', '集贤县', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('709', '230522', '友谊县', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('710', '230523', '宝清县', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('711', '230524', '饶河县', '230500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('712', '230600', '大庆市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('713', '230602', '萨尔图区', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('714', '230603', '龙凤区', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('715', '230604', '让胡路区', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('716', '230605', '红岗区', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('717', '230606', '大同区', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('718', '230621', '肇州县', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('719', '230622', '肇源县', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('720', '230623', '林甸县', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('721', '230624', '杜尔伯特蒙古族自治县', '230600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('722', '230700', '伊春市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('723', '230702', '伊春区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('724', '230703', '南岔区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('725', '230704', '友好区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('726', '230705', '西林区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('727', '230706', '翠峦区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('728', '230707', '新青区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('729', '230708', '美溪区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('730', '230709', '金山屯区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('731', '230710', '五营区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('732', '230711', '乌马河区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('733', '230712', '汤旺河区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('734', '230713', '带岭区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('735', '230714', '乌伊岭区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('736', '230715', '红星区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('737', '230716', '上甘岭区', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('738', '230722', '嘉荫县', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('739', '230781', '铁力市', '230700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('740', '230800', '佳木斯市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('741', '230803', '向阳区', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('742', '230804', '前进区', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('743', '230805', '东风区', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('744', '230811', '郊区', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('745', '230822', '桦南县', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('746', '230826', '桦川县', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('747', '230828', '汤原县', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('748', '230881', '同江市', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('749', '230882', '富锦市', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('750', '230883', '抚远市', '230800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('751', '230900', '七台河市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('752', '230902', '新兴区', '230900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('753', '230903', '桃山区', '230900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('754', '230904', '茄子河区', '230900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('755', '230921', '勃利县', '230900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('756', '231000', '牡丹江市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('757', '231002', '东安区', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('758', '231003', '阳明区', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('759', '231004', '爱民区', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('760', '231005', '西安区', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('761', '231025', '林口县', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('762', '231081', '绥芬河市', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('763', '231083', '海林市', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('764', '231084', '宁安市', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('765', '231085', '穆棱市', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('766', '231086', '东宁市', '231000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('767', '231100', '黑河市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('768', '231102', '爱辉区', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('769', '231121', '嫩江县', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('770', '231123', '逊克县', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('771', '231124', '孙吴县', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('772', '231181', '北安市', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('773', '231182', '五大连池市', '231100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('774', '231200', '绥化市', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('775', '231202', '北林区', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('776', '231221', '望奎县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('777', '231222', '兰西县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('778', '231223', '青冈县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('779', '231224', '庆安县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('780', '231225', '明水县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('781', '231226', '绥棱县', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('782', '231281', '安达市', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('783', '231282', '肇东市', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('784', '231283', '海伦市', '231200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('785', '232700', '大兴安岭地区', '230000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('786', '232701', '加格达奇区', '232700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('787', '232721', '呼玛县', '232700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('788', '232722', '塔河县', '232700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('789', '232723', '漠河县', '232700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('790', '310000', '上海市', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('791', '310101', '黄浦区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('792', '310104', '徐汇区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('793', '310105', '长宁区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('794', '310106', '静安区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('795', '310107', '普陀区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('796', '310109', '虹口区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('797', '310110', '杨浦区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('798', '310112', '闵行区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('799', '310113', '宝山区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('800', '310114', '嘉定区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('801', '310115', '浦东新区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('802', '310116', '金山区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('803', '310117', '松江区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('804', '310118', '青浦区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('805', '310120', '奉贤区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('806', '310151', '崇明区', '310000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('807', '320000', '江苏省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('808', '320100', '南京市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('809', '320102', '玄武区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('810', '320104', '秦淮区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('811', '320105', '建邺区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('812', '320106', '鼓楼区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('813', '320111', '浦口区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('814', '320113', '栖霞区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('815', '320114', '雨花台区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('816', '320115', '江宁区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('817', '320116', '六合区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('818', '320117', '溧水区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('819', '320118', '高淳区', '320100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('820', '320200', '无锡市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('821', '320205', '锡山区', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('822', '320206', '惠山区', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('823', '320211', '滨湖区', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('824', '320213', '梁溪区', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('825', '320214', '新吴区', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('826', '320281', '江阴市', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('827', '320282', '宜兴市', '320200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('828', '320300', '徐州市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('829', '320302', '鼓楼区', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('830', '320303', '云龙区', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('831', '320305', '贾汪区', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('832', '320311', '泉山区', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('833', '320312', '铜山区', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('834', '320321', '丰县', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('835', '320322', '沛县', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('836', '320324', '睢宁县', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('837', '320381', '新沂市', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('838', '320382', '邳州市', '320300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('839', '320400', '常州市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('840', '320402', '天宁区', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('841', '320404', '钟楼区', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('842', '320411', '新北区', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('843', '320412', '武进区', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('844', '320413', '金坛区', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('845', '320481', '溧阳市', '320400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('846', '320500', '苏州市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('847', '320505', '虎丘区', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('848', '320506', '吴中区', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('849', '320507', '相城区', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('850', '320508', '姑苏区', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('851', '320509', '吴江区', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('852', '320581', '常熟市', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('853', '320582', '张家港市', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('854', '320583', '昆山市', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('855', '320585', '太仓市', '320500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('856', '320600', '南通市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('857', '320602', '崇川区', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('858', '320611', '港闸区', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('859', '320612', '通州区', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('860', '320621', '海安县', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('861', '320623', '如东县', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('862', '320681', '启东市', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('863', '320682', '如皋市', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('864', '320684', '海门市', '320600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('865', '320700', '连云港市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('866', '320703', '连云区', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('867', '320706', '海州区', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('868', '320707', '赣榆区', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('869', '320722', '东海县', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('870', '320723', '灌云县', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('871', '320724', '灌南县', '320700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('872', '320800', '淮安市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('873', '320803', '淮安区', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('874', '320804', '淮阴区', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('875', '320812', '清江浦区', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('876', '320813', '洪泽区', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('877', '320826', '涟水县', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('878', '320830', '盱眙县', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('879', '320831', '金湖县', '320800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('880', '320900', '盐城市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('881', '320902', '亭湖区', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('882', '320903', '盐都区', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('883', '320904', '大丰区', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('884', '320921', '响水县', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('885', '320922', '滨海县', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('886', '320923', '阜宁县', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('887', '320924', '射阳县', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('888', '320925', '建湖县', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('889', '320981', '东台市', '320900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('890', '321000', '扬州市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('891', '321002', '广陵区', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('892', '321003', '邗江区', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('893', '321012', '江都区', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('894', '321023', '宝应县', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('895', '321081', '仪征市', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('896', '321084', '高邮市', '321000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('897', '321100', '镇江市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('898', '321102', '京口区', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('899', '321111', '润州区', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('900', '321112', '丹徒区', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('901', '321181', '丹阳市', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('902', '321182', '扬中市', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('903', '321183', '句容市', '321100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('904', '321200', '泰州市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('905', '321202', '海陵区', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('906', '321203', '高港区', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('907', '321204', '姜堰区', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('908', '321281', '兴化市', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('909', '321282', '靖江市', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('910', '321283', '泰兴市', '321200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('911', '321300', '宿迁市', '320000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('912', '321302', '宿城区', '321300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('913', '321311', '宿豫区', '321300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('914', '321322', '沭阳县', '321300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('915', '321323', '泗阳县', '321300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('916', '321324', '泗洪县', '321300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('917', '330000', '浙江省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('918', '330100', '杭州市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('919', '330102', '上城区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('920', '330103', '下城区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('921', '330104', '江干区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('922', '330105', '拱墅区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('923', '330106', '西湖区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('924', '330108', '滨江区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('925', '330109', '萧山区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('926', '330110', '余杭区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('927', '330111', '富阳区', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('928', '330122', '桐庐县', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('929', '330127', '淳安县', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('930', '330182', '建德市', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('931', '330185', '临安市', '330100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('932', '330200', '宁波市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('933', '330203', '海曙区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('934', '330205', '江北区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('935', '330206', '北仑区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('936', '330211', '镇海区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('937', '330212', '鄞州区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('938', '330213', '奉化区', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('939', '330225', '象山县', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('940', '330226', '宁海县', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('941', '330281', '余姚市', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('942', '330282', '慈溪市', '330200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('943', '330300', '温州市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('944', '330302', '鹿城区', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('945', '330303', '龙湾区', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('946', '330304', '瓯海区', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('947', '330305', '洞头区', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('948', '330324', '永嘉县', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('949', '330326', '平阳县', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('950', '330327', '苍南县', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('951', '330328', '文成县', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('952', '330329', '泰顺县', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('953', '330381', '瑞安市', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('954', '330382', '乐清市', '330300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('955', '330400', '嘉兴市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('956', '330402', '南湖区', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('957', '330411', '秀洲区', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('958', '330421', '嘉善县', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('959', '330424', '海盐县', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('960', '330481', '海宁市', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('961', '330482', '平湖市', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('962', '330483', '桐乡市', '330400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('963', '330500', '湖州市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('964', '330502', '吴兴区', '330500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('965', '330503', '南浔区', '330500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('966', '330521', '德清县', '330500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('967', '330522', '长兴县', '330500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('968', '330523', '安吉县', '330500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('969', '330600', '绍兴市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('970', '330602', '越城区', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('971', '330603', '柯桥区', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('972', '330604', '上虞区', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('973', '330624', '新昌县', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('974', '330681', '诸暨市', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('975', '330683', '嵊州市', '330600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('976', '330700', '金华市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('977', '330702', '婺城区', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('978', '330703', '金东区', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('979', '330723', '武义县', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('980', '330726', '浦江县', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('981', '330727', '磐安县', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('982', '330781', '兰溪市', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('983', '330782', '义乌市', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('984', '330783', '东阳市', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('985', '330784', '永康市', '330700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('986', '330800', '衢州市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('987', '330802', '柯城区', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('988', '330803', '衢江区', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('989', '330822', '常山县', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('990', '330824', '开化县', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('991', '330825', '龙游县', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('992', '330881', '江山市', '330800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('993', '330900', '舟山市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('994', '330902', '定海区', '330900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('995', '330903', '普陀区', '330900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('996', '330921', '岱山县', '330900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('997', '330922', '嵊泗县', '330900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('998', '331000', '台州市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('999', '331002', '椒江区', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1000', '331003', '黄岩区', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1001', '331004', '路桥区', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1002', '331022', '三门县', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1003', '331023', '天台县', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1004', '331024', '仙居县', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1005', '331081', '温岭市', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1006', '331082', '临海市', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1007', '331083', '玉环市', '331000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1008', '331100', '丽水市', '330000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1009', '331102', '莲都区', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1010', '331121', '青田县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1011', '331122', '缙云县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1012', '331123', '遂昌县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1013', '331124', '松阳县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1014', '331125', '云和县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1015', '331126', '庆元县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1016', '331127', '景宁畲族自治县', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1017', '331181', '龙泉市', '331100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1018', '340000', '安徽省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1019', '340100', '合肥市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1020', '340102', '瑶海区', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1021', '340103', '庐阳区', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1022', '340104', '蜀山区', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1023', '340111', '包河区', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1024', '340121', '长丰县', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1025', '340122', '肥东县', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1026', '340123', '肥西县', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1027', '340124', '庐江县', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1028', '340181', '巢湖市', '340100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1029', '340200', '芜湖市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1030', '340202', '镜湖区', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1031', '340203', '弋江区', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1032', '340207', '鸠江区', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1033', '340208', '三山区', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1034', '340221', '芜湖县', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1035', '340222', '繁昌县', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1036', '340223', '南陵县', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1037', '340225', '无为县', '340200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1038', '340300', '蚌埠市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1039', '340302', '龙子湖区', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1040', '340303', '蚌山区', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1041', '340304', '禹会区', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1042', '340311', '淮上区', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1043', '340321', '怀远县', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1044', '340322', '五河县', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1045', '340323', '固镇县', '340300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1046', '340400', '淮南市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1047', '340402', '大通区', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1048', '340403', '田家庵区', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1049', '340404', '谢家集区', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1050', '340405', '八公山区', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1051', '340406', '潘集区', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1052', '340421', '凤台县', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1053', '340422', '寿县', '340400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1054', '340500', '马鞍山市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1055', '340503', '花山区', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1056', '340504', '雨山区', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1057', '340506', '博望区', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1058', '340521', '当涂县', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1059', '340522', '含山县', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1060', '340523', '和县', '340500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1061', '340600', '淮北市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1062', '340602', '杜集区', '340600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1063', '340603', '相山区', '340600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1064', '340604', '烈山区', '340600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1065', '340621', '濉溪县', '340600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1066', '340700', '铜陵市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1067', '340705', '铜官区', '340700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1068', '340706', '义安区', '340700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1069', '340711', '郊区', '340700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1070', '340722', '枞阳县', '340700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1071', '340800', '安庆市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1072', '340802', '迎江区', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1073', '340803', '大观区', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1074', '340811', '宜秀区', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1075', '340822', '怀宁县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1076', '340824', '潜山县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1077', '340825', '太湖县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1078', '340826', '宿松县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1079', '340827', '望江县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1080', '340828', '岳西县', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1081', '340881', '桐城市', '340800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1082', '341000', '黄山市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1083', '341002', '屯溪区', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1084', '341003', '黄山区', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1085', '341004', '徽州区', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1086', '341021', '歙县', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1087', '341022', '休宁县', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1088', '341023', '黟县', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1089', '341024', '祁门县', '341000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1090', '341100', '滁州市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1091', '341102', '琅琊区', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1092', '341103', '南谯区', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1093', '341122', '来安县', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1094', '341124', '全椒县', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1095', '341125', '定远县', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1096', '341126', '凤阳县', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1097', '341181', '天长市', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1098', '341182', '明光市', '341100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1099', '341200', '阜阳市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1100', '341202', '颍州区', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1101', '341203', '颍东区', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1102', '341204', '颍泉区', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1103', '341221', '临泉县', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1104', '341222', '太和县', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1105', '341225', '阜南县', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1106', '341226', '颍上县', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1107', '341282', '界首市', '341200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1108', '341300', '宿州市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1109', '341302', '埇桥区', '341300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1110', '341321', '砀山县', '341300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1111', '341322', '萧县', '341300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1112', '341323', '灵璧县', '341300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1113', '341324', '泗县', '341300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1114', '341500', '六安市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1115', '341502', '金安区', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1116', '341503', '裕安区', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1117', '341504', '叶集区', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1118', '341522', '霍邱县', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1119', '341523', '舒城县', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1120', '341524', '金寨县', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1121', '341525', '霍山县', '341500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1122', '341600', '亳州市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1123', '341602', '谯城区', '341600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1124', '341621', '涡阳县', '341600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1125', '341622', '蒙城县', '341600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1126', '341623', '利辛县', '341600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1127', '341700', '池州市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1128', '341702', '贵池区', '341700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1129', '341721', '东至县', '341700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1130', '341722', '石台县', '341700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1131', '341723', '青阳县', '341700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1132', '341800', '宣城市', '340000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1133', '341802', '宣州区', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1134', '341821', '郎溪县', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1135', '341822', '广德县', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1136', '341823', '泾县', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1137', '341824', '绩溪县', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1138', '341825', '旌德县', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1139', '341881', '宁国市', '341800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1140', '350000', '福建省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1141', '350100', '福州市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1142', '350102', '鼓楼区', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1143', '350103', '台江区', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1144', '350104', '仓山区', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1145', '350105', '马尾区', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1146', '350111', '晋安区', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1147', '350121', '闽侯县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1148', '350122', '连江县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1149', '350123', '罗源县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1150', '350124', '闽清县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1151', '350125', '永泰县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1152', '350128', '平潭县', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1153', '350181', '福清市', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1154', '350182', '长乐市', '350100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1155', '350200', '厦门市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1156', '350203', '思明区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1157', '350205', '海沧区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1158', '350206', '湖里区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1159', '350211', '集美区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1160', '350212', '同安区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1161', '350213', '翔安区', '350200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1162', '350300', '莆田市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1163', '350302', '城厢区', '350300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1164', '350303', '涵江区', '350300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1165', '350304', '荔城区', '350300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1166', '350305', '秀屿区', '350300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1167', '350322', '仙游县', '350300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1168', '350400', '三明市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1169', '350402', '梅列区', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1170', '350403', '三元区', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1171', '350421', '明溪县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1172', '350423', '清流县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1173', '350424', '宁化县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1174', '350425', '大田县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1175', '350426', '尤溪县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1176', '350427', '沙县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1177', '350428', '将乐县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1178', '350429', '泰宁县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1179', '350430', '建宁县', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1180', '350481', '永安市', '350400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1181', '350500', '泉州市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1182', '350502', '鲤城区', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1183', '350503', '丰泽区', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1184', '350504', '洛江区', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1185', '350505', '泉港区', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1186', '350521', '惠安县', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1187', '350524', '安溪县', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1188', '350525', '永春县', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1189', '350526', '德化县', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1190', '350527', '金门县', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1191', '350581', '石狮市', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1192', '350582', '晋江市', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1193', '350583', '南安市', '350500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1194', '350600', '漳州市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1195', '350602', '芗城区', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1196', '350603', '龙文区', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1197', '350622', '云霄县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1198', '350623', '漳浦县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1199', '350624', '诏安县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1200', '350625', '长泰县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1201', '350626', '东山县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1202', '350627', '南靖县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1203', '350628', '平和县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1204', '350629', '华安县', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1205', '350681', '龙海市', '350600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1206', '350700', '南平市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1207', '350702', '延平区', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1208', '350703', '建阳区', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1209', '350721', '顺昌县', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1210', '350722', '浦城县', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1211', '350723', '光泽县', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1212', '350724', '松溪县', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1213', '350725', '政和县', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1214', '350781', '邵武市', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1215', '350782', '武夷山市', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1216', '350783', '建瓯市', '350700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1217', '350800', '龙岩市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1218', '350802', '新罗区', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1219', '350803', '永定区', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1220', '350821', '长汀县', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1221', '350823', '上杭县', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1222', '350824', '武平县', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1223', '350825', '连城县', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1224', '350881', '漳平市', '350800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1225', '350900', '宁德市', '350000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1226', '350902', '蕉城区', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1227', '350921', '霞浦县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1228', '350922', '古田县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1229', '350923', '屏南县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1230', '350924', '寿宁县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1231', '350925', '周宁县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1232', '350926', '柘荣县', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1233', '350981', '福安市', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1234', '350982', '福鼎市', '350900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1235', '360000', '江西省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1236', '360100', '南昌市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1237', '360102', '东湖区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1238', '360103', '西湖区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1239', '360104', '青云谱区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1240', '360105', '湾里区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1241', '360111', '青山湖区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1242', '360112', '新建区', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1243', '360121', '南昌县', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1244', '360123', '安义县', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1245', '360124', '进贤县', '360100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1246', '360200', '景德镇市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1247', '360202', '昌江区', '360200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1248', '360203', '珠山区', '360200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1249', '360222', '浮梁县', '360200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1250', '360281', '乐平市', '360200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1251', '360300', '萍乡市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1252', '360302', '安源区', '360300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1253', '360313', '湘东区', '360300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1254', '360321', '莲花县', '360300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1255', '360322', '上栗县', '360300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1256', '360323', '芦溪县', '360300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1257', '360400', '九江市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1258', '360402', '濂溪区', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1259', '360403', '浔阳区', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1260', '360421', '九江县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1261', '360423', '武宁县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1262', '360424', '修水县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1263', '360425', '永修县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1264', '360426', '德安县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1265', '360428', '都昌县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1266', '360429', '湖口县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1267', '360430', '彭泽县', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1268', '360481', '瑞昌市', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1269', '360482', '共青城市', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1270', '360483', '庐山市', '360400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1271', '360500', '新余市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1272', '360502', '渝水区', '360500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1273', '360521', '分宜县', '360500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1274', '360600', '鹰潭市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1275', '360602', '月湖区', '360600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1276', '360622', '余江县', '360600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1277', '360681', '贵溪市', '360600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1278', '360700', '赣州市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1279', '360702', '章贡区', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1280', '360703', '南康区', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1281', '360704', '赣县区', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1282', '360722', '信丰县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1283', '360723', '大余县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1284', '360724', '上犹县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1285', '360725', '崇义县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1286', '360726', '安远县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1287', '360727', '龙南县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1288', '360728', '定南县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1289', '360729', '全南县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1290', '360730', '宁都县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1291', '360731', '于都县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1292', '360732', '兴国县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1293', '360733', '会昌县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1294', '360734', '寻乌县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1295', '360735', '石城县', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1296', '360781', '瑞金市', '360700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1297', '360800', '吉安市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1298', '360802', '吉州区', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1299', '360803', '青原区', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1300', '360821', '吉安县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1301', '360822', '吉水县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1302', '360823', '峡江县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1303', '360824', '新干县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1304', '360825', '永丰县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1305', '360826', '泰和县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1306', '360827', '遂川县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1307', '360828', '万安县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1308', '360829', '安福县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1309', '360830', '永新县', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1310', '360881', '井冈山市', '360800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1311', '360900', '宜春市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1312', '360902', '袁州区', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1313', '360921', '奉新县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1314', '360922', '万载县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1315', '360923', '上高县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1316', '360924', '宜丰县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1317', '360925', '靖安县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1318', '360926', '铜鼓县', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1319', '360981', '丰城市', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1320', '360982', '樟树市', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1321', '360983', '高安市', '360900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1322', '361000', '抚州市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1323', '361002', '临川区', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1324', '361003', '东乡区', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1325', '361021', '南城县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1326', '361022', '黎川县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1327', '361023', '南丰县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1328', '361024', '崇仁县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1329', '361025', '乐安县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1330', '361026', '宜黄县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1331', '361027', '金溪县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1332', '361028', '资溪县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1333', '361030', '广昌县', '361000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1334', '361100', '上饶市', '360000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1335', '361102', '信州区', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1336', '361103', '广丰区', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1337', '361121', '上饶县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1338', '361123', '玉山县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1339', '361124', '铅山县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1340', '361125', '横峰县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1341', '361126', '弋阳县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1342', '361127', '余干县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1343', '361128', '鄱阳县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1344', '361129', '万年县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1345', '361130', '婺源县', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1346', '361181', '德兴市', '361100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1347', '370000', '山东省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1348', '370100', '济南市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1349', '370102', '历下区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1350', '370103', '市中区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1351', '370104', '槐荫区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1352', '370105', '天桥区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1353', '370112', '历城区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1354', '370113', '长清区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1355', '370114', '章丘区', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1356', '370124', '平阴县', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1357', '370125', '济阳县', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1358', '370126', '商河县', '370100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1359', '370200', '青岛市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1360', '370202', '市南区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1361', '370203', '市北区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1362', '370211', '黄岛区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1363', '370212', '崂山区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1364', '370213', '李沧区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1365', '370214', '城阳区', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1366', '370281', '胶州市', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1367', '370282', '即墨市', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1368', '370283', '平度市', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1369', '370285', '莱西市', '370200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1370', '370300', '淄博市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1371', '370302', '淄川区', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1372', '370303', '张店区', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1373', '370304', '博山区', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1374', '370305', '临淄区', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1375', '370306', '周村区', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1376', '370321', '桓台县', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1377', '370322', '高青县', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1378', '370323', '沂源县', '370300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1379', '370400', '枣庄市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1380', '370402', '市中区', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1381', '370403', '薛城区', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1382', '370404', '峄城区', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1383', '370405', '台儿庄区', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1384', '370406', '山亭区', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1385', '370481', '滕州市', '370400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1386', '370500', '东营市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1387', '370502', '东营区', '370500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1388', '370503', '河口区', '370500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1389', '370505', '垦利区', '370500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1390', '370522', '利津县', '370500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1391', '370523', '广饶县', '370500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1392', '370600', '烟台市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1393', '370602', '芝罘区', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1394', '370611', '福山区', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1395', '370612', '牟平区', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1396', '370613', '莱山区', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1397', '370634', '长岛县', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1398', '370681', '龙口市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1399', '370682', '莱阳市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1400', '370683', '莱州市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1401', '370684', '蓬莱市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1402', '370685', '招远市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1403', '370686', '栖霞市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1404', '370687', '海阳市', '370600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1405', '370700', '潍坊市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1406', '370702', '潍城区', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1407', '370703', '寒亭区', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1408', '370704', '坊子区', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1409', '370705', '奎文区', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1410', '370724', '临朐县', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1411', '370725', '昌乐县', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1412', '370781', '青州市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1413', '370782', '诸城市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1414', '370783', '寿光市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1415', '370784', '安丘市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1416', '370785', '高密市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1417', '370786', '昌邑市', '370700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1418', '370800', '济宁市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1419', '370811', '任城区', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1420', '370812', '兖州区', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1421', '370826', '微山县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1422', '370827', '鱼台县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1423', '370828', '金乡县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1424', '370829', '嘉祥县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1425', '370830', '汶上县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1426', '370831', '泗水县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1427', '370832', '梁山县', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1428', '370881', '曲阜市', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1429', '370883', '邹城市', '370800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1430', '370900', '泰安市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1431', '370902', '泰山区', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1432', '370911', '岱岳区', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1433', '370921', '宁阳县', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1434', '370923', '东平县', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1435', '370982', '新泰市', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1436', '370983', '肥城市', '370900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1437', '371000', '威海市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1438', '371002', '环翠区', '371000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1439', '371003', '文登区', '371000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1440', '371082', '荣成市', '371000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1441', '371083', '乳山市', '371000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1442', '371100', '日照市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1443', '371102', '东港区', '371100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1444', '371103', '岚山区', '371100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1445', '371121', '五莲县', '371100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1446', '371122', '莒县', '371100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1447', '371200', '莱芜市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1448', '371202', '莱城区', '371200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1449', '371203', '钢城区', '371200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1450', '371300', '临沂市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1451', '371302', '兰山区', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1452', '371311', '罗庄区', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1453', '371312', '河东区', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1454', '371321', '沂南县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1455', '371322', '郯城县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1456', '371323', '沂水县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1457', '371324', '兰陵县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1458', '371325', '费县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1459', '371326', '平邑县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1460', '371327', '莒南县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1461', '371328', '蒙阴县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1462', '371329', '临沭县', '371300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1463', '371400', '德州市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1464', '371402', '德城区', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1465', '371403', '陵城区', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1466', '371422', '宁津县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1467', '371423', '庆云县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1468', '371424', '临邑县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1469', '371425', '齐河县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1470', '371426', '平原县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1471', '371427', '夏津县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1472', '371428', '武城县', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1473', '371481', '乐陵市', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1474', '371482', '禹城市', '371400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1475', '371500', '聊城市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1476', '371502', '东昌府区', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1477', '371521', '阳谷县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1478', '371522', '莘县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1479', '371523', '茌平县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1480', '371524', '东阿县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1481', '371525', '冠县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1482', '371526', '高唐县', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1483', '371581', '临清市', '371500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1484', '371600', '滨州市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1485', '371602', '滨城区', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1486', '371603', '沾化区', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1487', '371621', '惠民县', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1488', '371622', '阳信县', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1489', '371623', '无棣县', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1490', '371625', '博兴县', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1491', '371626', '邹平县', '371600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1492', '371700', '菏泽市', '370000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1493', '371702', '牡丹区', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1494', '371703', '定陶区', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1495', '371721', '曹县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1496', '371722', '单县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1497', '371723', '成武县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1498', '371724', '巨野县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1499', '371725', '郓城县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1500', '371726', '鄄城县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1501', '371728', '东明县', '371700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1502', '410000', '河南省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1503', '410100', '郑州市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1504', '410102', '中原区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1505', '410103', '二七区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1506', '410104', '管城回族区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1507', '410105', '金水区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1508', '410106', '上街区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1509', '410108', '惠济区', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1510', '410122', '中牟县', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1511', '410181', '巩义市', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1512', '410182', '荥阳市', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1513', '410183', '新密市', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1514', '410184', '新郑市', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1515', '410185', '登封市', '410100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1516', '410200', '开封市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1517', '410202', '龙亭区', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1518', '410203', '顺河回族区', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1519', '410204', '鼓楼区', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1520', '410205', '禹王台区', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1521', '410212', '祥符区', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1522', '410221', '杞县', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1523', '410222', '通许县', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1524', '410223', '尉氏县', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1525', '410225', '兰考县', '410200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1526', '410300', '洛阳市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1527', '410302', '老城区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1528', '410303', '西工区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1529', '410304', '瀍河回族区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1530', '410305', '涧西区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1531', '410306', '吉利区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1532', '410311', '洛龙区', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1533', '410322', '孟津县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1534', '410323', '新安县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1535', '410324', '栾川县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1536', '410325', '嵩县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1537', '410326', '汝阳县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1538', '410327', '宜阳县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1539', '410328', '洛宁县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1540', '410329', '伊川县', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1541', '410381', '偃师市', '410300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1542', '410400', '平顶山市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1543', '410402', '新华区', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1544', '410403', '卫东区', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1545', '410404', '石龙区', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1546', '410411', '湛河区', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1547', '410421', '宝丰县', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1548', '410422', '叶县', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1549', '410423', '鲁山县', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1550', '410425', '郏县', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1551', '410481', '舞钢市', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1552', '410482', '汝州市', '410400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1553', '410500', '安阳市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1554', '410502', '文峰区', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1555', '410503', '北关区', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1556', '410505', '殷都区', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1557', '410506', '龙安区', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1558', '410522', '安阳县', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1559', '410523', '汤阴县', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1560', '410526', '滑县', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1561', '410527', '内黄县', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1562', '410581', '林州市', '410500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1563', '410600', '鹤壁市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1564', '410602', '鹤山区', '410600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1565', '410603', '山城区', '410600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1566', '410611', '淇滨区', '410600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1567', '410621', '浚县', '410600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1568', '410622', '淇县', '410600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1569', '410700', '新乡市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1570', '410702', '红旗区', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1571', '410703', '卫滨区', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1572', '410704', '凤泉区', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1573', '410711', '牧野区', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1574', '410721', '新乡县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1575', '410724', '获嘉县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1576', '410725', '原阳县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1577', '410726', '延津县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1578', '410727', '封丘县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1579', '410728', '长垣县', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1580', '410781', '卫辉市', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1581', '410782', '辉县市', '410700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1582', '410800', '焦作市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1583', '410802', '解放区', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1584', '410803', '中站区', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1585', '410804', '马村区', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1586', '410811', '山阳区', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1587', '410821', '修武县', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1588', '410822', '博爱县', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1589', '410823', '武陟县', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1590', '410825', '温县', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1591', '410882', '沁阳市', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1592', '410883', '孟州市', '410800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1593', '410900', '濮阳市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1594', '410902', '华龙区', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1595', '410922', '清丰县', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1596', '410923', '南乐县', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1597', '410926', '范县', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1598', '410927', '台前县', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1599', '410928', '濮阳县', '410900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1600', '411000', '许昌市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1601', '411002', '魏都区', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1602', '411003', '建安区', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1603', '411024', '鄢陵县', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1604', '411025', '襄城县', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1605', '411081', '禹州市', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1606', '411082', '长葛市', '411000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1607', '411100', '漯河市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1608', '411102', '源汇区', '411100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1609', '411103', '郾城区', '411100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1610', '411104', '召陵区', '411100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1611', '411121', '舞阳县', '411100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1612', '411122', '临颍县', '411100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1613', '411200', '三门峡市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1614', '411202', '湖滨区', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1615', '411203', '陕州区', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1616', '411221', '渑池县', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1617', '411224', '卢氏县', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1618', '411281', '义马市', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1619', '411282', '灵宝市', '411200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1620', '411300', '南阳市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1621', '411302', '宛城区', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1622', '411303', '卧龙区', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1623', '411321', '南召县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1624', '411322', '方城县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1625', '411323', '西峡县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1626', '411324', '镇平县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1627', '411325', '内乡县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1628', '411326', '淅川县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1629', '411327', '社旗县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1630', '411328', '唐河县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1631', '411329', '新野县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1632', '411330', '桐柏县', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1633', '411381', '邓州市', '411300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1634', '411400', '商丘市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1635', '411402', '梁园区', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1636', '411403', '睢阳区', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1637', '411421', '民权县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1638', '411422', '睢县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1639', '411423', '宁陵县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1640', '411424', '柘城县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1641', '411425', '虞城县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1642', '411426', '夏邑县', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1643', '411481', '永城市', '411400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1644', '411500', '信阳市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1645', '411502', '浉河区', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1646', '411503', '平桥区', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1647', '411521', '罗山县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1648', '411522', '光山县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1649', '411523', '新县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1650', '411524', '商城县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1651', '411525', '固始县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1652', '411526', '潢川县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1653', '411527', '淮滨县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1654', '411528', '息县', '411500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1655', '411600', '周口市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1656', '411602', '川汇区', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1657', '411621', '扶沟县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1658', '411622', '西华县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1659', '411623', '商水县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1660', '411624', '沈丘县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1661', '411625', '郸城县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1662', '411626', '淮阳县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1663', '411627', '太康县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1664', '411628', '鹿邑县', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1665', '411681', '项城市', '411600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1666', '411700', '驻马店市', '410000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1667', '411702', '驿城区', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1668', '411721', '西平县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1669', '411722', '上蔡县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1670', '411723', '平舆县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1671', '411724', '正阳县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1672', '411725', '确山县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1673', '411726', '泌阳县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1674', '411727', '汝南县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1675', '411728', '遂平县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1676', '411729', '新蔡县', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1677', '419001', '济源市', '411700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1678', '420000', '湖北省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1679', '420100', '武汉市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1680', '420102', '江岸区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1681', '420103', '江汉区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1682', '420104', '硚口区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1683', '420105', '汉阳区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1684', '420106', '武昌区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1685', '420107', '青山区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1686', '420111', '洪山区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1687', '420112', '东西湖区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1688', '420113', '汉南区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1689', '420114', '蔡甸区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1690', '420115', '江夏区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1691', '420116', '黄陂区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1692', '420117', '新洲区', '420100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1693', '420200', '黄石市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1694', '420202', '黄石港区', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1695', '420203', '西塞山区', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1696', '420204', '下陆区', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1697', '420205', '铁山区', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1698', '420222', '阳新县', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1699', '420281', '大冶市', '420200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1700', '420300', '十堰市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1701', '420302', '茅箭区', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1702', '420303', '张湾区', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1703', '420304', '郧阳区', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1704', '420322', '郧西县', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1705', '420323', '竹山县', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1706', '420324', '竹溪县', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1707', '420325', '房县', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1708', '420381', '丹江口市', '420300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1709', '420500', '宜昌市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1710', '420502', '西陵区', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1711', '420503', '伍家岗区', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1712', '420504', '点军区', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1713', '420505', '猇亭区', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1714', '420506', '夷陵区', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1715', '420525', '远安县', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1716', '420526', '兴山县', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1717', '420527', '秭归县', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1718', '420528', '长阳土家族自治县', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1719', '420529', '五峰土家族自治县', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1720', '420581', '宜都市', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1721', '420582', '当阳市', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1722', '420583', '枝江市', '420500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1723', '420600', '襄阳市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1724', '420602', '襄城区', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1725', '420606', '樊城区', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1726', '420607', '襄州区', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1727', '420624', '南漳县', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1728', '420625', '谷城县', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1729', '420626', '保康县', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1730', '420682', '老河口市', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1731', '420683', '枣阳市', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1732', '420684', '宜城市', '420600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1733', '420700', '鄂州市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1734', '420702', '梁子湖区', '420700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1735', '420703', '华容区', '420700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1736', '420704', '鄂城区', '420700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1737', '420800', '荆门市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1738', '420802', '东宝区', '420800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1739', '420804', '掇刀区', '420800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1740', '420821', '京山县', '420800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1741', '420822', '沙洋县', '420800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1742', '420881', '钟祥市', '420800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1743', '420900', '孝感市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1744', '420902', '孝南区', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1745', '420921', '孝昌县', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1746', '420922', '大悟县', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1747', '420923', '云梦县', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1748', '420981', '应城市', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1749', '420982', '安陆市', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1750', '420984', '汉川市', '420900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1751', '421000', '荆州市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1752', '421002', '沙市区', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1753', '421003', '荆州区', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1754', '421022', '公安县', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1755', '421023', '监利县', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1756', '421024', '江陵县', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1757', '421081', '石首市', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1758', '421083', '洪湖市', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1759', '421087', '松滋市', '421000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1760', '421100', '黄冈市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1761', '421102', '黄州区', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1762', '421121', '团风县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1763', '421122', '红安县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1764', '421123', '罗田县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1765', '421124', '英山县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1766', '421125', '浠水县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1767', '421126', '蕲春县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1768', '421127', '黄梅县', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1769', '421181', '麻城市', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1770', '421182', '武穴市', '421100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1771', '421200', '咸宁市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1772', '421202', '咸安区', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1773', '421221', '嘉鱼县', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1774', '421222', '通城县', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1775', '421223', '崇阳县', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1776', '421224', '通山县', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1777', '421281', '赤壁市', '421200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1778', '421300', '随州市', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1779', '421303', '曾都区', '421300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1780', '421321', '随县', '421300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1781', '421381', '广水市', '421300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1782', '422800', '恩施土家族苗族自治州', '420000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1783', '422801', '恩施市', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1784', '422802', '利川市', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1785', '422822', '建始县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1786', '422823', '巴东县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1787', '422825', '宣恩县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1788', '422826', '咸丰县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1789', '422827', '来凤县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1790', '422828', '鹤峰县', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1791', '429004', '仙桃市', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1792', '429005', '潜江市', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1793', '429006', '天门市', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1794', '429021', '神农架林区', '422800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1795', '430000', '湖南省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1796', '430100', '长沙市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1797', '430102', '芙蓉区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1798', '430103', '天心区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1799', '430104', '岳麓区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1800', '430105', '开福区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1801', '430111', '雨花区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1802', '430112', '望城区', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1803', '430121', '长沙县', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1804', '430181', '浏阳市', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1805', '430182', '宁乡市', '430100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1806', '430200', '株洲市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1807', '430202', '荷塘区', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1808', '430203', '芦淞区', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1809', '430204', '石峰区', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1810', '430211', '天元区', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1811', '430221', '株洲县', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1812', '430223', '攸县', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1813', '430224', '茶陵县', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1814', '430225', '炎陵县', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1815', '430281', '醴陵市', '430200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1816', '430300', '湘潭市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1817', '430302', '雨湖区', '430300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1818', '430304', '岳塘区', '430300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1819', '430321', '湘潭县', '430300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1820', '430381', '湘乡市', '430300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1821', '430382', '韶山市', '430300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1822', '430400', '衡阳市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1823', '430405', '珠晖区', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1824', '430406', '雁峰区', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1825', '430407', '石鼓区', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1826', '430408', '蒸湘区', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1827', '430412', '南岳区', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1828', '430421', '衡阳县', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1829', '430422', '衡南县', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1830', '430423', '衡山县', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1831', '430424', '衡东县', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1832', '430426', '祁东县', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1833', '430481', '耒阳市', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1834', '430482', '常宁市', '430400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1835', '430500', '邵阳市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1836', '430502', '双清区', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1837', '430503', '大祥区', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1838', '430511', '北塔区', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1839', '430521', '邵东县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1840', '430522', '新邵县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1841', '430523', '邵阳县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1842', '430524', '隆回县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1843', '430525', '洞口县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1844', '430527', '绥宁县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1845', '430528', '新宁县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1846', '430529', '城步苗族自治县', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1847', '430581', '武冈市', '430500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1848', '430600', '岳阳市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1849', '430602', '岳阳楼区', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1850', '430603', '云溪区', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1851', '430611', '君山区', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1852', '430621', '岳阳县', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1853', '430623', '华容县', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1854', '430624', '湘阴县', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1855', '430626', '平江县', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1856', '430681', '汨罗市', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1857', '430682', '临湘市', '430600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1858', '430700', '常德市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1859', '430702', '武陵区', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1860', '430703', '鼎城区', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1861', '430721', '安乡县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1862', '430722', '汉寿县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1863', '430723', '澧县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1864', '430724', '临澧县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1865', '430725', '桃源县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1866', '430726', '石门县', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1867', '430781', '津市市', '430700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1868', '430800', '张家界市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1869', '430802', '永定区', '430800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1870', '430811', '武陵源区', '430800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1871', '430821', '慈利县', '430800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1872', '430822', '桑植县', '430800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1873', '430900', '益阳市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1874', '430902', '资阳区', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1875', '430903', '赫山区', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1876', '430921', '南县', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1877', '430922', '桃江县', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1878', '430923', '安化县', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1879', '430981', '沅江市', '430900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1880', '431000', '郴州市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1881', '431002', '北湖区', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1882', '431003', '苏仙区', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1883', '431021', '桂阳县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1884', '431022', '宜章县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1885', '431023', '永兴县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1886', '431024', '嘉禾县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1887', '431025', '临武县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1888', '431026', '汝城县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1889', '431027', '桂东县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1890', '431028', '安仁县', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1891', '431081', '资兴市', '431000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1892', '431100', '永州市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1893', '431102', '零陵区', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1894', '431103', '冷水滩区', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1895', '431121', '祁阳县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1896', '431122', '东安县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1897', '431123', '双牌县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1898', '431124', '道县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1899', '431125', '江永县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1900', '431126', '宁远县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1901', '431127', '蓝山县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1902', '431128', '新田县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1903', '431129', '江华瑶族自治县', '431100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1904', '431200', '怀化市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1905', '431202', '鹤城区', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1906', '431221', '中方县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1907', '431222', '沅陵县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1908', '431223', '辰溪县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1909', '431224', '溆浦县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1910', '431225', '会同县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1911', '431226', '麻阳苗族自治县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1912', '431227', '新晃侗族自治县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1913', '431228', '芷江侗族自治县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1914', '431229', '靖州苗族侗族自治县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1915', '431230', '通道侗族自治县', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1916', '431281', '洪江市', '431200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1917', '431300', '娄底市', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1918', '431302', '娄星区', '431300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1919', '431321', '双峰县', '431300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1920', '431322', '新化县', '431300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1921', '431381', '冷水江市', '431300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1922', '431382', '涟源市', '431300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1923', '433100', '湘西土家族苗族自治州', '430000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1924', '433101', '吉首市', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1925', '433122', '泸溪县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1926', '433123', '凤凰县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1927', '433124', '花垣县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1928', '433125', '保靖县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1929', '433126', '古丈县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1930', '433127', '永顺县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1931', '433130', '龙山县', '433100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1932', '440000', '广东省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1933', '440100', '广州市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1934', '440103', '荔湾区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1935', '440104', '越秀区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1936', '440105', '海珠区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1937', '440106', '天河区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1938', '440111', '白云区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1939', '440112', '黄埔区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1940', '440113', '番禺区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1941', '440114', '花都区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1942', '440115', '南沙区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1943', '440117', '从化区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1944', '440118', '增城区', '440100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1945', '440200', '韶关市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1946', '440203', '武江区', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1947', '440204', '浈江区', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1948', '440205', '曲江区', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1949', '440222', '始兴县', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1950', '440224', '仁化县', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1951', '440229', '翁源县', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1952', '440232', '乳源瑶族自治县', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1953', '440233', '新丰县', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1954', '440281', '乐昌市', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1955', '440282', '南雄市', '440200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1956', '440300', '深圳市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1957', '440303', '罗湖区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1958', '440304', '福田区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1959', '440305', '南山区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1960', '440306', '宝安区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1961', '440307', '龙岗区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1962', '440308', '盐田区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1963', '440309', '龙华区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1964', '440310', '坪山区', '440300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1965', '440400', '珠海市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1966', '440402', '香洲区', '440400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1967', '440403', '斗门区', '440400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1968', '440404', '金湾区', '440400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1969', '440499', '香洲区(由澳门特别行政区实施管辖)', '440400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1970', '440500', '汕头市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1971', '440507', '龙湖区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1972', '440511', '金平区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1973', '440512', '濠江区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1974', '440513', '潮阳区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1975', '440514', '潮南区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1976', '440515', '澄海区', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1977', '440523', '南澳县', '440500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1978', '440600', '佛山市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1979', '440604', '禅城区', '440600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1980', '440605', '南海区', '440600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1981', '440606', '顺德区', '440600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1982', '440607', '三水区', '440600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1983', '440608', '高明区', '440600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1984', '440700', '江门市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1985', '440703', '蓬江区', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1986', '440704', '江海区', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1987', '440705', '新会区', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1988', '440781', '台山市', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1989', '440783', '开平市', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1990', '440784', '鹤山市', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1991', '440785', '恩平市', '440700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1992', '440800', '湛江市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1993', '440802', '赤坎区', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1994', '440803', '霞山区', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1995', '440804', '坡头区', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1996', '440811', '麻章区', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1997', '440823', '遂溪县', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1998', '440825', '徐闻县', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('1999', '440881', '廉江市', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2000', '440882', '雷州市', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2001', '440883', '吴川市', '440800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2002', '440900', '茂名市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2003', '440902', '茂南区', '440900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2004', '440904', '电白区', '440900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2005', '440981', '高州市', '440900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2006', '440982', '化州市', '440900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2007', '440983', '信宜市', '440900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2008', '441200', '肇庆市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2009', '441202', '端州区', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2010', '441203', '鼎湖区', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2011', '441204', '高要区', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2012', '441223', '广宁县', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2013', '441224', '怀集县', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2014', '441225', '封开县', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2015', '441226', '德庆县', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2016', '441284', '四会市', '441200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2017', '441300', '惠州市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2018', '441302', '惠城区', '441300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2019', '441303', '惠阳区', '441300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2020', '441322', '博罗县', '441300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2021', '441323', '惠东县', '441300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2022', '441324', '龙门县', '441300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2023', '441400', '梅州市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2024', '441402', '梅江区', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2025', '441403', '梅县区', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2026', '441422', '大埔县', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2027', '441423', '丰顺县', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2028', '441424', '五华县', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2029', '441426', '平远县', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2030', '441427', '蕉岭县', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2031', '441481', '兴宁市', '441400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2032', '441500', '汕尾市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2033', '441502', '城区', '441500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2034', '441521', '海丰县', '441500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2035', '441523', '陆河县', '441500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2036', '441581', '陆丰市', '441500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2037', '441600', '河源市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2038', '441602', '源城区', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2039', '441621', '紫金县', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2040', '441622', '龙川县', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2041', '441623', '连平县', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2042', '441624', '和平县', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2043', '441625', '东源县', '441600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2044', '441700', '阳江市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2045', '441702', '江城区', '441700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2046', '441704', '阳东区', '441700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2047', '441721', '阳西县', '441700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2048', '441781', '阳春市', '441700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2049', '441800', '清远市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2050', '441802', '清城区', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2051', '441803', '清新区', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2052', '441821', '佛冈县', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2053', '441823', '阳山县', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2054', '441825', '连山壮族瑶族自治县', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2055', '441826', '连南瑶族自治县', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2056', '441881', '英德市', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2057', '441882', '连州市', '441800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2058', '441900', '东莞市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2059', '442000', '中山市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2060', '445100', '潮州市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2061', '445102', '湘桥区', '445100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2062', '445103', '潮安区', '445100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2063', '445122', '饶平县', '445100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2064', '445200', '揭阳市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2065', '445202', '榕城区', '445200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2066', '445203', '揭东区', '445200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2067', '445222', '揭西县', '445200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2068', '445224', '惠来县', '445200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2069', '445281', '普宁市', '445200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2070', '445300', '云浮市', '440000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2071', '445302', '云城区', '445300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2072', '445303', '云安区', '445300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2073', '445321', '新兴县', '445300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2074', '445322', '郁南县', '445300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2075', '445381', '罗定市', '445300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2076', '450000', '广西壮族自治区', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2077', '450100', '南宁市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2078', '450102', '兴宁区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2079', '450103', '青秀区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2080', '450105', '江南区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2081', '450107', '西乡塘区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2082', '450108', '良庆区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2083', '450109', '邕宁区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2084', '450110', '武鸣区', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2085', '450123', '隆安县', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2086', '450124', '马山县', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2087', '450125', '上林县', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2088', '450126', '宾阳县', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2089', '450127', '横县', '450100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2090', '450200', '柳州市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2091', '450202', '城中区', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2092', '450203', '鱼峰区', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2093', '450204', '柳南区', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2094', '450205', '柳北区', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2095', '450206', '柳江区', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2096', '450222', '柳城县', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2097', '450223', '鹿寨县', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2098', '450224', '融安县', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2099', '450225', '融水苗族自治县', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2100', '450226', '三江侗族自治县', '450200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2101', '450300', '桂林市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2102', '450302', '秀峰区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2103', '450303', '叠彩区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2104', '450304', '象山区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2105', '450305', '七星区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2106', '450311', '雁山区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2107', '450312', '临桂区', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2108', '450321', '阳朔县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2109', '450323', '灵川县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2110', '450324', '全州县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2111', '450325', '兴安县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2112', '450326', '永福县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2113', '450327', '灌阳县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2114', '450328', '龙胜各族自治县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2115', '450329', '资源县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2116', '450330', '平乐县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2117', '450331', '荔浦县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2118', '450332', '恭城瑶族自治县', '450300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2119', '450400', '梧州市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2120', '450403', '万秀区', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2121', '450405', '长洲区', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2122', '450406', '龙圩区', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2123', '450421', '苍梧县', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2124', '450422', '藤县', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2125', '450423', '蒙山县', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2126', '450481', '岑溪市', '450400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2127', '450500', '北海市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2128', '450502', '海城区', '450500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2129', '450503', '银海区', '450500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2130', '450512', '铁山港区', '450500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2131', '450521', '合浦县', '450500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2132', '450600', '防城港市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2133', '450602', '港口区', '450600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2134', '450603', '防城区', '450600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2135', '450621', '上思县', '450600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2136', '450681', '东兴市', '450600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2137', '450700', '钦州市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2138', '450702', '钦南区', '450700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2139', '450703', '钦北区', '450700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2140', '450721', '灵山县', '450700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2141', '450722', '浦北县', '450700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2142', '450800', '贵港市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2143', '450802', '港北区', '450800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2144', '450803', '港南区', '450800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2145', '450804', '覃塘区', '450800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2146', '450821', '平南县', '450800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2147', '450881', '桂平市', '450800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2148', '450900', '玉林市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2149', '450902', '玉州区', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2150', '450903', '福绵区', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2151', '450921', '容县', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2152', '450922', '陆川县', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2153', '450923', '博白县', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2154', '450924', '兴业县', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2155', '450981', '北流市', '450900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2156', '451000', '百色市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2157', '451002', '右江区', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2158', '451021', '田阳县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2159', '451022', '田东县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2160', '451023', '平果县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2161', '451024', '德保县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2162', '451026', '那坡县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2163', '451027', '凌云县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2164', '451028', '乐业县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2165', '451029', '田林县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2166', '451030', '西林县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2167', '451031', '隆林各族自治县', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2168', '451081', '靖西市', '451000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2169', '451100', '贺州市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2170', '451102', '八步区', '451100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2171', '451103', '平桂区', '451100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2172', '451121', '昭平县', '451100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2173', '451122', '钟山县', '451100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2174', '451123', '富川瑶族自治县', '451100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2175', '451200', '河池市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2176', '451202', '金城江区', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2177', '451203', '宜州区', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2178', '451221', '南丹县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2179', '451222', '天峨县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2180', '451223', '凤山县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2181', '451224', '东兰县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2182', '451225', '罗城仫佬族自治县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2183', '451226', '环江毛南族自治县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2184', '451227', '巴马瑶族自治县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2185', '451228', '都安瑶族自治县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2186', '451229', '大化瑶族自治县', '451200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2187', '451300', '来宾市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2188', '451302', '兴宾区', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2189', '451321', '忻城县', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2190', '451322', '象州县', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2191', '451323', '武宣县', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2192', '451324', '金秀瑶族自治县', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2193', '451381', '合山市', '451300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2194', '451400', '崇左市', '450000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2195', '451402', '江州区', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2196', '451421', '扶绥县', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2197', '451422', '宁明县', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2198', '451423', '龙州县', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2199', '451424', '大新县', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2200', '451425', '天等县', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2201', '451481', '凭祥市', '451400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2202', '460000', '海南省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2203', '460100', '海口市', '460000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2204', '460105', '秀英区', '460100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2205', '460106', '龙华区', '460100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2206', '460107', '琼山区', '460100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2207', '460108', '美兰区', '460100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2208', '460200', '三亚市', '460000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2209', '460202', '海棠区', '460200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2210', '460203', '吉阳区', '460200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2211', '460204', '天涯区', '460200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2212', '460205', '崖州区', '460200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2213', '460300', '三沙市', '460000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2214', '460321', '西沙群岛', '460300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2215', '460322', '南沙群岛', '460300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2216', '460323', '中沙群岛的岛礁及其海域', '460300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2217', '460400', '儋州市', '460000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2218', '469001', '五指山市', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2219', '469002', '琼海市', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2220', '469005', '文昌市', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2221', '469006', '万宁市', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2222', '469007', '东方市', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2223', '469021', '定安县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2224', '469022', '屯昌县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2225', '469023', '澄迈县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2226', '469024', '临高县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2227', '469025', '白沙黎族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2228', '469026', '昌江黎族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2229', '469027', '乐东黎族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2230', '469028', '陵水黎族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2231', '469029', '保亭黎族苗族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2232', '469030', '琼中黎族苗族自治县', '460400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2233', '500000', '重庆市', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2234', '500101', '万州区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2235', '500102', '涪陵区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2236', '500103', '渝中区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2237', '500104', '大渡口区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2238', '500105', '江北区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2239', '500106', '沙坪坝区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2240', '500107', '九龙坡区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2241', '500108', '南岸区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2242', '500109', '北碚区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2243', '500110', '綦江区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2244', '500111', '大足区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2245', '500112', '渝北区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2246', '500113', '巴南区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2247', '500114', '黔江区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2248', '500115', '长寿区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2249', '500116', '江津区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2250', '500117', '合川区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2251', '500118', '永川区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2252', '500119', '南川区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2253', '500120', '璧山区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2254', '500151', '铜梁区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2255', '500152', '潼南区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2256', '500153', '荣昌区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2257', '500154', '开州区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2258', '500155', '梁平区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2259', '500156', '武隆区', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2260', '500229', '城口县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2261', '500230', '丰都县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2262', '500231', '垫江县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2263', '500233', '忠县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2264', '500235', '云阳县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2265', '500236', '奉节县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2266', '500237', '巫山县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2267', '500238', '巫溪县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2268', '500240', '石柱土家族自治县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2269', '500241', '秀山土家族苗族自治县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2270', '500242', '酉阳土家族苗族自治县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2271', '500243', '彭水苗族土家族自治县', '500000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2272', '510000', '四川省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2273', '510100', '成都市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2274', '510104', '锦江区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2275', '510105', '青羊区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2276', '510106', '金牛区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2277', '510107', '武侯区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2278', '510108', '成华区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2279', '510112', '龙泉驿区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2280', '510113', '青白江区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2281', '510114', '新都区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2282', '510115', '温江区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2283', '510116', '双流区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2284', '510117', '郫都区', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2285', '510121', '金堂县', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2286', '510129', '大邑县', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2287', '510131', '蒲江县', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2288', '510132', '新津县', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2289', '510181', '都江堰市', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2290', '510182', '彭州市', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2291', '510183', '邛崃市', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2292', '510184', '崇州市', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2293', '510185', '简阳市', '510100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2294', '510300', '自贡市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2295', '510302', '自流井区', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2296', '510303', '贡井区', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2297', '510304', '大安区', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2298', '510311', '沿滩区', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2299', '510321', '荣县', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2300', '510322', '富顺县', '510300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2301', '510400', '攀枝花市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2302', '510402', '东区', '510400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2303', '510403', '西区', '510400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2304', '510411', '仁和区', '510400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2305', '510421', '米易县', '510400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2306', '510422', '盐边县', '510400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2307', '510500', '泸州市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2308', '510502', '江阳区', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2309', '510503', '纳溪区', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2310', '510504', '龙马潭区', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2311', '510521', '泸县', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2312', '510522', '合江县', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2313', '510524', '叙永县', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2314', '510525', '古蔺县', '510500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2315', '510600', '德阳市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2316', '510603', '旌阳区', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2317', '510623', '中江县', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2318', '510626', '罗江县', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2319', '510681', '广汉市', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2320', '510682', '什邡市', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2321', '510683', '绵竹市', '510600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2322', '510700', '绵阳市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2323', '510703', '涪城区', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2324', '510704', '游仙区', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2325', '510705', '安州区', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2326', '510722', '三台县', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2327', '510723', '盐亭县', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2328', '510725', '梓潼县', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2329', '510726', '北川羌族自治县', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2330', '510727', '平武县', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2331', '510781', '江油市', '510700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2332', '510800', '广元市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2333', '510802', '利州区', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2334', '510811', '昭化区', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2335', '510812', '朝天区', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2336', '510821', '旺苍县', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2337', '510822', '青川县', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2338', '510823', '剑阁县', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2339', '510824', '苍溪县', '510800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2340', '510900', '遂宁市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2341', '510903', '船山区', '510900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2342', '510904', '安居区', '510900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2343', '510921', '蓬溪县', '510900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2344', '510922', '射洪县', '510900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2345', '510923', '大英县', '510900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2346', '511000', '内江市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2347', '511002', '市中区', '511000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2348', '511011', '东兴区', '511000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2349', '511024', '威远县', '511000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2350', '511025', '资中县', '511000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2351', '511083', '隆昌市', '511000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2352', '511100', '乐山市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2353', '511102', '市中区', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2354', '511111', '沙湾区', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2355', '511112', '五通桥区', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2356', '511113', '金口河区', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2357', '511123', '犍为县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2358', '511124', '井研县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2359', '511126', '夹江县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2360', '511129', '沐川县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2361', '511132', '峨边彝族自治县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2362', '511133', '马边彝族自治县', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2363', '511181', '峨眉山市', '511100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2364', '511300', '南充市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2365', '511302', '顺庆区', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2366', '511303', '高坪区', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2367', '511304', '嘉陵区', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2368', '511321', '南部县', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2369', '511322', '营山县', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2370', '511323', '蓬安县', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2371', '511324', '仪陇县', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2372', '511325', '西充县', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2373', '511381', '阆中市', '511300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2374', '511400', '眉山市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2375', '511402', '东坡区', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2376', '511403', '彭山区', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2377', '511421', '仁寿县', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2378', '511423', '洪雅县', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2379', '511424', '丹棱县', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2380', '511425', '青神县', '511400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2381', '511500', '宜宾市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2382', '511502', '翠屏区', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2383', '511503', '南溪区', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2384', '511521', '宜宾县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2385', '511523', '江安县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2386', '511524', '长宁县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2387', '511525', '高县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2388', '511526', '珙县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2389', '511527', '筠连县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2390', '511528', '兴文县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2391', '511529', '屏山县', '511500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2392', '511600', '广安市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2393', '511602', '广安区', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2394', '511603', '前锋区', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2395', '511621', '岳池县', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2396', '511622', '武胜县', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2397', '511623', '邻水县', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2398', '511681', '华蓥市', '511600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2399', '511700', '达州市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2400', '511702', '通川区', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2401', '511703', '达川区', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2402', '511722', '宣汉县', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2403', '511723', '开江县', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2404', '511724', '大竹县', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2405', '511725', '渠县', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2406', '511781', '万源市', '511700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2407', '511800', '雅安市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2408', '511802', '雨城区', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2409', '511803', '名山区', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2410', '511822', '荥经县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2411', '511823', '汉源县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2412', '511824', '石棉县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2413', '511825', '天全县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2414', '511826', '芦山县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2415', '511827', '宝兴县', '511800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2416', '511900', '巴中市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2417', '511902', '巴州区', '511900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2418', '511903', '恩阳区', '511900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2419', '511921', '通江县', '511900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2420', '511922', '南江县', '511900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2421', '511923', '平昌县', '511900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2422', '512000', '资阳市', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2423', '512002', '雁江区', '512000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2424', '512021', '安岳县', '512000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2425', '512022', '乐至县', '512000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2426', '513200', '阿坝藏族羌族自治州', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2427', '513201', '马尔康市', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2428', '513221', '汶川县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2429', '513222', '理县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2430', '513223', '茂县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2431', '513224', '松潘县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2432', '513225', '九寨沟县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2433', '513226', '金川县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2434', '513227', '小金县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2435', '513228', '黑水县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2436', '513230', '壤塘县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2437', '513231', '阿坝县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2438', '513232', '若尔盖县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2439', '513233', '红原县', '513200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2440', '513300', '甘孜藏族自治州', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2441', '513301', '康定市', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2442', '513322', '泸定县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2443', '513323', '丹巴县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2444', '513324', '九龙县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2445', '513325', '雅江县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2446', '513326', '道孚县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2447', '513327', '炉霍县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2448', '513328', '甘孜县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2449', '513329', '新龙县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2450', '513330', '德格县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2451', '513331', '白玉县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2452', '513332', '石渠县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2453', '513333', '色达县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2454', '513334', '理塘县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2455', '513335', '巴塘县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2456', '513336', '乡城县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2457', '513337', '稻城县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2458', '513338', '得荣县', '513300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2459', '513400', '凉山彝族自治州', '510000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2460', '513401', '西昌市', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2461', '513422', '木里藏族自治县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2462', '513423', '盐源县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2463', '513424', '德昌县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2464', '513425', '会理县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2465', '513426', '会东县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2466', '513427', '宁南县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2467', '513428', '普格县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2468', '513429', '布拖县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2469', '513430', '金阳县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2470', '513431', '昭觉县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2471', '513432', '喜德县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2472', '513433', '冕宁县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2473', '513434', '越西县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2474', '513435', '甘洛县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2475', '513436', '美姑县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2476', '513437', '雷波县', '513400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2477', '520000', '贵州省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2478', '520100', '贵阳市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2479', '520102', '南明区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2480', '520103', '云岩区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2481', '520111', '花溪区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2482', '520112', '乌当区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2483', '520113', '白云区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2484', '520115', '观山湖区', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2485', '520121', '开阳县', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2486', '520122', '息烽县', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2487', '520123', '修文县', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2488', '520181', '清镇市', '520100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2489', '520200', '六盘水市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2490', '520201', '钟山区', '520200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2491', '520203', '六枝特区', '520200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2492', '520221', '水城县', '520200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2493', '520281', '盘州市', '520200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2494', '520300', '遵义市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2495', '520302', '红花岗区', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2496', '520303', '汇川区', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2497', '520304', '播州区', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2498', '520322', '桐梓县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2499', '520323', '绥阳县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2500', '520324', '正安县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2501', '520325', '道真仡佬族苗族自治县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2502', '520326', '务川仡佬族苗族自治县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2503', '520327', '凤冈县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2504', '520328', '湄潭县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2505', '520329', '余庆县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2506', '520330', '习水县', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2507', '520381', '赤水市', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2508', '520382', '仁怀市', '520300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2509', '520400', '安顺市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2510', '520402', '西秀区', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2511', '520403', '平坝区', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2512', '520422', '普定县', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2513', '520423', '镇宁布依族苗族自治县', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2514', '520424', '关岭布依族苗族自治县', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2515', '520425', '紫云苗族布依族自治县', '520400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2516', '520500', '毕节市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2517', '520502', '七星关区', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2518', '520521', '大方县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2519', '520522', '黔西县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2520', '520523', '金沙县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2521', '520524', '织金县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2522', '520525', '纳雍县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2523', '520526', '威宁彝族回族苗族自治县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2524', '520527', '赫章县', '520500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2525', '520600', '铜仁市', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2526', '520602', '碧江区', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2527', '520603', '万山区', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2528', '520621', '江口县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2529', '520622', '玉屏侗族自治县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2530', '520623', '石阡县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2531', '520624', '思南县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2532', '520625', '印江土家族苗族自治县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2533', '520626', '德江县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2534', '520627', '沿河土家族自治县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2535', '520628', '松桃苗族自治县', '520600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2536', '522300', '黔西南布依族苗族自治州', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2537', '522301', '兴义市', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2538', '522322', '兴仁县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2539', '522323', '普安县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2540', '522324', '晴隆县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2541', '522325', '贞丰县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2542', '522326', '望谟县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2543', '522327', '册亨县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2544', '522328', '安龙县', '522300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2545', '522600', '黔东南苗族侗族自治州', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2546', '522601', '凯里市', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2547', '522622', '黄平县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2548', '522623', '施秉县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2549', '522624', '三穗县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2550', '522625', '镇远县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2551', '522626', '岑巩县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2552', '522627', '天柱县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2553', '522628', '锦屏县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2554', '522629', '剑河县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2555', '522630', '台江县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2556', '522631', '黎平县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2557', '522632', '榕江县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2558', '522633', '从江县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2559', '522634', '雷山县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2560', '522635', '麻江县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2561', '522636', '丹寨县', '522600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2562', '522700', '黔南布依族苗族自治州', '520000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2563', '522701', '都匀市', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2564', '522702', '福泉市', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2565', '522722', '荔波县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2566', '522723', '贵定县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2567', '522725', '瓮安县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2568', '522726', '独山县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2569', '522727', '平塘县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2570', '522728', '罗甸县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2571', '522729', '长顺县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2572', '522730', '龙里县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2573', '522731', '惠水县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2574', '522732', '三都水族自治县', '522700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2575', '530000', '云南省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2576', '530100', '昆明市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2577', '530102', '五华区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2578', '530103', '盘龙区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2579', '530111', '官渡区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2580', '530112', '西山区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2581', '530113', '东川区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2582', '530114', '呈贡区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2583', '530115', '晋宁区', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2584', '530124', '富民县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2585', '530125', '宜良县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2586', '530126', '石林彝族自治县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2587', '530127', '嵩明县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2588', '530128', '禄劝彝族苗族自治县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2589', '530129', '寻甸回族彝族自治县', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2590', '530181', '安宁市', '530100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2591', '530300', '曲靖市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2592', '530302', '麒麟区', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2593', '530303', '沾益区', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2594', '530321', '马龙县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2595', '530322', '陆良县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2596', '530323', '师宗县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2597', '530324', '罗平县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2598', '530325', '富源县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2599', '530326', '会泽县', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2600', '530381', '宣威市', '530300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2601', '530400', '玉溪市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2602', '530402', '红塔区', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2603', '530403', '江川区', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2604', '530422', '澄江县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2605', '530423', '通海县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2606', '530424', '华宁县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2607', '530425', '易门县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2608', '530426', '峨山彝族自治县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2609', '530427', '新平彝族傣族自治县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2610', '530428', '元江哈尼族彝族傣族自治县', '530400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2611', '530500', '保山市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2612', '530502', '隆阳区', '530500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2613', '530521', '施甸县', '530500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2614', '530523', '龙陵县', '530500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2615', '530524', '昌宁县', '530500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2616', '530581', '腾冲市', '530500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2617', '530600', '昭通市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2618', '530602', '昭阳区', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2619', '530621', '鲁甸县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2620', '530622', '巧家县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2621', '530623', '盐津县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2622', '530624', '大关县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2623', '530625', '永善县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2624', '530626', '绥江县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2625', '530627', '镇雄县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2626', '530628', '彝良县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2627', '530629', '威信县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2628', '530630', '水富县', '530600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2629', '530700', '丽江市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2630', '530702', '古城区', '530700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2631', '530721', '玉龙纳西族自治县', '530700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2632', '530722', '永胜县', '530700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2633', '530723', '华坪县', '530700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2634', '530724', '宁蒗彝族自治县', '530700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2635', '530800', '普洱市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2636', '530802', '思茅区', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2637', '530821', '宁洱哈尼族彝族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2638', '530822', '墨江哈尼族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2639', '530823', '景东彝族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2640', '530824', '景谷傣族彝族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2641', '530825', '镇沅彝族哈尼族拉祜族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2642', '530826', '江城哈尼族彝族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2643', '530827', '孟连傣族拉祜族佤族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2644', '530828', '澜沧拉祜族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2645', '530829', '西盟佤族自治县', '530800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2646', '530900', '临沧市', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2647', '530902', '临翔区', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2648', '530921', '凤庆县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2649', '530922', '云县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2650', '530923', '永德县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2651', '530924', '镇康县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2652', '530925', '双江拉祜族佤族布朗族傣族自治县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2653', '530926', '耿马傣族佤族自治县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2654', '530927', '沧源佤族自治县', '530900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2655', '532300', '楚雄彝族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2656', '532301', '楚雄市', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2657', '532322', '双柏县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2658', '532323', '牟定县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2659', '532324', '南华县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2660', '532325', '姚安县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2661', '532326', '大姚县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2662', '532327', '永仁县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2663', '532328', '元谋县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2664', '532329', '武定县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2665', '532331', '禄丰县', '532300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2666', '532500', '红河哈尼族彝族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2667', '532501', '个旧市', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2668', '532502', '开远市', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2669', '532503', '蒙自市', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2670', '532504', '弥勒市', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2671', '532523', '屏边苗族自治县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2672', '532524', '建水县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2673', '532525', '石屏县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2674', '532527', '泸西县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2675', '532528', '元阳县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2676', '532529', '红河县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2677', '532530', '金平苗族瑶族傣族自治县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2678', '532531', '绿春县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2679', '532532', '河口瑶族自治县', '532500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2680', '532600', '文山壮族苗族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2681', '532601', '文山市', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2682', '532622', '砚山县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2683', '532623', '西畴县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2684', '532624', '麻栗坡县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2685', '532625', '马关县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2686', '532626', '丘北县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2687', '532627', '广南县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2688', '532628', '富宁县', '532600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2689', '532800', '西双版纳傣族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2690', '532801', '景洪市', '532800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2691', '532822', '勐海县', '532800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2692', '532823', '勐腊县', '532800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2693', '532900', '大理白族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2694', '532901', '大理市', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2695', '532922', '漾濞彝族自治县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2696', '532923', '祥云县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2697', '532924', '宾川县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2698', '532925', '弥渡县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2699', '532926', '南涧彝族自治县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2700', '532927', '巍山彝族回族自治县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2701', '532928', '永平县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2702', '532929', '云龙县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2703', '532930', '洱源县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2704', '532931', '剑川县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2705', '532932', '鹤庆县', '532900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2706', '533100', '德宏傣族景颇族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2707', '533102', '瑞丽市', '533100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2708', '533103', '芒市', '533100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2709', '533122', '梁河县', '533100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2710', '533123', '盈江县', '533100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2711', '533124', '陇川县', '533100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2712', '533300', '怒江傈僳族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2713', '533301', '泸水市', '533300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2714', '533323', '福贡县', '533300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2715', '533324', '贡山独龙族怒族自治县', '533300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2716', '533325', '兰坪白族普米族自治县', '533300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2717', '533400', '迪庆藏族自治州', '530000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2718', '533401', '香格里拉市', '533400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2719', '533422', '德钦县', '533400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2720', '533423', '维西傈僳族自治县', '533400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2721', '540000', '西藏自治区', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2722', '540100', '拉萨市', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2723', '540102', '城关区', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2724', '540103', '堆龙德庆区', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2725', '540121', '林周县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2726', '540122', '当雄县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2727', '540123', '尼木县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2728', '540124', '曲水县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2729', '540126', '达孜县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2730', '540127', '墨竹工卡县', '540100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2731', '540200', '日喀则市', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2732', '540202', '桑珠孜区', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2733', '540221', '南木林县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2734', '540222', '江孜县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2735', '540223', '定日县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2736', '540224', '萨迦县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2737', '540225', '拉孜县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2738', '540226', '昂仁县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2739', '540227', '谢通门县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2740', '540228', '白朗县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2741', '540229', '仁布县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2742', '540230', '康马县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2743', '540231', '定结县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2744', '540232', '仲巴县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2745', '540233', '亚东县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2746', '540234', '吉隆县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2747', '540235', '聂拉木县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2748', '540236', '萨嘎县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2749', '540237', '岗巴县', '540200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2750', '540300', '昌都市', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2751', '540302', '卡若区', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2752', '540321', '江达县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2753', '540322', '贡觉县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2754', '540323', '类乌齐县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2755', '540324', '丁青县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2756', '540325', '察雅县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2757', '540326', '八宿县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2758', '540327', '左贡县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2759', '540328', '芒康县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2760', '540329', '洛隆县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2761', '540330', '边坝县', '540300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2762', '540400', '林芝市', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2763', '540402', '巴宜区', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2764', '540421', '工布江达县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2765', '540422', '米林县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2766', '540423', '墨脱县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2767', '540424', '波密县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2768', '540425', '察隅县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2769', '540426', '朗县', '540400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2770', '540500', '山南市', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2771', '540502', '乃东区', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2772', '540521', '扎囊县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2773', '540522', '贡嘎县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2774', '540523', '桑日县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2775', '540524', '琼结县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2776', '540525', '曲松县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2777', '540526', '措美县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2778', '540527', '洛扎县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2779', '540528', '加查县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2780', '540529', '隆子县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2781', '540530', '错那县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2782', '540531', '浪卡子县', '540500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2783', '542400', '那曲地区', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2784', '542421', '那曲县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2785', '542422', '嘉黎县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2786', '542423', '比如县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2787', '542424', '聂荣县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2788', '542425', '安多县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2789', '542426', '申扎县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2790', '542427', '索县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2791', '542428', '班戈县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2792', '542429', '巴青县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2793', '542430', '尼玛县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2794', '542431', '双湖县', '542400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2795', '542500', '阿里地区', '540000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2796', '542521', '普兰县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2797', '542522', '札达县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2798', '542523', '噶尔县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2799', '542524', '日土县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2800', '542525', '革吉县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2801', '542526', '改则县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2802', '542527', '措勤县', '542500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2803', '610000', '陕西省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2804', '610100', '西安市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2805', '610102', '新城区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2806', '610103', '碑林区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2807', '610104', '莲湖区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2808', '610111', '灞桥区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2809', '610112', '未央区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2810', '610113', '雁塔区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2811', '610114', '阎良区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2812', '610115', '临潼区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2813', '610116', '长安区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2814', '610117', '高陵区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2815', '610118', '鄠邑区', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2816', '610122', '蓝田县', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2817', '610124', '周至县', '610100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2818', '610200', '铜川市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2819', '610202', '王益区', '610200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2820', '610203', '印台区', '610200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2821', '610204', '耀州区', '610200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2822', '610222', '宜君县', '610200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2823', '610300', '宝鸡市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2824', '610302', '渭滨区', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2825', '610303', '金台区', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2826', '610304', '陈仓区', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2827', '610322', '凤翔县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2828', '610323', '岐山县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2829', '610324', '扶风县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2830', '610326', '眉县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2831', '610327', '陇县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2832', '610328', '千阳县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2833', '610329', '麟游县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2834', '610330', '凤县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2835', '610331', '太白县', '610300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2836', '610400', '咸阳市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2837', '610402', '秦都区', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2838', '610403', '杨陵区', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2839', '610404', '渭城区', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2840', '610422', '三原县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2841', '610423', '泾阳县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2842', '610424', '乾县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2843', '610425', '礼泉县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2844', '610426', '永寿县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2845', '610427', '彬县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2846', '610428', '长武县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2847', '610429', '旬邑县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2848', '610430', '淳化县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2849', '610431', '武功县', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2850', '610481', '兴平市', '610400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2851', '610500', '渭南市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2852', '610502', '临渭区', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2853', '610503', '华州区', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2854', '610522', '潼关县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2855', '610523', '大荔县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2856', '610524', '合阳县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2857', '610525', '澄城县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2858', '610526', '蒲城县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2859', '610527', '白水县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2860', '610528', '富平县', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2861', '610581', '韩城市', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2862', '610582', '华阴市', '610500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2863', '610600', '延安市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2864', '610602', '宝塔区', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2865', '610603', '安塞区', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2866', '610621', '延长县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2867', '610622', '延川县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2868', '610623', '子长县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2869', '610625', '志丹县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2870', '610626', '吴起县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2871', '610627', '甘泉县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2872', '610628', '富县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2873', '610629', '洛川县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2874', '610630', '宜川县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2875', '610631', '黄龙县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2876', '610632', '黄陵县', '610600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2877', '610700', '汉中市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2878', '610702', '汉台区', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2879', '610721', '南郑县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2880', '610722', '城固县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2881', '610723', '洋县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2882', '610724', '西乡县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2883', '610725', '勉县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2884', '610726', '宁强县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2885', '610727', '略阳县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2886', '610728', '镇巴县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2887', '610729', '留坝县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2888', '610730', '佛坪县', '610700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2889', '610800', '榆林市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2890', '610802', '榆阳区', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2891', '610803', '横山区', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2892', '610822', '府谷县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2893', '610824', '靖边县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2894', '610825', '定边县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2895', '610826', '绥德县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2896', '610827', '米脂县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2897', '610828', '佳县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2898', '610829', '吴堡县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2899', '610830', '清涧县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2900', '610831', '子洲县', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2901', '610881', '神木市', '610800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2902', '610900', '安康市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2903', '610902', '汉滨区', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2904', '610921', '汉阴县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2905', '610922', '石泉县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2906', '610923', '宁陕县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2907', '610924', '紫阳县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2908', '610925', '岚皋县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2909', '610926', '平利县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2910', '610927', '镇坪县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2911', '610928', '旬阳县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2912', '610929', '白河县', '610900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2913', '611000', '商洛市', '610000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2914', '611002', '商州区', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2915', '611021', '洛南县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2916', '611022', '丹凤县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2917', '611023', '商南县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2918', '611024', '山阳县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2919', '611025', '镇安县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2920', '611026', '柞水县', '611000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2921', '620000', '甘肃省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2922', '620100', '兰州市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2923', '620102', '城关区', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2924', '620103', '七里河区', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2925', '620104', '西固区', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2926', '620105', '安宁区', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2927', '620111', '红古区', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2928', '620121', '永登县', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2929', '620122', '皋兰县', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2930', '620123', '榆中县', '620100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2931', '620200', '嘉峪关市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2932', '620201', '嘉峪关市', '620200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2933', '620300', '金昌市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2934', '620302', '金川区', '620300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2935', '620321', '永昌县', '620300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2936', '620400', '白银市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2937', '620402', '白银区', '620400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2938', '620403', '平川区', '620400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2939', '620421', '靖远县', '620400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2940', '620422', '会宁县', '620400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2941', '620423', '景泰县', '620400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2942', '620500', '天水市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2943', '620502', '秦州区', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2944', '620503', '麦积区', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2945', '620521', '清水县', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2946', '620522', '秦安县', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2947', '620523', '甘谷县', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2948', '620524', '武山县', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2949', '620525', '张家川回族自治县', '620500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2950', '620600', '武威市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2951', '620602', '凉州区', '620600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2952', '620621', '民勤县', '620600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2953', '620622', '古浪县', '620600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2954', '620623', '天祝藏族自治县', '620600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2955', '620700', '张掖市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2956', '620702', '甘州区', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2957', '620721', '肃南裕固族自治县', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2958', '620722', '民乐县', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2959', '620723', '临泽县', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2960', '620724', '高台县', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2961', '620725', '山丹县', '620700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2962', '620800', '平凉市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2963', '620802', '崆峒区', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2964', '620821', '泾川县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2965', '620822', '灵台县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2966', '620823', '崇信县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2967', '620824', '华亭县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2968', '620825', '庄浪县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2969', '620826', '静宁县', '620800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2970', '620900', '酒泉市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2971', '620902', '肃州区', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2972', '620921', '金塔县', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2973', '620922', '瓜州县', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2974', '620923', '肃北蒙古族自治县', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2975', '620924', '阿克塞哈萨克族自治县', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2976', '620981', '玉门市', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2977', '620982', '敦煌市', '620900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2978', '621000', '庆阳市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2979', '621002', '西峰区', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2980', '621021', '庆城县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2981', '621022', '环县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2982', '621023', '华池县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2983', '621024', '合水县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2984', '621025', '正宁县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2985', '621026', '宁县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2986', '621027', '镇原县', '621000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2987', '621100', '定西市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2988', '621102', '安定区', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2989', '621121', '通渭县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2990', '621122', '陇西县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2991', '621123', '渭源县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2992', '621124', '临洮县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2993', '621125', '漳县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2994', '621126', '岷县', '621100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2995', '621200', '陇南市', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2996', '621202', '武都区', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2997', '621221', '成县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2998', '621222', '文县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('2999', '621223', '宕昌县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3000', '621224', '康县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3001', '621225', '西和县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3002', '621226', '礼县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3003', '621227', '徽县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3004', '621228', '两当县', '621200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3005', '622900', '临夏回族自治州', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3006', '622901', '临夏市', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3007', '622921', '临夏县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3008', '622922', '康乐县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3009', '622923', '永靖县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3010', '622924', '广河县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3011', '622925', '和政县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3012', '622926', '东乡族自治县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3013', '622927', '积石山保安族东乡族撒拉族自治县', '622900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3014', '623000', '甘南藏族自治州', '620000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3015', '623001', '合作市', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3016', '623021', '临潭县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3017', '623022', '卓尼县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3018', '623023', '舟曲县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3019', '623024', '迭部县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3020', '623025', '玛曲县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3021', '623026', '碌曲县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3022', '623027', '夏河县', '623000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3023', '630000', '青海省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3024', '630100', '西宁市', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3025', '630102', '城东区', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3026', '630103', '城中区', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3027', '630104', '城西区', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3028', '630105', '城北区', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3029', '630121', '大通回族土族自治县', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3030', '630122', '湟中县', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3031', '630123', '湟源县', '630100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3032', '630200', '海东市', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3033', '630202', '乐都区', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3034', '630203', '平安区', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3035', '630222', '民和回族土族自治县', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3036', '630223', '互助土族自治县', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3037', '630224', '化隆回族自治县', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3038', '630225', '循化撒拉族自治县', '630200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3039', '632200', '海北藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3040', '632221', '门源回族自治县', '632200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3041', '632222', '祁连县', '632200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3042', '632223', '海晏县', '632200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3043', '632224', '刚察县', '632200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3044', '632300', '黄南藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3045', '632321', '同仁县', '632300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3046', '632322', '尖扎县', '632300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3047', '632323', '泽库县', '632300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3048', '632324', '河南蒙古族自治县', '632300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3049', '632500', '海南藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3050', '632521', '共和县', '632500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3051', '632522', '同德县', '632500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3052', '632523', '贵德县', '632500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3053', '632524', '兴海县', '632500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3054', '632525', '贵南县', '632500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3055', '632600', '果洛藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3056', '632621', '玛沁县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3057', '632622', '班玛县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3058', '632623', '甘德县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3059', '632624', '达日县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3060', '632625', '久治县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3061', '632626', '玛多县', '632600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3062', '632700', '玉树藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3063', '632701', '玉树市', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3064', '632722', '杂多县', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3065', '632723', '称多县', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3066', '632724', '治多县', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3067', '632725', '囊谦县', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3068', '632726', '曲麻莱县', '632700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3069', '632800', '海西蒙古族藏族自治州', '630000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3070', '632801', '格尔木市', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3071', '632802', '德令哈市', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3072', '632821', '乌兰县', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3073', '632822', '都兰县', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3074', '632823', '天峻县', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3075', '632824', '冷湖行政区', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3076', '632825', '大柴旦行政区', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3077', '632826', '茫崖行政区', '632800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3078', '640000', '宁夏回族自治区', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3079', '640100', '银川市', '640000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3080', '640104', '兴庆区', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3081', '640105', '西夏区', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3082', '640106', '金凤区', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3083', '640121', '永宁县', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3084', '640122', '贺兰县', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3085', '640181', '灵武市', '640100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3086', '640200', '石嘴山市', '640000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3087', '640202', '大武口区', '640200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3088', '640205', '惠农区', '640200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3089', '640221', '平罗县', '640200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3090', '640300', '吴忠市', '640000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3091', '640302', '利通区', '640300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3092', '640303', '红寺堡区', '640300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3093', '640323', '盐池县', '640300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3094', '640324', '同心县', '640300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3095', '640381', '青铜峡市', '640300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3096', '640400', '固原市', '640000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3097', '640402', '原州区', '640400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3098', '640422', '西吉县', '640400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3099', '640423', '隆德县', '640400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3100', '640424', '泾源县', '640400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3101', '640425', '彭阳县', '640400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3102', '640500', '中卫市', '640000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3103', '640502', '沙坡头区', '640500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3104', '640521', '中宁县', '640500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3105', '640522', '海原县', '640500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3106', '650000', '新疆维吾尔自治区', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3107', '650100', '乌鲁木齐市', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3108', '650102', '天山区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3109', '650103', '沙依巴克区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3110', '650104', '新市区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3111', '650105', '水磨沟区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3112', '650106', '头屯河区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3113', '650107', '达坂城区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3114', '650109', '米东区', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3115', '650121', '乌鲁木齐县', '650100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3116', '650200', '克拉玛依市', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3117', '650202', '独山子区', '650200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3118', '650203', '克拉玛依区', '650200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3119', '650204', '白碱滩区', '650200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3120', '650205', '乌尔禾区', '650200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3121', '650400', '吐鲁番市', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3122', '650402', '高昌区', '650400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3123', '650421', '鄯善县', '650400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3124', '650422', '托克逊县', '650400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3125', '650500', '哈密市', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3126', '650502', '伊州区', '650500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3127', '650521', '巴里坤哈萨克自治县', '650500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3128', '650522', '伊吾县', '650500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3129', '652300', '昌吉回族自治州', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3130', '652301', '昌吉市', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3131', '652302', '阜康市', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3132', '652323', '呼图壁县', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3133', '652324', '玛纳斯县', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3134', '652325', '奇台县', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3135', '652327', '吉木萨尔县', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3136', '652328', '木垒哈萨克自治县', '652300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3137', '652700', '博尔塔拉蒙古自治州', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3138', '652701', '博乐市', '652700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3139', '652702', '阿拉山口市', '652700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3140', '652722', '精河县', '652700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3141', '652723', '温泉县', '652700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3142', '652800', '巴音郭楞蒙古自治州', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3143', '652801', '库尔勒市', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3144', '652822', '轮台县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3145', '652823', '尉犁县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3146', '652824', '若羌县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3147', '652825', '且末县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3148', '652826', '焉耆回族自治县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3149', '652827', '和静县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3150', '652828', '和硕县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3151', '652829', '博湖县', '652800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3152', '652900', '阿克苏地区', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3153', '652901', '阿克苏市', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3154', '652922', '温宿县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3155', '652923', '库车县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3156', '652924', '沙雅县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3157', '652925', '新和县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3158', '652926', '拜城县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3159', '652927', '乌什县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3160', '652928', '阿瓦提县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3161', '652929', '柯坪县', '652900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3162', '653000', '克孜勒苏柯尔克孜自治州', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3163', '653001', '阿图什市', '653000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3164', '653022', '阿克陶县', '653000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3165', '653023', '阿合奇县', '653000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3166', '653024', '乌恰县', '653000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3167', '653100', '喀什地区', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3168', '653101', '喀什市', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3169', '653121', '疏附县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3170', '653122', '疏勒县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3171', '653123', '英吉沙县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3172', '653124', '泽普县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3173', '653125', '莎车县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3174', '653126', '叶城县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3175', '653127', '麦盖提县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3176', '653128', '岳普湖县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3177', '653129', '伽师县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3178', '653130', '巴楚县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3179', '653131', '塔什库尔干塔吉克自治县', '653100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3180', '653200', '和田地区', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3181', '653201', '和田市', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3182', '653221', '和田县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3183', '653222', '墨玉县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3184', '653223', '皮山县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3185', '653224', '洛浦县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3186', '653225', '策勒县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3187', '653226', '于田县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3188', '653227', '民丰县', '653200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3189', '654000', '伊犁哈萨克自治州', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3190', '654002', '伊宁市', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3191', '654003', '奎屯市', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3192', '654004', '霍尔果斯市', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3193', '654021', '伊宁县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3194', '654022', '察布查尔锡伯自治县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3195', '654023', '霍城县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3196', '654024', '巩留县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3197', '654025', '新源县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3198', '654026', '昭苏县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3199', '654027', '特克斯县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3200', '654028', '尼勒克县', '654000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3201', '654200', '塔城地区', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3202', '654201', '塔城市', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3203', '654202', '乌苏市', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3204', '654221', '额敏县', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3205', '654223', '沙湾县', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3206', '654224', '托里县', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3207', '654225', '裕民县', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3208', '654226', '和布克赛尔蒙古自治县', '654200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3209', '654300', '阿勒泰地区', '650000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3210', '654301', '阿勒泰市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3211', '654321', '布尔津县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3212', '654322', '富蕴县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3213', '654323', '福海县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3214', '654324', '哈巴河县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3215', '654325', '青河县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3216', '654326', '吉木乃县', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3217', '659001', '石河子市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3218', '659002', '阿拉尔市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3219', '659003', '图木舒克市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3220', '659004', '五家渠市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3221', '659005', '北屯市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3222', '659006', '铁门关市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3223', '659007', '双河市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3224', '659008', '可克达拉市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3225', '659009', '昆玉市', '654300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3226', '710000', '台湾省', '000000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3227', '710100', '台北市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3228', '710101', '中正区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3229', '710102', '大同区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3230', '710103', '中山区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3231', '710104', '松山区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3232', '710105', '大安区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3233', '710106', '万华区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3234', '710107', '信义区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3235', '710108', '士林区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3236', '710109', '北投区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3237', '710110', '内湖区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3238', '710111', '南港区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3239', '710112', '文山区', '710100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3240', '710200', '高雄市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3241', '710201', '新兴区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3242', '710202', '前金区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3243', '710203', '苓雅区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3244', '710204', '盐埕区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3245', '710205', '鼓山区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3246', '710206', '旗津区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3247', '710207', '前镇区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3248', '710208', '三民区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3249', '710209', '左营区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3250', '710210', '楠梓区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3251', '710211', '小港区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3252', '710242', '仁武区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3253', '710243', '大社区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3254', '710244', '冈山区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3255', '710245', '路竹区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3256', '710246', '阿莲区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3257', '710247', '田寮区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3258', '710248', '燕巢区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3259', '710249', '桥头区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3260', '710250', '梓官区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3261', '710251', '弥陀区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3262', '710252', '永安区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3263', '710253', '湖内区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3264', '710254', '凤山区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3265', '710255', '大寮区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3266', '710256', '林园区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3267', '710257', '鸟松区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3268', '710258', '大树区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3269', '710259', '旗山区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3270', '710260', '美浓区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3271', '710261', '六龟区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3272', '710262', '内门区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3273', '710263', '杉林区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3274', '710264', '甲仙区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3275', '710265', '桃源区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3276', '710266', '那玛夏区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3277', '710267', '茂林区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3278', '710268', '茄萣区', '710200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3279', '710300', '台南市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3280', '710301', '中西区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3281', '710302', '东区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3282', '710303', '南区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3283', '710304', '北区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3284', '710305', '安平区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3285', '710306', '安南区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3286', '710339', '永康区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3287', '710340', '归仁区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3288', '710341', '新化区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3289', '710342', '左镇区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3290', '710343', '玉井区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3291', '710344', '楠西区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3292', '710345', '南化区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3293', '710346', '仁德区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3294', '710347', '关庙区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3295', '710348', '龙崎区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3296', '710349', '官田区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3297', '710350', '麻豆区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3298', '710351', '佳里区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3299', '710352', '西港区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3300', '710353', '七股区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3301', '710354', '将军区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3302', '710355', '学甲区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3303', '710356', '北门区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3304', '710357', '新营区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3305', '710358', '后壁区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3306', '710359', '白河区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3307', '710360', '东山区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3308', '710361', '六甲区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3309', '710362', '下营区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3310', '710363', '柳营区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3311', '710364', '盐水区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3312', '710365', '善化区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3313', '710366', '大内区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3314', '710367', '山上区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3315', '710368', '新市区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3316', '710369', '安定区', '710300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3317', '710400', '台中市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3318', '710401', '中区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3319', '710402', '东区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3320', '710403', '南区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3321', '710404', '西区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3322', '710405', '北区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3323', '710406', '北屯区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3324', '710407', '西屯区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3325', '710408', '南屯区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3326', '710431', '太平区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3327', '710432', '大里区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3328', '710433', '雾峰区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3329', '710434', '乌日区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3330', '710435', '丰原区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3331', '710436', '后里区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3332', '710437', '石冈区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3333', '710438', '东势区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3334', '710439', '和平区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3335', '710440', '新社区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3336', '710441', '潭子区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3337', '710442', '大雅区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3338', '710443', '神冈区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3339', '710444', '大肚区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3340', '710445', '沙鹿区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3341', '710446', '龙井区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3342', '710447', '梧栖区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3343', '710448', '清水区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3344', '710449', '大甲区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3345', '710450', '外埔区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3346', '710451', '大安区', '710400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3347', '710600', '南投县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3348', '710614', '南投市', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3349', '710615', '中寮乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3350', '710616', '草屯镇', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3351', '710617', '国姓乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3352', '710618', '埔里镇', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3353', '710619', '仁爱乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3354', '710620', '名间乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3355', '710621', '集集镇', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3356', '710622', '水里乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3357', '710623', '鱼池乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3358', '710624', '信义乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3359', '710625', '竹山镇', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3360', '710626', '鹿谷乡', '710600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3361', '710700', '基隆市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3362', '710701', '仁爱区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3363', '710702', '信义区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3364', '710703', '中正区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3365', '710704', '中山区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3366', '710705', '安乐区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3367', '710706', '暖暖区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3368', '710707', '七堵区', '710700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3369', '710800', '新竹市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3370', '710801', '东区', '710800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3371', '710802', '北区', '710800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3372', '710803', '香山区', '710800');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3373', '710900', '嘉义市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3374', '710901', '东区', '710900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3375', '710902', '西区', '710900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3376', '711100', '新北市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3377', '711130', '万里区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3378', '711131', '金山区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3379', '711132', '板桥区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3380', '711133', '汐止区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3381', '711134', '深坑区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3382', '711135', '石碇区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3383', '711136', '瑞芳区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3384', '711137', '平溪区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3385', '711138', '双溪区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3386', '711139', '贡寮区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3387', '711140', '新店区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3388', '711141', '坪林区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3389', '711142', '乌来区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3390', '711143', '永和区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3391', '711144', '中和区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3392', '711145', '土城区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3393', '711146', '三峡区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3394', '711147', '树林区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3395', '711148', '莺歌区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3396', '711149', '三重区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3397', '711150', '新庄区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3398', '711151', '泰山区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3399', '711152', '林口区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3400', '711153', '芦洲区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3401', '711154', '五股区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3402', '711155', '八里区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3403', '711156', '淡水区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3404', '711157', '三芝区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3405', '711158', '石门区', '711100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3406', '711200', '宜兰县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3407', '711214', '宜兰市', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3408', '711215', '头城镇', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3409', '711216', '礁溪乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3410', '711217', '壮围乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3411', '711218', '员山乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3412', '711219', '罗东镇', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3413', '711220', '三星乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3414', '711221', '大同乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3415', '711222', '五结乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3416', '711223', '冬山乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3417', '711224', '苏澳镇', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3418', '711225', '南澳乡', '711200');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3419', '711300', '新竹县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3420', '711314', '竹北市', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3421', '711315', '湖口乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3422', '711316', '新丰乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3423', '711317', '新埔镇', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3424', '711318', '关西镇', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3425', '711319', '芎林乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3426', '711320', '宝山乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3427', '711321', '竹东镇', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3428', '711322', '五峰乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3429', '711323', '横山乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3430', '711324', '尖石乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3431', '711325', '北埔乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3432', '711326', '峨眉乡', '711300');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3433', '711400', '桃园市', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3434', '711414', '中坜区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3435', '711415', '平镇区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3436', '711416', '龙潭区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3437', '711417', '杨梅区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3438', '711418', '新屋区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3439', '711419', '观音区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3440', '711420', '桃园区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3441', '711421', '龟山区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3442', '711422', '八德区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3443', '711423', '大溪区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3444', '711424', '复兴区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3445', '711425', '大园区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3446', '711426', '芦竹区', '711400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3447', '711500', '苗栗县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3448', '711519', '竹南镇', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3449', '711520', '头份市', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3450', '711521', '三湾乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3451', '711522', '南庄乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3452', '711523', '狮潭乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3453', '711524', '后龙镇', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3454', '711525', '通霄镇', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3455', '711526', '苑里镇', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3456', '711527', '苗栗市', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3457', '711528', '造桥乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3458', '711529', '头屋乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3459', '711530', '公馆乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3460', '711531', '大湖乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3461', '711532', '泰安乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3462', '711533', '铜锣乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3463', '711534', '三义乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3464', '711535', '西湖乡', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3465', '711536', '卓兰镇', '711500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3466', '711700', '彰化县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3467', '711727', '彰化市', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3468', '711728', '芬园乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3469', '711729', '花坛乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3470', '711730', '秀水乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3471', '711731', '鹿港镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3472', '711732', '福兴乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3473', '711733', '线西乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3474', '711734', '和美镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3475', '711735', '伸港乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3476', '711736', '员林市', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3477', '711737', '社头乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3478', '711738', '永靖乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3479', '711739', '埔心乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3480', '711740', '溪湖镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3481', '711741', '大村乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3482', '711742', '埔盐乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3483', '711743', '田中镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3484', '711744', '北斗镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3485', '711745', '田尾乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3486', '711746', '埤头乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3487', '711747', '溪州乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3488', '711748', '竹塘乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3489', '711749', '二林镇', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3490', '711750', '大城乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3491', '711751', '芳苑乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3492', '711752', '二水乡', '711700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3493', '711900', '嘉义县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3494', '711919', '番路乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3495', '711920', '梅山乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3496', '711921', '竹崎乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3497', '711922', '阿里山乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3498', '711923', '中埔乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3499', '711924', '大埔乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3500', '711925', '水上乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3501', '711926', '鹿草乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3502', '711927', '太保市', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3503', '711928', '朴子市', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3504', '711929', '东石乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3505', '711930', '六脚乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3506', '711931', '新港乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3507', '711932', '民雄乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3508', '711933', '大林镇', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3509', '711934', '溪口乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3510', '711935', '义竹乡', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3511', '711936', '布袋镇', '711900');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3512', '712100', '云林县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3513', '712121', '斗南镇', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3514', '712122', '大埤乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3515', '712123', '虎尾镇', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3516', '712124', '土库镇', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3517', '712125', '褒忠乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3518', '712126', '东势乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3519', '712127', '台西乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3520', '712128', '仑背乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3521', '712129', '麦寮乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3522', '712130', '斗六市', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3523', '712131', '林内乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3524', '712132', '古坑乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3525', '712133', '莿桐乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3526', '712134', '西螺镇', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3527', '712135', '二仑乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3528', '712136', '北港镇', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3529', '712137', '水林乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3530', '712138', '口湖乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3531', '712139', '四湖乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3532', '712140', '元长乡', '712100');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3533', '712400', '屏东县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3534', '712434', '屏东市', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3535', '712435', '三地门乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3536', '712436', '雾台乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3537', '712437', '玛家乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3538', '712438', '九如乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3539', '712439', '里港乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3540', '712440', '高树乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3541', '712441', '盐埔乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3542', '712442', '长治乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3543', '712443', '麟洛乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3544', '712444', '竹田乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3545', '712445', '内埔乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3546', '712446', '万丹乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3547', '712447', '潮州镇', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3548', '712448', '泰武乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3549', '712449', '来义乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3550', '712450', '万峦乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3551', '712451', '崁顶乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3552', '712452', '新埤乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3553', '712453', '南州乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3554', '712454', '林边乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3555', '712455', '东港镇', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3556', '712456', '琉球乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3557', '712457', '佳冬乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3558', '712458', '新园乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3559', '712459', '枋寮乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3560', '712460', '枋山乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3561', '712461', '春日乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3562', '712462', '狮子乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3563', '712463', '车城乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3564', '712464', '牡丹乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3565', '712465', '恒春镇', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3566', '712466', '满州乡', '712400');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3567', '712500', '台东县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3568', '712517', '台东市', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3569', '712518', '绿岛乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3570', '712519', '兰屿乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3571', '712520', '延平乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3572', '712521', '卑南乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3573', '712522', '鹿野乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3574', '712523', '关山镇', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3575', '712524', '海端乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3576', '712525', '池上乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3577', '712526', '东河乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3578', '712527', '成功镇', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3579', '712528', '长滨乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3580', '712529', '金峰乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3581', '712530', '大武乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3582', '712531', '达仁乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3583', '712532', '太麻里乡', '712500');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3584', '712600', '花莲县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3585', '712615', '花莲市', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3586', '712616', '新城乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3587', '712618', '秀林乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3588', '712619', '吉安乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3589', '712620', '寿丰乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3590', '712621', '凤林镇', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3591', '712622', '光复乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3592', '712623', '丰滨乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3593', '712624', '瑞穗乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3594', '712625', '万荣乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3595', '712626', '玉里镇', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3596', '712627', '卓溪乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3597', '712628', '富里乡', '712600');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3598', '712700', '澎湖县', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3599', '712707', '马公市', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3600', '712708', '西屿乡', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3601', '712709', '望安乡', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3602', '712710', '七美乡', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3603', '712711', '白沙乡', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3604', '712712', '湖西乡', '712700');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3605', '810000', '香港特别行政区', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3606', '810101', '中西区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3607', '810102', '东区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3608', '810103', '九龙城区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3609', '810104', '观塘区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3610', '810105', '南区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3611', '810106', '深水埗区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3612', '810107', '湾仔区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3613', '810108', '黄大仙区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3614', '810109', '油尖旺区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3615', '810110', '离岛区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3616', '810111', '葵青区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3617', '810112', '北区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3618', '810113', '西贡区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3619', '810114', '沙田区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3620', '810115', '屯门区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3621', '810116', '大埔区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3622', '810117', '荃湾区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3623', '810118', '元朗区', '810000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3624', '820000', '澳门特别行政区', '710000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3625', '820101', '澳门半岛', '820000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3626', '820102', '凼仔', '820000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3627', '820103', '路凼城', '820000');
insert into pub_address_inf
  (ADD_ID, ADD_CODE, ADD_NAME, ADD_CITYCODE)
values
  ('3628', '820104', '路环', '820000');

