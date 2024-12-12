/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80019
 Source Host           : localhost:3306
 Source Schema         : cloudstack

 Target Server Type    : MySQL
 Target Server Version : 80019
 File Encoding         : 65001

 Date: 28/05/2023 21:00:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for account
-- ----------------------------
DROP TABLE IF EXISTS `account`;
CREATE TABLE `account`  (
  `id` bigint unsigned NOT NULL,
  `account_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'an account name set by the creator of the account, defaults to username for single accounts',
  `uuid` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `type` int unsigned NOT NULL,
  `role_id` bigint unsigned COMMENT 'role id for this account',
  `domain_id` bigint unsigned,
  `state` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'enabled',
  `removed` datetime(0) DEFAULT NULL COMMENT 'date removed',
  `cleanup_needed` tinyint(1) NOT NULL DEFAULT 0,
  `network_domain` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `default_zone_id` bigint unsigned,
  `default` int unsigned NOT NULL COMMENT '1 if account is default',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uc_account__uuid`(`uuid`) USING BTREE,
  INDEX `i_account__removed`(`removed`) USING BTREE,
  INDEX `fk_account__default_zone_id`(`default_zone_id`) USING BTREE,
  INDEX `i_account__cleanup_needed`(`cleanup_needed`) USING BTREE,
  INDEX `i_account__account_name__domain_id__removed`(`account_name`, `domain_id`, `removed`) USING BTREE,
  INDEX `i_account__domain_id`(`domain_id`) USING BTREE,
  INDEX `fk_account__role_id`(`role_id`) USING BTREE,
  CONSTRAINT `account_ibfk_1` FOREIGN KEY (`default_zone_id`) REFERENCES `data_center` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `account_ibfk_2` FOREIGN KEY (`domain_id`) REFERENCES `domain` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `account_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of account
-- ----------------------------
INSERT INTO `account` VALUES (1, 'system', '1ea6cb05-cdfc-11ec-bb74-000c29bf26e7', 1, 1, 1, 'enabled', NULL, 0, NULL, NULL, 1);
INSERT INTO `account` VALUES (2, 'admin', '1ea7d0a1-cdfc-11ec-bb74-000c29bf26e7', 1, 1, 1, 'enabled', NULL, 0, NULL, NULL, 1);
INSERT INTO `account` VALUES (3, 'baremetal-system-account', '63f0ea18-c870-4742-8026-76408ae0d0b5', 0, 4, 1, 'enabled', NULL, 0, NULL, NULL, 0);

-- ----------------------------
-- Table structure for aly_policy
-- ----------------------------
DROP TABLE IF EXISTS `aly_policy`;
CREATE TABLE `aly_policy`  (
  `policy_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `policy_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `format` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `policy_rules_addr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of aly_policy
-- ----------------------------
INSERT INTO `aly_policy` VALUES ('ALY0001', '策略1', 'V1', 'aliyun', 6, '../../static/aliyun1.json');
INSERT INTO `aly_policy` VALUES ('ALY0002', '策略2', 'V2', 'aliyun', 7, '../../static/aliyun2.json');
INSERT INTO `aly_policy` VALUES ('ALY0003', '策略1', 'V1', 'cloudStack', 8, '../../static/aliyun3.json');
INSERT INTO `aly_policy` VALUES ('sadf', 'sddsfgf', 'dsfsad', 'openStack', 9, '../../static/aliyun4.json');

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES (1, '11');

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `group_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int(0) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add 图书', 7, 'add_bookinfo');
INSERT INTO `auth_permission` VALUES (26, 'Can change 图书', 7, 'change_bookinfo');
INSERT INTO `auth_permission` VALUES (27, 'Can delete 图书', 7, 'delete_bookinfo');
INSERT INTO `auth_permission` VALUES (28, 'Can view 图书', 7, 'view_bookinfo');
INSERT INTO `auth_permission` VALUES (29, 'Can add 英雄', 8, 'add_heroinfo');
INSERT INTO `auth_permission` VALUES (30, 'Can change 英雄', 8, 'change_heroinfo');
INSERT INTO `auth_permission` VALUES (31, 'Can delete 英雄', 8, 'delete_heroinfo');
INSERT INTO `auth_permission` VALUES (32, 'Can view 英雄', 8, 'view_heroinfo');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------
INSERT INTO `auth_user` VALUES (1, 'pbkdf2_sha256$260000$JhAjXG9WURRBTkU96PxLNE$FUGLpGHKdCdf1HU/Iuy/0CY8+BDgvFJ/mrV3FPGycXI=', '2022-08-18 03:35:45.190305', 1, 'nj', '', '', '', 1, 1, '2022-08-09 13:15:57.572873');

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `group_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `user_id` int(0) NOT NULL,
  `permission_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int(0) DEFAULT NULL,
  `user_id` int(0) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2022-08-09 13:18:09.586684', '1', '11', 1, '[{\"added\": {}}]', 3, 1);
INSERT INTO `django_admin_log` VALUES (2, '2022-08-09 13:18:32.257781', '1', '11', 2, '[{\"changed\": {\"fields\": [\"Permissions\"]}}]', 3, 1);
INSERT INTO `django_admin_log` VALUES (3, '2022-08-18 03:42:01.707771', 'fsdaf', 'OsPolicy object (fsdaf)', 1, '[{\"added\": {}}]', 11, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (7, 'adaptor', 'bookinfo');
INSERT INTO `django_content_type` VALUES (8, 'adaptor', 'heroinfo');
INSERT INTO `django_content_type` VALUES (11, 'adaptor', 'ospolicy');
INSERT INTO `django_content_type` VALUES (10, 'adaptor', 'role');
INSERT INTO `django_content_type` VALUES (9, 'adaptor', 'rolepermissions');
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(0) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('7o8dvsoztcxkxrk80rkg8i4bw4x86qnp', '.eJxVjDsOwjAQRO_iGllx8JeSnjNY6901DiBbipMKcXcSKQVUI817M28RYV1KXDvPcSJxEUqcfrsE-OS6A3pAvTeJrS7zlOSuyIN2eWvEr-vh_h0U6GVba6uTRXM2oHMwyY5DVsYpDxzsuEUYkJVm0oSEQMEZx-TZB8rZY2Dx-QLaMjiF:1oOWJt:9h9GUP1sjMh57cXKejxdJqGorfhSSNWaYhKBba1tRAQ', '2022-09-01 03:35:45.195440');

-- ----------------------------
-- Table structure for os_policy
-- ----------------------------
DROP TABLE IF EXISTS `os_policy`;
CREATE TABLE `os_policy`  (
  `policy_id` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `policy_name` varchar(36) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `version` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `format` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `id` int(0) NOT NULL AUTO_INCREMENT,
  `policy_rules_addr` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `isselected` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of os_policy
-- ----------------------------
INSERT INTO `os_policy` VALUES ('OS0001', '策略1', 'V1', 'OpenStack', 6, '../../static/os.json', '');
INSERT INTO `os_policy` VALUES ('OS0002', '策略2', 'V2', 'OpenStack', 7, '../../static/os2.json', '');
INSERT INTO `os_policy` VALUES ('OS0003', '策略1', 'V1', 'CloudStack', 8, '../../static/os3.json', '');

-- ----------------------------
-- Table structure for role_permissions
-- ----------------------------
DROP TABLE IF EXISTS `role_permissions`;
CREATE TABLE `role_permissions`  (
  `id` bigint unsigned NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `role_id` bigint unsigned NOT NULL COMMENT 'id of the role',
  `rule` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'rule for the role, api name or wildcard',
  `permission` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'access authority, allow or deny',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'description of the rule',
  `sort_order` bigint unsigned COMMENT 'permission sort order',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_id`(`role_id`, `rule`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid`) USING BTREE,
  INDEX `fk_role_permissions__role_id`(`role_id`) USING BTREE,
  INDEX `i_role_permissions__sort_order`(`sort_order`) USING BTREE,
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1107 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permissions
-- ----------------------------
INSERT INTO `role_permissions` VALUES (1, '17d1b537-cdfc-11ec-bb74-000c29bf26e7', 1, '*', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (2, '17d1bbed-cdfc-11ec-bb74-000c29bf26e7', 2, 'activateProject', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (3, '17d1c196-cdfc-11ec-bb74-000c29bf26e7', 2, 'addAccountToProject', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (4, '17d1c674-cdfc-11ec-bb74-000c29bf26e7', 2, 'addHost', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (5, '17d1cb19-cdfc-11ec-bb74-000c29bf26e7', 2, 'addIpToNic', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (6, '17d1cfbf-cdfc-11ec-bb74-000c29bf26e7', 2, 'addLdapConfiguration', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (7, '17d1d444-cdfc-11ec-bb74-000c29bf26e7', 2, 'addNicToVirtualMachine', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (8, '17d1d8c7-cdfc-11ec-bb74-000c29bf26e7', 2, 'addVpnUser', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (9, '17d1dd84-cdfc-11ec-bb74-000c29bf26e7', 2, 'archiveEvents', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (10, '17d1e2de-cdfc-11ec-bb74-000c29bf26e7', 2, 'assignCertToLoadBalancer', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (11, '17d1e779-cdfc-11ec-bb74-000c29bf26e7', 2, 'assignToGlobalLoadBalancerRule', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (12, '17d1ec07-cdfc-11ec-bb74-000c29bf26e7', 2, 'assignToLoadBalancerRule', 'ALLOW', NULL, 10);
INSERT INTO `role_permissions` VALUES (13, '17d1f0d5-cdfc-11ec-bb74-000c29bf26e7', 2, 'assignVirtualMachine', 'ALLOW', NULL, 11);
INSERT INTO `role_permissions` VALUES (14, '17d1f548-cdfc-11ec-bb74-000c29bf26e7', 2, 'associateIpAddress', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (16, '17d1fe29-cdfc-11ec-bb74-000c29bf26e7', 2, 'attachIso', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (17, '17d20296-cdfc-11ec-bb74-000c29bf26e7', 2, 'attachVolume', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (18, '17d207a4-cdfc-11ec-bb74-000c29bf26e7', 2, 'authorizeSamlSso', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (19, '17d20d16-cdfc-11ec-bb74-000c29bf26e7', 2, 'authorizeSecurityGroupEgress', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (20, '17d2118f-cdfc-11ec-bb74-000c29bf26e7', 2, 'authorizeSecurityGroupIngress', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (21, '17d215fe-cdfc-11ec-bb74-000c29bf26e7', 2, 'changeServiceForRouter', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (22, '17d21a6c-cdfc-11ec-bb74-000c29bf26e7', 2, 'changeServiceForVirtualMachine', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (23, '17d21ecc-cdfc-11ec-bb74-000c29bf26e7', 2, 'configureInternalLoadBalancerElement', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (24, '17d22326-cdfc-11ec-bb74-000c29bf26e7', 2, 'configureOvsElement', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (25, '17d22856-cdfc-11ec-bb74-000c29bf26e7', 2, 'configureVirtualRouterElement', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (26, '17d22d47-cdfc-11ec-bb74-000c29bf26e7', 2, 'copyIso', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (27, '17d231e6-cdfc-11ec-bb74-000c29bf26e7', 2, 'copyTemplate', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (28, '17d23667-cdfc-11ec-bb74-000c29bf26e7', 2, 'createAccount', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (29, '17d23ae4-cdfc-11ec-bb74-000c29bf26e7', 2, 'createAffinityGroup', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (30, '17d23f59-cdfc-11ec-bb74-000c29bf26e7', 2, 'createAutoScalePolicy', 'ALLOW', NULL, 28);
INSERT INTO `role_permissions` VALUES (31, '17d2458b-cdfc-11ec-bb74-000c29bf26e7', 2, 'createAutoScaleVmGroup', 'ALLOW', NULL, 29);
INSERT INTO `role_permissions` VALUES (32, '17d24aa0-cdfc-11ec-bb74-000c29bf26e7', 2, 'createAutoScaleVmProfile', 'ALLOW', NULL, 30);
INSERT INTO `role_permissions` VALUES (33, '17d24f3c-cdfc-11ec-bb74-000c29bf26e7', 2, 'createCondition', 'ALLOW', NULL, 31);
INSERT INTO `role_permissions` VALUES (34, '17d2541a-cdfc-11ec-bb74-000c29bf26e7', 2, 'createDiskOffering', 'ALLOW', NULL, 32);
INSERT INTO `role_permissions` VALUES (35, '17d258cf-cdfc-11ec-bb74-000c29bf26e7', 2, 'createEgressFirewallRule', 'ALLOW', NULL, 33);
INSERT INTO `role_permissions` VALUES (36, '17d25e0e-cdfc-11ec-bb74-000c29bf26e7', 2, 'createFirewallRule', 'ALLOW', NULL, 34);
INSERT INTO `role_permissions` VALUES (37, '17d262bb-cdfc-11ec-bb74-000c29bf26e7', 2, 'createGlobalLoadBalancerRule', 'ALLOW', NULL, 35);
INSERT INTO `role_permissions` VALUES (38, '17d26854-cdfc-11ec-bb74-000c29bf26e7', 2, 'createInstanceGroup', 'ALLOW', NULL, 36);
INSERT INTO `role_permissions` VALUES (39, '17d26df0-cdfc-11ec-bb74-000c29bf26e7', 2, 'createInternalLoadBalancerElement', 'ALLOW', NULL, 37);
INSERT INTO `role_permissions` VALUES (40, '17d27281-cdfc-11ec-bb74-000c29bf26e7', 2, 'createIpForwardingRule', 'ALLOW', NULL, 38);
INSERT INTO `role_permissions` VALUES (41, '17d27725-cdfc-11ec-bb74-000c29bf26e7', 2, 'createLBHealthCheckPolicy', 'ALLOW', NULL, 39);
INSERT INTO `role_permissions` VALUES (42, '17d27bfa-cdfc-11ec-bb74-000c29bf26e7', 2, 'createLBStickinessPolicy', 'ALLOW', NULL, 40);
INSERT INTO `role_permissions` VALUES (43, '17d28088-cdfc-11ec-bb74-000c29bf26e7', 2, 'createLoadBalancer', 'ALLOW', NULL, 41);
INSERT INTO `role_permissions` VALUES (44, '17d28500-cdfc-11ec-bb74-000c29bf26e7', 2, 'createLoadBalancerRule', 'ALLOW', NULL, 42);
INSERT INTO `role_permissions` VALUES (46, '17d28ddd-cdfc-11ec-bb74-000c29bf26e7', 2, 'createNetwork', 'ALLOW', NULL, 44);
INSERT INTO `role_permissions` VALUES (47, '17d2924a-cdfc-11ec-bb74-000c29bf26e7', 2, 'createNetworkACL', 'ALLOW', NULL, 45);
INSERT INTO `role_permissions` VALUES (48, '17d296a5-cdfc-11ec-bb74-000c29bf26e7', 2, 'createNetworkACLList', 'ALLOW', NULL, 46);
INSERT INTO `role_permissions` VALUES (49, '17d29b09-cdfc-11ec-bb74-000c29bf26e7', 2, 'createOvsElement', 'ALLOW', NULL, 47);
INSERT INTO `role_permissions` VALUES (51, '17d2a499-cdfc-11ec-bb74-000c29bf26e7', 2, 'createPortForwardingRule', 'ALLOW', NULL, 49);
INSERT INTO `role_permissions` VALUES (52, '17d2a91e-cdfc-11ec-bb74-000c29bf26e7', 2, 'createProject', 'ALLOW', NULL, 50);
INSERT INTO `role_permissions` VALUES (53, '17d2ad93-cdfc-11ec-bb74-000c29bf26e7', 2, 'createRemoteAccessVpn', 'ALLOW', NULL, 51);
INSERT INTO `role_permissions` VALUES (54, '17d2b1fd-cdfc-11ec-bb74-000c29bf26e7', 2, 'createSSHKeyPair', 'ALLOW', NULL, 52);
INSERT INTO `role_permissions` VALUES (55, '17d2b66e-cdfc-11ec-bb74-000c29bf26e7', 2, 'createSecurityGroup', 'ALLOW', NULL, 53);
INSERT INTO `role_permissions` VALUES (56, '17d2bae0-cdfc-11ec-bb74-000c29bf26e7', 2, 'createServiceOffering', 'ALLOW', NULL, 54);
INSERT INTO `role_permissions` VALUES (57, '17d2bf7a-cdfc-11ec-bb74-000c29bf26e7', 2, 'createSnapshot', 'ALLOW', NULL, 55);
INSERT INTO `role_permissions` VALUES (58, '17d2c554-cdfc-11ec-bb74-000c29bf26e7', 2, 'createSnapshotPolicy', 'ALLOW', NULL, 56);
INSERT INTO `role_permissions` VALUES (59, '17d2ca30-cdfc-11ec-bb74-000c29bf26e7', 2, 'createStaticRoute', 'ALLOW', NULL, 57);
INSERT INTO `role_permissions` VALUES (60, '17d2ceca-cdfc-11ec-bb74-000c29bf26e7', 2, 'createTags', 'ALLOW', NULL, 58);
INSERT INTO `role_permissions` VALUES (61, '17d2d34c-cdfc-11ec-bb74-000c29bf26e7', 2, 'createTemplate', 'ALLOW', NULL, 59);
INSERT INTO `role_permissions` VALUES (62, '17d2d7bb-cdfc-11ec-bb74-000c29bf26e7', 2, 'createUser', 'ALLOW', NULL, 60);
INSERT INTO `role_permissions` VALUES (63, '17d2dc2e-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVMSnapshot', 'ALLOW', NULL, 61);
INSERT INTO `role_permissions` VALUES (64, '17d2e09e-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVPC', 'ALLOW', NULL, 62);
INSERT INTO `role_permissions` VALUES (65, '17d2e509-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVirtualRouterElement', 'ALLOW', NULL, 63);
INSERT INTO `role_permissions` VALUES (66, '17d2e970-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVolume', 'ALLOW', NULL, 64);
INSERT INTO `role_permissions` VALUES (68, '17d2f2db-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVpnConnection', 'ALLOW', NULL, 66);
INSERT INTO `role_permissions` VALUES (69, '17d2f76c-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVpnCustomerGateway', 'ALLOW', NULL, 67);
INSERT INTO `role_permissions` VALUES (70, '17d2fdfa-cdfc-11ec-bb74-000c29bf26e7', 2, 'createVpnGateway', 'ALLOW', NULL, 68);
INSERT INTO `role_permissions` VALUES (71, '17d30290-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAccount', 'ALLOW', NULL, 69);
INSERT INTO `role_permissions` VALUES (72, '17d30710-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAccountFromProject', 'ALLOW', NULL, 70);
INSERT INTO `role_permissions` VALUES (73, '17d30bda-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAffinityGroup', 'ALLOW', NULL, 71);
INSERT INTO `role_permissions` VALUES (74, '17d31054-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAutoScalePolicy', 'ALLOW', NULL, 72);
INSERT INTO `role_permissions` VALUES (75, '17d314be-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAutoScaleVmGroup', 'ALLOW', NULL, 73);
INSERT INTO `role_permissions` VALUES (76, '17d319ae-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteAutoScaleVmProfile', 'ALLOW', NULL, 74);
INSERT INTO `role_permissions` VALUES (77, '17d31e32-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteCondition', 'ALLOW', NULL, 75);
INSERT INTO `role_permissions` VALUES (78, '17d322a2-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteDiskOffering', 'ALLOW', NULL, 76);
INSERT INTO `role_permissions` VALUES (79, '17d328b1-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteEgressFirewallRule', 'ALLOW', NULL, 77);
INSERT INTO `role_permissions` VALUES (80, '17d32d33-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteEvents', 'ALLOW', NULL, 78);
INSERT INTO `role_permissions` VALUES (81, '17d331ab-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteFirewallRule', 'ALLOW', NULL, 79);
INSERT INTO `role_permissions` VALUES (82, '17d33619-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteGlobalLoadBalancerRule', 'ALLOW', NULL, 80);
INSERT INTO `role_permissions` VALUES (83, '17d33ad3-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteHost', 'ALLOW', NULL, 81);
INSERT INTO `role_permissions` VALUES (84, '17d3406e-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteInstanceGroup', 'ALLOW', NULL, 82);
INSERT INTO `role_permissions` VALUES (85, '17d3450f-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteIpForwardingRule', 'ALLOW', NULL, 83);
INSERT INTO `role_permissions` VALUES (86, '17d34971-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteIso', 'ALLOW', NULL, 84);
INSERT INTO `role_permissions` VALUES (87, '17d34dd4-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteLBHealthCheckPolicy', 'ALLOW', NULL, 85);
INSERT INTO `role_permissions` VALUES (88, '17d35256-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteLBStickinessPolicy', 'ALLOW', NULL, 86);
INSERT INTO `role_permissions` VALUES (89, '17d356b1-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteLdapConfiguration', 'ALLOW', NULL, 87);
INSERT INTO `role_permissions` VALUES (90, '17d35b02-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteLoadBalancer', 'ALLOW', NULL, 88);
INSERT INTO `role_permissions` VALUES (91, '17d36046-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteLoadBalancerRule', 'ALLOW', NULL, 89);
INSERT INTO `role_permissions` VALUES (92, '17d36505-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteNetwork', 'ALLOW', NULL, 90);
INSERT INTO `role_permissions` VALUES (93, '17d36a59-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteNetworkACL', 'ALLOW', NULL, 91);
INSERT INTO `role_permissions` VALUES (94, '17d36ee4-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteNetworkACLList', 'ALLOW', NULL, 92);
INSERT INTO `role_permissions` VALUES (96, '17d377cb-cdfc-11ec-bb74-000c29bf26e7', 2, 'deletePortForwardingRule', 'ALLOW', NULL, 94);
INSERT INTO `role_permissions` VALUES (97, '17d37c40-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteProject', 'ALLOW', NULL, 95);
INSERT INTO `role_permissions` VALUES (98, '17d380a5-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteProjectInvitation', 'ALLOW', NULL, 96);
INSERT INTO `role_permissions` VALUES (99, '17d38506-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteRemoteAccessVpn', 'ALLOW', NULL, 97);
INSERT INTO `role_permissions` VALUES (100, '17d38968-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteSSHKeyPair', 'ALLOW', NULL, 98);
INSERT INTO `role_permissions` VALUES (101, '17d38e53-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteSecurityGroup', 'ALLOW', NULL, 99);
INSERT INTO `role_permissions` VALUES (102, '17d39570-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteServiceOffering', 'ALLOW', NULL, 100);
INSERT INTO `role_permissions` VALUES (103, '17d39a0e-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteSnapshot', 'ALLOW', NULL, 101);
INSERT INTO `role_permissions` VALUES (104, '17d39eb3-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteSnapshotPolicies', 'ALLOW', NULL, 102);
INSERT INTO `role_permissions` VALUES (105, '17d3a334-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteSslCert', 'ALLOW', NULL, 103);
INSERT INTO `role_permissions` VALUES (106, '17d3a7a3-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteStaticRoute', 'ALLOW', NULL, 104);
INSERT INTO `role_permissions` VALUES (107, '17d3ac05-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteTags', 'ALLOW', NULL, 105);
INSERT INTO `role_permissions` VALUES (108, '17d3b067-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteTemplate', 'ALLOW', NULL, 106);
INSERT INTO `role_permissions` VALUES (109, '17d3b538-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteUser', 'ALLOW', NULL, 107);
INSERT INTO `role_permissions` VALUES (110, '17d3b9cb-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVMSnapshot', 'ALLOW', NULL, 108);
INSERT INTO `role_permissions` VALUES (111, '17d3be31-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVPC', 'ALLOW', NULL, 109);
INSERT INTO `role_permissions` VALUES (112, '17d3c28a-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVolume', 'ALLOW', NULL, 110);
INSERT INTO `role_permissions` VALUES (113, '17d3c6fe-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVpnConnection', 'ALLOW', NULL, 111);
INSERT INTO `role_permissions` VALUES (114, '17d3cb70-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVpnCustomerGateway', 'ALLOW', NULL, 112);
INSERT INTO `role_permissions` VALUES (115, '17d3cfd3-cdfc-11ec-bb74-000c29bf26e7', 2, 'deleteVpnGateway', 'ALLOW', NULL, 113);
INSERT INTO `role_permissions` VALUES (116, '17d3d438-cdfc-11ec-bb74-000c29bf26e7', 2, 'deployVirtualMachine', 'ALLOW', NULL, 114);
INSERT INTO `role_permissions` VALUES (118, '17d3ddc2-cdfc-11ec-bb74-000c29bf26e7', 2, 'destroyRouter', 'ALLOW', NULL, 116);
INSERT INTO `role_permissions` VALUES (119, '17d3e268-cdfc-11ec-bb74-000c29bf26e7', 2, 'destroyVirtualMachine', 'ALLOW', NULL, 117);
INSERT INTO `role_permissions` VALUES (121, '17d3eb66-cdfc-11ec-bb74-000c29bf26e7', 2, 'detachIso', 'ALLOW', NULL, 119);
INSERT INTO `role_permissions` VALUES (122, '17d3efcb-cdfc-11ec-bb74-000c29bf26e7', 2, 'detachVolume', 'ALLOW', NULL, 120);
INSERT INTO `role_permissions` VALUES (123, '17d3f41f-cdfc-11ec-bb74-000c29bf26e7', 2, 'disableAccount', 'ALLOW', NULL, 121);
INSERT INTO `role_permissions` VALUES (124, '17d3f879-cdfc-11ec-bb74-000c29bf26e7', 2, 'disableAutoScaleVmGroup', 'ALLOW', NULL, 122);
INSERT INTO `role_permissions` VALUES (125, '17d3fcd9-cdfc-11ec-bb74-000c29bf26e7', 2, 'disableStaticNat', 'ALLOW', NULL, 123);
INSERT INTO `role_permissions` VALUES (126, '17d40402-cdfc-11ec-bb74-000c29bf26e7', 2, 'disableUser', 'ALLOW', NULL, 124);
INSERT INTO `role_permissions` VALUES (127, '17d40887-cdfc-11ec-bb74-000c29bf26e7', 2, 'disassociateIpAddress', 'ALLOW', NULL, 125);
INSERT INTO `role_permissions` VALUES (129, '17d4128a-cdfc-11ec-bb74-000c29bf26e7', 2, 'enableAccount', 'ALLOW', NULL, 127);
INSERT INTO `role_permissions` VALUES (130, '17d416f3-cdfc-11ec-bb74-000c29bf26e7', 2, 'enableAutoScaleVmGroup', 'ALLOW', NULL, 128);
INSERT INTO `role_permissions` VALUES (131, '17d41b51-cdfc-11ec-bb74-000c29bf26e7', 2, 'enableStaticNat', 'ALLOW', NULL, 129);
INSERT INTO `role_permissions` VALUES (132, '17d41fae-cdfc-11ec-bb74-000c29bf26e7', 2, 'enableUser', 'ALLOW', NULL, 130);
INSERT INTO `role_permissions` VALUES (133, '17d42481-cdfc-11ec-bb74-000c29bf26e7', 2, 'expungeVirtualMachine', 'ALLOW', NULL, 131);
INSERT INTO `role_permissions` VALUES (134, '17d4294c-cdfc-11ec-bb74-000c29bf26e7', 2, 'extractIso', 'ALLOW', NULL, 132);
INSERT INTO `role_permissions` VALUES (135, '17d42de9-cdfc-11ec-bb74-000c29bf26e7', 2, 'extractTemplate', 'ALLOW', NULL, 133);
INSERT INTO `role_permissions` VALUES (136, '17d4334a-cdfc-11ec-bb74-000c29bf26e7', 2, 'extractVolume', 'ALLOW', NULL, 134);
INSERT INTO `role_permissions` VALUES (137, '17d437ff-cdfc-11ec-bb74-000c29bf26e7', 2, 'getApiLimit', 'ALLOW', NULL, 135);
INSERT INTO `role_permissions` VALUES (138, '17d43c6c-cdfc-11ec-bb74-000c29bf26e7', 2, 'getCloudIdentifier', 'ALLOW', NULL, 136);
INSERT INTO `role_permissions` VALUES (139, '17d44103-cdfc-11ec-bb74-000c29bf26e7', 2, 'getSolidFireAccountId', 'ALLOW', NULL, 137);
INSERT INTO `role_permissions` VALUES (140, '17d44571-cdfc-11ec-bb74-000c29bf26e7', 2, 'getSolidFireVolumeAccessGroupId', 'ALLOW', NULL, 138);
INSERT INTO `role_permissions` VALUES (141, '17d449d8-cdfc-11ec-bb74-000c29bf26e7', 2, 'getSolidFireVolumeIscsiName', 'ALLOW', NULL, 139);
INSERT INTO `role_permissions` VALUES (142, '17d44e34-cdfc-11ec-bb74-000c29bf26e7', 2, 'getSolidFireVolumeSize', 'ALLOW', NULL, 140);
INSERT INTO `role_permissions` VALUES (143, '17d45321-cdfc-11ec-bb74-000c29bf26e7', 2, 'getUploadParamsForTemplate', 'ALLOW', NULL, 141);
INSERT INTO `role_permissions` VALUES (144, '17d457b7-cdfc-11ec-bb74-000c29bf26e7', 2, 'getUploadParamsForVolume', 'ALLOW', NULL, 142);
INSERT INTO `role_permissions` VALUES (145, '17d45c29-cdfc-11ec-bb74-000c29bf26e7', 2, 'getVMPassword', 'ALLOW', NULL, 143);
INSERT INTO `role_permissions` VALUES (146, '17d463c2-cdfc-11ec-bb74-000c29bf26e7', 2, 'getVirtualMachineUserData', 'ALLOW', NULL, 144);
INSERT INTO `role_permissions` VALUES (147, '17d46851-cdfc-11ec-bb74-000c29bf26e7', 2, 'importLdapUsers', 'ALLOW', NULL, 145);
INSERT INTO `role_permissions` VALUES (148, '17d46cc7-cdfc-11ec-bb74-000c29bf26e7', 2, 'ldapCreateAccount', 'ALLOW', NULL, 147);
INSERT INTO `role_permissions` VALUES (149, '17d4713b-cdfc-11ec-bb74-000c29bf26e7', 2, 'linkDomainToLdap', 'ALLOW', NULL, 148);
INSERT INTO `role_permissions` VALUES (150, '17d47599-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAccounts', 'ALLOW', NULL, 149);
INSERT INTO `role_permissions` VALUES (151, '17d47a8c-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAffinityGroupTypes', 'ALLOW', NULL, 150);
INSERT INTO `role_permissions` VALUES (152, '17d481b1-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAffinityGroups', 'ALLOW', NULL, 151);
INSERT INTO `role_permissions` VALUES (153, '17d4862b-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAlerts', 'ALLOW', NULL, 152);
INSERT INTO `role_permissions` VALUES (154, '17d48a91-cdfc-11ec-bb74-000c29bf26e7', 2, 'listApis', 'ALLOW', NULL, 153);
INSERT INTO `role_permissions` VALUES (155, '17d48f0a-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAsyncJobs', 'ALLOW', NULL, 154);
INSERT INTO `role_permissions` VALUES (156, '17d49388-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAutoScalePolicies', 'ALLOW', NULL, 155);
INSERT INTO `role_permissions` VALUES (157, '17d497ec-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAutoScaleVmGroups', 'ALLOW', NULL, 156);
INSERT INTO `role_permissions` VALUES (158, '17d49c4a-cdfc-11ec-bb74-000c29bf26e7', 2, 'listAutoScaleVmProfiles', 'ALLOW', NULL, 157);
INSERT INTO `role_permissions` VALUES (159, '17d4a12e-cdfc-11ec-bb74-000c29bf26e7', 2, 'listCapabilities', 'ALLOW', NULL, 158);
INSERT INTO `role_permissions` VALUES (160, '17d4a587-cdfc-11ec-bb74-000c29bf26e7', 2, 'listCapacity', 'ALLOW', NULL, 159);
INSERT INTO `role_permissions` VALUES (161, '17d4a9ee-cdfc-11ec-bb74-000c29bf26e7', 2, 'listClusters', 'ALLOW', NULL, 160);
INSERT INTO `role_permissions` VALUES (162, '17d4ae3e-cdfc-11ec-bb74-000c29bf26e7', 2, 'listConditions', 'ALLOW', NULL, 161);
INSERT INTO `role_permissions` VALUES (163, '17d4b293-cdfc-11ec-bb74-000c29bf26e7', 2, 'listCounters', 'ALLOW', NULL, 162);
INSERT INTO `role_permissions` VALUES (164, '17d4b6db-cdfc-11ec-bb74-000c29bf26e7', 2, 'listDiskOfferings', 'ALLOW', NULL, 163);
INSERT INTO `role_permissions` VALUES (165, '17d4bb24-cdfc-11ec-bb74-000c29bf26e7', 2, 'listDomainChildren', 'ALLOW', NULL, 164);
INSERT INTO `role_permissions` VALUES (166, '17d4bfc3-cdfc-11ec-bb74-000c29bf26e7', 2, 'listDomains', 'ALLOW', NULL, 165);
INSERT INTO `role_permissions` VALUES (167, '17d4c3f2-cdfc-11ec-bb74-000c29bf26e7', 2, 'listEgressFirewallRules', 'ALLOW', NULL, 166);
INSERT INTO `role_permissions` VALUES (168, '17d4c8d2-cdfc-11ec-bb74-000c29bf26e7', 2, 'listEventTypes', 'ALLOW', NULL, 167);
INSERT INTO `role_permissions` VALUES (169, '17d4cdb0-cdfc-11ec-bb74-000c29bf26e7', 2, 'listEvents', 'ALLOW', NULL, 168);
INSERT INTO `role_permissions` VALUES (170, '17d4d2cc-cdfc-11ec-bb74-000c29bf26e7', 2, 'listFirewallRules', 'ALLOW', NULL, 169);
INSERT INTO `role_permissions` VALUES (171, '17d4d733-cdfc-11ec-bb74-000c29bf26e7', 2, 'listGlobalLoadBalancerRules', 'ALLOW', NULL, 170);
INSERT INTO `role_permissions` VALUES (172, '17d4db90-cdfc-11ec-bb74-000c29bf26e7', 2, 'listHostTags', 'ALLOW', NULL, 171);
INSERT INTO `role_permissions` VALUES (173, '17d4e0df-cdfc-11ec-bb74-000c29bf26e7', 2, 'listHosts', 'ALLOW', NULL, 172);
INSERT INTO `role_permissions` VALUES (174, '17d4e558-cdfc-11ec-bb74-000c29bf26e7', 2, 'listHypervisors', 'ALLOW', NULL, 173);
INSERT INTO `role_permissions` VALUES (175, '17d4e9be-cdfc-11ec-bb74-000c29bf26e7', 2, 'listInstanceGroups', 'ALLOW', NULL, 174);
INSERT INTO `role_permissions` VALUES (176, '17d4f00f-cdfc-11ec-bb74-000c29bf26e7', 2, 'listInternalLoadBalancerElements', 'ALLOW', NULL, 175);
INSERT INTO `role_permissions` VALUES (177, '17d4f4ad-cdfc-11ec-bb74-000c29bf26e7', 2, 'listIpForwardingRules', 'ALLOW', NULL, 176);
INSERT INTO `role_permissions` VALUES (178, '17d4f913-cdfc-11ec-bb74-000c29bf26e7', 2, 'listIsoPermissions', 'ALLOW', NULL, 177);
INSERT INTO `role_permissions` VALUES (179, '17d4fdc6-cdfc-11ec-bb74-000c29bf26e7', 2, 'listIsos', 'ALLOW', NULL, 178);
INSERT INTO `role_permissions` VALUES (180, '17d50513-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLBHealthCheckPolicies', 'ALLOW', NULL, 179);
INSERT INTO `role_permissions` VALUES (181, '17d50983-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLBStickinessPolicies', 'ALLOW', NULL, 180);
INSERT INTO `role_permissions` VALUES (182, '17d50dec-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLdapConfigurations', 'ALLOW', NULL, 181);
INSERT INTO `role_permissions` VALUES (183, '17d51221-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLdapUsers', 'ALLOW', NULL, 182);
INSERT INTO `role_permissions` VALUES (184, '17d517ca-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLoadBalancerRuleInstances', 'ALLOW', NULL, 183);
INSERT INTO `role_permissions` VALUES (185, '17d51c50-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLoadBalancerRules', 'ALLOW', NULL, 184);
INSERT INTO `role_permissions` VALUES (186, '17d520a8-cdfc-11ec-bb74-000c29bf26e7', 2, 'listLoadBalancers', 'ALLOW', NULL, 185);
INSERT INTO `role_permissions` VALUES (188, '17d52c7c-cdfc-11ec-bb74-000c29bf26e7', 2, 'listNetworkACLLists', 'ALLOW', NULL, 187);
INSERT INTO `role_permissions` VALUES (189, '17d531c4-cdfc-11ec-bb74-000c29bf26e7', 2, 'listNetworkACLs', 'ALLOW', NULL, 188);
INSERT INTO `role_permissions` VALUES (190, '17d5363c-cdfc-11ec-bb74-000c29bf26e7', 2, 'listNetworkOfferings', 'ALLOW', NULL, 189);
INSERT INTO `role_permissions` VALUES (191, '17d53aac-cdfc-11ec-bb74-000c29bf26e7', 2, 'listNetworks', 'ALLOW', NULL, 190);
INSERT INTO `role_permissions` VALUES (192, '17d53f01-cdfc-11ec-bb74-000c29bf26e7', 2, 'listNics', 'ALLOW', NULL, 191);
INSERT INTO `role_permissions` VALUES (193, '17d54338-cdfc-11ec-bb74-000c29bf26e7', 2, 'listOsCategories', 'ALLOW', NULL, 192);
INSERT INTO `role_permissions` VALUES (194, '17d54735-cdfc-11ec-bb74-000c29bf26e7', 2, 'listOsTypes', 'ALLOW', NULL, 193);
INSERT INTO `role_permissions` VALUES (195, '17d54b2b-cdfc-11ec-bb74-000c29bf26e7', 2, 'listOvsElements', 'ALLOW', NULL, 194);
INSERT INTO `role_permissions` VALUES (196, '17d54f26-cdfc-11ec-bb74-000c29bf26e7', 2, 'listPods', 'ALLOW', NULL, 195);
INSERT INTO `role_permissions` VALUES (198, '17d55712-cdfc-11ec-bb74-000c29bf26e7', 2, 'listPortForwardingRules', 'ALLOW', NULL, 197);
INSERT INTO `role_permissions` VALUES (199, '17d55afc-cdfc-11ec-bb74-000c29bf26e7', 2, 'listPrivateGateways', 'ALLOW', NULL, 198);
INSERT INTO `role_permissions` VALUES (200, '17d55f0a-cdfc-11ec-bb74-000c29bf26e7', 2, 'listProjectAccounts', 'ALLOW', NULL, 199);
INSERT INTO `role_permissions` VALUES (201, '17d563bf-cdfc-11ec-bb74-000c29bf26e7', 2, 'listProjectInvitations', 'ALLOW', NULL, 200);
INSERT INTO `role_permissions` VALUES (202, '17d569f7-cdfc-11ec-bb74-000c29bf26e7', 2, 'listProjects', 'ALLOW', NULL, 201);
INSERT INTO `role_permissions` VALUES (203, '17d56ffc-cdfc-11ec-bb74-000c29bf26e7', 2, 'listPublicIpAddresses', 'ALLOW', NULL, 202);
INSERT INTO `role_permissions` VALUES (204, '17d574e2-cdfc-11ec-bb74-000c29bf26e7', 2, 'listRegions', 'ALLOW', NULL, 203);
INSERT INTO `role_permissions` VALUES (205, '17d57b28-cdfc-11ec-bb74-000c29bf26e7', 2, 'listRemoteAccessVpns', 'ALLOW', NULL, 204);
INSERT INTO `role_permissions` VALUES (206, '17d57f81-cdfc-11ec-bb74-000c29bf26e7', 2, 'listResourceDetails', 'ALLOW', NULL, 205);
INSERT INTO `role_permissions` VALUES (207, '17d58483-cdfc-11ec-bb74-000c29bf26e7', 2, 'listResourceLimits', 'ALLOW', NULL, 206);
INSERT INTO `role_permissions` VALUES (208, '17d58991-cdfc-11ec-bb74-000c29bf26e7', 2, 'listRouters', 'ALLOW', NULL, 207);
INSERT INTO `role_permissions` VALUES (209, '17d58e76-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSSHKeyPairs', 'ALLOW', NULL, 208);
INSERT INTO `role_permissions` VALUES (210, '17d59390-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSamlAuthorization', 'ALLOW', NULL, 209);
INSERT INTO `role_permissions` VALUES (211, '17d597d6-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSecurityGroups', 'ALLOW', NULL, 210);
INSERT INTO `role_permissions` VALUES (212, '17d59f9e-cdfc-11ec-bb74-000c29bf26e7', 2, 'listServiceOfferings', 'ALLOW', NULL, 211);
INSERT INTO `role_permissions` VALUES (213, '17d5a3fc-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSnapshotPolicies', 'ALLOW', NULL, 212);
INSERT INTO `role_permissions` VALUES (214, '17d5a83f-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSnapshots', 'ALLOW', NULL, 213);
INSERT INTO `role_permissions` VALUES (215, '17d5ac7e-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSslCerts', 'ALLOW', NULL, 214);
INSERT INTO `role_permissions` VALUES (216, '17d5b188-cdfc-11ec-bb74-000c29bf26e7', 2, 'listStaticRoutes', 'ALLOW', NULL, 215);
INSERT INTO `role_permissions` VALUES (217, '17d5b716-cdfc-11ec-bb74-000c29bf26e7', 2, 'listStoragePools', 'ALLOW', NULL, 216);
INSERT INTO `role_permissions` VALUES (218, '17d5bb82-cdfc-11ec-bb74-000c29bf26e7', 2, 'listStorageProviders', 'ALLOW', NULL, 217);
INSERT INTO `role_permissions` VALUES (219, '17d5c149-cdfc-11ec-bb74-000c29bf26e7', 2, 'listStorageTags', 'ALLOW', NULL, 218);
INSERT INTO `role_permissions` VALUES (220, '17d5c5dc-cdfc-11ec-bb74-000c29bf26e7', 2, 'listSystemVms', 'ALLOW', NULL, 219);
INSERT INTO `role_permissions` VALUES (221, '17d5ca39-cdfc-11ec-bb74-000c29bf26e7', 2, 'listTags', 'ALLOW', NULL, 220);
INSERT INTO `role_permissions` VALUES (222, '17d5ce96-cdfc-11ec-bb74-000c29bf26e7', 2, 'listTemplatePermissions', 'ALLOW', NULL, 221);
INSERT INTO `role_permissions` VALUES (223, '17d5d2e0-cdfc-11ec-bb74-000c29bf26e7', 2, 'listTemplates', 'ALLOW', NULL, 222);
INSERT INTO `role_permissions` VALUES (224, '17d5d7c6-cdfc-11ec-bb74-000c29bf26e7', 2, 'listUsageRecords', 'ALLOW', NULL, 223);
INSERT INTO `role_permissions` VALUES (225, '17d5dc43-cdfc-11ec-bb74-000c29bf26e7', 2, 'listUsers', 'ALLOW', NULL, 224);
INSERT INTO `role_permissions` VALUES (226, '17d5e090-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVMSnapshot', 'ALLOW', NULL, 225);
INSERT INTO `role_permissions` VALUES (227, '17d5e4e3-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVPCOfferings', 'ALLOW', NULL, 226);
INSERT INTO `role_permissions` VALUES (228, '17d5e92d-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVPCs', 'ALLOW', NULL, 227);
INSERT INTO `role_permissions` VALUES (229, '17d5ed77-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVirtualMachines', 'ALLOW', NULL, 228);
INSERT INTO `role_permissions` VALUES (230, '17d5f1bf-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVirtualRouterElements', 'ALLOW', NULL, 229);
INSERT INTO `role_permissions` VALUES (231, '17d5f5fd-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVolumes', 'ALLOW', NULL, 230);
INSERT INTO `role_permissions` VALUES (233, '17d5ff1f-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVpnConnections', 'ALLOW', NULL, 232);
INSERT INTO `role_permissions` VALUES (234, '17d6038e-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVpnCustomerGateways', 'ALLOW', NULL, 233);
INSERT INTO `role_permissions` VALUES (235, '17d60984-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVpnGateways', 'ALLOW', NULL, 234);
INSERT INTO `role_permissions` VALUES (236, '17d60e3a-cdfc-11ec-bb74-000c29bf26e7', 2, 'listVpnUsers', 'ALLOW', NULL, 235);
INSERT INTO `role_permissions` VALUES (237, '17d61338-cdfc-11ec-bb74-000c29bf26e7', 2, 'listZones', 'ALLOW', NULL, 236);
INSERT INTO `role_permissions` VALUES (238, '17d6179a-cdfc-11ec-bb74-000c29bf26e7', 2, 'lockAccount', 'ALLOW', NULL, 237);
INSERT INTO `role_permissions` VALUES (239, '17d61cd0-cdfc-11ec-bb74-000c29bf26e7', 2, 'lockUser', 'ALLOW', NULL, 238);
INSERT INTO `role_permissions` VALUES (240, '17d62166-cdfc-11ec-bb74-000c29bf26e7', 2, 'migrateVolume', 'ALLOW', NULL, 239);
INSERT INTO `role_permissions` VALUES (242, '17d62fcd-cdfc-11ec-bb74-000c29bf26e7', 2, 'queryAsyncJobResult', 'ALLOW', NULL, 241);
INSERT INTO `role_permissions` VALUES (243, '17d63508-cdfc-11ec-bb74-000c29bf26e7', 2, 'quotaBalance', 'ALLOW', NULL, 242);
INSERT INTO `role_permissions` VALUES (244, '17d63945-cdfc-11ec-bb74-000c29bf26e7', 2, 'quotaIsEnabled', 'ALLOW', NULL, 243);
INSERT INTO `role_permissions` VALUES (245, '17d63d56-cdfc-11ec-bb74-000c29bf26e7', 2, 'quotaStatement', 'ALLOW', NULL, 244);
INSERT INTO `role_permissions` VALUES (246, '17d6414f-cdfc-11ec-bb74-000c29bf26e7', 2, 'quotaSummary', 'ALLOW', NULL, 245);
INSERT INTO `role_permissions` VALUES (247, '17d6453d-cdfc-11ec-bb74-000c29bf26e7', 2, 'quotaTariffList', 'ALLOW', NULL, 246);
INSERT INTO `role_permissions` VALUES (248, '17d64d07-cdfc-11ec-bb74-000c29bf26e7', 2, 'rebootRouter', 'ALLOW', NULL, 247);
INSERT INTO `role_permissions` VALUES (249, '17d65171-cdfc-11ec-bb74-000c29bf26e7', 2, 'rebootVirtualMachine', 'ALLOW', NULL, 248);
INSERT INTO `role_permissions` VALUES (250, '17d65574-cdfc-11ec-bb74-000c29bf26e7', 2, 'recoverVirtualMachine', 'ALLOW', NULL, 249);
INSERT INTO `role_permissions` VALUES (251, '17d65960-cdfc-11ec-bb74-000c29bf26e7', 2, 'registerIso', 'ALLOW', NULL, 250);
INSERT INTO `role_permissions` VALUES (252, '17d65d47-cdfc-11ec-bb74-000c29bf26e7', 2, 'registerSSHKeyPair', 'ALLOW', NULL, 251);
INSERT INTO `role_permissions` VALUES (253, '17d6613b-cdfc-11ec-bb74-000c29bf26e7', 2, 'registerTemplate', 'ALLOW', NULL, 252);
INSERT INTO `role_permissions` VALUES (254, '17d6651d-cdfc-11ec-bb74-000c29bf26e7', 2, 'registerUserKeys', 'ALLOW', NULL, 253);
INSERT INTO `role_permissions` VALUES (255, '17d66900-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeCertFromLoadBalancer', 'ALLOW', NULL, 254);
INSERT INTO `role_permissions` VALUES (256, '17d66cec-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeFromGlobalLoadBalancerRule', 'ALLOW', NULL, 255);
INSERT INTO `role_permissions` VALUES (257, '17d670d2-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeFromLoadBalancerRule', 'ALLOW', NULL, 256);
INSERT INTO `role_permissions` VALUES (258, '17d6756b-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeIpFromNic', 'ALLOW', NULL, 257);
INSERT INTO `role_permissions` VALUES (259, '17d67993-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeNicFromVirtualMachine', 'ALLOW', NULL, 258);
INSERT INTO `role_permissions` VALUES (260, '17d67d97-cdfc-11ec-bb74-000c29bf26e7', 2, 'removeVpnUser', 'ALLOW', NULL, 259);
INSERT INTO `role_permissions` VALUES (261, '17d68190-cdfc-11ec-bb74-000c29bf26e7', 2, 'replaceNetworkACLList', 'ALLOW', NULL, 260);
INSERT INTO `role_permissions` VALUES (262, '17d6869b-cdfc-11ec-bb74-000c29bf26e7', 2, 'resetPasswordForVirtualMachine', 'ALLOW', NULL, 261);
INSERT INTO `role_permissions` VALUES (263, '17d68ace-cdfc-11ec-bb74-000c29bf26e7', 2, 'resetSSHKeyForVirtualMachine', 'ALLOW', NULL, 262);
INSERT INTO `role_permissions` VALUES (264, '17d68ee6-cdfc-11ec-bb74-000c29bf26e7', 2, 'resetVpnConnection', 'ALLOW', NULL, 263);
INSERT INTO `role_permissions` VALUES (265, '17d692da-cdfc-11ec-bb74-000c29bf26e7', 2, 'resizeVolume', 'ALLOW', NULL, 264);
INSERT INTO `role_permissions` VALUES (266, '17d696bb-cdfc-11ec-bb74-000c29bf26e7', 2, 'restartNetwork', 'ALLOW', NULL, 265);
INSERT INTO `role_permissions` VALUES (267, '17d69ac3-cdfc-11ec-bb74-000c29bf26e7', 2, 'restartVPC', 'ALLOW', NULL, 266);
INSERT INTO `role_permissions` VALUES (268, '17d69ece-cdfc-11ec-bb74-000c29bf26e7', 2, 'restoreVirtualMachine', 'ALLOW', NULL, 267);
INSERT INTO `role_permissions` VALUES (269, '17d6a450-cdfc-11ec-bb74-000c29bf26e7', 2, 'revertSnapshot', 'ALLOW', NULL, 268);
INSERT INTO `role_permissions` VALUES (270, '17d6a864-cdfc-11ec-bb74-000c29bf26e7', 2, 'revertToVMSnapshot', 'ALLOW', NULL, 269);
INSERT INTO `role_permissions` VALUES (271, '17d6acbc-cdfc-11ec-bb74-000c29bf26e7', 2, 'revokeSecurityGroupEgress', 'ALLOW', NULL, 270);
INSERT INTO `role_permissions` VALUES (272, '17d6b0b2-cdfc-11ec-bb74-000c29bf26e7', 2, 'revokeSecurityGroupIngress', 'ALLOW', NULL, 271);
INSERT INTO `role_permissions` VALUES (273, '17d6b4ac-cdfc-11ec-bb74-000c29bf26e7', 2, 'scaleVirtualMachine', 'ALLOW', NULL, 272);
INSERT INTO `role_permissions` VALUES (274, '17d6b886-cdfc-11ec-bb74-000c29bf26e7', 2, 'startRouter', 'ALLOW', NULL, 273);
INSERT INTO `role_permissions` VALUES (275, '17d6bc5f-cdfc-11ec-bb74-000c29bf26e7', 2, 'startVirtualMachine', 'ALLOW', NULL, 274);
INSERT INTO `role_permissions` VALUES (276, '17d6c034-cdfc-11ec-bb74-000c29bf26e7', 2, 'stopRouter', 'ALLOW', NULL, 275);
INSERT INTO `role_permissions` VALUES (277, '17d6c766-cdfc-11ec-bb74-000c29bf26e7', 2, 'stopVirtualMachine', 'ALLOW', NULL, 276);
INSERT INTO `role_permissions` VALUES (278, '17d6ccea-cdfc-11ec-bb74-000c29bf26e7', 2, 'suspendProject', 'ALLOW', NULL, 277);
INSERT INTO `role_permissions` VALUES (279, '17d6d184-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateAccount', 'ALLOW', NULL, 278);
INSERT INTO `role_permissions` VALUES (280, '17d6d5b7-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateAutoScalePolicy', 'ALLOW', NULL, 279);
INSERT INTO `role_permissions` VALUES (281, '17d6d9c6-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateAutoScaleVmGroup', 'ALLOW', NULL, 280);
INSERT INTO `role_permissions` VALUES (282, '17d6e168-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateAutoScaleVmProfile', 'ALLOW', NULL, 281);
INSERT INTO `role_permissions` VALUES (283, '17d6e574-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateDefaultNicForVirtualMachine', 'ALLOW', NULL, 282);
INSERT INTO `role_permissions` VALUES (284, '17d6ea0f-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateDiskOffering', 'ALLOW', NULL, 283);
INSERT INTO `role_permissions` VALUES (285, '17d6ee40-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateEgressFirewallRule', 'ALLOW', NULL, 284);
INSERT INTO `role_permissions` VALUES (286, '17d6f23f-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateFirewallRule', 'ALLOW', NULL, 285);
INSERT INTO `role_permissions` VALUES (287, '17d6f637-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateGlobalLoadBalancerRule', 'ALLOW', NULL, 286);
INSERT INTO `role_permissions` VALUES (288, '17d6fa27-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateInstanceGroup', 'ALLOW', NULL, 287);
INSERT INTO `role_permissions` VALUES (289, '17d6fe23-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateIpAddress', 'ALLOW', NULL, 288);
INSERT INTO `role_permissions` VALUES (290, '17d7021b-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateIso', 'ALLOW', NULL, 289);
INSERT INTO `role_permissions` VALUES (291, '17d7065a-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateIsoPermissions', 'ALLOW', NULL, 290);
INSERT INTO `role_permissions` VALUES (292, '17d70c86-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateLBHealthCheckPolicy', 'ALLOW', NULL, 291);
INSERT INTO `role_permissions` VALUES (293, '17d711ef-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateLBStickinessPolicy', 'ALLOW', NULL, 292);
INSERT INTO `role_permissions` VALUES (294, '17d71663-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateLoadBalancer', 'ALLOW', NULL, 293);
INSERT INTO `role_permissions` VALUES (295, '17d71ada-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateLoadBalancerRule', 'ALLOW', NULL, 294);
INSERT INTO `role_permissions` VALUES (296, '17d71f23-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateNetwork', 'ALLOW', NULL, 295);
INSERT INTO `role_permissions` VALUES (297, '17d7237c-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateNetworkACLItem', 'ALLOW', NULL, 296);
INSERT INTO `role_permissions` VALUES (298, '17d727b5-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateNetworkACLList', 'ALLOW', NULL, 297);
INSERT INTO `role_permissions` VALUES (299, '17d72bf2-cdfc-11ec-bb74-000c29bf26e7', 2, 'updatePortForwardingRule', 'ALLOW', NULL, 298);
INSERT INTO `role_permissions` VALUES (300, '17d73025-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateProject', 'ALLOW', NULL, 299);
INSERT INTO `role_permissions` VALUES (301, '17d73458-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateProjectInvitation', 'ALLOW', NULL, 300);
INSERT INTO `role_permissions` VALUES (302, '17d73918-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateRemoteAccessVpn', 'ALLOW', NULL, 301);
INSERT INTO `role_permissions` VALUES (303, '17d73ea3-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateResourceCount', 'ALLOW', NULL, 302);
INSERT INTO `role_permissions` VALUES (304, '17d7431d-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateResourceLimit', 'ALLOW', NULL, 303);
INSERT INTO `role_permissions` VALUES (305, '17d74777-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateServiceOffering', 'ALLOW', NULL, 304);
INSERT INTO `role_permissions` VALUES (306, '17d74cc4-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateSnapshotPolicy', 'ALLOW', NULL, 305);
INSERT INTO `role_permissions` VALUES (307, '17d75135-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateTemplate', 'ALLOW', NULL, 306);
INSERT INTO `role_permissions` VALUES (308, '17d75589-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateTemplatePermissions', 'ALLOW', NULL, 307);
INSERT INTO `role_permissions` VALUES (309, '17d759da-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateUser', 'ALLOW', NULL, 308);
INSERT INTO `role_permissions` VALUES (310, '17d7619f-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVMAffinityGroup', 'ALLOW', NULL, 309);
INSERT INTO `role_permissions` VALUES (311, '17d76664-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVPC', 'ALLOW', NULL, 310);
INSERT INTO `role_permissions` VALUES (312, '17d76ad0-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVirtualMachine', 'ALLOW', NULL, 311);
INSERT INTO `role_permissions` VALUES (313, '17d76f31-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVmNicIp', 'ALLOW', NULL, 312);
INSERT INTO `role_permissions` VALUES (314, '17d77387-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVpnConnection', 'ALLOW', NULL, 313);
INSERT INTO `role_permissions` VALUES (315, '17d777f1-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVpnCustomerGateway', 'ALLOW', NULL, 314);
INSERT INTO `role_permissions` VALUES (316, '17d77c48-cdfc-11ec-bb74-000c29bf26e7', 2, 'updateVpnGateway', 'ALLOW', NULL, 315);
INSERT INTO `role_permissions` VALUES (317, '17d7892c-cdfc-11ec-bb74-000c29bf26e7', 2, 'uploadSslCert', 'ALLOW', NULL, 316);
INSERT INTO `role_permissions` VALUES (318, '17d78dd0-cdfc-11ec-bb74-000c29bf26e7', 2, 'uploadVolume', 'ALLOW', NULL, 317);
INSERT INTO `role_permissions` VALUES (319, '17d7924b-cdfc-11ec-bb74-000c29bf26e7', 3, 'activateProject', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (320, '17d796c9-cdfc-11ec-bb74-000c29bf26e7', 3, 'addAccountToProject', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (321, '17d79b3b-cdfc-11ec-bb74-000c29bf26e7', 3, 'addIpToNic', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (322, '17d79fb4-cdfc-11ec-bb74-000c29bf26e7', 3, 'addNicToVirtualMachine', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (323, '17d7a40a-cdfc-11ec-bb74-000c29bf26e7', 3, 'addVpnUser', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (324, '17d7a85c-cdfc-11ec-bb74-000c29bf26e7', 3, 'archiveEvents', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (325, '17d7ad90-cdfc-11ec-bb74-000c29bf26e7', 3, 'assignCertToLoadBalancer', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (326, '17d7b23c-cdfc-11ec-bb74-000c29bf26e7', 3, 'assignToGlobalLoadBalancerRule', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (327, '17d7b6ac-cdfc-11ec-bb74-000c29bf26e7', 3, 'assignToLoadBalancerRule', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (328, '17d7baf4-cdfc-11ec-bb74-000c29bf26e7', 3, 'assignVirtualMachine', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (329, '17d7bfe6-cdfc-11ec-bb74-000c29bf26e7', 3, 'associateIpAddress', 'ALLOW', NULL, 10);
INSERT INTO `role_permissions` VALUES (331, '17d7c890-cdfc-11ec-bb74-000c29bf26e7', 3, 'attachIso', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (332, '17d7cf5c-cdfc-11ec-bb74-000c29bf26e7', 3, 'attachVolume', 'ALLOW', NULL, 13);
INSERT INTO `role_permissions` VALUES (333, '17d7d5c8-cdfc-11ec-bb74-000c29bf26e7', 3, 'authorizeSamlSso', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (334, '17d7db15-cdfc-11ec-bb74-000c29bf26e7', 3, 'authorizeSecurityGroupEgress', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (335, '17d7e062-cdfc-11ec-bb74-000c29bf26e7', 3, 'authorizeSecurityGroupIngress', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (336, '17d7e4e9-cdfc-11ec-bb74-000c29bf26e7', 3, 'changeServiceForRouter', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (337, '17d7e95c-cdfc-11ec-bb74-000c29bf26e7', 3, 'changeServiceForVirtualMachine', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (338, '17d7edc8-cdfc-11ec-bb74-000c29bf26e7', 3, 'configureInternalLoadBalancerElement', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (339, '17d7f225-cdfc-11ec-bb74-000c29bf26e7', 3, 'configureOvsElement', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (340, '17d7f67a-cdfc-11ec-bb74-000c29bf26e7', 3, 'configureVirtualRouterElement', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (341, '17d7fb62-cdfc-11ec-bb74-000c29bf26e7', 3, 'copyIso', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (342, '17d801d3-cdfc-11ec-bb74-000c29bf26e7', 3, 'copyTemplate', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (343, '17d806dd-cdfc-11ec-bb74-000c29bf26e7', 3, 'createAccount', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (344, '17d80b68-cdfc-11ec-bb74-000c29bf26e7', 3, 'createAffinityGroup', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (345, '17d81196-cdfc-11ec-bb74-000c29bf26e7', 3, 'createAutoScalePolicy', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (346, '17d81740-cdfc-11ec-bb74-000c29bf26e7', 3, 'createAutoScaleVmGroup', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (347, '17d81bb8-cdfc-11ec-bb74-000c29bf26e7', 3, 'createAutoScaleVmProfile', 'ALLOW', NULL, 28);
INSERT INTO `role_permissions` VALUES (348, '17d81fe0-cdfc-11ec-bb74-000c29bf26e7', 3, 'createCondition', 'ALLOW', NULL, 29);
INSERT INTO `role_permissions` VALUES (349, '17d82496-cdfc-11ec-bb74-000c29bf26e7', 3, 'createDiskOffering', 'ALLOW', NULL, 30);
INSERT INTO `role_permissions` VALUES (350, '17d82d8f-cdfc-11ec-bb74-000c29bf26e7', 3, 'createEgressFirewallRule', 'ALLOW', NULL, 31);
INSERT INTO `role_permissions` VALUES (351, '17d832a7-cdfc-11ec-bb74-000c29bf26e7', 3, 'createFirewallRule', 'ALLOW', NULL, 32);
INSERT INTO `role_permissions` VALUES (352, '17d836c9-cdfc-11ec-bb74-000c29bf26e7', 3, 'createGlobalLoadBalancerRule', 'ALLOW', NULL, 33);
INSERT INTO `role_permissions` VALUES (353, '17d83ad0-cdfc-11ec-bb74-000c29bf26e7', 3, 'createInstanceGroup', 'ALLOW', NULL, 34);
INSERT INTO `role_permissions` VALUES (354, '17d83ed0-cdfc-11ec-bb74-000c29bf26e7', 3, 'createInternalLoadBalancerElement', 'ALLOW', NULL, 35);
INSERT INTO `role_permissions` VALUES (355, '17d842c6-cdfc-11ec-bb74-000c29bf26e7', 3, 'createIpForwardingRule', 'ALLOW', NULL, 36);
INSERT INTO `role_permissions` VALUES (356, '17d846b7-cdfc-11ec-bb74-000c29bf26e7', 3, 'createLBHealthCheckPolicy', 'ALLOW', NULL, 37);
INSERT INTO `role_permissions` VALUES (357, '17d84b9f-cdfc-11ec-bb74-000c29bf26e7', 3, 'createLBStickinessPolicy', 'ALLOW', NULL, 38);
INSERT INTO `role_permissions` VALUES (358, '17d84fe0-cdfc-11ec-bb74-000c29bf26e7', 3, 'createLoadBalancer', 'ALLOW', NULL, 39);
INSERT INTO `role_permissions` VALUES (359, '17d853dc-cdfc-11ec-bb74-000c29bf26e7', 3, 'createLoadBalancerRule', 'ALLOW', NULL, 40);
INSERT INTO `role_permissions` VALUES (361, '17d85bc4-cdfc-11ec-bb74-000c29bf26e7', 3, 'createNetwork', 'ALLOW', NULL, 42);
INSERT INTO `role_permissions` VALUES (362, '17d86096-cdfc-11ec-bb74-000c29bf26e7', 3, 'createNetworkACL', 'ALLOW', NULL, 43);
INSERT INTO `role_permissions` VALUES (363, '17d864b6-cdfc-11ec-bb74-000c29bf26e7', 3, 'createNetworkACLList', 'ALLOW', NULL, 44);
INSERT INTO `role_permissions` VALUES (364, '17d868ad-cdfc-11ec-bb74-000c29bf26e7', 3, 'createOvsElement', 'ALLOW', NULL, 45);
INSERT INTO `role_permissions` VALUES (366, '17d87120-cdfc-11ec-bb74-000c29bf26e7', 3, 'createPortForwardingRule', 'ALLOW', NULL, 47);
INSERT INTO `role_permissions` VALUES (367, '17d87532-cdfc-11ec-bb74-000c29bf26e7', 3, 'createProject', 'ALLOW', NULL, 48);
INSERT INTO `role_permissions` VALUES (368, '17d87cc3-cdfc-11ec-bb74-000c29bf26e7', 3, 'createRemoteAccessVpn', 'ALLOW', NULL, 49);
INSERT INTO `role_permissions` VALUES (369, '17d88159-cdfc-11ec-bb74-000c29bf26e7', 3, 'createSSHKeyPair', 'ALLOW', NULL, 50);
INSERT INTO `role_permissions` VALUES (370, '17d8861d-cdfc-11ec-bb74-000c29bf26e7', 3, 'createSecurityGroup', 'ALLOW', NULL, 51);
INSERT INTO `role_permissions` VALUES (371, '17d88a9a-cdfc-11ec-bb74-000c29bf26e7', 3, 'createServiceOffering', 'ALLOW', NULL, 52);
INSERT INTO `role_permissions` VALUES (372, '17d88f00-cdfc-11ec-bb74-000c29bf26e7', 3, 'createSnapshot', 'ALLOW', NULL, 53);
INSERT INTO `role_permissions` VALUES (373, '17d8935c-cdfc-11ec-bb74-000c29bf26e7', 3, 'createSnapshotPolicy', 'ALLOW', NULL, 54);
INSERT INTO `role_permissions` VALUES (374, '17d89885-cdfc-11ec-bb74-000c29bf26e7', 3, 'createStaticRoute', 'ALLOW', NULL, 55);
INSERT INTO `role_permissions` VALUES (375, '17d89cfd-cdfc-11ec-bb74-000c29bf26e7', 3, 'createTags', 'ALLOW', NULL, 56);
INSERT INTO `role_permissions` VALUES (376, '17d8a156-cdfc-11ec-bb74-000c29bf26e7', 3, 'createTemplate', 'ALLOW', NULL, 57);
INSERT INTO `role_permissions` VALUES (377, '17d8a5e9-cdfc-11ec-bb74-000c29bf26e7', 3, 'createUser', 'ALLOW', NULL, 58);
INSERT INTO `role_permissions` VALUES (378, '17d8a9e1-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVMSnapshot', 'ALLOW', NULL, 59);
INSERT INTO `role_permissions` VALUES (379, '17d8adde-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVPC', 'ALLOW', NULL, 60);
INSERT INTO `role_permissions` VALUES (380, '17d8b1cc-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVirtualRouterElement', 'ALLOW', NULL, 61);
INSERT INTO `role_permissions` VALUES (381, '17d8b5c1-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVolume', 'ALLOW', NULL, 62);
INSERT INTO `role_permissions` VALUES (383, '17d8bddd-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVpnConnection', 'ALLOW', NULL, 64);
INSERT INTO `role_permissions` VALUES (384, '17d8c209-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVpnCustomerGateway', 'ALLOW', NULL, 65);
INSERT INTO `role_permissions` VALUES (385, '17d8c617-cdfc-11ec-bb74-000c29bf26e7', 3, 'createVpnGateway', 'ALLOW', NULL, 66);
INSERT INTO `role_permissions` VALUES (386, '17d8ca0b-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAccount', 'ALLOW', NULL, 67);
INSERT INTO `role_permissions` VALUES (387, '17d8cdf9-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAccountFromProject', 'ALLOW', NULL, 68);
INSERT INTO `role_permissions` VALUES (388, '17d8d216-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAffinityGroup', 'ALLOW', NULL, 69);
INSERT INTO `role_permissions` VALUES (389, '17d8db04-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAutoScalePolicy', 'ALLOW', NULL, 70);
INSERT INTO `role_permissions` VALUES (390, '17d8df38-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAutoScaleVmGroup', 'ALLOW', NULL, 71);
INSERT INTO `role_permissions` VALUES (391, '17d8e333-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteAutoScaleVmProfile', 'ALLOW', NULL, 72);
INSERT INTO `role_permissions` VALUES (392, '17d8e7d2-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteCondition', 'ALLOW', NULL, 73);
INSERT INTO `role_permissions` VALUES (393, '17d8ebe5-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteDiskOffering', 'ALLOW', NULL, 74);
INSERT INTO `role_permissions` VALUES (394, '17d8efd9-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteEgressFirewallRule', 'ALLOW', NULL, 75);
INSERT INTO `role_permissions` VALUES (395, '17d8f4bb-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteEvents', 'ALLOW', NULL, 76);
INSERT INTO `role_permissions` VALUES (396, '17d8f8d2-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteFirewallRule', 'ALLOW', NULL, 77);
INSERT INTO `role_permissions` VALUES (397, '17d8fcd6-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteGlobalLoadBalancerRule', 'ALLOW', NULL, 78);
INSERT INTO `role_permissions` VALUES (398, '17d900ce-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteInstanceGroup', 'ALLOW', NULL, 79);
INSERT INTO `role_permissions` VALUES (399, '17d904c0-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteIpForwardingRule', 'ALLOW', NULL, 80);
INSERT INTO `role_permissions` VALUES (400, '17d908b4-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteIso', 'ALLOW', NULL, 81);
INSERT INTO `role_permissions` VALUES (401, '17d90d39-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteLBHealthCheckPolicy', 'ALLOW', NULL, 82);
INSERT INTO `role_permissions` VALUES (402, '17d91146-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteLBStickinessPolicy', 'ALLOW', NULL, 83);
INSERT INTO `role_permissions` VALUES (403, '17d915d9-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteLoadBalancer', 'ALLOW', NULL, 84);
INSERT INTO `role_permissions` VALUES (404, '17d91dbd-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteLoadBalancerRule', 'ALLOW', NULL, 85);
INSERT INTO `role_permissions` VALUES (405, '17d92203-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteNetwork', 'ALLOW', NULL, 86);
INSERT INTO `role_permissions` VALUES (406, '17d92643-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteNetworkACL', 'ALLOW', NULL, 87);
INSERT INTO `role_permissions` VALUES (407, '17d92a51-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteNetworkACLList', 'ALLOW', NULL, 88);
INSERT INTO `role_permissions` VALUES (409, '17d93289-cdfc-11ec-bb74-000c29bf26e7', 3, 'deletePortForwardingRule', 'ALLOW', NULL, 90);
INSERT INTO `role_permissions` VALUES (410, '17d936bb-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteProject', 'ALLOW', NULL, 91);
INSERT INTO `role_permissions` VALUES (411, '17d93abb-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteProjectInvitation', 'ALLOW', NULL, 92);
INSERT INTO `role_permissions` VALUES (412, '17d93eae-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteRemoteAccessVpn', 'ALLOW', NULL, 93);
INSERT INTO `role_permissions` VALUES (413, '17d942a1-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteSSHKeyPair', 'ALLOW', NULL, 94);
INSERT INTO `role_permissions` VALUES (414, '17d94699-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteSecurityGroup', 'ALLOW', NULL, 95);
INSERT INTO `role_permissions` VALUES (415, '17d94a90-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteServiceOffering', 'ALLOW', NULL, 96);
INSERT INTO `role_permissions` VALUES (416, '17d94e7f-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteSnapshot', 'ALLOW', NULL, 97);
INSERT INTO `role_permissions` VALUES (417, '17d95271-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteSnapshotPolicies', 'ALLOW', NULL, 98);
INSERT INTO `role_permissions` VALUES (418, '17d9566b-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteSslCert', 'ALLOW', NULL, 99);
INSERT INTO `role_permissions` VALUES (419, '17d95af3-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteStaticRoute', 'ALLOW', NULL, 100);
INSERT INTO `role_permissions` VALUES (420, '17d95f28-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteTags', 'ALLOW', NULL, 101);
INSERT INTO `role_permissions` VALUES (421, '17d9632b-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteTemplate', 'ALLOW', NULL, 102);
INSERT INTO `role_permissions` VALUES (422, '17d96745-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteUser', 'ALLOW', NULL, 103);
INSERT INTO `role_permissions` VALUES (423, '17d96b44-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVMSnapshot', 'ALLOW', NULL, 104);
INSERT INTO `role_permissions` VALUES (424, '17d96f43-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVPC', 'ALLOW', NULL, 105);
INSERT INTO `role_permissions` VALUES (425, '17d97338-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVolume', 'ALLOW', NULL, 106);
INSERT INTO `role_permissions` VALUES (426, '17d9773d-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVpnConnection', 'ALLOW', NULL, 107);
INSERT INTO `role_permissions` VALUES (427, '17d97b37-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVpnCustomerGateway', 'ALLOW', NULL, 108);
INSERT INTO `role_permissions` VALUES (428, '17d97f36-cdfc-11ec-bb74-000c29bf26e7', 3, 'deleteVpnGateway', 'ALLOW', NULL, 109);
INSERT INTO `role_permissions` VALUES (429, '17d983f2-cdfc-11ec-bb74-000c29bf26e7', 3, 'deployVirtualMachine', 'ALLOW', NULL, 110);
INSERT INTO `role_permissions` VALUES (431, '17d98c06-cdfc-11ec-bb74-000c29bf26e7', 3, 'destroyRouter', 'ALLOW', NULL, 112);
INSERT INTO `role_permissions` VALUES (432, '17d99030-cdfc-11ec-bb74-000c29bf26e7', 3, 'destroyVirtualMachine', 'ALLOW', NULL, 113);
INSERT INTO `role_permissions` VALUES (434, '17d99e48-cdfc-11ec-bb74-000c29bf26e7', 3, 'detachIso', 'ALLOW', NULL, 115);
INSERT INTO `role_permissions` VALUES (435, '17d9a483-cdfc-11ec-bb74-000c29bf26e7', 3, 'detachVolume', 'ALLOW', NULL, 116);
INSERT INTO `role_permissions` VALUES (436, '17d9a92b-cdfc-11ec-bb74-000c29bf26e7', 3, 'disableAccount', 'ALLOW', NULL, 117);
INSERT INTO `role_permissions` VALUES (437, '17d9ad62-cdfc-11ec-bb74-000c29bf26e7', 3, 'disableAutoScaleVmGroup', 'ALLOW', NULL, 118);
INSERT INTO `role_permissions` VALUES (438, '17d9b2cf-cdfc-11ec-bb74-000c29bf26e7', 3, 'disableStaticNat', 'ALLOW', NULL, 119);
INSERT INTO `role_permissions` VALUES (439, '17d9b737-cdfc-11ec-bb74-000c29bf26e7', 3, 'disableUser', 'ALLOW', NULL, 120);
INSERT INTO `role_permissions` VALUES (440, '17d9bc89-cdfc-11ec-bb74-000c29bf26e7', 3, 'disassociateIpAddress', 'ALLOW', NULL, 121);
INSERT INTO `role_permissions` VALUES (442, '17d9c541-cdfc-11ec-bb74-000c29bf26e7', 3, 'enableAccount', 'ALLOW', NULL, 123);
INSERT INTO `role_permissions` VALUES (443, '17d9c988-cdfc-11ec-bb74-000c29bf26e7', 3, 'enableAutoScaleVmGroup', 'ALLOW', NULL, 124);
INSERT INTO `role_permissions` VALUES (444, '17d9ce3c-cdfc-11ec-bb74-000c29bf26e7', 3, 'enableStaticNat', 'ALLOW', NULL, 125);
INSERT INTO `role_permissions` VALUES (445, '17d9d2f7-cdfc-11ec-bb74-000c29bf26e7', 3, 'enableUser', 'ALLOW', NULL, 126);
INSERT INTO `role_permissions` VALUES (446, '17d9d756-cdfc-11ec-bb74-000c29bf26e7', 3, 'expungeVirtualMachine', 'ALLOW', NULL, 127);
INSERT INTO `role_permissions` VALUES (447, '17d9dcb8-cdfc-11ec-bb74-000c29bf26e7', 3, 'extractIso', 'ALLOW', NULL, 128);
INSERT INTO `role_permissions` VALUES (448, '17d9e1af-cdfc-11ec-bb74-000c29bf26e7', 3, 'extractTemplate', 'ALLOW', NULL, 129);
INSERT INTO `role_permissions` VALUES (449, '17d9e675-cdfc-11ec-bb74-000c29bf26e7', 3, 'extractVolume', 'ALLOW', NULL, 130);
INSERT INTO `role_permissions` VALUES (450, '17d9eaff-cdfc-11ec-bb74-000c29bf26e7', 3, 'getApiLimit', 'ALLOW', NULL, 131);
INSERT INTO `role_permissions` VALUES (451, '17d9ef6a-cdfc-11ec-bb74-000c29bf26e7', 3, 'getCloudIdentifier', 'ALLOW', NULL, 132);
INSERT INTO `role_permissions` VALUES (452, '17d9f3cc-cdfc-11ec-bb74-000c29bf26e7', 3, 'getSolidFireAccountId', 'ALLOW', NULL, 133);
INSERT INTO `role_permissions` VALUES (453, '17d9f8ed-cdfc-11ec-bb74-000c29bf26e7', 3, 'getSolidFireVolumeAccessGroupId', 'ALLOW', NULL, 134);
INSERT INTO `role_permissions` VALUES (454, '17d9fd6b-cdfc-11ec-bb74-000c29bf26e7', 3, 'getSolidFireVolumeIscsiName', 'ALLOW', NULL, 135);
INSERT INTO `role_permissions` VALUES (455, '17da01c8-cdfc-11ec-bb74-000c29bf26e7', 3, 'getSolidFireVolumeSize', 'ALLOW', NULL, 136);
INSERT INTO `role_permissions` VALUES (456, '17da0628-cdfc-11ec-bb74-000c29bf26e7', 3, 'getUploadParamsForTemplate', 'ALLOW', NULL, 137);
INSERT INTO `role_permissions` VALUES (457, '17da0a7c-cdfc-11ec-bb74-000c29bf26e7', 3, 'getUploadParamsForVolume', 'ALLOW', NULL, 138);
INSERT INTO `role_permissions` VALUES (458, '17da0ec9-cdfc-11ec-bb74-000c29bf26e7', 3, 'getVMPassword', 'ALLOW', NULL, 139);
INSERT INTO `role_permissions` VALUES (459, '17da1319-cdfc-11ec-bb74-000c29bf26e7', 3, 'getVirtualMachineUserData', 'ALLOW', NULL, 140);
INSERT INTO `role_permissions` VALUES (460, '17da176e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAccounts', 'ALLOW', NULL, 142);
INSERT INTO `role_permissions` VALUES (461, '17da1bc7-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAffinityGroupTypes', 'ALLOW', NULL, 143);
INSERT INTO `role_permissions` VALUES (462, '17da20ae-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAffinityGroups', 'ALLOW', NULL, 144);
INSERT INTO `role_permissions` VALUES (463, '17da2511-cdfc-11ec-bb74-000c29bf26e7', 3, 'listApis', 'ALLOW', NULL, 145);
INSERT INTO `role_permissions` VALUES (464, '17da2978-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAsyncJobs', 'ALLOW', NULL, 146);
INSERT INTO `role_permissions` VALUES (465, '17da2dea-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAutoScalePolicies', 'ALLOW', NULL, 147);
INSERT INTO `role_permissions` VALUES (466, '17da3258-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAutoScaleVmGroups', 'ALLOW', NULL, 148);
INSERT INTO `role_permissions` VALUES (467, '17da36b5-cdfc-11ec-bb74-000c29bf26e7', 3, 'listAutoScaleVmProfiles', 'ALLOW', NULL, 149);
INSERT INTO `role_permissions` VALUES (468, '17da3b16-cdfc-11ec-bb74-000c29bf26e7', 3, 'listCapabilities', 'ALLOW', NULL, 150);
INSERT INTO `role_permissions` VALUES (469, '17da3fa8-cdfc-11ec-bb74-000c29bf26e7', 3, 'listConditions', 'ALLOW', NULL, 151);
INSERT INTO `role_permissions` VALUES (470, '17da4465-cdfc-11ec-bb74-000c29bf26e7', 3, 'listCounters', 'ALLOW', NULL, 152);
INSERT INTO `role_permissions` VALUES (471, '17da48ef-cdfc-11ec-bb74-000c29bf26e7', 3, 'listDiskOfferings', 'ALLOW', NULL, 153);
INSERT INTO `role_permissions` VALUES (472, '17da4fbd-cdfc-11ec-bb74-000c29bf26e7', 3, 'listDomainChildren', 'ALLOW', NULL, 154);
INSERT INTO `role_permissions` VALUES (473, '17da5491-cdfc-11ec-bb74-000c29bf26e7', 3, 'listDomains', 'ALLOW', NULL, 155);
INSERT INTO `role_permissions` VALUES (474, '17da5a47-cdfc-11ec-bb74-000c29bf26e7', 3, 'listEgressFirewallRules', 'ALLOW', NULL, 156);
INSERT INTO `role_permissions` VALUES (475, '17da5f0e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listEventTypes', 'ALLOW', NULL, 157);
INSERT INTO `role_permissions` VALUES (476, '17da648d-cdfc-11ec-bb74-000c29bf26e7', 3, 'listEvents', 'ALLOW', NULL, 158);
INSERT INTO `role_permissions` VALUES (477, '17da71ae-cdfc-11ec-bb74-000c29bf26e7', 3, 'listFirewallRules', 'ALLOW', NULL, 159);
INSERT INTO `role_permissions` VALUES (478, '17da76c7-cdfc-11ec-bb74-000c29bf26e7', 3, 'listGlobalLoadBalancerRules', 'ALLOW', NULL, 160);
INSERT INTO `role_permissions` VALUES (479, '17da7c0e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listHostTags', 'ALLOW', NULL, 161);
INSERT INTO `role_permissions` VALUES (480, '17da80dc-cdfc-11ec-bb74-000c29bf26e7', 3, 'listHypervisors', 'ALLOW', NULL, 162);
INSERT INTO `role_permissions` VALUES (481, '17da85a0-cdfc-11ec-bb74-000c29bf26e7', 3, 'listInstanceGroups', 'ALLOW', NULL, 163);
INSERT INTO `role_permissions` VALUES (482, '17da8a69-cdfc-11ec-bb74-000c29bf26e7', 3, 'listInternalLoadBalancerElements', 'ALLOW', NULL, 164);
INSERT INTO `role_permissions` VALUES (483, '17da8f1f-cdfc-11ec-bb74-000c29bf26e7', 3, 'listIpForwardingRules', 'ALLOW', NULL, 165);
INSERT INTO `role_permissions` VALUES (484, '17da9582-cdfc-11ec-bb74-000c29bf26e7', 3, 'listIsoPermissions', 'ALLOW', NULL, 166);
INSERT INTO `role_permissions` VALUES (485, '17da9a8d-cdfc-11ec-bb74-000c29bf26e7', 3, 'listIsos', 'ALLOW', NULL, 167);
INSERT INTO `role_permissions` VALUES (486, '17da9f59-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLBHealthCheckPolicies', 'ALLOW', NULL, 168);
INSERT INTO `role_permissions` VALUES (487, '17daa413-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLBStickinessPolicies', 'ALLOW', NULL, 169);
INSERT INTO `role_permissions` VALUES (488, '17daa8d3-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLdapConfigurations', 'ALLOW', NULL, 170);
INSERT INTO `role_permissions` VALUES (489, '17daade4-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLoadBalancerRuleInstances', 'ALLOW', NULL, 171);
INSERT INTO `role_permissions` VALUES (490, '17dab50a-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLoadBalancerRules', 'ALLOW', NULL, 172);
INSERT INTO `role_permissions` VALUES (491, '17dabcec-cdfc-11ec-bb74-000c29bf26e7', 3, 'listLoadBalancers', 'ALLOW', NULL, 173);
INSERT INTO `role_permissions` VALUES (493, '17dac67d-cdfc-11ec-bb74-000c29bf26e7', 3, 'listNetworkACLLists', 'ALLOW', NULL, 175);
INSERT INTO `role_permissions` VALUES (494, '17daca9e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listNetworkACLs', 'ALLOW', NULL, 176);
INSERT INTO `role_permissions` VALUES (495, '17daceb5-cdfc-11ec-bb74-000c29bf26e7', 3, 'listNetworkOfferings', 'ALLOW', NULL, 177);
INSERT INTO `role_permissions` VALUES (496, '17dad2b2-cdfc-11ec-bb74-000c29bf26e7', 3, 'listNetworks', 'ALLOW', NULL, 178);
INSERT INTO `role_permissions` VALUES (497, '17dad6ae-cdfc-11ec-bb74-000c29bf26e7', 3, 'listNics', 'ALLOW', NULL, 179);
INSERT INTO `role_permissions` VALUES (498, '17dadaa7-cdfc-11ec-bb74-000c29bf26e7', 3, 'listOsCategories', 'ALLOW', NULL, 180);
INSERT INTO `role_permissions` VALUES (499, '17dade98-cdfc-11ec-bb74-000c29bf26e7', 3, 'listOsTypes', 'ALLOW', NULL, 181);
INSERT INTO `role_permissions` VALUES (500, '17dae40b-cdfc-11ec-bb74-000c29bf26e7', 3, 'listOvsElements', 'ALLOW', NULL, 182);
INSERT INTO `role_permissions` VALUES (502, '17daed82-cdfc-11ec-bb74-000c29bf26e7', 3, 'listPortForwardingRules', 'ALLOW', NULL, 184);
INSERT INTO `role_permissions` VALUES (503, '17daf1d3-cdfc-11ec-bb74-000c29bf26e7', 3, 'listPrivateGateways', 'ALLOW', NULL, 185);
INSERT INTO `role_permissions` VALUES (504, '17daf621-cdfc-11ec-bb74-000c29bf26e7', 3, 'listProjectAccounts', 'ALLOW', NULL, 186);
INSERT INTO `role_permissions` VALUES (505, '17dafa6b-cdfc-11ec-bb74-000c29bf26e7', 3, 'listProjectInvitations', 'ALLOW', NULL, 187);
INSERT INTO `role_permissions` VALUES (506, '17dafeb0-cdfc-11ec-bb74-000c29bf26e7', 3, 'listProjects', 'ALLOW', NULL, 188);
INSERT INTO `role_permissions` VALUES (507, '17db03f3-cdfc-11ec-bb74-000c29bf26e7', 3, 'listPublicIpAddresses', 'ALLOW', NULL, 189);
INSERT INTO `role_permissions` VALUES (508, '17db097b-cdfc-11ec-bb74-000c29bf26e7', 3, 'listRegions', 'ALLOW', NULL, 190);
INSERT INTO `role_permissions` VALUES (509, '17db0e05-cdfc-11ec-bb74-000c29bf26e7', 3, 'listRemoteAccessVpns', 'ALLOW', NULL, 191);
INSERT INTO `role_permissions` VALUES (510, '17db126a-cdfc-11ec-bb74-000c29bf26e7', 3, 'listResourceDetails', 'ALLOW', NULL, 192);
INSERT INTO `role_permissions` VALUES (511, '17db1705-cdfc-11ec-bb74-000c29bf26e7', 3, 'listResourceLimits', 'ALLOW', NULL, 193);
INSERT INTO `role_permissions` VALUES (512, '17db1b1c-cdfc-11ec-bb74-000c29bf26e7', 3, 'listRouters', 'ALLOW', NULL, 194);
INSERT INTO `role_permissions` VALUES (513, '17db1f0f-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSSHKeyPairs', 'ALLOW', NULL, 195);
INSERT INTO `role_permissions` VALUES (514, '17db234e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSamlAuthorization', 'ALLOW', NULL, 196);
INSERT INTO `role_permissions` VALUES (515, '17db278a-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSecurityGroups', 'ALLOW', NULL, 197);
INSERT INTO `role_permissions` VALUES (516, '17db2b97-cdfc-11ec-bb74-000c29bf26e7', 3, 'listServiceOfferings', 'ALLOW', NULL, 198);
INSERT INTO `role_permissions` VALUES (517, '17db3078-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSnapshotPolicies', 'ALLOW', NULL, 199);
INSERT INTO `role_permissions` VALUES (518, '17db34a0-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSnapshots', 'ALLOW', NULL, 200);
INSERT INTO `role_permissions` VALUES (519, '17db389a-cdfc-11ec-bb74-000c29bf26e7', 3, 'listSslCerts', 'ALLOW', NULL, 201);
INSERT INTO `role_permissions` VALUES (520, '17db3c9e-cdfc-11ec-bb74-000c29bf26e7', 3, 'listStaticRoutes', 'ALLOW', NULL, 202);
INSERT INTO `role_permissions` VALUES (521, '17db4819-cdfc-11ec-bb74-000c29bf26e7', 3, 'listStorageTags', 'ALLOW', NULL, 203);
INSERT INTO `role_permissions` VALUES (522, '17db4c76-cdfc-11ec-bb74-000c29bf26e7', 3, 'listTags', 'ALLOW', NULL, 204);
INSERT INTO `role_permissions` VALUES (523, '17db5084-cdfc-11ec-bb74-000c29bf26e7', 3, 'listTemplatePermissions', 'ALLOW', NULL, 205);
INSERT INTO `role_permissions` VALUES (524, '17db54d1-cdfc-11ec-bb74-000c29bf26e7', 3, 'listTemplates', 'ALLOW', NULL, 206);
INSERT INTO `role_permissions` VALUES (525, '17db5925-cdfc-11ec-bb74-000c29bf26e7', 3, 'listUsageRecords', 'ALLOW', NULL, 207);
INSERT INTO `role_permissions` VALUES (526, '17db5d30-cdfc-11ec-bb74-000c29bf26e7', 3, 'listUsers', 'ALLOW', NULL, 208);
INSERT INTO `role_permissions` VALUES (527, '17db613f-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVMSnapshot', 'ALLOW', NULL, 209);
INSERT INTO `role_permissions` VALUES (528, '17db6843-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVPCOfferings', 'ALLOW', NULL, 210);
INSERT INTO `role_permissions` VALUES (529, '17db6daf-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVPCs', 'ALLOW', NULL, 211);
INSERT INTO `role_permissions` VALUES (530, '17db7246-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVirtualMachines', 'ALLOW', NULL, 212);
INSERT INTO `role_permissions` VALUES (531, '17db76c0-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVirtualRouterElements', 'ALLOW', NULL, 213);
INSERT INTO `role_permissions` VALUES (532, '17db7b31-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVolumes', 'ALLOW', NULL, 214);
INSERT INTO `role_permissions` VALUES (534, '17db86a3-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVpnConnections', 'ALLOW', NULL, 216);
INSERT INTO `role_permissions` VALUES (535, '17db8bac-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVpnCustomerGateways', 'ALLOW', NULL, 217);
INSERT INTO `role_permissions` VALUES (536, '17db908b-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVpnGateways', 'ALLOW', NULL, 218);
INSERT INTO `role_permissions` VALUES (537, '17db9555-cdfc-11ec-bb74-000c29bf26e7', 3, 'listVpnUsers', 'ALLOW', NULL, 219);
INSERT INTO `role_permissions` VALUES (538, '17db9a19-cdfc-11ec-bb74-000c29bf26e7', 3, 'listZones', 'ALLOW', NULL, 220);
INSERT INTO `role_permissions` VALUES (539, '17db9ec9-cdfc-11ec-bb74-000c29bf26e7', 3, 'lockAccount', 'ALLOW', NULL, 221);
INSERT INTO `role_permissions` VALUES (540, '17dba3ce-cdfc-11ec-bb74-000c29bf26e7', 3, 'lockUser', 'ALLOW', NULL, 222);
INSERT INTO `role_permissions` VALUES (541, '17dba89b-cdfc-11ec-bb74-000c29bf26e7', 3, 'migrateVolume', 'ALLOW', NULL, 223);
INSERT INTO `role_permissions` VALUES (543, '17dbb239-cdfc-11ec-bb74-000c29bf26e7', 3, 'queryAsyncJobResult', 'ALLOW', NULL, 225);
INSERT INTO `role_permissions` VALUES (544, '17dbb684-cdfc-11ec-bb74-000c29bf26e7', 3, 'quotaBalance', 'ALLOW', NULL, 226);
INSERT INTO `role_permissions` VALUES (545, '17dbbacd-cdfc-11ec-bb74-000c29bf26e7', 3, 'quotaIsEnabled', 'ALLOW', NULL, 227);
INSERT INTO `role_permissions` VALUES (546, '17dbbf0f-cdfc-11ec-bb74-000c29bf26e7', 3, 'quotaStatement', 'ALLOW', NULL, 228);
INSERT INTO `role_permissions` VALUES (547, '17dbc354-cdfc-11ec-bb74-000c29bf26e7', 3, 'quotaSummary', 'ALLOW', NULL, 229);
INSERT INTO `role_permissions` VALUES (548, '17dbca42-cdfc-11ec-bb74-000c29bf26e7', 3, 'quotaTariffList', 'ALLOW', NULL, 230);
INSERT INTO `role_permissions` VALUES (549, '17dbd082-cdfc-11ec-bb74-000c29bf26e7', 3, 'rebootRouter', 'ALLOW', NULL, 231);
INSERT INTO `role_permissions` VALUES (550, '17dbd525-cdfc-11ec-bb74-000c29bf26e7', 3, 'rebootVirtualMachine', 'ALLOW', NULL, 232);
INSERT INTO `role_permissions` VALUES (551, '17dbd95f-cdfc-11ec-bb74-000c29bf26e7', 3, 'recoverVirtualMachine', 'ALLOW', NULL, 233);
INSERT INTO `role_permissions` VALUES (552, '17dbdd71-cdfc-11ec-bb74-000c29bf26e7', 3, 'registerIso', 'ALLOW', NULL, 234);
INSERT INTO `role_permissions` VALUES (553, '17dbe17f-cdfc-11ec-bb74-000c29bf26e7', 3, 'registerSSHKeyPair', 'ALLOW', NULL, 235);
INSERT INTO `role_permissions` VALUES (554, '17dbe57f-cdfc-11ec-bb74-000c29bf26e7', 3, 'registerTemplate', 'ALLOW', NULL, 236);
INSERT INTO `role_permissions` VALUES (555, '17dbe970-cdfc-11ec-bb74-000c29bf26e7', 3, 'registerUserKeys', 'ALLOW', NULL, 237);
INSERT INTO `role_permissions` VALUES (556, '17dbed5f-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeCertFromLoadBalancer', 'ALLOW', NULL, 238);
INSERT INTO `role_permissions` VALUES (557, '17dbf19e-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeFromGlobalLoadBalancerRule', 'ALLOW', NULL, 239);
INSERT INTO `role_permissions` VALUES (558, '17dbf5dd-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeFromLoadBalancerRule', 'ALLOW', NULL, 240);
INSERT INTO `role_permissions` VALUES (559, '17dbf9da-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeIpFromNic', 'ALLOW', NULL, 241);
INSERT INTO `role_permissions` VALUES (560, '17dbfdca-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeNicFromVirtualMachine', 'ALLOW', NULL, 242);
INSERT INTO `role_permissions` VALUES (561, '17dc01b2-cdfc-11ec-bb74-000c29bf26e7', 3, 'removeVpnUser', 'ALLOW', NULL, 243);
INSERT INTO `role_permissions` VALUES (562, '17dc05ab-cdfc-11ec-bb74-000c29bf26e7', 3, 'replaceNetworkACLList', 'ALLOW', NULL, 244);
INSERT INTO `role_permissions` VALUES (563, '17dc0999-cdfc-11ec-bb74-000c29bf26e7', 3, 'resetPasswordForVirtualMachine', 'ALLOW', NULL, 245);
INSERT INTO `role_permissions` VALUES (564, '17dc0dd9-cdfc-11ec-bb74-000c29bf26e7', 3, 'resetSSHKeyForVirtualMachine', 'ALLOW', NULL, 246);
INSERT INTO `role_permissions` VALUES (565, '17dc11d6-cdfc-11ec-bb74-000c29bf26e7', 3, 'resetVpnConnection', 'ALLOW', NULL, 247);
INSERT INTO `role_permissions` VALUES (566, '17dc15ec-cdfc-11ec-bb74-000c29bf26e7', 3, 'resizeVolume', 'ALLOW', NULL, 248);
INSERT INTO `role_permissions` VALUES (567, '17dc1a7c-cdfc-11ec-bb74-000c29bf26e7', 3, 'restartNetwork', 'ALLOW', NULL, 249);
INSERT INTO `role_permissions` VALUES (568, '17dc1e7c-cdfc-11ec-bb74-000c29bf26e7', 3, 'restartVPC', 'ALLOW', NULL, 250);
INSERT INTO `role_permissions` VALUES (569, '17dc23dd-cdfc-11ec-bb74-000c29bf26e7', 3, 'restoreVirtualMachine', 'ALLOW', NULL, 251);
INSERT INTO `role_permissions` VALUES (570, '17dc2844-cdfc-11ec-bb74-000c29bf26e7', 3, 'revertSnapshot', 'ALLOW', NULL, 252);
INSERT INTO `role_permissions` VALUES (571, '17dc3434-cdfc-11ec-bb74-000c29bf26e7', 3, 'revertToVMSnapshot', 'ALLOW', NULL, 253);
INSERT INTO `role_permissions` VALUES (572, '17dc38a6-cdfc-11ec-bb74-000c29bf26e7', 3, 'revokeSecurityGroupEgress', 'ALLOW', NULL, 254);
INSERT INTO `role_permissions` VALUES (573, '17dc3e36-cdfc-11ec-bb74-000c29bf26e7', 3, 'revokeSecurityGroupIngress', 'ALLOW', NULL, 255);
INSERT INTO `role_permissions` VALUES (574, '17dc435e-cdfc-11ec-bb74-000c29bf26e7', 3, 'scaleVirtualMachine', 'ALLOW', NULL, 256);
INSERT INTO `role_permissions` VALUES (575, '17dc47cc-cdfc-11ec-bb74-000c29bf26e7', 3, 'startRouter', 'ALLOW', NULL, 257);
INSERT INTO `role_permissions` VALUES (576, '17dc4c5f-cdfc-11ec-bb74-000c29bf26e7', 3, 'startVirtualMachine', 'ALLOW', NULL, 258);
INSERT INTO `role_permissions` VALUES (577, '17dc5053-cdfc-11ec-bb74-000c29bf26e7', 3, 'stopRouter', 'ALLOW', NULL, 259);
INSERT INTO `role_permissions` VALUES (578, '17dc5447-cdfc-11ec-bb74-000c29bf26e7', 3, 'stopVirtualMachine', 'ALLOW', NULL, 260);
INSERT INTO `role_permissions` VALUES (579, '17dc582c-cdfc-11ec-bb74-000c29bf26e7', 3, 'suspendProject', 'ALLOW', NULL, 261);
INSERT INTO `role_permissions` VALUES (580, '17dc5c64-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateAccount', 'ALLOW', NULL, 262);
INSERT INTO `role_permissions` VALUES (581, '17dc610d-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateAutoScalePolicy', 'ALLOW', NULL, 263);
INSERT INTO `role_permissions` VALUES (582, '17dc672b-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateAutoScaleVmGroup', 'ALLOW', NULL, 264);
INSERT INTO `role_permissions` VALUES (583, '17dc6be2-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateAutoScaleVmProfile', 'ALLOW', NULL, 265);
INSERT INTO `role_permissions` VALUES (584, '17dc704a-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateDefaultNicForVirtualMachine', 'ALLOW', NULL, 266);
INSERT INTO `role_permissions` VALUES (585, '17dc74a9-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateDiskOffering', 'ALLOW', NULL, 267);
INSERT INTO `role_permissions` VALUES (586, '17dc7900-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateEgressFirewallRule', 'ALLOW', NULL, 268);
INSERT INTO `role_permissions` VALUES (587, '17dc7d49-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateFirewallRule', 'ALLOW', NULL, 269);
INSERT INTO `role_permissions` VALUES (588, '17dc8198-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateGlobalLoadBalancerRule', 'ALLOW', NULL, 270);
INSERT INTO `role_permissions` VALUES (589, '17dc85e5-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateInstanceGroup', 'ALLOW', NULL, 271);
INSERT INTO `role_permissions` VALUES (590, '17dc8a27-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateIpAddress', 'ALLOW', NULL, 272);
INSERT INTO `role_permissions` VALUES (591, '17dc8ede-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateIso', 'ALLOW', NULL, 273);
INSERT INTO `role_permissions` VALUES (592, '17dc9349-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateIsoPermissions', 'ALLOW', NULL, 274);
INSERT INTO `role_permissions` VALUES (593, '17dc9795-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateLBHealthCheckPolicy', 'ALLOW', NULL, 275);
INSERT INTO `role_permissions` VALUES (594, '17dc9beb-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateLBStickinessPolicy', 'ALLOW', NULL, 276);
INSERT INTO `role_permissions` VALUES (595, '17dca076-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateLoadBalancer', 'ALLOW', NULL, 277);
INSERT INTO `role_permissions` VALUES (596, '17dca526-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateLoadBalancerRule', 'ALLOW', NULL, 278);
INSERT INTO `role_permissions` VALUES (597, '17dca97b-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateNetwork', 'ALLOW', NULL, 279);
INSERT INTO `role_permissions` VALUES (598, '17dcadc8-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateNetworkACLItem', 'ALLOW', NULL, 280);
INSERT INTO `role_permissions` VALUES (599, '17dcb214-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateNetworkACLList', 'ALLOW', NULL, 281);
INSERT INTO `role_permissions` VALUES (600, '17dcb6f2-cdfc-11ec-bb74-000c29bf26e7', 3, 'updatePortForwardingRule', 'ALLOW', NULL, 282);
INSERT INTO `role_permissions` VALUES (601, '17dcbb52-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateProject', 'ALLOW', NULL, 283);
INSERT INTO `role_permissions` VALUES (602, '17dcc086-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateProjectInvitation', 'ALLOW', NULL, 284);
INSERT INTO `role_permissions` VALUES (603, '17dcc4e3-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateRemoteAccessVpn', 'ALLOW', NULL, 285);
INSERT INTO `role_permissions` VALUES (604, '17dcc936-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateResourceCount', 'ALLOW', NULL, 286);
INSERT INTO `role_permissions` VALUES (605, '17dcce4f-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateResourceLimit', 'ALLOW', NULL, 287);
INSERT INTO `role_permissions` VALUES (606, '17dcd38a-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateServiceOffering', 'ALLOW', NULL, 288);
INSERT INTO `role_permissions` VALUES (607, '17dcd88c-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateSnapshotPolicy', 'ALLOW', NULL, 289);
INSERT INTO `role_permissions` VALUES (608, '17dcddcd-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateTemplate', 'ALLOW', NULL, 290);
INSERT INTO `role_permissions` VALUES (609, '17dce295-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateTemplatePermissions', 'ALLOW', NULL, 291);
INSERT INTO `role_permissions` VALUES (610, '17dce745-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateUser', 'ALLOW', NULL, 292);
INSERT INTO `role_permissions` VALUES (611, '17dcec15-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVMAffinityGroup', 'ALLOW', NULL, 293);
INSERT INTO `role_permissions` VALUES (612, '17dcf126-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVPC', 'ALLOW', NULL, 294);
INSERT INTO `role_permissions` VALUES (613, '17dcf5cb-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVirtualMachine', 'ALLOW', NULL, 295);
INSERT INTO `role_permissions` VALUES (614, '17dcfa6f-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVmNicIp', 'ALLOW', NULL, 296);
INSERT INTO `role_permissions` VALUES (615, '17dcff71-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVpnConnection', 'ALLOW', NULL, 297);
INSERT INTO `role_permissions` VALUES (616, '17dd0417-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVpnCustomerGateway', 'ALLOW', NULL, 298);
INSERT INTO `role_permissions` VALUES (617, '17dd0995-cdfc-11ec-bb74-000c29bf26e7', 3, 'updateVpnGateway', 'ALLOW', NULL, 299);
INSERT INTO `role_permissions` VALUES (618, '17dd0e03-cdfc-11ec-bb74-000c29bf26e7', 3, 'uploadSslCert', 'ALLOW', NULL, 300);
INSERT INTO `role_permissions` VALUES (619, '17dd1257-cdfc-11ec-bb74-000c29bf26e7', 3, 'uploadVolume', 'ALLOW', NULL, 301);
INSERT INTO `role_permissions` VALUES (620, '17dd200e-cdfc-11ec-bb74-000c29bf26e7', 4, 'activateProject', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (621, '17dd2488-cdfc-11ec-bb74-000c29bf26e7', 4, 'addAccountToProject', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (622, '17dd28da-cdfc-11ec-bb74-000c29bf26e7', 4, 'addIpToNic', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (623, '17dd2dc7-cdfc-11ec-bb74-000c29bf26e7', 4, 'addNicToVirtualMachine', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (624, '17dd321f-cdfc-11ec-bb74-000c29bf26e7', 4, 'addVpnUser', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (625, '17dd366d-cdfc-11ec-bb74-000c29bf26e7', 4, 'archiveEvents', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (626, '17dd3ab7-cdfc-11ec-bb74-000c29bf26e7', 4, 'assignCertToLoadBalancer', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (627, '17dd3f04-cdfc-11ec-bb74-000c29bf26e7', 4, 'assignToGlobalLoadBalancerRule', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (628, '17dd4442-cdfc-11ec-bb74-000c29bf26e7', 4, 'assignToLoadBalancerRule', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (629, '17dd4937-cdfc-11ec-bb74-000c29bf26e7', 4, 'associateIpAddress', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (631, '17dd52aa-cdfc-11ec-bb74-000c29bf26e7', 4, 'attachIso', 'ALLOW', NULL, 11);
INSERT INTO `role_permissions` VALUES (632, '17dd5704-cdfc-11ec-bb74-000c29bf26e7', 4, 'attachVolume', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (633, '17dd5c5d-cdfc-11ec-bb74-000c29bf26e7', 4, 'authorizeSecurityGroupEgress', 'ALLOW', NULL, 13);
INSERT INTO `role_permissions` VALUES (634, '17dd60c3-cdfc-11ec-bb74-000c29bf26e7', 4, 'authorizeSecurityGroupIngress', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (635, '17dd6527-cdfc-11ec-bb74-000c29bf26e7', 4, 'changeServiceForVirtualMachine', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (636, '17dd6972-cdfc-11ec-bb74-000c29bf26e7', 4, 'copyIso', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (637, '17dd6db6-cdfc-11ec-bb74-000c29bf26e7', 4, 'copyTemplate', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (638, '17dd71f2-cdfc-11ec-bb74-000c29bf26e7', 4, 'createAffinityGroup', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (639, '17dd7634-cdfc-11ec-bb74-000c29bf26e7', 4, 'createAutoScalePolicy', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (640, '17dd7b23-cdfc-11ec-bb74-000c29bf26e7', 4, 'createAutoScaleVmGroup', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (641, '17dd7f7e-cdfc-11ec-bb74-000c29bf26e7', 4, 'createAutoScaleVmProfile', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (642, '17dd83c3-cdfc-11ec-bb74-000c29bf26e7', 4, 'createCondition', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (643, '17dd882b-cdfc-11ec-bb74-000c29bf26e7', 4, 'createEgressFirewallRule', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (644, '17dd8ca0-cdfc-11ec-bb74-000c29bf26e7', 4, 'createFirewallRule', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (645, '17dd90e6-cdfc-11ec-bb74-000c29bf26e7', 4, 'createGlobalLoadBalancerRule', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (646, '17dd9529-cdfc-11ec-bb74-000c29bf26e7', 4, 'createInstanceGroup', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (647, '17dd9973-cdfc-11ec-bb74-000c29bf26e7', 4, 'createIpForwardingRule', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (648, '17dd9ddd-cdfc-11ec-bb74-000c29bf26e7', 4, 'createLBHealthCheckPolicy', 'ALLOW', NULL, 28);
INSERT INTO `role_permissions` VALUES (649, '17dda3af-cdfc-11ec-bb74-000c29bf26e7', 4, 'createLBStickinessPolicy', 'ALLOW', NULL, 29);
INSERT INTO `role_permissions` VALUES (650, '17dda827-cdfc-11ec-bb74-000c29bf26e7', 4, 'createLoadBalancer', 'ALLOW', NULL, 30);
INSERT INTO `role_permissions` VALUES (651, '17ddad77-cdfc-11ec-bb74-000c29bf26e7', 4, 'createLoadBalancerRule', 'ALLOW', NULL, 31);
INSERT INTO `role_permissions` VALUES (653, '17ddb65d-cdfc-11ec-bb74-000c29bf26e7', 4, 'createNetwork', 'ALLOW', NULL, 33);
INSERT INTO `role_permissions` VALUES (654, '17ddbad1-cdfc-11ec-bb74-000c29bf26e7', 4, 'createNetworkACL', 'ALLOW', NULL, 34);
INSERT INTO `role_permissions` VALUES (655, '17ddbf1d-cdfc-11ec-bb74-000c29bf26e7', 4, 'createNetworkACLList', 'ALLOW', NULL, 35);
INSERT INTO `role_permissions` VALUES (657, '17ddc836-cdfc-11ec-bb74-000c29bf26e7', 4, 'createPortForwardingRule', 'ALLOW', NULL, 37);
INSERT INTO `role_permissions` VALUES (658, '17ddcc98-cdfc-11ec-bb74-000c29bf26e7', 4, 'createProject', 'ALLOW', NULL, 38);
INSERT INTO `role_permissions` VALUES (659, '17ddd120-cdfc-11ec-bb74-000c29bf26e7', 4, 'createRemoteAccessVpn', 'ALLOW', NULL, 39);
INSERT INTO `role_permissions` VALUES (660, '17ddd572-cdfc-11ec-bb74-000c29bf26e7', 4, 'createSSHKeyPair', 'ALLOW', NULL, 40);
INSERT INTO `role_permissions` VALUES (661, '17dddae7-cdfc-11ec-bb74-000c29bf26e7', 4, 'createSecurityGroup', 'ALLOW', NULL, 41);
INSERT INTO `role_permissions` VALUES (662, '17dddf66-cdfc-11ec-bb74-000c29bf26e7', 4, 'createSnapshot', 'ALLOW', NULL, 42);
INSERT INTO `role_permissions` VALUES (663, '17dde3c0-cdfc-11ec-bb74-000c29bf26e7', 4, 'createSnapshotPolicy', 'ALLOW', NULL, 43);
INSERT INTO `role_permissions` VALUES (664, '17ddeab0-cdfc-11ec-bb74-000c29bf26e7', 4, 'createStaticRoute', 'ALLOW', NULL, 44);
INSERT INTO `role_permissions` VALUES (665, '17ddefc8-cdfc-11ec-bb74-000c29bf26e7', 4, 'createTags', 'ALLOW', NULL, 45);
INSERT INTO `role_permissions` VALUES (666, '17ddf434-cdfc-11ec-bb74-000c29bf26e7', 4, 'createTemplate', 'ALLOW', NULL, 46);
INSERT INTO `role_permissions` VALUES (667, '17ddf951-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVMSnapshot', 'ALLOW', NULL, 47);
INSERT INTO `role_permissions` VALUES (668, '17ddfdb5-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVPC', 'ALLOW', NULL, 48);
INSERT INTO `role_permissions` VALUES (669, '17de020f-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVolume', 'ALLOW', NULL, 49);
INSERT INTO `role_permissions` VALUES (671, '17de0ba8-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVpnConnection', 'ALLOW', NULL, 51);
INSERT INTO `role_permissions` VALUES (672, '17de107a-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVpnCustomerGateway', 'ALLOW', NULL, 52);
INSERT INTO `role_permissions` VALUES (673, '17de1592-cdfc-11ec-bb74-000c29bf26e7', 4, 'createVpnGateway', 'ALLOW', NULL, 53);
INSERT INTO `role_permissions` VALUES (674, '17de1a67-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteAccountFromProject', 'ALLOW', NULL, 54);
INSERT INTO `role_permissions` VALUES (675, '17de1fc3-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteAffinityGroup', 'ALLOW', NULL, 55);
INSERT INTO `role_permissions` VALUES (676, '17de2407-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteAutoScalePolicy', 'ALLOW', NULL, 56);
INSERT INTO `role_permissions` VALUES (677, '17de288f-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteAutoScaleVmGroup', 'ALLOW', NULL, 57);
INSERT INTO `role_permissions` VALUES (678, '17de2ce6-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteAutoScaleVmProfile', 'ALLOW', NULL, 58);
INSERT INTO `role_permissions` VALUES (679, '17de3136-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteCondition', 'ALLOW', NULL, 59);
INSERT INTO `role_permissions` VALUES (680, '17de4018-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteEgressFirewallRule', 'ALLOW', NULL, 60);
INSERT INTO `role_permissions` VALUES (681, '17de449b-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteEvents', 'ALLOW', NULL, 61);
INSERT INTO `role_permissions` VALUES (682, '17de48f5-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteFirewallRule', 'ALLOW', NULL, 62);
INSERT INTO `role_permissions` VALUES (683, '17de4d42-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteGlobalLoadBalancerRule', 'ALLOW', NULL, 63);
INSERT INTO `role_permissions` VALUES (684, '17de518a-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteInstanceGroup', 'ALLOW', NULL, 64);
INSERT INTO `role_permissions` VALUES (685, '17de55c9-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteIpForwardingRule', 'ALLOW', NULL, 65);
INSERT INTO `role_permissions` VALUES (686, '17de5a09-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteIso', 'ALLOW', NULL, 66);
INSERT INTO `role_permissions` VALUES (687, '17de5e4e-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteLBHealthCheckPolicy', 'ALLOW', NULL, 67);
INSERT INTO `role_permissions` VALUES (688, '17de62f8-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteLBStickinessPolicy', 'ALLOW', NULL, 68);
INSERT INTO `role_permissions` VALUES (689, '17de6772-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteLoadBalancer', 'ALLOW', NULL, 69);
INSERT INTO `role_permissions` VALUES (690, '17de6bc5-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteLoadBalancerRule', 'ALLOW', NULL, 70);
INSERT INTO `role_permissions` VALUES (691, '17de7033-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteNetwork', 'ALLOW', NULL, 71);
INSERT INTO `role_permissions` VALUES (692, '17de7484-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteNetworkACL', 'ALLOW', NULL, 72);
INSERT INTO `role_permissions` VALUES (693, '17de78c7-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteNetworkACLList', 'ALLOW', NULL, 73);
INSERT INTO `role_permissions` VALUES (695, '17de8171-cdfc-11ec-bb74-000c29bf26e7', 4, 'deletePortForwardingRule', 'ALLOW', NULL, 75);
INSERT INTO `role_permissions` VALUES (696, '17de85b1-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteProject', 'ALLOW', NULL, 76);
INSERT INTO `role_permissions` VALUES (697, '17de8a73-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteProjectInvitation', 'ALLOW', NULL, 77);
INSERT INTO `role_permissions` VALUES (698, '17de8ee1-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteRemoteAccessVpn', 'ALLOW', NULL, 78);
INSERT INTO `role_permissions` VALUES (699, '17de93f3-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteSSHKeyPair', 'ALLOW', NULL, 79);
INSERT INTO `role_permissions` VALUES (700, '17de990a-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteSecurityGroup', 'ALLOW', NULL, 80);
INSERT INTO `role_permissions` VALUES (701, '17de9dc1-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteSnapshot', 'ALLOW', NULL, 81);
INSERT INTO `role_permissions` VALUES (702, '17dea267-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteSnapshotPolicies', 'ALLOW', NULL, 82);
INSERT INTO `role_permissions` VALUES (703, '17dea734-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteSslCert', 'ALLOW', NULL, 83);
INSERT INTO `role_permissions` VALUES (704, '17deabd9-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteStaticRoute', 'ALLOW', NULL, 84);
INSERT INTO `role_permissions` VALUES (705, '17deb0eb-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteTags', 'ALLOW', NULL, 85);
INSERT INTO `role_permissions` VALUES (706, '17deb6ed-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteTemplate', 'ALLOW', NULL, 86);
INSERT INTO `role_permissions` VALUES (707, '17debc3e-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVMSnapshot', 'ALLOW', NULL, 87);
INSERT INTO `role_permissions` VALUES (708, '17dec09e-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVPC', 'ALLOW', NULL, 88);
INSERT INTO `role_permissions` VALUES (709, '17dec4eb-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVolume', 'ALLOW', NULL, 89);
INSERT INTO `role_permissions` VALUES (710, '17dec941-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVpnConnection', 'ALLOW', NULL, 90);
INSERT INTO `role_permissions` VALUES (711, '17decd92-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVpnCustomerGateway', 'ALLOW', NULL, 91);
INSERT INTO `role_permissions` VALUES (712, '17ded1d7-cdfc-11ec-bb74-000c29bf26e7', 4, 'deleteVpnGateway', 'ALLOW', NULL, 92);
INSERT INTO `role_permissions` VALUES (713, '17ded61f-cdfc-11ec-bb74-000c29bf26e7', 4, 'deployVirtualMachine', 'ALLOW', NULL, 93);
INSERT INTO `role_permissions` VALUES (715, '17dedf41-cdfc-11ec-bb74-000c29bf26e7', 4, 'destroyVirtualMachine', 'ALLOW', NULL, 95);
INSERT INTO `role_permissions` VALUES (717, '17dee7bf-cdfc-11ec-bb74-000c29bf26e7', 4, 'detachIso', 'ALLOW', NULL, 97);
INSERT INTO `role_permissions` VALUES (718, '17deec01-cdfc-11ec-bb74-000c29bf26e7', 4, 'detachVolume', 'ALLOW', NULL, 98);
INSERT INTO `role_permissions` VALUES (719, '17def03a-cdfc-11ec-bb74-000c29bf26e7', 4, 'disableAutoScaleVmGroup', 'ALLOW', NULL, 99);
INSERT INTO `role_permissions` VALUES (720, '17def46d-cdfc-11ec-bb74-000c29bf26e7', 4, 'disableStaticNat', 'ALLOW', NULL, 100);
INSERT INTO `role_permissions` VALUES (721, '17def8cb-cdfc-11ec-bb74-000c29bf26e7', 4, 'disassociateIpAddress', 'ALLOW', NULL, 101);
INSERT INTO `role_permissions` VALUES (723, '17df0208-cdfc-11ec-bb74-000c29bf26e7', 4, 'enableAutoScaleVmGroup', 'ALLOW', NULL, 103);
INSERT INTO `role_permissions` VALUES (724, '17df0659-cdfc-11ec-bb74-000c29bf26e7', 4, 'enableStaticNat', 'ALLOW', NULL, 104);
INSERT INTO `role_permissions` VALUES (725, '17df0a9f-cdfc-11ec-bb74-000c29bf26e7', 4, 'expungeVirtualMachine', 'ALLOW', NULL, 105);
INSERT INTO `role_permissions` VALUES (726, '17df0ede-cdfc-11ec-bb74-000c29bf26e7', 4, 'extractIso', 'ALLOW', NULL, 106);
INSERT INTO `role_permissions` VALUES (727, '17df132d-cdfc-11ec-bb74-000c29bf26e7', 4, 'extractTemplate', 'ALLOW', NULL, 107);
INSERT INTO `role_permissions` VALUES (728, '17df1764-cdfc-11ec-bb74-000c29bf26e7', 4, 'extractVolume', 'ALLOW', NULL, 108);
INSERT INTO `role_permissions` VALUES (729, '17df1b99-cdfc-11ec-bb74-000c29bf26e7', 4, 'getApiLimit', 'ALLOW', NULL, 109);
INSERT INTO `role_permissions` VALUES (730, '17df1fd5-cdfc-11ec-bb74-000c29bf26e7', 4, 'getCloudIdentifier', 'ALLOW', NULL, 110);
INSERT INTO `role_permissions` VALUES (731, '17df240d-cdfc-11ec-bb74-000c29bf26e7', 4, 'getSolidFireAccountId', 'ALLOW', NULL, 111);
INSERT INTO `role_permissions` VALUES (732, '17df28cb-cdfc-11ec-bb74-000c29bf26e7', 4, 'getSolidFireVolumeAccessGroupId', 'ALLOW', NULL, 112);
INSERT INTO `role_permissions` VALUES (733, '17df2d16-cdfc-11ec-bb74-000c29bf26e7', 4, 'getSolidFireVolumeIscsiName', 'ALLOW', NULL, 113);
INSERT INTO `role_permissions` VALUES (734, '17df330b-cdfc-11ec-bb74-000c29bf26e7', 4, 'getSolidFireVolumeSize', 'ALLOW', NULL, 114);
INSERT INTO `role_permissions` VALUES (735, '17df37b7-cdfc-11ec-bb74-000c29bf26e7', 4, 'getUploadParamsForTemplate', 'ALLOW', NULL, 115);
INSERT INTO `role_permissions` VALUES (736, '17df3c5b-cdfc-11ec-bb74-000c29bf26e7', 4, 'getUploadParamsForVolume', 'ALLOW', NULL, 116);
INSERT INTO `role_permissions` VALUES (737, '17df4117-cdfc-11ec-bb74-000c29bf26e7', 4, 'getVMPassword', 'ALLOW', NULL, 117);
INSERT INTO `role_permissions` VALUES (738, '17df45b0-cdfc-11ec-bb74-000c29bf26e7', 4, 'getVirtualMachineUserData', 'ALLOW', NULL, 118);
INSERT INTO `role_permissions` VALUES (739, '17df4a78-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAccounts', 'ALLOW', NULL, 120);
INSERT INTO `role_permissions` VALUES (740, '17df4fba-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAffinityGroupTypes', 'ALLOW', NULL, 121);
INSERT INTO `role_permissions` VALUES (741, '17df54a6-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAffinityGroups', 'ALLOW', NULL, 122);
INSERT INTO `role_permissions` VALUES (742, '17df58f2-cdfc-11ec-bb74-000c29bf26e7', 4, 'listApis', 'ALLOW', NULL, 123);
INSERT INTO `role_permissions` VALUES (743, '17df5d5b-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAsyncJobs', 'ALLOW', NULL, 124);
INSERT INTO `role_permissions` VALUES (744, '17df61ac-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAutoScalePolicies', 'ALLOW', NULL, 125);
INSERT INTO `role_permissions` VALUES (745, '17df65f1-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAutoScaleVmGroups', 'ALLOW', NULL, 126);
INSERT INTO `role_permissions` VALUES (746, '17df6a35-cdfc-11ec-bb74-000c29bf26e7', 4, 'listAutoScaleVmProfiles', 'ALLOW', NULL, 127);
INSERT INTO `role_permissions` VALUES (747, '17df6e7b-cdfc-11ec-bb74-000c29bf26e7', 4, 'listCapabilities', 'ALLOW', NULL, 128);
INSERT INTO `role_permissions` VALUES (748, '17df72a5-cdfc-11ec-bb74-000c29bf26e7', 4, 'listConditions', 'ALLOW', NULL, 129);
INSERT INTO `role_permissions` VALUES (749, '17df77aa-cdfc-11ec-bb74-000c29bf26e7', 4, 'listCounters', 'ALLOW', NULL, 130);
INSERT INTO `role_permissions` VALUES (750, '17df7ce0-cdfc-11ec-bb74-000c29bf26e7', 4, 'listDiskOfferings', 'ALLOW', NULL, 131);
INSERT INTO `role_permissions` VALUES (751, '17df8b73-cdfc-11ec-bb74-000c29bf26e7', 4, 'listEgressFirewallRules', 'ALLOW', NULL, 132);
INSERT INTO `role_permissions` VALUES (752, '17df90a2-cdfc-11ec-bb74-000c29bf26e7', 4, 'listEventTypes', 'ALLOW', NULL, 133);
INSERT INTO `role_permissions` VALUES (753, '17df9559-cdfc-11ec-bb74-000c29bf26e7', 4, 'listEvents', 'ALLOW', NULL, 134);
INSERT INTO `role_permissions` VALUES (754, '17df9aa4-cdfc-11ec-bb74-000c29bf26e7', 4, 'listFirewallRules', 'ALLOW', NULL, 135);
INSERT INTO `role_permissions` VALUES (755, '17df9f88-cdfc-11ec-bb74-000c29bf26e7', 4, 'listGlobalLoadBalancerRules', 'ALLOW', NULL, 136);
INSERT INTO `role_permissions` VALUES (756, '17dfa442-cdfc-11ec-bb74-000c29bf26e7', 4, 'listHypervisors', 'ALLOW', NULL, 137);
INSERT INTO `role_permissions` VALUES (757, '17dfb7b1-cdfc-11ec-bb74-000c29bf26e7', 4, 'listInstanceGroups', 'ALLOW', NULL, 138);
INSERT INTO `role_permissions` VALUES (758, '17dfbcd1-cdfc-11ec-bb74-000c29bf26e7', 4, 'listIpForwardingRules', 'ALLOW', NULL, 139);
INSERT INTO `role_permissions` VALUES (759, '17dfc32b-cdfc-11ec-bb74-000c29bf26e7', 4, 'listIsoPermissions', 'ALLOW', NULL, 140);
INSERT INTO `role_permissions` VALUES (760, '17dfc7d0-cdfc-11ec-bb74-000c29bf26e7', 4, 'listIsos', 'ALLOW', NULL, 141);
INSERT INTO `role_permissions` VALUES (761, '17dfcde2-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLBHealthCheckPolicies', 'ALLOW', NULL, 142);
INSERT INTO `role_permissions` VALUES (762, '17dfd2a1-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLBStickinessPolicies', 'ALLOW', NULL, 143);
INSERT INTO `role_permissions` VALUES (763, '17dfd74b-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLdapConfigurations', 'ALLOW', NULL, 144);
INSERT INTO `role_permissions` VALUES (764, '17dfdbe9-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLoadBalancerRuleInstances', 'ALLOW', NULL, 145);
INSERT INTO `role_permissions` VALUES (765, '17dfe07f-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLoadBalancerRules', 'ALLOW', NULL, 146);
INSERT INTO `role_permissions` VALUES (766, '17dfe51c-cdfc-11ec-bb74-000c29bf26e7', 4, 'listLoadBalancers', 'ALLOW', NULL, 147);
INSERT INTO `role_permissions` VALUES (768, '17dfef37-cdfc-11ec-bb74-000c29bf26e7', 4, 'listNetworkACLLists', 'ALLOW', NULL, 149);
INSERT INTO `role_permissions` VALUES (769, '17dff3e7-cdfc-11ec-bb74-000c29bf26e7', 4, 'listNetworkACLs', 'ALLOW', NULL, 150);
INSERT INTO `role_permissions` VALUES (770, '17dff8cb-cdfc-11ec-bb74-000c29bf26e7', 4, 'listNetworkOfferings', 'ALLOW', NULL, 151);
INSERT INTO `role_permissions` VALUES (771, '17dffd0d-cdfc-11ec-bb74-000c29bf26e7', 4, 'listNetworks', 'ALLOW', NULL, 152);
INSERT INTO `role_permissions` VALUES (772, '17e00150-cdfc-11ec-bb74-000c29bf26e7', 4, 'listNics', 'ALLOW', NULL, 153);
INSERT INTO `role_permissions` VALUES (773, '17e00593-cdfc-11ec-bb74-000c29bf26e7', 4, 'listOsCategories', 'ALLOW', NULL, 154);
INSERT INTO `role_permissions` VALUES (774, '17e009d4-cdfc-11ec-bb74-000c29bf26e7', 4, 'listOsTypes', 'ALLOW', NULL, 155);
INSERT INTO `role_permissions` VALUES (776, '17e012e0-cdfc-11ec-bb74-000c29bf26e7', 4, 'listPortForwardingRules', 'ALLOW', NULL, 157);
INSERT INTO `role_permissions` VALUES (777, '17e01728-cdfc-11ec-bb74-000c29bf26e7', 4, 'listPrivateGateways', 'ALLOW', NULL, 158);
INSERT INTO `role_permissions` VALUES (778, '17e01b63-cdfc-11ec-bb74-000c29bf26e7', 4, 'listProjectAccounts', 'ALLOW', NULL, 159);
INSERT INTO `role_permissions` VALUES (779, '17e01f9f-cdfc-11ec-bb74-000c29bf26e7', 4, 'listProjectInvitations', 'ALLOW', NULL, 160);
INSERT INTO `role_permissions` VALUES (780, '17e023db-cdfc-11ec-bb74-000c29bf26e7', 4, 'listProjects', 'ALLOW', NULL, 161);
INSERT INTO `role_permissions` VALUES (781, '17e02922-cdfc-11ec-bb74-000c29bf26e7', 4, 'listPublicIpAddresses', 'ALLOW', NULL, 162);
INSERT INTO `role_permissions` VALUES (782, '17e02d7c-cdfc-11ec-bb74-000c29bf26e7', 4, 'listRegions', 'ALLOW', NULL, 163);
INSERT INTO `role_permissions` VALUES (783, '17e031bd-cdfc-11ec-bb74-000c29bf26e7', 4, 'listRemoteAccessVpns', 'ALLOW', NULL, 164);
INSERT INTO `role_permissions` VALUES (784, '17e035f2-cdfc-11ec-bb74-000c29bf26e7', 4, 'listResourceDetails', 'ALLOW', NULL, 165);
INSERT INTO `role_permissions` VALUES (785, '17e03b59-cdfc-11ec-bb74-000c29bf26e7', 4, 'listResourceLimits', 'ALLOW', NULL, 166);
INSERT INTO `role_permissions` VALUES (786, '17e03fdc-cdfc-11ec-bb74-000c29bf26e7', 4, 'listSSHKeyPairs', 'ALLOW', NULL, 167);
INSERT INTO `role_permissions` VALUES (787, '17e04435-cdfc-11ec-bb74-000c29bf26e7', 4, 'listSecurityGroups', 'ALLOW', NULL, 168);
INSERT INTO `role_permissions` VALUES (788, '17e0487c-cdfc-11ec-bb74-000c29bf26e7', 4, 'listServiceOfferings', 'ALLOW', NULL, 169);
INSERT INTO `role_permissions` VALUES (789, '17e04d88-cdfc-11ec-bb74-000c29bf26e7', 4, 'listSnapshotPolicies', 'ALLOW', NULL, 170);
INSERT INTO `role_permissions` VALUES (790, '17e051d9-cdfc-11ec-bb74-000c29bf26e7', 4, 'listSnapshots', 'ALLOW', NULL, 171);
INSERT INTO `role_permissions` VALUES (791, '17e0561a-cdfc-11ec-bb74-000c29bf26e7', 4, 'listSslCerts', 'ALLOW', NULL, 172);
INSERT INTO `role_permissions` VALUES (792, '17e05a5d-cdfc-11ec-bb74-000c29bf26e7', 4, 'listStaticRoutes', 'ALLOW', NULL, 173);
INSERT INTO `role_permissions` VALUES (793, '17e05f0e-cdfc-11ec-bb74-000c29bf26e7', 4, 'listTags', 'ALLOW', NULL, 174);
INSERT INTO `role_permissions` VALUES (794, '17e06381-cdfc-11ec-bb74-000c29bf26e7', 4, 'listTemplatePermissions', 'ALLOW', NULL, 175);
INSERT INTO `role_permissions` VALUES (795, '17e06b52-cdfc-11ec-bb74-000c29bf26e7', 4, 'listTemplates', 'ALLOW', NULL, 176);
INSERT INTO `role_permissions` VALUES (796, '17e06ffc-cdfc-11ec-bb74-000c29bf26e7', 4, 'listUsers', 'ALLOW', NULL, 177);
INSERT INTO `role_permissions` VALUES (797, '17e07468-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVMSnapshot', 'ALLOW', NULL, 178);
INSERT INTO `role_permissions` VALUES (798, '17e078b0-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVPCOfferings', 'ALLOW', NULL, 179);
INSERT INTO `role_permissions` VALUES (799, '17e07ce9-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVPCs', 'ALLOW', NULL, 180);
INSERT INTO `role_permissions` VALUES (800, '17e0822c-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVirtualMachines', 'ALLOW', NULL, 181);
INSERT INTO `role_permissions` VALUES (801, '17e0871d-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVolumes', 'ALLOW', NULL, 182);
INSERT INTO `role_permissions` VALUES (803, '17e09234-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVpnConnections', 'ALLOW', NULL, 184);
INSERT INTO `role_permissions` VALUES (804, '17e09688-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVpnCustomerGateways', 'ALLOW', NULL, 185);
INSERT INTO `role_permissions` VALUES (805, '17e09ad9-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVpnGateways', 'ALLOW', NULL, 186);
INSERT INTO `role_permissions` VALUES (806, '17e09f9b-cdfc-11ec-bb74-000c29bf26e7', 4, 'listVpnUsers', 'ALLOW', NULL, 187);
INSERT INTO `role_permissions` VALUES (807, '17e0a44a-cdfc-11ec-bb74-000c29bf26e7', 4, 'listZones', 'ALLOW', NULL, 188);
INSERT INTO `role_permissions` VALUES (808, '17e0a895-cdfc-11ec-bb74-000c29bf26e7', 4, 'migrateVolume', 'ALLOW', NULL, 189);
INSERT INTO `role_permissions` VALUES (810, '17e0b192-cdfc-11ec-bb74-000c29bf26e7', 4, 'queryAsyncJobResult', 'ALLOW', NULL, 191);
INSERT INTO `role_permissions` VALUES (811, '17e0b5c7-cdfc-11ec-bb74-000c29bf26e7', 4, 'quotaBalance', 'ALLOW', NULL, 192);
INSERT INTO `role_permissions` VALUES (812, '17e0b9ff-cdfc-11ec-bb74-000c29bf26e7', 4, 'quotaIsEnabled', 'ALLOW', NULL, 193);
INSERT INTO `role_permissions` VALUES (813, '17e0be2b-cdfc-11ec-bb74-000c29bf26e7', 4, 'quotaStatement', 'ALLOW', NULL, 194);
INSERT INTO `role_permissions` VALUES (814, '17e0c260-cdfc-11ec-bb74-000c29bf26e7', 4, 'quotaSummary', 'ALLOW', NULL, 195);
INSERT INTO `role_permissions` VALUES (815, '17e0c6ab-cdfc-11ec-bb74-000c29bf26e7', 4, 'quotaTariffList', 'ALLOW', NULL, 196);
INSERT INTO `role_permissions` VALUES (816, '17e0cae3-cdfc-11ec-bb74-000c29bf26e7', 4, 'rebootVirtualMachine', 'ALLOW', NULL, 197);
INSERT INTO `role_permissions` VALUES (817, '17e0cf17-cdfc-11ec-bb74-000c29bf26e7', 4, 'recoverVirtualMachine', 'ALLOW', NULL, 198);
INSERT INTO `role_permissions` VALUES (818, '17e0e176-cdfc-11ec-bb74-000c29bf26e7', 4, 'registerIso', 'ALLOW', NULL, 199);
INSERT INTO `role_permissions` VALUES (819, '17e0e5ef-cdfc-11ec-bb74-000c29bf26e7', 4, 'registerSSHKeyPair', 'ALLOW', NULL, 200);
INSERT INTO `role_permissions` VALUES (820, '17e0ea3f-cdfc-11ec-bb74-000c29bf26e7', 4, 'registerTemplate', 'ALLOW', NULL, 201);
INSERT INTO `role_permissions` VALUES (821, '17e0ee86-cdfc-11ec-bb74-000c29bf26e7', 4, 'registerUserKeys', 'ALLOW', NULL, 202);
INSERT INTO `role_permissions` VALUES (822, '17e0f2c4-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeCertFromLoadBalancer', 'ALLOW', NULL, 203);
INSERT INTO `role_permissions` VALUES (823, '17e0f6f8-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeFromGlobalLoadBalancerRule', 'ALLOW', NULL, 204);
INSERT INTO `role_permissions` VALUES (824, '17e0fb8b-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeFromLoadBalancerRule', 'ALLOW', NULL, 205);
INSERT INTO `role_permissions` VALUES (825, '17e0ffe4-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeIpFromNic', 'ALLOW', NULL, 206);
INSERT INTO `role_permissions` VALUES (826, '17e1050b-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeNicFromVirtualMachine', 'ALLOW', NULL, 207);
INSERT INTO `role_permissions` VALUES (827, '17e10954-cdfc-11ec-bb74-000c29bf26e7', 4, 'removeVpnUser', 'ALLOW', NULL, 208);
INSERT INTO `role_permissions` VALUES (828, '17e10d86-cdfc-11ec-bb74-000c29bf26e7', 4, 'replaceNetworkACLList', 'ALLOW', NULL, 209);
INSERT INTO `role_permissions` VALUES (829, '17e111ba-cdfc-11ec-bb74-000c29bf26e7', 4, 'resetPasswordForVirtualMachine', 'ALLOW', NULL, 210);
INSERT INTO `role_permissions` VALUES (830, '17e115e9-cdfc-11ec-bb74-000c29bf26e7', 4, 'resetSSHKeyForVirtualMachine', 'ALLOW', NULL, 211);
INSERT INTO `role_permissions` VALUES (831, '17e11a1b-cdfc-11ec-bb74-000c29bf26e7', 4, 'resetVpnConnection', 'ALLOW', NULL, 212);
INSERT INTO `role_permissions` VALUES (832, '17e11e43-cdfc-11ec-bb74-000c29bf26e7', 4, 'resizeVolume', 'ALLOW', NULL, 213);
INSERT INTO `role_permissions` VALUES (833, '17e122dc-cdfc-11ec-bb74-000c29bf26e7', 4, 'restartNetwork', 'ALLOW', NULL, 214);
INSERT INTO `role_permissions` VALUES (834, '17e12757-cdfc-11ec-bb74-000c29bf26e7', 4, 'restartVPC', 'ALLOW', NULL, 215);
INSERT INTO `role_permissions` VALUES (835, '17e12b99-cdfc-11ec-bb74-000c29bf26e7', 4, 'restoreVirtualMachine', 'ALLOW', NULL, 216);
INSERT INTO `role_permissions` VALUES (836, '17e12fc4-cdfc-11ec-bb74-000c29bf26e7', 4, 'revertSnapshot', 'ALLOW', NULL, 217);
INSERT INTO `role_permissions` VALUES (837, '17e133f4-cdfc-11ec-bb74-000c29bf26e7', 4, 'revertToVMSnapshot', 'ALLOW', NULL, 218);
INSERT INTO `role_permissions` VALUES (838, '17e13823-cdfc-11ec-bb74-000c29bf26e7', 4, 'revokeSecurityGroupEgress', 'ALLOW', NULL, 219);
INSERT INTO `role_permissions` VALUES (839, '17e13d85-cdfc-11ec-bb74-000c29bf26e7', 4, 'revokeSecurityGroupIngress', 'ALLOW', NULL, 220);
INSERT INTO `role_permissions` VALUES (840, '17e141e9-cdfc-11ec-bb74-000c29bf26e7', 4, 'scaleVirtualMachine', 'ALLOW', NULL, 221);
INSERT INTO `role_permissions` VALUES (841, '17e1462a-cdfc-11ec-bb74-000c29bf26e7', 4, 'startVirtualMachine', 'ALLOW', NULL, 222);
INSERT INTO `role_permissions` VALUES (842, '17e14afc-cdfc-11ec-bb74-000c29bf26e7', 4, 'stopVirtualMachine', 'ALLOW', NULL, 223);
INSERT INTO `role_permissions` VALUES (843, '17e14f3f-cdfc-11ec-bb74-000c29bf26e7', 4, 'suspendProject', 'ALLOW', NULL, 224);
INSERT INTO `role_permissions` VALUES (844, '17e15371-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateAutoScalePolicy', 'ALLOW', NULL, 225);
INSERT INTO `role_permissions` VALUES (845, '17e1579e-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateAutoScaleVmGroup', 'ALLOW', NULL, 226);
INSERT INTO `role_permissions` VALUES (846, '17e15bc7-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateAutoScaleVmProfile', 'ALLOW', NULL, 227);
INSERT INTO `role_permissions` VALUES (847, '17e15fff-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateDefaultNicForVirtualMachine', 'ALLOW', NULL, 228);
INSERT INTO `role_permissions` VALUES (848, '17e1642b-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateEgressFirewallRule', 'ALLOW', NULL, 229);
INSERT INTO `role_permissions` VALUES (849, '17e16874-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateFirewallRule', 'ALLOW', NULL, 230);
INSERT INTO `role_permissions` VALUES (850, '17e16cab-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateGlobalLoadBalancerRule', 'ALLOW', NULL, 231);
INSERT INTO `role_permissions` VALUES (851, '17e17170-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateInstanceGroup', 'ALLOW', NULL, 232);
INSERT INTO `role_permissions` VALUES (852, '17e175b8-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateIpAddress', 'ALLOW', NULL, 233);
INSERT INTO `role_permissions` VALUES (853, '17e179f2-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateIso', 'ALLOW', NULL, 234);
INSERT INTO `role_permissions` VALUES (854, '17e17e20-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateIsoPermissions', 'ALLOW', NULL, 235);
INSERT INTO `role_permissions` VALUES (855, '17e18247-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateLBHealthCheckPolicy', 'ALLOW', NULL, 236);
INSERT INTO `role_permissions` VALUES (856, '17e18a4f-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateLBStickinessPolicy', 'ALLOW', NULL, 237);
INSERT INTO `role_permissions` VALUES (857, '17e18f8f-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateLoadBalancer', 'ALLOW', NULL, 238);
INSERT INTO `role_permissions` VALUES (858, '17e193e6-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateLoadBalancerRule', 'ALLOW', NULL, 239);
INSERT INTO `role_permissions` VALUES (859, '17e198aa-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateNetwork', 'ALLOW', NULL, 240);
INSERT INTO `role_permissions` VALUES (860, '17e19cb2-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateNetworkACLItem', 'ALLOW', NULL, 241);
INSERT INTO `role_permissions` VALUES (861, '17e1a64a-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateNetworkACLList', 'ALLOW', NULL, 242);
INSERT INTO `role_permissions` VALUES (862, '17e1b120-cdfc-11ec-bb74-000c29bf26e7', 4, 'updatePortForwardingRule', 'ALLOW', NULL, 243);
INSERT INTO `role_permissions` VALUES (863, '17e1b9a5-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateProject', 'ALLOW', NULL, 244);
INSERT INTO `role_permissions` VALUES (864, '17e1c373-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateProjectInvitation', 'ALLOW', NULL, 245);
INSERT INTO `role_permissions` VALUES (865, '17e1ccad-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateRemoteAccessVpn', 'ALLOW', NULL, 246);
INSERT INTO `role_permissions` VALUES (866, '17e1d45c-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateSnapshotPolicy', 'ALLOW', NULL, 247);
INSERT INTO `role_permissions` VALUES (867, '17e1dbc8-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateTemplate', 'ALLOW', NULL, 248);
INSERT INTO `role_permissions` VALUES (868, '17e1e38d-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateTemplatePermissions', 'ALLOW', NULL, 249);
INSERT INTO `role_permissions` VALUES (869, '17e1ed02-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateUser', 'ALLOW', NULL, 250);
INSERT INTO `role_permissions` VALUES (870, '17e1f763-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVMAffinityGroup', 'ALLOW', NULL, 251);
INSERT INTO `role_permissions` VALUES (871, '17e2008b-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVPC', 'ALLOW', NULL, 252);
INSERT INTO `role_permissions` VALUES (872, '17e209a8-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVirtualMachine', 'ALLOW', NULL, 253);
INSERT INTO `role_permissions` VALUES (873, '17e213b9-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVmNicIp', 'ALLOW', NULL, 254);
INSERT INTO `role_permissions` VALUES (874, '17e21c35-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVpnConnection', 'ALLOW', NULL, 255);
INSERT INTO `role_permissions` VALUES (875, '17e223c9-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVpnCustomerGateway', 'ALLOW', NULL, 256);
INSERT INTO `role_permissions` VALUES (876, '17e22c1b-cdfc-11ec-bb74-000c29bf26e7', 4, 'updateVpnGateway', 'ALLOW', NULL, 257);
INSERT INTO `role_permissions` VALUES (877, '17e2349f-cdfc-11ec-bb74-000c29bf26e7', 4, 'uploadSslCert', 'ALLOW', NULL, 258);
INSERT INTO `role_permissions` VALUES (878, '17e23ef7-cdfc-11ec-bb74-000c29bf26e7', 4, 'uploadVolume', 'ALLOW', NULL, 259);
INSERT INTO `role_permissions` VALUES (879, '181054ee-cdfc-11ec-bb74-000c29bf26e7', 2, 'createSnapshotFromVMSnapshot', 'ALLOW', NULL, 318);
INSERT INTO `role_permissions` VALUES (880, '18105d6a-cdfc-11ec-bb74-000c29bf26e7', 3, 'createSnapshotFromVMSnapshot', 'ALLOW', NULL, 302);
INSERT INTO `role_permissions` VALUES (881, '18106680-cdfc-11ec-bb74-000c29bf26e7', 4, 'createSnapshotFromVMSnapshot', 'ALLOW', NULL, 260);
INSERT INTO `role_permissions` VALUES (882, '184508a8-cdfc-11ec-bb74-000c29bf26e7', 2, 'moveNetworkAclItem', 'ALLOW', NULL, 100);
INSERT INTO `role_permissions` VALUES (883, '18450e30-cdfc-11ec-bb74-000c29bf26e7', 3, 'moveNetworkAclItem', 'ALLOW', NULL, 302);
INSERT INTO `role_permissions` VALUES (884, '184513a9-cdfc-11ec-bb74-000c29bf26e7', 4, 'moveNetworkAclItem', 'ALLOW', NULL, 260);
INSERT INTO `role_permissions` VALUES (885, '189137fb-cdfc-11ec-bb74-000c29bf26e7', 5, 'list*', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (886, '18914039-cdfc-11ec-bb74-000c29bf26e7', 5, 'getUploadParamsFor*', 'DENY', NULL, 1);
INSERT INTO `role_permissions` VALUES (887, '1891464a-cdfc-11ec-bb74-000c29bf26e7', 5, 'get*', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (888, '18914d12-cdfc-11ec-bb74-000c29bf26e7', 5, 'cloudianIsEnabled', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (889, '189152ca-cdfc-11ec-bb74-000c29bf26e7', 5, 'queryAsyncJobResult', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (890, '18915844-cdfc-11ec-bb74-000c29bf26e7', 5, 'quotaIsEnabled', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (891, '18915ef1-cdfc-11ec-bb74-000c29bf26e7', 5, 'quotaTariffList', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (892, '189165f2-cdfc-11ec-bb74-000c29bf26e7', 5, 'quotaSummary', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (893, '18916d86-cdfc-11ec-bb74-000c29bf26e7', 5, '*', 'DENY', NULL, 8);
INSERT INTO `role_permissions` VALUES (894, '1891ce2f-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAccounts', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (895, '1891d5f6-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAffinityGroupTypes', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (896, '1891dc6a-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAffinityGroups', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (897, '1891e36c-cdfc-11ec-bb74-000c29bf26e7', 6, 'listApis', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (898, '1891e9e8-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAsyncJobs', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (899, '18920200-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAutoScalePolicies', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (900, '18920bdf-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAutoScaleVmGroups', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (901, '1892149c-cdfc-11ec-bb74-000c29bf26e7', 6, 'listAutoScaleVmProfiles', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (902, '18921c82-cdfc-11ec-bb74-000c29bf26e7', 6, 'listCapabilities', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (903, '189222f2-cdfc-11ec-bb74-000c29bf26e7', 6, 'listConditions', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (904, '189228a9-cdfc-11ec-bb74-000c29bf26e7', 6, 'listCounters', 'ALLOW', NULL, 10);
INSERT INTO `role_permissions` VALUES (905, '18922ddb-cdfc-11ec-bb74-000c29bf26e7', 6, 'listDiskOfferings', 'ALLOW', NULL, 11);
INSERT INTO `role_permissions` VALUES (906, '1892353d-cdfc-11ec-bb74-000c29bf26e7', 6, 'listEgressFirewallRules', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (907, '18923bb9-cdfc-11ec-bb74-000c29bf26e7', 6, 'listEventTypes', 'ALLOW', NULL, 13);
INSERT INTO `role_permissions` VALUES (908, '18924195-cdfc-11ec-bb74-000c29bf26e7', 6, 'listEvents', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (909, '1892475d-cdfc-11ec-bb74-000c29bf26e7', 6, 'listFirewallRules', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (910, '18924df5-cdfc-11ec-bb74-000c29bf26e7', 6, 'listGlobalLoadBalancerRules', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (911, '189253be-cdfc-11ec-bb74-000c29bf26e7', 6, 'listHypervisors', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (912, '18925984-cdfc-11ec-bb74-000c29bf26e7', 6, 'listInstanceGroups', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (913, '18925f2d-cdfc-11ec-bb74-000c29bf26e7', 6, 'listIpForwardingRules', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (914, '189264d9-cdfc-11ec-bb74-000c29bf26e7', 6, 'listIsoPermissions', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (915, '18926a70-cdfc-11ec-bb74-000c29bf26e7', 6, 'listIsos', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (916, '18927509-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLBHealthCheckPolicies', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (917, '18927c42-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLBStickinessPolicies', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (918, '189281de-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLdapConfigurations', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (919, '18928702-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLoadBalancerRuleInstances', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (920, '18928c05-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLoadBalancerRules', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (921, '189290e5-cdfc-11ec-bb74-000c29bf26e7', 6, 'listLoadBalancers', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (923, '18929b47-cdfc-11ec-bb74-000c29bf26e7', 6, 'listNetworkACLLists', 'ALLOW', NULL, 29);
INSERT INTO `role_permissions` VALUES (924, '1892a069-cdfc-11ec-bb74-000c29bf26e7', 6, 'listNetworkACLs', 'ALLOW', NULL, 30);
INSERT INTO `role_permissions` VALUES (925, '1892a76c-cdfc-11ec-bb74-000c29bf26e7', 6, 'listNetworkOfferings', 'ALLOW', NULL, 31);
INSERT INTO `role_permissions` VALUES (926, '1892ade7-cdfc-11ec-bb74-000c29bf26e7', 6, 'listNetworks', 'ALLOW', NULL, 32);
INSERT INTO `role_permissions` VALUES (927, '1892b577-cdfc-11ec-bb74-000c29bf26e7', 6, 'listNics', 'ALLOW', NULL, 33);
INSERT INTO `role_permissions` VALUES (928, '1892bc35-cdfc-11ec-bb74-000c29bf26e7', 6, 'listOsCategories', 'ALLOW', NULL, 34);
INSERT INTO `role_permissions` VALUES (929, '1892c290-cdfc-11ec-bb74-000c29bf26e7', 6, 'listOsTypes', 'ALLOW', NULL, 35);
INSERT INTO `role_permissions` VALUES (931, '1892cc39-cdfc-11ec-bb74-000c29bf26e7', 6, 'listPortForwardingRules', 'ALLOW', NULL, 37);
INSERT INTO `role_permissions` VALUES (932, '1892d24e-cdfc-11ec-bb74-000c29bf26e7', 6, 'listPrivateGateways', 'ALLOW', NULL, 38);
INSERT INTO `role_permissions` VALUES (933, '1892d863-cdfc-11ec-bb74-000c29bf26e7', 6, 'listProjectAccounts', 'ALLOW', NULL, 39);
INSERT INTO `role_permissions` VALUES (934, '1892e094-cdfc-11ec-bb74-000c29bf26e7', 6, 'listProjectInvitations', 'ALLOW', NULL, 40);
INSERT INTO `role_permissions` VALUES (935, '1892e7ac-cdfc-11ec-bb74-000c29bf26e7', 6, 'listProjects', 'ALLOW', NULL, 41);
INSERT INTO `role_permissions` VALUES (936, '1892ecb8-cdfc-11ec-bb74-000c29bf26e7', 6, 'listPublicIpAddresses', 'ALLOW', NULL, 42);
INSERT INTO `role_permissions` VALUES (937, '1892f153-cdfc-11ec-bb74-000c29bf26e7', 6, 'listRegions', 'ALLOW', NULL, 43);
INSERT INTO `role_permissions` VALUES (938, '1892f5dd-cdfc-11ec-bb74-000c29bf26e7', 6, 'listRemoteAccessVpns', 'ALLOW', NULL, 44);
INSERT INTO `role_permissions` VALUES (939, '1892fb5b-cdfc-11ec-bb74-000c29bf26e7', 6, 'listResourceDetails', 'ALLOW', NULL, 45);
INSERT INTO `role_permissions` VALUES (940, '1893018f-cdfc-11ec-bb74-000c29bf26e7', 6, 'listResourceLimits', 'ALLOW', NULL, 46);
INSERT INTO `role_permissions` VALUES (941, '189308f4-cdfc-11ec-bb74-000c29bf26e7', 6, 'listSSHKeyPairs', 'ALLOW', NULL, 47);
INSERT INTO `role_permissions` VALUES (942, '18930f31-cdfc-11ec-bb74-000c29bf26e7', 6, 'listSecurityGroups', 'ALLOW', NULL, 48);
INSERT INTO `role_permissions` VALUES (943, '18931806-cdfc-11ec-bb74-000c29bf26e7', 6, 'listServiceOfferings', 'ALLOW', NULL, 49);
INSERT INTO `role_permissions` VALUES (944, '18931dab-cdfc-11ec-bb74-000c29bf26e7', 6, 'listSnapshotPolicies', 'ALLOW', NULL, 50);
INSERT INTO `role_permissions` VALUES (945, '18932272-cdfc-11ec-bb74-000c29bf26e7', 6, 'listSnapshots', 'ALLOW', NULL, 51);
INSERT INTO `role_permissions` VALUES (946, '18932709-cdfc-11ec-bb74-000c29bf26e7', 6, 'listSslCerts', 'ALLOW', NULL, 52);
INSERT INTO `role_permissions` VALUES (947, '18932d10-cdfc-11ec-bb74-000c29bf26e7', 6, 'listStaticRoutes', 'ALLOW', NULL, 53);
INSERT INTO `role_permissions` VALUES (948, '18933433-cdfc-11ec-bb74-000c29bf26e7', 6, 'listTags', 'ALLOW', NULL, 54);
INSERT INTO `role_permissions` VALUES (949, '18933d8a-cdfc-11ec-bb74-000c29bf26e7', 6, 'listTemplatePermissions', 'ALLOW', NULL, 55);
INSERT INTO `role_permissions` VALUES (950, '18934317-cdfc-11ec-bb74-000c29bf26e7', 6, 'listTemplates', 'ALLOW', NULL, 56);
INSERT INTO `role_permissions` VALUES (951, '189353d5-cdfc-11ec-bb74-000c29bf26e7', 6, 'listUsers', 'ALLOW', NULL, 57);
INSERT INTO `role_permissions` VALUES (952, '18935a81-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVMSnapshot', 'ALLOW', NULL, 58);
INSERT INTO `role_permissions` VALUES (953, '18935fa6-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVPCOfferings', 'ALLOW', NULL, 59);
INSERT INTO `role_permissions` VALUES (954, '1893643a-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVPCs', 'ALLOW', NULL, 60);
INSERT INTO `role_permissions` VALUES (955, '189368ba-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVirtualMachines', 'ALLOW', NULL, 61);
INSERT INTO `role_permissions` VALUES (956, '18936d97-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVolumes', 'ALLOW', NULL, 62);
INSERT INTO `role_permissions` VALUES (958, '18937ba2-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVpnConnections', 'ALLOW', NULL, 64);
INSERT INTO `role_permissions` VALUES (959, '1893820b-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVpnCustomerGateways', 'ALLOW', NULL, 65);
INSERT INTO `role_permissions` VALUES (960, '189387dc-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVpnGateways', 'ALLOW', NULL, 66);
INSERT INTO `role_permissions` VALUES (961, '18938d49-cdfc-11ec-bb74-000c29bf26e7', 6, 'listVpnUsers', 'ALLOW', NULL, 67);
INSERT INTO `role_permissions` VALUES (962, '189392b8-cdfc-11ec-bb74-000c29bf26e7', 6, 'listZones', 'ALLOW', NULL, 68);
INSERT INTO `role_permissions` VALUES (963, '1893a5cf-cdfc-11ec-bb74-000c29bf26e7', 6, 'getApiLimit', 'ALLOW', NULL, 69);
INSERT INTO `role_permissions` VALUES (964, '1893acb0-cdfc-11ec-bb74-000c29bf26e7', 6, 'getCloudIdentifier', 'ALLOW', NULL, 70);
INSERT INTO `role_permissions` VALUES (965, '1893b25f-cdfc-11ec-bb74-000c29bf26e7', 6, 'getSolidFireAccountId', 'ALLOW', NULL, 71);
INSERT INTO `role_permissions` VALUES (966, '1893b7d5-cdfc-11ec-bb74-000c29bf26e7', 6, 'getSolidFireVolumeAccessGroupId', 'ALLOW', NULL, 72);
INSERT INTO `role_permissions` VALUES (967, '1893bd45-cdfc-11ec-bb74-000c29bf26e7', 6, 'getSolidFireVolumeIscsiName', 'ALLOW', NULL, 73);
INSERT INTO `role_permissions` VALUES (968, '1893c2b0-cdfc-11ec-bb74-000c29bf26e7', 6, 'getSolidFireVolumeSize', 'ALLOW', NULL, 74);
INSERT INTO `role_permissions` VALUES (969, '1893c7fd-cdfc-11ec-bb74-000c29bf26e7', 6, 'getVMPassword', 'ALLOW', NULL, 75);
INSERT INTO `role_permissions` VALUES (970, '1893ce8b-cdfc-11ec-bb74-000c29bf26e7', 6, 'getVirtualMachineUserData', 'ALLOW', NULL, 76);
INSERT INTO `role_permissions` VALUES (971, '1893d5f1-cdfc-11ec-bb74-000c29bf26e7', 6, 'cloudianIsEnabled', 'ALLOW', NULL, 77);
INSERT INTO `role_permissions` VALUES (972, '1893e2eb-cdfc-11ec-bb74-000c29bf26e7', 6, 'queryAsyncJobResult', 'ALLOW', NULL, 78);
INSERT INTO `role_permissions` VALUES (973, '1893f14d-cdfc-11ec-bb74-000c29bf26e7', 6, 'quotaIsEnabled', 'ALLOW', NULL, 79);
INSERT INTO `role_permissions` VALUES (974, '1894028c-cdfc-11ec-bb74-000c29bf26e7', 6, 'quotaTariffList', 'ALLOW', NULL, 80);
INSERT INTO `role_permissions` VALUES (975, '189441ca-cdfc-11ec-bb74-000c29bf26e7', 6, 'quotaSummary', 'ALLOW', NULL, 81);
INSERT INTO `role_permissions` VALUES (976, '189454f9-cdfc-11ec-bb74-000c29bf26e7', 6, '*', 'DENY', NULL, 82);
INSERT INTO `role_permissions` VALUES (977, '1894b6aa-cdfc-11ec-bb74-000c29bf26e7', 7, 'list*', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (978, '1894c4ab-cdfc-11ec-bb74-000c29bf26e7', 7, 'get*', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (979, '1894d0ef-cdfc-11ec-bb74-000c29bf26e7', 7, 'cloudianIsEnabled', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (980, '1894dd8e-cdfc-11ec-bb74-000c29bf26e7', 7, 'queryAsyncJobResult', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (981, '1894eac1-cdfc-11ec-bb74-000c29bf26e7', 7, 'quotaIsEnabled', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (982, '1894f6e7-cdfc-11ec-bb74-000c29bf26e7', 7, 'quotaTariffList', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (983, '189502da-cdfc-11ec-bb74-000c29bf26e7', 7, 'quotaSummary', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (984, '18951498-cdfc-11ec-bb74-000c29bf26e7', 7, 'prepareHostForMaintenance', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (985, '18952063-cdfc-11ec-bb74-000c29bf26e7', 7, 'cancelHostMaintenance', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (986, '18952bcb-cdfc-11ec-bb74-000c29bf26e7', 7, 'enableStorageMaintenance', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (987, '18953a07-cdfc-11ec-bb74-000c29bf26e7', 7, 'cancelStorageMaintenance', 'ALLOW', NULL, 10);
INSERT INTO `role_permissions` VALUES (988, '189545a2-cdfc-11ec-bb74-000c29bf26e7', 7, 'createServiceOffering', 'ALLOW', NULL, 11);
INSERT INTO `role_permissions` VALUES (989, '189550f5-cdfc-11ec-bb74-000c29bf26e7', 7, 'createDiskOffering', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (990, '18955d5c-cdfc-11ec-bb74-000c29bf26e7', 7, 'createNetworkOffering', 'ALLOW', NULL, 13);
INSERT INTO `role_permissions` VALUES (991, '189568a4-cdfc-11ec-bb74-000c29bf26e7', 7, 'createVPCOffering', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (992, '189573de-cdfc-11ec-bb74-000c29bf26e7', 7, 'startVirtualMachine', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (993, '18958035-cdfc-11ec-bb74-000c29bf26e7', 7, 'stopVirtualMachine', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (994, '18958bb4-cdfc-11ec-bb74-000c29bf26e7', 7, 'rebootVirtualMachine', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (995, '189596fe-cdfc-11ec-bb74-000c29bf26e7', 7, 'startKubernetesCluster', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (996, '1895a2cf-cdfc-11ec-bb74-000c29bf26e7', 7, 'stopKubernetesCluster', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (997, '1895b0a3-cdfc-11ec-bb74-000c29bf26e7', 7, 'createVolume', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (998, '1895bbd8-cdfc-11ec-bb74-000c29bf26e7', 7, 'attachVolume', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (999, '1895c3d6-cdfc-11ec-bb74-000c29bf26e7', 7, 'detachVolume', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (1000, '1895cc97-cdfc-11ec-bb74-000c29bf26e7', 7, 'uploadVolume', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (1001, '1895d506-cdfc-11ec-bb74-000c29bf26e7', 7, 'attachIso', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (1002, '1895de38-cdfc-11ec-bb74-000c29bf26e7', 7, 'detachIso', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (1003, '1895e650-cdfc-11ec-bb74-000c29bf26e7', 7, 'registerTemplate', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (1004, '1895ee1d-cdfc-11ec-bb74-000c29bf26e7', 7, 'registerIso', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (1005, '1895f6fe-cdfc-11ec-bb74-000c29bf26e7', 7, '*', 'DENY', NULL, 28);
INSERT INTO `role_permissions` VALUES (1006, '189649ef-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAccounts', 'ALLOW', NULL, 0);
INSERT INTO `role_permissions` VALUES (1007, '18965361-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAffinityGroupTypes', 'ALLOW', NULL, 1);
INSERT INTO `role_permissions` VALUES (1008, '18965c1e-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAffinityGroups', 'ALLOW', NULL, 2);
INSERT INTO `role_permissions` VALUES (1009, '1896646a-cdfc-11ec-bb74-000c29bf26e7', 8, 'listApis', 'ALLOW', NULL, 3);
INSERT INTO `role_permissions` VALUES (1010, '18966d64-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAsyncJobs', 'ALLOW', NULL, 4);
INSERT INTO `role_permissions` VALUES (1011, '1896759c-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAutoScalePolicies', 'ALLOW', NULL, 5);
INSERT INTO `role_permissions` VALUES (1012, '18967dc0-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAutoScaleVmGroups', 'ALLOW', NULL, 6);
INSERT INTO `role_permissions` VALUES (1013, '189685d0-cdfc-11ec-bb74-000c29bf26e7', 8, 'listAutoScaleVmProfiles', 'ALLOW', NULL, 7);
INSERT INTO `role_permissions` VALUES (1014, '18968df5-cdfc-11ec-bb74-000c29bf26e7', 8, 'listCapabilities', 'ALLOW', NULL, 8);
INSERT INTO `role_permissions` VALUES (1015, '189696c5-cdfc-11ec-bb74-000c29bf26e7', 8, 'listConditions', 'ALLOW', NULL, 9);
INSERT INTO `role_permissions` VALUES (1016, '18969fb7-cdfc-11ec-bb74-000c29bf26e7', 8, 'listCounters', 'ALLOW', NULL, 10);
INSERT INTO `role_permissions` VALUES (1017, '1896a9d4-cdfc-11ec-bb74-000c29bf26e7', 8, 'listDiskOfferings', 'ALLOW', NULL, 11);
INSERT INTO `role_permissions` VALUES (1018, '1896b210-cdfc-11ec-bb74-000c29bf26e7', 8, 'listEgressFirewallRules', 'ALLOW', NULL, 12);
INSERT INTO `role_permissions` VALUES (1019, '1896bada-cdfc-11ec-bb74-000c29bf26e7', 8, 'listEventTypes', 'ALLOW', NULL, 13);
INSERT INTO `role_permissions` VALUES (1020, '1896c2f3-cdfc-11ec-bb74-000c29bf26e7', 8, 'listEvents', 'ALLOW', NULL, 14);
INSERT INTO `role_permissions` VALUES (1021, '1896cb04-cdfc-11ec-bb74-000c29bf26e7', 8, 'listFirewallRules', 'ALLOW', NULL, 15);
INSERT INTO `role_permissions` VALUES (1022, '1896d312-cdfc-11ec-bb74-000c29bf26e7', 8, 'listGlobalLoadBalancerRules', 'ALLOW', NULL, 16);
INSERT INTO `role_permissions` VALUES (1023, '1896db15-cdfc-11ec-bb74-000c29bf26e7', 8, 'listHypervisors', 'ALLOW', NULL, 17);
INSERT INTO `role_permissions` VALUES (1024, '1896e3f2-cdfc-11ec-bb74-000c29bf26e7', 8, 'listInstanceGroups', 'ALLOW', NULL, 18);
INSERT INTO `role_permissions` VALUES (1025, '1896ed7b-cdfc-11ec-bb74-000c29bf26e7', 8, 'listIpForwardingRules', 'ALLOW', NULL, 19);
INSERT INTO `role_permissions` VALUES (1026, '1896f6cd-cdfc-11ec-bb74-000c29bf26e7', 8, 'listIsoPermissions', 'ALLOW', NULL, 20);
INSERT INTO `role_permissions` VALUES (1027, '1896feec-cdfc-11ec-bb74-000c29bf26e7', 8, 'listIsos', 'ALLOW', NULL, 21);
INSERT INTO `role_permissions` VALUES (1028, '189707aa-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLBHealthCheckPolicies', 'ALLOW', NULL, 22);
INSERT INTO `role_permissions` VALUES (1029, '18971032-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLBStickinessPolicies', 'ALLOW', NULL, 23);
INSERT INTO `role_permissions` VALUES (1030, '18971833-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLdapConfigurations', 'ALLOW', NULL, 24);
INSERT INTO `role_permissions` VALUES (1031, '18972039-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLoadBalancerRuleInstances', 'ALLOW', NULL, 25);
INSERT INTO `role_permissions` VALUES (1032, '18972971-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLoadBalancerRules', 'ALLOW', NULL, 26);
INSERT INTO `role_permissions` VALUES (1033, '18973407-cdfc-11ec-bb74-000c29bf26e7', 8, 'listLoadBalancers', 'ALLOW', NULL, 27);
INSERT INTO `role_permissions` VALUES (1035, '189741e9-cdfc-11ec-bb74-000c29bf26e7', 8, 'listNetworkACLLists', 'ALLOW', NULL, 29);
INSERT INTO `role_permissions` VALUES (1036, '1897480d-cdfc-11ec-bb74-000c29bf26e7', 8, 'listNetworkACLs', 'ALLOW', NULL, 30);
INSERT INTO `role_permissions` VALUES (1037, '18974dc1-cdfc-11ec-bb74-000c29bf26e7', 8, 'listNetworkOfferings', 'ALLOW', NULL, 31);
INSERT INTO `role_permissions` VALUES (1038, '189754e1-cdfc-11ec-bb74-000c29bf26e7', 8, 'listNetworks', 'ALLOW', NULL, 32);
INSERT INTO `role_permissions` VALUES (1039, '18975997-cdfc-11ec-bb74-000c29bf26e7', 8, 'listNics', 'ALLOW', NULL, 33);
INSERT INTO `role_permissions` VALUES (1040, '18975e25-cdfc-11ec-bb74-000c29bf26e7', 8, 'listOsCategories', 'ALLOW', NULL, 34);
INSERT INTO `role_permissions` VALUES (1041, '18976361-cdfc-11ec-bb74-000c29bf26e7', 8, 'listOsTypes', 'ALLOW', NULL, 35);
INSERT INTO `role_permissions` VALUES (1043, '18976cd1-cdfc-11ec-bb74-000c29bf26e7', 8, 'listPortForwardingRules', 'ALLOW', NULL, 37);
INSERT INTO `role_permissions` VALUES (1044, '1897733e-cdfc-11ec-bb74-000c29bf26e7', 8, 'listPrivateGateways', 'ALLOW', NULL, 38);
INSERT INTO `role_permissions` VALUES (1045, '18977a32-cdfc-11ec-bb74-000c29bf26e7', 8, 'listProjectAccounts', 'ALLOW', NULL, 39);
INSERT INTO `role_permissions` VALUES (1046, '1897837a-cdfc-11ec-bb74-000c29bf26e7', 8, 'listProjectInvitations', 'ALLOW', NULL, 40);
INSERT INTO `role_permissions` VALUES (1047, '189789ec-cdfc-11ec-bb74-000c29bf26e7', 8, 'listProjects', 'ALLOW', NULL, 41);
INSERT INTO `role_permissions` VALUES (1048, '18978f0d-cdfc-11ec-bb74-000c29bf26e7', 8, 'listPublicIpAddresses', 'ALLOW', NULL, 42);
INSERT INTO `role_permissions` VALUES (1049, '189793c5-cdfc-11ec-bb74-000c29bf26e7', 8, 'listRegions', 'ALLOW', NULL, 43);
INSERT INTO `role_permissions` VALUES (1050, '18979a2b-cdfc-11ec-bb74-000c29bf26e7', 8, 'listRemoteAccessVpns', 'ALLOW', NULL, 44);
INSERT INTO `role_permissions` VALUES (1051, '1897a10b-cdfc-11ec-bb74-000c29bf26e7', 8, 'listResourceDetails', 'ALLOW', NULL, 45);
INSERT INTO `role_permissions` VALUES (1052, '1897a730-cdfc-11ec-bb74-000c29bf26e7', 8, 'listResourceLimits', 'ALLOW', NULL, 46);
INSERT INTO `role_permissions` VALUES (1053, '1897b042-cdfc-11ec-bb74-000c29bf26e7', 8, 'listSSHKeyPairs', 'ALLOW', NULL, 47);
INSERT INTO `role_permissions` VALUES (1054, '1897b732-cdfc-11ec-bb74-000c29bf26e7', 8, 'listSecurityGroups', 'ALLOW', NULL, 48);
INSERT INTO `role_permissions` VALUES (1055, '1897cdcb-cdfc-11ec-bb74-000c29bf26e7', 8, 'listServiceOfferings', 'ALLOW', NULL, 49);
INSERT INTO `role_permissions` VALUES (1056, '1897d373-cdfc-11ec-bb74-000c29bf26e7', 8, 'listSnapshotPolicies', 'ALLOW', NULL, 50);
INSERT INTO `role_permissions` VALUES (1057, '1897d829-cdfc-11ec-bb74-000c29bf26e7', 8, 'listSnapshots', 'ALLOW', NULL, 51);
INSERT INTO `role_permissions` VALUES (1058, '1897dccc-cdfc-11ec-bb74-000c29bf26e7', 8, 'listSslCerts', 'ALLOW', NULL, 52);
INSERT INTO `role_permissions` VALUES (1059, '1897e164-cdfc-11ec-bb74-000c29bf26e7', 8, 'listStaticRoutes', 'ALLOW', NULL, 53);
INSERT INTO `role_permissions` VALUES (1060, '1897e5f3-cdfc-11ec-bb74-000c29bf26e7', 8, 'listTags', 'ALLOW', NULL, 54);
INSERT INTO `role_permissions` VALUES (1061, '1897ea7e-cdfc-11ec-bb74-000c29bf26e7', 8, 'listTemplatePermissions', 'ALLOW', NULL, 55);
INSERT INTO `role_permissions` VALUES (1062, '1897ef63-cdfc-11ec-bb74-000c29bf26e7', 8, 'listTemplates', 'ALLOW', NULL, 56);
INSERT INTO `role_permissions` VALUES (1063, '1897f41b-cdfc-11ec-bb74-000c29bf26e7', 8, 'listUsers', 'ALLOW', NULL, 57);
INSERT INTO `role_permissions` VALUES (1064, '1897f8a8-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVMSnapshot', 'ALLOW', NULL, 58);
INSERT INTO `role_permissions` VALUES (1065, '1897fd21-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVPCOfferings', 'ALLOW', NULL, 59);
INSERT INTO `role_permissions` VALUES (1066, '1898019d-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVPCs', 'ALLOW', NULL, 60);
INSERT INTO `role_permissions` VALUES (1067, '18980615-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVirtualMachines', 'ALLOW', NULL, 61);
INSERT INTO `role_permissions` VALUES (1068, '18980abf-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVolumes', 'ALLOW', NULL, 62);
INSERT INTO `role_permissions` VALUES (1070, '189813ae-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVpnConnections', 'ALLOW', NULL, 64);
INSERT INTO `role_permissions` VALUES (1071, '189818aa-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVpnCustomerGateways', 'ALLOW', NULL, 65);
INSERT INTO `role_permissions` VALUES (1072, '18981fd7-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVpnGateways', 'ALLOW', NULL, 66);
INSERT INTO `role_permissions` VALUES (1073, '18982663-cdfc-11ec-bb74-000c29bf26e7', 8, 'listVpnUsers', 'ALLOW', NULL, 67);
INSERT INTO `role_permissions` VALUES (1074, '18982c59-cdfc-11ec-bb74-000c29bf26e7', 8, 'listZones', 'ALLOW', NULL, 68);
INSERT INTO `role_permissions` VALUES (1075, '1898322c-cdfc-11ec-bb74-000c29bf26e7', 8, 'getApiLimit', 'ALLOW', NULL, 69);
INSERT INTO `role_permissions` VALUES (1076, '18983ccb-cdfc-11ec-bb74-000c29bf26e7', 8, 'getCloudIdentifier', 'ALLOW', NULL, 70);
INSERT INTO `role_permissions` VALUES (1077, '18984344-cdfc-11ec-bb74-000c29bf26e7', 8, 'getSolidFireAccountId', 'ALLOW', NULL, 71);
INSERT INTO `role_permissions` VALUES (1078, '1898488a-cdfc-11ec-bb74-000c29bf26e7', 8, 'getSolidFireVolumeAccessGroupId', 'ALLOW', NULL, 72);
INSERT INTO `role_permissions` VALUES (1079, '18984da3-cdfc-11ec-bb74-000c29bf26e7', 8, 'getSolidFireVolumeIscsiName', 'ALLOW', NULL, 73);
INSERT INTO `role_permissions` VALUES (1080, '18985245-cdfc-11ec-bb74-000c29bf26e7', 8, 'getSolidFireVolumeSize', 'ALLOW', NULL, 74);
INSERT INTO `role_permissions` VALUES (1081, '189856c8-cdfc-11ec-bb74-000c29bf26e7', 8, 'getVMPassword', 'ALLOW', NULL, 75);
INSERT INTO `role_permissions` VALUES (1082, '18985b4d-cdfc-11ec-bb74-000c29bf26e7', 8, 'getVirtualMachineUserData', 'ALLOW', NULL, 76);
INSERT INTO `role_permissions` VALUES (1083, '18985fda-cdfc-11ec-bb74-000c29bf26e7', 8, 'cloudianIsEnabled', 'ALLOW', NULL, 77);
INSERT INTO `role_permissions` VALUES (1084, '18986505-cdfc-11ec-bb74-000c29bf26e7', 8, 'queryAsyncJobResult', 'ALLOW', NULL, 78);
INSERT INTO `role_permissions` VALUES (1085, '18986cfa-cdfc-11ec-bb74-000c29bf26e7', 8, 'quotaIsEnabled', 'ALLOW', NULL, 79);
INSERT INTO `role_permissions` VALUES (1086, '18987492-cdfc-11ec-bb74-000c29bf26e7', 8, 'quotaTariffList', 'ALLOW', NULL, 80);
INSERT INTO `role_permissions` VALUES (1087, '18987a82-cdfc-11ec-bb74-000c29bf26e7', 8, 'quotaSummary', 'ALLOW', NULL, 81);
INSERT INTO `role_permissions` VALUES (1088, '18988059-cdfc-11ec-bb74-000c29bf26e7', 8, 'startVirtualMachine', 'ALLOW', NULL, 82);
INSERT INTO `role_permissions` VALUES (1089, '189885eb-cdfc-11ec-bb74-000c29bf26e7', 8, 'stopVirtualMachine', 'ALLOW', NULL, 83);
INSERT INTO `role_permissions` VALUES (1090, '18988bd1-cdfc-11ec-bb74-000c29bf26e7', 8, 'rebootVirtualMachine', 'ALLOW', NULL, 84);
INSERT INTO `role_permissions` VALUES (1091, '18989164-cdfc-11ec-bb74-000c29bf26e7', 8, 'startKubernetesCluster', 'ALLOW', NULL, 85);
INSERT INTO `role_permissions` VALUES (1092, '1898992d-cdfc-11ec-bb74-000c29bf26e7', 8, 'stopKubernetesCluster', 'ALLOW', NULL, 86);
INSERT INTO `role_permissions` VALUES (1093, '18989eb8-cdfc-11ec-bb74-000c29bf26e7', 8, 'createVolume', 'ALLOW', NULL, 87);
INSERT INTO `role_permissions` VALUES (1094, '1898a4f1-cdfc-11ec-bb74-000c29bf26e7', 8, 'attachVolume', 'ALLOW', NULL, 88);
INSERT INTO `role_permissions` VALUES (1095, '1898aa4d-cdfc-11ec-bb74-000c29bf26e7', 8, 'detachVolume', 'ALLOW', NULL, 89);
INSERT INTO `role_permissions` VALUES (1096, '1898afd3-cdfc-11ec-bb74-000c29bf26e7', 8, 'uploadVolume', 'ALLOW', NULL, 90);
INSERT INTO `role_permissions` VALUES (1097, '1898b5c2-cdfc-11ec-bb74-000c29bf26e7', 8, 'attachIso', 'ALLOW', NULL, 91);
INSERT INTO `role_permissions` VALUES (1098, '1898bc32-cdfc-11ec-bb74-000c29bf26e7', 8, 'detachIso', 'ALLOW', NULL, 92);
INSERT INTO `role_permissions` VALUES (1099, '1898c1ba-cdfc-11ec-bb74-000c29bf26e7', 8, 'registerTemplate', 'ALLOW', NULL, 93);
INSERT INTO `role_permissions` VALUES (1100, '1898c720-cdfc-11ec-bb74-000c29bf26e7', 8, 'registerIso', 'ALLOW', NULL, 94);
INSERT INTO `role_permissions` VALUES (1101, '1898cc7a-cdfc-11ec-bb74-000c29bf26e7', 8, 'getUploadParamsFor*', 'ALLOW', NULL, 95);
INSERT INTO `role_permissions` VALUES (1102, '1898d1a4-cdfc-11ec-bb74-000c29bf26e7', 8, '*', 'DENY', NULL, 96);
INSERT INTO `role_permissions` VALUES (1107, '85f4681a-5c04-496b-9322-d68fee664edb', 3, 'dfsaf', 'ALLOW', NULL, NULL);

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles`  (
  `id` bigint unsigned NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'unique name of the dynamic role',
  `role_type` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'the type of the role',
  `removed` datetime(0) DEFAULT NULL COMMENT 'date removed',
  `description` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'description of the role',
  `is_default` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'is this a default role',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uuid`(`uuid`) USING BTREE,
  UNIQUE INDEX `name`(`name`, `role_type`) USING BTREE,
  INDEX `i_roles__name`(`name`) USING BTREE,
  INDEX `i_roles__role_type`(`role_type`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of roles
-- ----------------------------
INSERT INTO `roles` VALUES (1, '17cd88b4-cdfc-11ec-bb74-000c29bf26e7', 'Root Admin', 'Admin', NULL, 'Default root admin role', 1);
INSERT INTO `roles` VALUES (2, '17cd9613-cdfc-11ec-bb74-000c29bf26e7', 'Resource Admin', 'ResourceAdmin', NULL, 'Default resource admin role', 1);
INSERT INTO `roles` VALUES (3, '17cda1de-cdfc-11ec-bb74-000c29bf26e7', 'Domain Admin', 'DomainAdmin', NULL, 'Default domain admin role', 1);
INSERT INTO `roles` VALUES (4, '17cdac71-cdfc-11ec-bb74-000c29bf26e7', 'User', 'User', NULL, 'Default user role', 1);
INSERT INTO `roles` VALUES (5, '187bd4ee-cdfc-11ec-bb74-000c29bf26e7', 'Read-Only Admin - Default', 'Admin', NULL, 'Default read-only admin role', 1);
INSERT INTO `roles` VALUES (6, '187be253-cdfc-11ec-bb74-000c29bf26e7', 'Read-Only User - Default', 'User', NULL, 'Default read-only user role', 1);
INSERT INTO `roles` VALUES (7, '187bed36-cdfc-11ec-bb74-000c29bf26e7', 'Support Admin - Default', 'Admin', NULL, 'Default support admin role', 1);
INSERT INTO `roles` VALUES (8, '187bfabd-cdfc-11ec-bb74-000c29bf26e7', 'Support User - Default', 'User', NULL, 'Default support user role', 1);
INSERT INTO `roles` VALUES (9, 'sdf', 'df', 'df', NULL, 'sss', 1);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint unsigned NOT NULL,
  `uuid` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `account_id` bigint unsigned NOT NULL,
  `firstname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `lastname` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `state` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'enabled',
  `api_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `secret_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `created` datetime(0) NOT NULL COMMENT 'date created',
  `removed` datetime(0) DEFAULT NULL COMMENT 'date removed',
  `timezone` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `registration_token` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `is_registered` tinyint(0) NOT NULL DEFAULT 0 COMMENT '1: yes, 0: no',
  `incorrect_login_attempts` int unsigned NOT NULL,
  `default` int unsigned NOT NULL COMMENT '1 if user is default',
  `source` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'UNKNOWN',
  `external_entity` text CHARACTER SET utf8 COLLATE utf8_general_ci COMMENT 'reference to external federation entity',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `i_user__api_key`(`api_key`) USING BTREE,
  UNIQUE INDEX `uc_user__uuid`(`uuid`) USING BTREE,
  INDEX `i_user__removed`(`removed`) USING BTREE,
  INDEX `i_user__secret_key_removed`(`secret_key`, `removed`) USING BTREE,
  INDEX `i_user__account_id`(`account_id`) USING BTREE,
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `account` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '1ea6d429-cdfc-11ec-bb74-000c29bf26e7', 'system', '0.9650121125998088', 1, 'system', 'cloud', NULL, 'enabled', NULL, NULL, '2022-05-07 19:52:07', NULL, NULL, NULL, 0, 0, 1, 'UNKNOWN', NULL);
INSERT INTO `user` VALUES (2, '1ea88732-cdfc-11ec-bb74-000c29bf26e7', 'admin', 'chxu9mg7K6K6MV8aPqZfbH8Aw/n2WPQiqPY0k7k8X0nuXOTVB9Hdo/HpqDnMOZ4Rdtl5CQb0V1jYr+FQfLgrmg==:9L+K9dASvgZ0T+Bk6UrkNPdGG0JY+LuVQt2S5SNbKwQdpoH63XDWlf9i/mF4wPN8fDPENTQbI93fsOgnlxDmXQ==:100000', 2, 'admin', 'cloud', NULL, 'enabled', NULL, NULL, '2022-05-07 19:52:07', NULL, NULL, NULL, 0, 0, 1, 'UNKNOWN', NULL);
INSERT INTO `user` VALUES (3, '280a09f8-a21e-42bd-b047-b97ea4f3e7e4', 'baremetal-system-account', '9b6e8313-7fdc-4ffb-b5d5-02d335b58c80', 3, 'baremetal-system-account', 'baremetal-system-account', NULL, 'enabled', '1nOPKwaKh5FVYAa0YFAdCLKMEo2wjTXFSEEQX9xcD0BViAPafV1ykPBZRmUG7aHw2I0LE36Ugb7JXtFrnoJjTg', '41zGEeeYIr1dsv+j5veUueT53TiZ+i4fJaOwbOKnLNQikARrgSPjpVzdXd6dmGqcmAEst0zXkwM23Q6fiY5JIN/DBedJdtC8dFGCEYMFfmC8N/u3ip8NRh1QX80FPidU', '2022-05-07 11:52:16', NULL, NULL, NULL, 0, 0, 0, 'UNKNOWN', NULL);

SET FOREIGN_KEY_CHECKS = 1;
