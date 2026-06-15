-- 宠物便捷系统 - 实际项目数据库设计脚本 (MySQL)
-- 本脚本严格基于当前 Spring Boot 后端项目实体类 (Entity) 的字段设计
-- 字符集使用 utf8mb4 以全面支持 Emoji 和特殊字符

CREATE DATABASE IF NOT EXISTS `animal_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `animal_system`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. user (用户表)
-- 对应实体类: User.java
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID自动生成',
  `name` VARCHAR(100) DEFAULT NULL COMMENT '用户名',
  `password` VARCHAR(255) DEFAULT NULL COMMENT '密码',
  `email` VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- ----------------------------
-- 2. boarding_post (寄养帖子/服务发布表)
-- 对应实体类: BoardingPost.java
-- ----------------------------
DROP TABLE IF EXISTS `boarding_post`;
CREATE TABLE `boarding_post` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `title` VARCHAR(255) NOT NULL COMMENT '帖子标题',
  `desc_text` TEXT DEFAULT NULL COMMENT '服务描述',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '服务类型标识',
  `type_label` VARCHAR(50) DEFAULT NULL COMMENT '服务类型标签(如: 寄养, 遛狗)',
  `distance` VARCHAR(50) DEFAULT NULL COMMENT '距离/位置描述',
  `price` VARCHAR(50) DEFAULT NULL COMMENT '价格描述',
  `user_name` VARCHAR(100) DEFAULT NULL COMMENT '发布者名称',
  `thumb` VARCHAR(500) DEFAULT NULL COMMENT '缩略图URL',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='寄养/服务发布表';

-- ----------------------------
-- 3. order_history (订单历史表)
-- 对应实体类: OrderHistory.java
-- ----------------------------
DROP TABLE IF EXISTS `order_history`;
CREATE TABLE `order_history` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `order_id` VARCHAR(64) NOT NULL COMMENT '业务订单号',
  `type` VARCHAR(50) DEFAULT NULL COMMENT '订单类型标识',
  `description` VARCHAR(255) DEFAULT NULL COMMENT '订单简述',
  `price` VARCHAR(50) DEFAULT NULL COMMENT '订单金额',
  `date` DATE DEFAULT NULL COMMENT '订单日期',
  `status` VARCHAR(50) DEFAULT NULL COMMENT '状态标识',
  `status_label` VARCHAR(50) DEFAULT NULL COMMENT '状态显示文本(如: 待处理, 已完成)',
  `user_id` INT NOT NULL COMMENT '关联的用户ID',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_id` (`order_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单历史记录表';

-- ----------------------------
-- 4. medical_record (病历/智能问诊记录表)
-- 对应实体类: MedicalRecord.java
-- ----------------------------
DROP TABLE IF EXISTS `medical_record`;
CREATE TABLE `medical_record` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `case_id` VARCHAR(64) NOT NULL COMMENT '病历单号',
  `pet_name` VARCHAR(100) DEFAULT NULL COMMENT '宠物名称',
  `pet_type` VARCHAR(50) DEFAULT NULL COMMENT '宠物类型',
  `age` VARCHAR(50) DEFAULT NULL COMMENT '宠物年龄',
  `disease` VARCHAR(255) DEFAULT NULL COMMENT '疾病/症状描述',
  `visit_date` DATE DEFAULT NULL COMMENT '就诊日期',
  `doctor` VARCHAR(100) DEFAULT NULL COMMENT '就诊医生/AI医生名称',
  `status` VARCHAR(50) DEFAULT NULL COMMENT '病历状态',
  `status_label` VARCHAR(50) DEFAULT NULL COMMENT '病历状态标签',
  `diagnosis` TEXT DEFAULT NULL COMMENT '诊断结果',
  `treatment` TEXT DEFAULT NULL COMMENT '治疗方案',
  `medication` TEXT DEFAULT NULL COMMENT '用药建议',
  `user_id` INT NOT NULL COMMENT '所属用户ID',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医疗问诊记录表';

-- ----------------------------
-- 5. alliance_org (联盟机构/医院表)
-- 对应实体类: AllianceOrg.java
-- ----------------------------
DROP TABLE IF EXISTS `alliance_org`;
CREATE TABLE `alliance_org` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` VARCHAR(255) NOT NULL COMMENT '机构/医院名称',
  `category` VARCHAR(50) DEFAULT NULL COMMENT '机构分类标识',
  `category_label` VARCHAR(50) DEFAULT NULL COMMENT '机构分类标签(如: 宠物医院, 美容店)',
  `city` VARCHAR(50) DEFAULT NULL COMMENT '所在城市',
  `address` VARCHAR(255) DEFAULT NULL COMMENT '详细地址',
  `services` VARCHAR(255) DEFAULT NULL COMMENT '提供服务列表',
  `description` TEXT DEFAULT NULL COMMENT '机构简介',
  `logo` VARCHAR(500) DEFAULT NULL COMMENT 'Logo图片URL',
  `contact_name` VARCHAR(100) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` VARCHAR(50) DEFAULT NULL COMMENT '联系电话',
  `relationship` VARCHAR(100) DEFAULT NULL COMMENT '合作关系',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '入驻时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联盟入驻机构表';

-- ----------------------------
-- 6. community_boarding_record (社区寄养记录表)
-- 对应实体类: CommunityBoardingRecord.java
-- ----------------------------
DROP TABLE IF EXISTS `community_boarding_record`;
CREATE TABLE `community_boarding_record` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `service_id` VARCHAR(64) NOT NULL COMMENT '服务ID',
  `provider_name` VARCHAR(100) DEFAULT NULL COMMENT '服务提供者名称',
  `service_type` VARCHAR(50) DEFAULT NULL COMMENT '服务类型',
  `pet_name` VARCHAR(100) DEFAULT NULL COMMENT '宠物名称',
  `location` VARCHAR(255) DEFAULT NULL COMMENT '服务位置',
  `search_date` DATE DEFAULT NULL COMMENT '发布/查询日期',
  `rating` INT DEFAULT '0' COMMENT '评分星级(如 1-5)',
  `status` VARCHAR(50) DEFAULT NULL COMMENT '状态标识',
  `status_label` VARCHAR(50) DEFAULT NULL COMMENT '状态标签(如: 进行中, 已完成)',
  `phone` VARCHAR(50) DEFAULT NULL COMMENT '联系电话',
  `price` INT DEFAULT '0' COMMENT '服务价格',
  `description` TEXT DEFAULT NULL COMMENT '记录描述',
  `user_id` INT NOT NULL COMMENT '所属用户ID',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='社区寄养交互记录表';

-- ----------------------------
-- 7. alliance_application (联盟机构入驻申请表)
-- 对应实体类: AllianceApplication.java
-- ----------------------------
DROP TABLE IF EXISTS `alliance_application`;
CREATE TABLE `alliance_application` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `org_id` INT DEFAULT NULL COMMENT '关联的机构ID(审核通过后回填)',
  `applicant_user_id` INT NOT NULL COMMENT '申请人用户ID',
  `contact_name` VARCHAR(100) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` VARCHAR(50) DEFAULT NULL COMMENT '联系电话',
  `remark` TEXT DEFAULT NULL COMMENT '申请备注/说明',
  `status` VARCHAR(50) DEFAULT 'pending' COMMENT '申请状态(如: pending, approved, rejected)',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
  PRIMARY KEY (`id`),
  KEY `idx_applicant` (`applicant_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='联盟机构入驻申请表';

-- ----------------------------
-- 8. 初始化测试数据
-- ----------------------------
-- 测试用户
INSERT INTO `user` (`id`, `name`, `password`, `email`) VALUES 
(1, '测试用户', '123456', 'test@animal.com');

-- 测试机构
INSERT INTO `alliance_org` (`id`, `name`, `category_label`, `city`, `address`, `contact_name`, `contact_phone`) VALUES 
(1, '爱心宠物医院', '宠物医院', '北京', '朝阳区中关村大道1号', '李医生', '13800001111');

-- 测试寄养帖子
INSERT INTO `boarding_post` (`id`, `title`, `desc_text`, `type_label`, `price`, `user_name`) VALUES 
(1, '金毛寻回犬求寄养', '十一长假求靠谱寄养', '家庭寄养', '80元/天', '测试用户');

SET FOREIGN_KEY_CHECKS = 1;
