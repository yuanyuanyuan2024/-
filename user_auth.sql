-- 宠物便捷系统 - 用户登录注册专属数据库设计脚本 (MySQL)
-- 专门为 User 实体类（登录、注册模块）设计的表结构

CREATE DATABASE IF NOT EXISTS `animal_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `animal_system`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- 1. user (用户表)
-- 对应实体类: comn.star_factory.pet.entity.User
-- 作用: 用于处理用户的注册、登录、信息查询等基础鉴权功能
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '主键ID自动生成',
  `name` VARCHAR(100) NOT NULL COMMENT '用户名(登录账号)',
  `password` VARCHAR(255) NOT NULL COMMENT '密码',
  `email` VARCHAR(100) NOT NULL COMMENT '用户邮箱(用于找回密码等)',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '账号注册时间',
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_name` (`name`),
  UNIQUE KEY `uk_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户核心信息表(登录注册使用)';

-- ----------------------------
-- 2. 初始化测试数据
-- ----------------------------
-- 插入两个默认的测试账号供开发调试使用
INSERT INTO `user` (`id`, `name`, `password`, `email`) VALUES 
(1, 'demo', '123456', 'demo@example.com'),
(2, 'test_user', 'password123', 'test@animal.com');

SET FOREIGN_KEY_CHECKS = 1;
