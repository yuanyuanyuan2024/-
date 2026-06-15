/*
SQLyog Ultimate v11.24 (32 bit)
MySQL - 8.0.11 : Database - web_booker
*********************************************************************
*/


/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`zf` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `zf`;

/*Table structure for table `book` */

DROP TABLE IF EXISTS `book`;

CREATE TABLE `book` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '书id',
  `title` varchar(255) DEFAULT NULL COMMENT '书标题',
  `author` varchar(255) DEFAULT NULL COMMENT '作者',
  `total_quantity` int(11) DEFAULT NULL COMMENT '总数量',
  `type` varchar(255) DEFAULT NULL COMMENT '类型',
  `publisher` varchar(255) DEFAULT NULL COMMENT '出版社',
  `url` varchar(255) DEFAULT NULL COMMENT '图片url',
  `description` text COMMENT '简介',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6939 DEFAULT CHARSET=utf8;

/*Table structure for table `user` */

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT COMMENT '用户编号',
  `email` varchar(255) DEFAULT NULL COMMENT '邮箱',
  `name` varchar(255) DEFAULT NULL COMMENT '用户名',
  `account` varchar(255) DEFAULT NULL COMMENT '用户账号',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT '账号密码',
  `bid` int(11) DEFAULT NULL COMMENT '书籍账号',
  `book_name` varchar(255) DEFAULT NULL COMMENT '书籍名称',
  `borrow_start_time` date DEFAULT NULL COMMENT '借阅开始时间',
  `borrow_end_date` date DEFAULT NULL COMMENT '借阅结束时间',
  `role` int(11) DEFAULT 0 COMMENT '角色：0-普通用户，1-管理员',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

INSERT INTO `user` (`email`, `name`, `account`, `password`, `role`) VALUES 
('admin@admin.com', 'admin', 'admin', 'admin123', 1),
('user@user.com', 'user1', '12345678901', 'user123', 0),
('user2@user.com', 'user2', '12345678902', 'user123', 0);

INSERT INTO `book` (`title`, `author`, `total_quantity`, `type`, `publisher`, `description`) VALUES 
('Java编程思想', 'Bruce Eckel', 10, '计算机', '机械工业出版社', 'Java经典书籍'),
('深入理解计算机系统', 'Randal E. Bryant', 5, '计算机', '机械工业出版社', '计算机系统基础'),
('算法导论', 'Randal E. Bryant', 3, '计算机', '机械工业出版社', '算法经典');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
