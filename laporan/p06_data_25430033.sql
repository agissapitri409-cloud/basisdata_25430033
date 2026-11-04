-- =====================================================================
-- p06_data_25430033.sql | Perpustakaan Nusa Cendekia
-- Milestone Proyek 6 - Data sampel (DML)
-- Penyusun : Agis Sapitri (NIM 25430033, kelas B)
-- Parameter: P = (33 mod 9) + 1 = 7  ->  transaksi utama (peminjaman) = 10 x P = 70 baris
-- Urutan jalan: 1) p05_ddl_25430033.sql  2) berkas ini (dari basis data kosong).
-- Nilai id TIDAK ditebak; tabel anak memakai kode alami (nomor_anggota, isbn,
-- username, kode_peminjaman) lewat subkueri agar tidak terkena ERROR 1452.
-- Seluruh nama/data adalah fiktif. ISBN bersifat contoh (bukan ISBN asli).
-- CATATAN: nama kolom di bawah disusun dari DDL Modul 5; cocokkan dengan DDL Anda.
-- =====================================================================
USE perpus_nusa_cendekia_033;

-- ---------- 1. TABEL INDUK ----------

INSERT INTO katagori (nama_katagori) VALUES
  ('Fiksi'),
  ('Sains dan Teknologi'),
  ('Komputer dan Informatika'),
  ('Sejarah dan Biografi'),
  ('Agama dan Filsafat'),
  ('Anak dan Remaja');

INSERT INTO petugas (nama_petugas, username, password, no_telp_petugas) VALUES
  ('Rahmat Hidayat', 'rahmat.h', SHA2('Perpus#rahmat.h',256), '081273450011'),
  ('Siti Nurhaliza Putri', 'siti.np', SHA2('Perpus#siti.np',256), '081374560022'),
  ('Fajar Ramadhan', 'fajar.r', SHA2('Perpus#fajar.r',256), '082175670033'),
  ('Dewi Lestari Anggraini', 'dewi.la', SHA2('Perpus#dewi.la',256), '085276780044'),
  ('Budi Santoso', 'budi.s', SHA2('Perpus#budi.s',256), '085777890055');

-- (SHA2 dipakai agar kolom berisi hash, bukan teks biasa; aplikasi nyata sebaiknya memakai password_hash() PHP)

INSERT INTO anggota (nomor_anggota, nama_anggota, alamat_anggota, no_hp_anggota, tanggal_daftar) VALUES
  ('AGT-0001', 'Alya Safitri', 'Jl. Sutan Syahrir No. 12, Metro Pusat', '081279001001', '2025-08-04'),
  ('AGT-0002', 'Bagas Prasetyo', 'Jl. Ki Hajar Dewantara No. 45, Iringmulyo', '081379002002', '2025-08-11'),
  ('AGT-0003', 'Citra Maharani', 'Jl. Jenderal Sudirman No. 7, Metro Timur', '082179003003', '2025-09-02'),
  ('AGT-0004', 'Dimas Aditya Pratama', 'Jl. Imam Bonjol No. 23, Yosomulyo', '085279004004', '2025-09-15'),
  ('AGT-0005', 'Eka Wulandari', 'Jl. Pattimura No. 31, Metro Barat', '085779005005', '2025-10-06'),
  ('AGT-0006', 'Farhan Maulana', 'Jl. Diponegoro No. 18, Metro Utara', '081279006006', '2025-10-20'),
  ('AGT-0007', 'Gita Permatasari', 'Jl. Kartini No. 9, Tejosari', '081379007007', '2026-01-12'),
  ('AGT-0008', 'Hendra Kurniawan', 'Jl. Hasanudin No. 52, Ganjar Agung', '082179008008', '2026-02-03'),
  ('AGT-0009', 'Indah Cahyani', 'Jl. Cut Nyak Dien No. 14, Banjarsari', '085279009009', '2026-03-09'),
  ('AGT-0010', 'Joko Susilo', 'Jl. Brigjen Katamso No. 66, Mulyojati', '085779010010', '2026-04-21'),
  ('AGT-0011', 'Kirana Dewanti', 'Jl. Mangga No. 5, Metro Selatan', '081279011011', '2026-05-18'),
  ('AGT-0012', 'Lukman Hakim', 'Jl. Melati No. 27, Hadimulyo Barat', '081379012012', '2026-06-30');

