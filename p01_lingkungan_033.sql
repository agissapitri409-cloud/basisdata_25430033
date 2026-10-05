-- Modul 1: Lingkungan Kerja MariaDB dan Git
-- NIM: 033

CREATE DATABASE IF NOT EXISTS kopma_033 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_033'@'localhost' IDENTIFIED BY 'PasswordKerja';

GRANT ALL PRIVILEGES ON kopma_033.* TO 'mhs_033'@'localhost';

FLUSH PRIVILEGES;


CREATE USER IF NOT EXISTS 'tamu_033'@'localhost' IDENTIFIED BY 'PasswordKerja';

GRANT ALL PRIVILEGES ON kopma_033.* TO 'tamu_033'@'localhost';

FLUSH PRIVILEGES;