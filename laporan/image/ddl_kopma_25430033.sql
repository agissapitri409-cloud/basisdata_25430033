CREATE DATABASE IF NOT EXISTS kopma_033
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE kopma_033;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE petugas (
  id_petugas INT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_petugas VARCHAR(20) NOT NULL,
  nama_petugas VARCHAR(100) NOT NULL,
  peran_petugas VARCHAR(50) NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT uq_petugas_kode UNIQUE (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_anggota VARCHAR(28) NOT NULL,
  nim_anggota VARCHAR(25) NOT NULL,
  nama_anggota VARCHAR(115) NOT NULL,
  prodi_anggota VARCHAR(100) NOT NULL,
  no_hp_anggota VARCHAR(20) NULL,
  status_anggota ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE NOT NULL,
  CONSTRAINT pk_anggota PRIMARY KEY (id_anggota),
  CONSTRAINT uq_anggota_no UNIQUE (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE (nim_anggota)
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang INT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_barang VARCHAR(20) NOT NULL,
  nama_barang VARCHAR(150) NOT NULL,
  kategori_barang VARCHAR(60) NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang INT UNSIGNED NOT NULL DEFAULT 0,
  stok_min_barang INT UNSIGNED NOT NULL DEFAULT 0,
  CONSTRAINT pk_barang PRIMARY KEY (id_barang),
  CONSTRAINT uq_barang_kode UNIQUE (kode_barang),
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
  CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nama_pemasok VARCHAR(150) NOT NULL,
  no_telp_pemasok VARCHAR(25) NULL,
  alamat_pemasok VARCHAR(255) NULL,
  CONSTRAINT pk_pemasok PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- AB-01: nomor nota unik. AB-02: no_anggota boleh NULL untuk pembeli nonanggota.
CREATE TABLE penjualan (
  id_penjualan INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_nota_penjualan VARCHAR(30) NOT NULL,
  tgl_penjualan DATETIME NOT NULL,
  id_petugas INT UNSIGNED NOT NULL,
  id_anggota INT UNSIGNED NULL,
  bayar_penjualan DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  CONSTRAINT pk_penjualan PRIMARY KEY (id_penjualan),
  CONSTRAINT uq_penjualan_nota UNIQUE (no_nota_penjualan),
  CONSTRAINT ck_penjualan_bayar CHECK (bayar_penjualan >= 0),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- Harga satuan disimpan sebagai potret harga pada saat transaksi.
CREATE TABLE detail_penjualan (
  id_penjualan INT UNSIGNED NOT NULL,
  id_barang INT UNSIGNED NOT NULL,
  qty_detail_penjualan INT UNSIGNED NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
  CONSTRAINT pk_detail_penjualan PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT ck_detail_penjualan_qty CHECK (qty_detail_penjualan > 0),
  CONSTRAINT ck_detail_penjualan_harga CHECK (harga_satuan_detail_penjualan >= 0),
  CONSTRAINT fk_detail_penjualan_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan (id_penjualan)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detail_penjualan_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(30) NOT NULL,
  tgl_pembelian DATE NOT NULL,
  id_pemasok INT UNSIGNED NOT NULL,
  status_pembelian ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',
  CONSTRAINT pk_pembelian PRIMARY KEY (id_pembelian),
  CONSTRAINT uq_pembelian_faktur UNIQUE (no_faktur_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok)
    REFERENCES pemasok (id_pemasok)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian INT UNSIGNED NOT NULL,
  id_barang INT UNSIGNED NOT NULL,
  qty_detail_pembelian INT UNSIGNED NOT NULL,
  harga_beli_satuan DECIMAL(12,2) NOT NULL,
  CONSTRAINT pk_detail_pembelian PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT ck_detail_pembelian_qty CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_detail_pembelian_harga CHECK (harga_beli_satuan >= 0),
  CONSTRAINT fk_detail_pembelian_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian (id_pembelian)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_detail_pembelian_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

SHOW TABLES;
SHOW CREATE TABLE penjualan;
SHOW CREATE TABLE detail_penjualan;
SHOW CREATE TABLE pembelian;
SHOW CREATE TABLE detail_pembelian;
