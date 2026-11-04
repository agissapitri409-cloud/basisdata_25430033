CREATE DATABASE IF NOT EXISTS perpus_nusa_cendekia_033
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE perpus_nusa_cendekia_033;

-- Hapus dari tabel anak ke induk agar skrip dapat dijalankan ulang.
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS pengembalian;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS petugas;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS katagori;
SET FOREIGN_KEY_CHECKS = 1;

-- AB-01: nomor anggota wajib dan unik.
CREATE TABLE anggota (
  id_anggota INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nomor_anggota VARCHAR(28) NOT NULL,
  nama_anggota VARCHAR(115) NOT NULL,
  alamat_anggota TEXT NULL,
  no_hp_anggota VARCHAR(12) NULL,
  tanggal_pendaftaran DATE NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_nomor UNIQUE (nomor_anggota)
) ENGINE=InnoDB;

CREATE TABLE katagori (
  id_katagori INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_katagori VARCHAR(56) NOT NULL,
  CONSTRAINT pk_katagori PRIMARY KEY (id_katagori),
  CONSTRAINT uq_katagori_nama UNIQUE (nama_katagori)
) ENGINE=InnoDB;

CREATE TABLE petugas (
  id_petugas INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_petugas VARCHAR(100) NOT NULL,
  username VARCHAR(58) NOT NULL,
  password VARCHAR(210) NOT NULL COMMENT 'Simpan hash password, bukan teks biasa',
  no_telp_petugas VARCHAR(12) NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_username UNIQUE (username)
) ENGINE=InnoDB;

-- AB-02: setiap buku harus memiliki kategori yang terdaftar.
-- AB-07: stok buku tidak boleh negatif.
CREATE TABLE buku (
  id_buku INT UNSIGNED NOT NULL AUTO_INCREMENT,
  isbn VARCHAR(26) NOT NULL,
  judul_buku VARCHAR(146) NOT NULL,
  penulis VARCHAR(125) NULL,
  penerbit VARCHAR(100) NULL,
  tahun_terbit SMALLINT UNSIGNED NULL,
  stok INT NOT NULL DEFAULT 0,
  id_katagori INT UNSIGNED NOT NULL,
  CONSTRAINT pk_buku PRIMARY KEY (id_buku),
  CONSTRAINT uq_buku_isbn UNIQUE (isbn),
  CONSTRAINT ck_buku_stok CHECK (stok >= 0),
  CONSTRAINT fk_buku_katagori FOREIGN KEY (id_katagori)
    REFERENCES katagori (id_katagori)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- AB-04: status peminjaman dibatasi pada dipinjam/dikembalikan.
-- AB-05: peminjaman harus memiliki anggota dan petugas yang terdaftar.
CREATE TABLE peminjaman (
  id_peminjaman INT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_peminjaman VARCHAR(20) NOT NULL,
  id_anggota INT UNSIGNED NOT NULL,
  id_petugas INT UNSIGNED NOT NULL,
  tanggal_pinjam DATE NOT NULL,
  tanggal_jatuh_tempo DATE NOT NULL,
  status_pinjam ENUM('dipinjam','dikembalikan') NOT NULL DEFAULT 'dipinjam',
  CONSTRAINT pk_peminjaman PRIMARY KEY (id_peminjaman),
  CONSTRAINT uq_peminjaman_kode UNIQUE (kode_peminjaman),
  CONSTRAINT ck_peminjaman_tanggal CHECK (tanggal_jatuh_tempo >= tanggal_pinjam),
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- AB-03: satu transaksi dapat memiliki beberapa detail buku.
CREATE TABLE detail_peminjaman (
  id_detail_peminjaman INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_peminjaman INT UNSIGNED NOT NULL,
  id_buku INT UNSIGNED NOT NULL,
  jumlah INT UNSIGNED NOT NULL,
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (id_detail_peminjaman),
  CONSTRAINT ck_detail_peminjaman_jumlah CHECK (jumlah > 0),
  CONSTRAINT fk_detail_peminjaman_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detail_peminjaman_buku FOREIGN KEY (id_buku)
    REFERENCES buku (id_buku)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- AB-06: satu peminjaman dicatat pengembaliannya satu kali; denda tidak boleh negatif.
CREATE TABLE pengembalian (
  id_pengembalian INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_peminjaman INT UNSIGNED NOT NULL,
  id_petugas INT UNSIGNED NOT NULL,
  tanggal_dikembalikan DATE NOT NULL,
  denda DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  status_denda ENUM('lunas','belum_lunas') NOT NULL DEFAULT 'lunas',
  CONSTRAINT pk_pengembalian PRIMARY KEY (id_pengembalian),
  CONSTRAINT uq_pengembalian_peminjaman UNIQUE (id_peminjaman),
  CONSTRAINT ck_pengembalian_denda CHECK (denda >= 0),
  CONSTRAINT fk_pengembalian_peminjaman FOREIGN KEY (id_peminjaman)
    REFERENCES peminjaman (id_peminjaman)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_pengembalian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Pemeriksaan hasil (tangkap layar untuk laporan)
SHOW TABLES;
SHOW CREATE TABLE peminjaman;
SHOW CREATE TABLE detail_peminjaman;
SHOW CREATE TABLE pengembalian;

SELECT COUNT(*) AS jumlah_tabel
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'perpus_nusa_cendekia_033';

SELECT TABLE_NAME, CONSTRAINT_NAME, DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'perpus_nusa_cendekia_033';