INSERT INTO buku (isbn, judul_buku, penulis, penerbit, tahun_terbit, stok, id_katagori) VALUES
  ('9786230010011', 'Senja di Tepi Way Sekampung', 'Nadia Purnamasari', 'Penerbit Lentera Lampung', 2021, 30, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Fiksi')),
  ('9786230010028', 'Jejak Hujan di Kota Kecil', 'Rangga Wijaya', 'Penerbit Lentera Lampung', 2022, 28, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Fiksi')),
  ('9786230020035', 'Dasar-Dasar Basis Data Relasional', 'Hartono Setiawan', 'Citra Informatika', 2020, 34, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Komputer dan Informatika')),
  ('9786230020042', 'Pemrograman Web dengan PHP dan MySQL', 'Wahyu Ramadhani', 'Citra Informatika', 2023, 36, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Komputer dan Informatika')),
  ('9786230020059', 'Jaringan Komputer untuk Pemula', 'Yoga Mahendra', 'Citra Informatika', 2019, 26, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Komputer dan Informatika')),
  ('9786230030066', 'Pengantar Fisika Dasar', 'Sulistyo Utomo', 'Penerbit Cakrawala Ilmu', 2018, 30, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Sains dan Teknologi')),
  ('9786230030073', 'Ekosistem dan Lingkungan Hidup', 'Maria Anggraeni', 'Penerbit Cakrawala Ilmu', 2021, 24, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Sains dan Teknologi')),
  ('9786230040080', 'Sejarah Lampung dari Masa ke Masa', 'Ahmad Zainuddin', 'Pustaka Nusantara Jaya', 2017, 28, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Sejarah dan Biografi')),
  ('9786230040097', 'Biografi Tokoh Pendidikan Daerah', 'Retno Handayani', 'Pustaka Nusantara Jaya', 2020, 22, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Sejarah dan Biografi')),
  ('9786230050103', 'Etika dan Cara Berpikir Kritis', 'Imam Syafii Rahman', 'Penerbit Hikmah Insani', 2019, 25, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Agama dan Filsafat')),
  ('9786230060110', 'Petualangan Si Kancil di Hutan Jati', 'Dian Kusumawati', 'Kanak-Kanak Ceria', 2022, 32, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Anak dan Remaja')),
  ('9786230060127', 'Klub Detektif Sekolah Tunas Bangsa', 'Bayu Aji Nugroho', 'Kanak-Kanak Ceria', 2023, 27, (SELECT id_katagori FROM katagori WHERE nama_katagori = 'Anak dan Remaja'));

-- ---------- 2. TRANSAKSI PEMINJAMAN (70 baris, 6 tanggal) ----------

-- 2026-10-05 (12 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261005-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0009'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0002'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0009'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0003'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0002'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-05', '2026-10-12', 'dikembalikan'),
  ('PMJ-261005-12', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-05', '2026-10-12', 'dikembalikan');

-- 2026-10-12 (12 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261012-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0001'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0003'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0010'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0008'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0003'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-12', '2026-10-19', 'dipinjam'),
  ('PMJ-261012-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0009'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-12', '2026-10-19', 'dipinjam'),
  ('PMJ-261012-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-12', '2026-10-19', 'dikembalikan'),
  ('PMJ-261012-12', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0012'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-12', '2026-10-19', 'dikembalikan');

-- 2026-10-19 (12 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261019-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-19', '2026-10-26', 'dipinjam'),
  ('PMJ-261019-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0008'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0008'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0002'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-19', '2026-10-26', 'dipinjam'),
  ('PMJ-261019-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-19', '2026-10-26', 'dikembalikan'),
  ('PMJ-261019-12', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0012'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-19', '2026-10-26', 'dikembalikan');

-- 2026-10-26 (12 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261026-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0008'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0001'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0001'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0005'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-26', '2026-11-02', 'dipinjam'),
  ('PMJ-261026-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-26', '2026-11-02', 'dipinjam'),
  ('PMJ-261026-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-26', '2026-11-02', 'dipinjam'),
  ('PMJ-261026-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0010'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-26', '2026-11-02', 'dikembalikan'),
  ('PMJ-261026-12', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0001'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-26', '2026-11-02', 'dikembalikan');

-- 2026-10-30 (11 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261030-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0002'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0004'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0012'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0002'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-30', '2026-11-06', 'dipinjam'),
  ('PMJ-261030-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0009'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', '2026-11-06', 'dipinjam');

-- 2026-11-02 (11 transaksi)
INSERT INTO peminjaman (kode_peminjaman, id_anggota, id_petugas, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam) VALUES
  ('PMJ-261102-01', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0003'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-02', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-03', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0009'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-04', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0007'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-05', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0012'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-06', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0006'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-07', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0001'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-08', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0003'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-09', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0011'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-10', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0008'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-02', '2026-11-09', 'dipinjam'),
  ('PMJ-261102-11', (SELECT id_anggota FROM anggota WHERE nomor_anggota = 'AGT-0012'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-02', '2026-11-09', 'dipinjam');

-- ---------- 3. DETAIL PEMINJAMAN (118 baris) ----------

INSERT INTO detail_peminjaman (id_peminjaman, id_buku, jumlah) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-12'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-12'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-12'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230010011'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-12'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230010011'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-12'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230010011'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230060110'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230030073'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230010011'), 3),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230050103'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261030-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-01'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-02'), (SELECT id_buku FROM buku WHERE isbn = '9786230030066'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-03'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-04'), (SELECT id_buku FROM buku WHERE isbn = '9786230040097'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-05'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-06'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-07'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230010028'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230010011'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-08'), (SELECT id_buku FROM buku WHERE isbn = '9786230040080'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-09'), (SELECT id_buku FROM buku WHERE isbn = '9786230020042'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-10'), (SELECT id_buku FROM buku WHERE isbn = '9786230020035'), 2),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230020059'), 1),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261102-11'), (SELECT id_buku FROM buku WHERE isbn = '9786230060127'), 1);

-- ---------- 4. PENGEMBALIAN (41 baris; denda Rp1.000/hari terlambat) ----------

INSERT INTO pengembalian (id_peminjaman, id_petugas, tanggal_kembali, denda, status_denda) VALUES
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-01'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-13', 1000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-02'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-11', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-03'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-12', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-04'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-13', 1000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-05'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-09', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-06'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-13', 1000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-07'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-14', 2000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-08'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-11', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-09'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-17', 5000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-10'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-15', 3000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-11'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-10', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261005-12'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-15', 3000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-01'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-22', 3000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-02'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-19', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-03'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-20', 1000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-04'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-21', 2000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-05'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-18', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-06'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-17', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-07'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-19', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-09'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-22', 3000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-11'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-20', 1000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261012-12'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-21', 2000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-01'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-27', 1000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-02'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-23', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-04'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-25', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-05'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-26', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-06'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-10-29', 3000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-07'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-29', 3000, 'belum_lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-08'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-26', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-09'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-26', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-11'), (SELECT id_petugas FROM petugas WHERE username = 'siti.np'), '2026-10-23', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261019-12'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-10-25', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-01'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-01', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-02'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-04', 2000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-03'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-04', 2000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-04'), (SELECT id_petugas FROM petugas WHERE username = 'dewi.la'), '2026-11-01', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-05'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-11-02', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-06'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-11-03', 1000, 'lunas'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-10'), (SELECT id_petugas FROM petugas WHERE username = 'fajar.r'), '2026-10-31', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-11'), (SELECT id_petugas FROM petugas WHERE username = 'budi.s'), '2026-10-30', 0, 'tidak_ada'),
  ((SELECT id_peminjaman FROM peminjaman WHERE kode_peminjaman = 'PMJ-261026-12'), (SELECT id_petugas FROM petugas WHERE username = 'rahmat.h'), '2026-11-02', 0, 'tidak_ada');

-- ---------- 5. KURANGI STOK UNTUK BUKU YANG MASIH DIPINJAM ----------
-- (stok awal pada tabel buku = stok di rak sebelum transaksi periode ini)
SET SESSION sql_safe_updates = 1;
UPDATE buku b
JOIN (SELECT d.id_buku, SUM(d.jumlah) AS total
      FROM detail_peminjaman d
      JOIN peminjaman p ON p.id_peminjaman = d.id_peminjaman
      WHERE p.status_pinjam = 'dipinjam'
      GROUP BY d.id_buku) x ON x.id_buku = b.id_buku
SET b.stok = b.stok - x.total
WHERE b.id_buku > 0;
SET SESSION sql_safe_updates = 0;

-- ---------- 6. PEMERIKSAAN JUMLAH BARIS (untuk tangkapan layar) ----------
SELECT 'katagori' AS tabel, COUNT(*) AS jumlah_baris FROM katagori
UNION ALL SELECT 'petugas', COUNT(*) FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman
UNION ALL SELECT 'pengembalian', COUNT(*) FROM pengembalian;

SELECT tanggal_pinjam, COUNT(*) AS jumlah_transaksi
FROM peminjaman GROUP BY tanggal_pinjam ORDER BY tanggal_pinjam;
