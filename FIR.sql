-- Set character set and SQL mode
SET NAMES utf8;
SET SQL_MODE='';

-- Create and use the database
CREATE DATABASE IF NOT EXISTS `crimenew`;
USE `crimenew`;

-- ---------------------- admin ----------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `username` VARCHAR(20) DEFAULT NULL,
  `password` VARCHAR(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `admin` VALUES ('vel', 'vel');

-- ---------------------- crime ----------------------
DROP TABLE IF EXISTS `crime`;
CREATE TABLE `crime` (
  `name` VARCHAR(20) DEFAULT NULL,
  `place` VARCHAR(20) DEFAULT NULL,
  `dist` VARCHAR(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `crime` VALUES 
('murder', 'tirunelveli', 'tirunelveli'),
('robery', 'chennai', 'chennai'),
('castim', 'madurai', 'madurai'),
('rab', 'chennai', 'chennai');

-- ---------------------- missing ----------------------
DROP TABLE IF EXISTS `missing`;
CREATE TABLE `missing` (
  `name` VARCHAR(20) DEFAULT NULL,
  `mobile` VARCHAR(20) DEFAULT NULL,
  `addd` VARCHAR(200) DEFAULT NULL,
  `pin` VARCHAR(20) DEFAULT NULL,
  `da` VARCHAR(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `missing` VALUES 
('vel', '7339300411', 'chennai', '2342', '2020-03-03'),
('james', '9600066689', 'nagarkovil', '627123', '2020-01-15'),
('a', '1234567891', 'chennai', '7235', '2020-01-15'),
('vel', '7339300411', 'chennai', '2342', '2020-03-05');

-- ---------------------- report ----------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report` (
  `username` VARCHAR(20) DEFAULT NULL,
  `landmark` VARCHAR(20) DEFAULT NULL,
  `complaint` VARCHAR(20) DEFAULT NULL,
  `phonenumber` VARCHAR(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `report` VALUES ('vel', 'chennai', 'murder', '7339300411');

-- ---------------------- user ----------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `username` VARCHAR(20) DEFAULT NULL,
  `password` VARCHAR(20) DEFAULT NULL,
  `mail` VARCHAR(30) DEFAULT NULL,
  `mobile` VARCHAR(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `user` VALUES ('vel', 'vel', 'vel@gmail.com', '7339300411');

-- ---------------------- fir_report ----------------------
DROP TABLE IF EXISTS `fir_report`;

CREATE TABLE `fir_report` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255),
  `crimeType` VARCHAR(100),
  `ipcSection` VARCHAR(100),
  `description` TEXT,
  `Photo` LONGBLOB,
  `signature` LONGBLOB, -- Officer's signature column
  `officerName` VARCHAR(255), -- Officer's name (Reported By)
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `pdf_path` VARCHAR(255) -- New column for storing the relative path of PDF
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ---------------------- fir_report_2 ----------------------
DROP TABLE IF EXISTS fir_report_2;

CREATE TABLE fir_report_2 (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `crimeType` VARCHAR(100) NOT NULL,
  `ipcSection` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `photo` LONGBLOB,
  `signature` LONGBLOB,
  `officerName` VARCHAR(255),
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `pdf_filename` VARCHAR(255) COMMENT 'Only the PDF file name'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ---------------------- Complaint_report ----------------------
DROP TABLE IF EXISTS `Complaint_report`;
CREATE TABLE `Complaint_report` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `ack_number` VARCHAR(100) UNIQUE,
  `name` VARCHAR(100),
  `email` VARCHAR(100),
  `phone` VARCHAR(15),
  `incident_date` DATE,
  `complaint_type` VARCHAR(100),
  `complaint_detail` TEXT,
  `status` VARCHAR(20) DEFAULT 'Pending',
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ---------------------- police ----------------------
DROP TABLE IF EXISTS `police`;
CREATE TABLE `police` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100),
  `phone` VARCHAR(15),
  `badgeNumber` VARCHAR(50) UNIQUE,
  `rank` VARCHAR(50),
  `station` VARCHAR(100),
  `email` VARCHAR(100) UNIQUE,
  `password` VARCHAR(255),
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- ---------------------- chat----------------------
DROP TABLE IF EXISTS chat_messages;

CREATE TABLE chat_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_email VARCHAR(255),
    receiver_email VARCHAR(255),
    message TEXT,
    file_path VARCHAR(255), -- Path to the uploaded file
    file_data LONGBLOB,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);