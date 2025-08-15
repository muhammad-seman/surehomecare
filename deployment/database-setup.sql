-- Database Setup untuk Bidan Care Production
-- Run this script as MySQL root user

-- Create database
CREATE DATABASE IF NOT EXISTS bidan_care 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Create application user
CREATE USER IF NOT EXISTS 'bidan_care_user'@'localhost' IDENTIFIED BY 'BiDaN_CaRe_2025!@#';

-- Grant privileges
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP 
ON bidan_care.* 
TO 'bidan_care_user'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Use the database
USE bidan_care;

-- Show grants for verification
SHOW GRANTS FOR 'bidan_care_user'@'localhost';