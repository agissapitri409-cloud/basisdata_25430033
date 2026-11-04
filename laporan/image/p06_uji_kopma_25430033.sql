-- =====================================================================
-- p06_uji_kopma_25430033.sql | Basis Data Koperasi Mahasiswa (Kopma)
-- Milestone Proyek 6 - Pengujian Data & Pelaporan (DQL)
-- Penyusun : Agis Sapitri (NIM 25430033, kelas B)
-- Basis Data: kopma_033
-- =====================================================================
USE kopma_033;

-- =====================================================================
-- 1. UJI INTEGRITAS DAN JUMLAH REKORD TABEL
-- =====================================================================
SELECT '1. Jumlah Rekord Per Tabel' AS Pengujian;
SELECT 'petugas' AS tabel, COUNT(*) AS total_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan;


-- =====================================================================
-- 2. UJI KEBUTUHAN INFORMASI (KI-01): KEANGGOTAAN
-- Menampilkan daftar anggota aktif beserta program studi dan lama bergabung
-- =====================================================================
SELECT '2. Daftar Anggota Aktif Kopma' AS Pengujian;
SELECT 
  no_anggota,
  nim_anggota,
  nama_anggota,
  prodi_anggota,
  tgl_daftar_anggota,
  status_anggota
FROM anggota
WHERE status_anggota = 'aktif'
ORDER BY tgl_daftar_anggota ASC;


-- =====================================================================
-- 3. UJI KEBUTUHAN INFORMASI (KI-02): STOK BARANG & STATUS MONITORED
-- Menampilkan daftar stok barang dan peringatan jika stok di bawah stok minimum
-- =====================================================================
SELECT '3. Rekapitulasi Stok Barang dan Peringatan Minimum' AS Pengujian;
SELECT 
  kode_barang,
  nama_barang,
  kategori_barang,
  harga_jual_barang,
  stok_barang,
  stok_min_barang,
  CASE 
    WHEN stok_barang <= stok_min_barang THEN 'PERLU RESTOCK'
    ELSE 'AMAN'
  END AS status_stok
FROM barang
ORDER BY status_stok DESC, stok_barang ASC;


-- =====================================================================
-- 4. UJI KEBUTUHAN INFORMASI (KI-03): REKAP OMZET PENJUALAN HARIAN
-- Menghitung total transaksi, unit barang terjual, dan total omzet per hari
-- =====================================================================
SELECT '4. Laporan Omzet Penjualan Harian' AS Pengujian;
SELECT 
  DATE(p.tgl_penjualan) AS tanggal_transaksi,
  COUNT(DISTINCT p.id_penjualan) AS jumlah_nota,
  SUM(dp.qty_detail_penjualan) AS total_item_terjual,
  SUM(dp.qty_detail_penjualan * dp.harga_satuan_detail_penjualan) AS total_omzet
FROM penjualan p
JOIN detail_penjualan dp ON p.id_penjualan = dp.id_penjualan
GROUP BY DATE(p.tgl_penjualan)
ORDER BY tanggal_transaksi ASC;


-- =====================================================================
-- 5. UJI KEBUTUHAN INFORMASI (KI-04): BARANG TERLARIS (TOP 5)
-- Menampilkan 5 barang dengan jumlah kuantitas penjualan tertinggi
-- =====================================================================
SELECT '5. Top 5 Barang Terlaris di Kopma' AS Pengujian;
SELECT 
  b.kode_barang,
  b.nama_barang,
  b.kategori_barang,
  SUM(dp.qty_detail_penjualan) AS total_terjual,
  SUM(dp.qty_detail_penjualan * dp.harga_satuan_detail_penjualan) AS total_pendapatan
FROM detail_penjualan dp
JOIN barang b ON b.id_barang = dp.id_barang
GROUP BY b.id_barang, b.kode_barang, b.nama_barang, b.kategori_barang
ORDER BY total_terjual DESC
LIMIT 5;


-- =====================================================================
-- 6. UJI KEBUTUHAN INFORMASI (KI-05): REKAP TRANSKSI ANGGOTA VS NON-ANGGOTA
-- Membandingkan kontribusi omzet pembeli anggota dan non-anggota
-- =====================================================================
SELECT '6. Analisis Transaksi Anggota vs Non-Anggota' AS Pengujian;
SELECT 
  IF(p.id_anggota IS NOT NULL, 'Anggota Kopma', 'Pembeli Umum (Non-Anggota)') AS tipe_pembeli,
  COUNT(DISTINCT p.id_penjualan) AS jumlah_transaksi,
  SUM(dp.qty_detail_penjualan * dp.harga_satuan_detail_penjualan) AS total_omzet
FROM penjualan p
JOIN detail_penjualan dp ON p.id_penjualan = dp.id_penjualan
GROUP BY IF(p.id_anggota IS NOT NULL, 'Anggota Kopma', 'Pembeli Umum (Non-Anggota)');


-- =====================================================================
-- 7. UJI REKAPITULASI PENGADAAN BARANG (PEMBELIAN DARI PEMASOK)
-- Menampilkan riwayat pengadaan barang beserta status faktur
-- =====================================================================
SELECT '7. Riwayat Pengadaan Barang dari Pemasok' AS Pengujian;
SELECT 
  pem.no_faktur_pembelian,
  pem.tgl_pembelian,
  pm.nama_pemasok,
  pem.status_pembelian,
  COUNT(dp.id_barang) AS ragam_barang,
  SUM(dp.qty_detail_pembelian) AS total_kuantitas,
  SUM(dp.qty_detail_pembelian * dp.harga_beli_satuan) AS total_pengeluaran
FROM pembelian pem
JOIN pemasok pm ON pm.id_pemasok = pem.id_pemasok
JOIN detail_pembelian dp ON dp.id_pembelian = pem.id_pembelian
GROUP BY pem.id_pembelian, pem.no_faktur_pembelian, pem.tgl_pembelian, pm.nama_pemasok, pem.status_pembelian
ORDER BY pem.tgl_pembelian DESC;