-- MySQL dump 10.13  Distrib 5.7.31, for macos10.14 (x86_64)
--
-- Host: localhost    Database: padzilla_database
-- ------------------------------------------------------
-- Server version	5.7.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `t_device_mac_assignments`
--

DROP TABLE IF EXISTS `t_device_mac_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_device_mac_assignments` (
  `id_device_mac_assignment` int(11) NOT NULL AUTO_INCREMENT,
  `f_id_device` int(11) NOT NULL,
  `f_id_mac` int(11) NOT NULL,
  `id_assignment_date` datetime NOT NULL,
  PRIMARY KEY (`id_device_mac_assignment`),
  KEY `f_id_device_idx` (`f_id_device`),
  KEY `f_id_mac_idx` (`f_id_mac`),
  CONSTRAINT `f_id_device` FOREIGN KEY (`f_id_device`) REFERENCES `t_devices` (`id_device`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `f_id_mac` FOREIGN KEY (`f_id_mac`) REFERENCES `t_macs` (`id_mac`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_devices`
--

DROP TABLE IF EXISTS `t_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_devices` (
  `id_device` int(11) NOT NULL AUTO_INCREMENT,
  `id_serial_identifier` varchar(80) NOT NULL,
  `f_id_configuration` int(11) DEFAULT NULL,
  `id_date_created` datetime DEFAULT NULL,
  `f_id_device_state` int(11) DEFAULT NULL,
  `f_id_hardware_model` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_device`),
  KEY `f_id_hardware_model_idx` (`f_id_hardware_model`),
  CONSTRAINT `f_id_hardware_model` FOREIGN KEY (`f_id_hardware_model`) REFERENCES `t_hardware_models` (`id_hardware_model`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_downloads`
--

DROP TABLE IF EXISTS `t_downloads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_downloads` (
  `id_download` int(11) NOT NULL AUTO_INCREMENT,
  `f_id_package` int(11) NOT NULL,
  `ff_id_mac` int(11) NOT NULL,
  `id_download_date` datetime NOT NULL,
  `id_status` varchar(45) NOT NULL DEFAULT 'started',
  `id_last_change_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id_download`),
  KEY `f_id_package_idx` (`f_id_package`),
  KEY `ff_id_mac_idx` (`ff_id_mac`),
  CONSTRAINT `f_id_package` FOREIGN KEY (`f_id_package`) REFERENCES `t_packages` (`id_package`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ff_id_mac` FOREIGN KEY (`ff_id_mac`) REFERENCES `t_macs` (`id_mac`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_hardware_models`
--

DROP TABLE IF EXISTS `t_hardware_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_hardware_models` (
  `id_hardware_model` int(11) NOT NULL AUTO_INCREMENT,
  `id_label` varchar(45) NOT NULL,
  PRIMARY KEY (`id_hardware_model`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_installations`
--

DROP TABLE IF EXISTS `t_installations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_installations` (
  `id_installation` int(11) NOT NULL AUTO_INCREMENT,
  `f_id_mac` int(11) DEFAULT NULL,
  `f_id_manifest` int(11) DEFAULT NULL,
  `id_date_reported` datetime DEFAULT NULL,
  `id_receipt` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_installation`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_macs`
--

DROP TABLE IF EXISTS `t_macs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_macs` (
  `id_mac` int(11) NOT NULL AUTO_INCREMENT,
  `id_serial` varchar(45) NOT NULL,
  `id_model` varchar(45) NOT NULL,
  `id_date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`id_mac`),
  UNIQUE KEY `id_serial_UNIQUE` (`id_serial`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_manifests`
--

DROP TABLE IF EXISTS `t_manifests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_manifests` (
  `id_manifest` int(11) NOT NULL AUTO_INCREMENT,
  `id_label` varchar(45) DEFAULT NULL,
  `id_release_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id_manifest`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_package_types`
--

DROP TABLE IF EXISTS `t_package_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_package_types` (
  `id_package_type` int(11) NOT NULL,
  `id_package_type_label` varchar(45) NOT NULL,
  PRIMARY KEY (`id_package_type`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_packages`
--

DROP TABLE IF EXISTS `t_packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_packages` (
  `id_package` int(11) NOT NULL AUTO_INCREMENT,
  `id_location` varchar(45) NOT NULL,
  `id_label` varchar(45) NOT NULL,
  `id_md5` varchar(45) NOT NULL,
  `id_date_created` datetime NOT NULL,
  `f_id_manifest` int(11) DEFAULT NULL,
  `f_id_package_type` int(11) NOT NULL,
  `id_reinstall` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_package`),
  KEY `f_id_manifest_idx` (`f_id_manifest`),
  KEY `f_id_package_type_idx` (`f_id_package_type`),
  CONSTRAINT `f_id_manifest` FOREIGN KEY (`f_id_manifest`) REFERENCES `t_manifests` (`id_manifest`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `f_id_package_type` FOREIGN KEY (`f_id_package_type`) REFERENCES `t_package_types` (`id_package_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_roles`
--

DROP TABLE IF EXISTS `t_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_roles` (
  `id_user_role` int(11) NOT NULL AUTO_INCREMENT,
  `id_user_role_label` varchar(45) NOT NULL,
  PRIMARY KEY (`id_user_role`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_subscription_device_assignments`
--

DROP TABLE IF EXISTS `t_subscription_device_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_subscription_device_assignments` (
  `id_subscription_device_assignment` int(11) NOT NULL AUTO_INCREMENT,
  `f_id_subscription` int(11) NOT NULL,
  `ff_id_device` int(11) NOT NULL,
  `id_assignment_date` datetime NOT NULL,
  PRIMARY KEY (`id_subscription_device_assignment`),
  KEY `f_id_device_idx` (`ff_id_device`),
  KEY `f_id_subscription_idx` (`f_id_subscription`),
  CONSTRAINT `f_id_subscription` FOREIGN KEY (`f_id_subscription`) REFERENCES `t_subscriptions` (`id_subscription`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ff_id_device` FOREIGN KEY (`ff_id_device`) REFERENCES `t_devices` (`id_device`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_subscription_terms_and_conditions_acceptance`
--

DROP TABLE IF EXISTS `t_subscription_terms_and_conditions_acceptance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_subscription_terms_and_conditions_acceptance` (
  `id_subscription_terms_and_conditions_acceptance` int(11) NOT NULL AUTO_INCREMENT,
  `f_id_subscription` int(11) NOT NULL,
  `f_id_terms_and_conditions` int(11) NOT NULL,
  `id_date_accepted` datetime NOT NULL,
  PRIMARY KEY (`id_subscription_terms_and_conditions_acceptance`),
  KEY `ff_id_subscription_idx` (`f_id_subscription`),
  KEY `ff_id_terms_and_conditions_idx` (`f_id_terms_and_conditions`),
  CONSTRAINT `ff_id_subscription` FOREIGN KEY (`f_id_subscription`) REFERENCES `t_subscriptions` (`id_subscription`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `ff_id_terms_and_conditions` FOREIGN KEY (`f_id_terms_and_conditions`) REFERENCES `t_terms_and_conditions` (`id_terms_and_conditions`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_subscription_types`
--

DROP TABLE IF EXISTS `t_subscription_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_subscription_types` (
  `id_type` int(11) NOT NULL AUTO_INCREMENT,
  `id_label` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id_type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_subscriptions`
--

DROP TABLE IF EXISTS `t_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_subscriptions` (
  `id_subscription` int(11) NOT NULL AUTO_INCREMENT,
  `id_zoho_subscription` bigint(20) DEFAULT NULL,
  `f_id_subscription_type` int(11) NOT NULL,
  `id_customer_id` bigint(16) DEFAULT NULL,
  `id_customer_name` varchar(45) DEFAULT NULL,
  `id_status` varchar(45) DEFAULT NULL,
  `id_last_pulled_date` datetime DEFAULT NULL,
  `id_quantity` int(11) DEFAULT NULL,
  `id_last_issue_date` datetime DEFAULT NULL,
  `id_token_expires_at` datetime DEFAULT NULL,
  `id_next_billing_at` datetime DEFAULT NULL,
  `id_current_term_starts_at` datetime DEFAULT NULL,
  `id_activated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id_subscription`),
  KEY `f_id_subscription_type_idx` (`f_id_subscription_type`),
  CONSTRAINT `f_id_subscription_type` FOREIGN KEY (`f_id_subscription_type`) REFERENCES `t_subscription_types` (`id_type`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_support_notes`
--

DROP TABLE IF EXISTS `t_support_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_support_notes` (
  `id_support_notes` int(11) NOT NULL,
  `id_note` varchar(255) NOT NULL,
  `f_id_user` int(11) NOT NULL,
  PRIMARY KEY (`id_support_notes`),
  KEY `f_id_user_idx` (`f_id_user`),
  CONSTRAINT `f_id_user` FOREIGN KEY (`f_id_user`) REFERENCES `t_users` (`id_users`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_terms_and_conditions`
--

DROP TABLE IF EXISTS `t_terms_and_conditions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_terms_and_conditions` (
  `id_terms_and_conditions` int(11) NOT NULL AUTO_INCREMENT,
  `id_label` varchar(90) NOT NULL,
  `id_md5` varchar(45) NOT NULL,
  `id_date_created` datetime NOT NULL,
  PRIMARY KEY (`id_terms_and_conditions`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `t_users`
--

DROP TABLE IF EXISTS `t_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_users` (
  `id_users` int(11) NOT NULL AUTO_INCREMENT,
  `id_firstname` varchar(45) NOT NULL,
  `id_lastname` varchar(45) NOT NULL,
  `f_id_role` int(11) NOT NULL,
  PRIMARY KEY (`id_users`),
  KEY `f_id_role_idx` (`f_id_role`),
  CONSTRAINT `f_id_role` FOREIGN KEY (`f_id_role`) REFERENCES `t_roles` (`id_user_role`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'padzilla_database'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_device_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_device_details`(_padzilla_serial varchar(45))
sp: BEGIN
	DECLARE x_id_mac INT;
	DECLARE x_id_device INT;
	DECLARE x_id_hw_model INT;
	DECLARE x_id_subscription INT;
	DECLARE x_id_device_mac_assignment INT;
    DECLARE x_id_zoho_subscription BIGINT;
    DECLARE x_id_device_hwmodel_label VARCHAR(45);
    DECLARE x_id_mac_serial VARCHAR(45);
    DECLARE x_id_mac_model VARCHAR(45);
    
    SELECT id_device, f_id_hardware_model
    FROM t_devices
    WHERE id_serial_identifier = _padzilla_serial
    INTO x_id_device,x_id_hw_model;
    
    IF x_id_device IS NULL THEN
        LEAVE sp;
    END IF;
    
    SELECT f_id_subscription
    FROM t_subscription_device_assignments
    WHERE ff_id_device = x_id_device
    INTO x_id_subscription;
    
    SELECT id_zoho_subscription
    FROM t_subscriptions
    WHERE id_subscription = x_id_subscription
    INTO x_id_zoho_subscription;
    
    SELECT f_id_mac
    FROM t_device_mac_assignments
    WHERE f_id_device = x_id_device
    INTO x_id_mac;
    
    SELECT id_serial, id_model
    FROM t_macs
    WHERE id_mac = x_id_mac
    INTO x_id_mac_serial, x_id_mac_model;
    
    SELECT id_label
    FROM t_hardware_models
    WHERE id_hardware_model = x_id_hw_model
    INTO x_id_device_hwmodel_label;
    
    
    SELECT _padzilla_serial AS "id_padzilla_serial", 
			x_id_mac_serial AS "id_mac_serial", 
            x_id_mac_model AS "id_mac_model",
            x_id_zoho_subscription AS "id_zoho_subscription",
            x_id_device_hwmodel_label AS "id_hw_model_label";
            
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_download` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_download`(_id_package INT(11), _mac_serial varchar(45), _status varchar(45))
BEGIN
	DECLARE x_id_mac INT;
	DECLARE x_id_package INT;

	SELECT id_mac
	FROM t_macs
	WHERE id_serial = _mac_serial
	INTO x_id_mac;
    
    SELECT id_package
	FROM t_packages
	WHERE id_package = _id_package
	INTO x_id_package;
    
    IF x_id_mac IS NOT NULL THEN
		IF x_id_package IS NOT NULL THEN
			INSERT INTO t_downloads (f_id_package,ff_id_mac,id_download_date,id_status) VALUES (x_id_package,x_id_mac,now(),_status);
            
            SELECT LAST_INSERT_ID() AS 'id_download';
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_new_device_with_mac` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_new_device_with_mac`(_padzilla_serial varchar(45), _id_mac INT(11))
BEGIN

	DECLARE x_id_mac INT;
	DECLARE x_id_device INT;
	DECLARE x_id_device_mac_assignment INT;

	SELECT id_mac
	FROM t_macs
	WHERE id_mac = _id_mac
	INTO x_id_mac;
    
    SELECT id_device
	FROM t_devices
	WHERE id_serial_identifier = _padzilla_serial
	INTO x_id_device;
    
    IF x_id_mac IS NULL THEN
    
		/* dont do anything*/
        
		SELECT "-1" AS "created", "no such mac exists" AS "reason";
        
	ELSE
		/* check device mac assignment, this may be a request to create the same relationship */
		
            
        IF x_id_device IS NULL THEN
        
			SELECT id_device_mac_assignment
			FROM t_device_mac_assignments
			WHERE f_id_mac = x_id_mac
			INTO x_id_device_mac_assignment;
            
            IF x_id_device_mac_assignment IS NULL THEN
				/* create device entry */
				INSERT INTO t_devices (id_serial_identifier,id_date_created) VALUES (_padzilla_serial, now());
            
				SELECT id_device
				FROM t_devices
				WHERE id_serial_identifier = _padzilla_serial
				INTO x_id_device;
            
				INSERT INTO t_device_mac_assignments (f_id_device, f_id_mac, id_assignment_date) VALUES (x_id_device,x_id_mac, now());
    
				SELECT "1" AS "created";
			
            ELSE
				SELECT "-1" AS "created", "attempting to reassign mac to more than 1 padzilla, not allowed"  AS "reason";
            END IF;
            
        ELSE
        
			SELECT id_device_mac_assignment
			FROM t_device_mac_assignments
			WHERE f_id_device = x_id_device AND f_id_mac = x_id_mac
			INTO x_id_device_mac_assignment;
            
            IF x_id_device_mac_assignment IS NULL THEN
				/* if not the same device mac assignment then*/
				/* device already exists, reassignments not allowed through this SP */
				SELECT "-1" AS "created", "attempting to reassign padzilla to another mac, not allowed" AS "reason";
			ELSE
				SELECT "2" AS "created";
            END IF;
            
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_new_mac` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_new_mac`(_mac_serial varchar(45), _model varchar(45))
BEGIN

	DECLARE x_id_mac INT;
	DECLARE x_id_date_created DATETIME;

	SELECT id_mac
	FROM t_macs
	WHERE id_serial = _mac_serial
	INTO x_id_mac;
    
    SELECT id_date_created
	FROM t_macs
	WHERE id_serial = _mac_serial
	INTO x_id_date_created;
    
    IF x_id_mac IS NULL THEN
		INSERT INTO t_macs (id_serial,id_model,id_date_created) VALUES (_mac_serial, _model, now());
        
        SELECT id_mac, id_date_created
		FROM t_macs
		WHERE id_serial = _mac_serial;
        
	ELSE
		SELECT x_id_mac AS "id_mac" ,x_id_date_created AS "id_date_created";
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_latest_manifest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_latest_manifest`()
BEGIN
	DECLARE x_id_manifest INT;

	SELECT MAX(id_manifest) as "id_manifest" 
    FROM t_manifests 
    WHERE id_release_date < now() 
    INTO x_id_manifest;
    
    SELECT id_manifest, id_release_date
    FROM t_manifests
    WHERE id_manifest = x_id_manifest;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_manifest_packages` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_manifest_packages`(_id_manifest INT(11))
BEGIN

SELECT p.*, t.*
FROM t_packages p
    inner join t_package_types t on p.f_id_package_type = t.id_package_type
WHERE p.f_id_manifest = _id_manifest;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_padzillas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_padzillas`()
BEGIN
	SELECT t_devices.* , t_subscriptions.*, t_subscription_types.id_label AS 'plan_type' ,t_hardware_models.id_label AS 'hw_model'
	FROM t_devices
	INNER JOIN t_subscription_device_assignments
	ON t_devices.id_device = t_subscription_device_assignments.ff_id_device
	INNER JOIN t_subscriptions
	ON t_subscription_device_assignments.f_id_subscription = t_subscriptions.id_subscription
	INNER JOIN t_subscription_types
	ON t_subscriptions.f_id_subscription_type = t_subscription_types.id_type
	INNER JOIN t_hardware_models
	ON t_devices.f_id_hardware_model = t_hardware_models.id_hardware_model;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_device_hwmodel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_device_hwmodel`(_id_device INT(11), _id_hw_model INT(11))
sp: BEGIN

    DECLARE x_id_hardware_model INT;
	DECLARE x_id_device INT;
	DECLARE x_id_subscription_device_assignment INT;
    
    SELECT id_hardware_model
	FROM t_hardware_models
	WHERE id_hardware_model = _id_hw_model
	INTO x_id_hardware_model;
    
    IF x_id_hardware_model IS NULL THEN
		SELECT "-1" AS "updated", "no such hardware model exists" AS "reason";
		LEAVE sp;
    END IF;
    
    SELECT id_device
	FROM t_devices
	WHERE id_device = _id_device
	INTO x_id_device;
    
    IF x_id_device IS NULL THEN
		SELECT "-1" AS "updated", "no such device exists" AS "reason";
		LEAVE sp;
    END IF;
    
    
    UPDATE t_devices
    SET f_id_hardware_model = x_id_hardware_model
    WHERE id_device = x_id_device;
    
	SELECT "1" AS "updated";

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_device_subscription` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_device_subscription`(_id_device INT(11), _id_zoho_subscription BIGINT(20))
sp: BEGIN

    DECLARE x_id_subscription INT;
	DECLARE x_id_device INT;
	DECLARE x_id_subscription_device_assignment INT;
    
    SELECT id_device
	FROM t_devices
	WHERE id_device = _id_device
	INTO x_id_device;
    
    SELECT id_subscription
	FROM t_subscriptions
	WHERE id_zoho_subscription = _id_zoho_subscription
	INTO x_id_subscription;
    
    
    
    
    IF x_id_subscription IS NULL THEN
		SELECT "-1" AS "updated", "no such subscription exists" AS "reason";
		LEAVE sp;
    END IF;
    
    IF x_id_device IS NULL THEN
		SELECT "-1" AS "updated", "no such device exists" AS "reason";
		LEAVE sp;
    END IF;
    
    SELECT id_subscription_device_assignment
	FROM t_subscription_device_assignments
	WHERE f_id_subscription = x_id_subscription AND ff_id_device = x_id_device
	INTO x_id_subscription_device_assignment;
    
    IF x_id_subscription_device_assignment IS NOT NULL THEN
		SELECT "2" AS "updated";
		LEAVE sp;
    END IF;
    
	SELECT id_subscription_device_assignment
	FROM t_subscription_device_assignments
	WHERE f_id_subscription = x_id_subscription OR ff_id_device = x_id_device
	INTO x_id_subscription_device_assignment;
    
    IF x_id_subscription_device_assignment IS NOT NULL THEN
		SELECT "-1" AS "updated", "attempting to reassign device subscription or device already has a different subscription" AS "reason";
		LEAVE sp;
    END IF;
    
    INSERT INTO t_subscription_device_assignments (f_id_subscription,ff_id_device,id_assignment_date) VALUES (x_id_subscription, x_id_device, now());
    
	SELECT "1" AS "updated";

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-18 13:52:33
-- MySQL dump 10.13  Distrib 5.7.31, for macos10.14 (x86_64)
--
-- Host: localhost    Database: padzilla_database
-- ------------------------------------------------------
-- Server version	5.7.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `t_package_types`
--

LOCK TABLES `t_package_types` WRITE;
/*!40000 ALTER TABLE `t_package_types` DISABLE KEYS */;
INSERT INTO `t_package_types` VALUES (0,'System'),(1,'Daemon'),(2,'Dependency'),(3,'App');
/*!40000 ALTER TABLE `t_package_types` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-18 13:52:33
