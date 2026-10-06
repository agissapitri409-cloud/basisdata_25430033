# Dokumen Kebutuhan Data - Perpustakaan Nusa Cendekia (perpus_nusa_cendekia_033)

**Nama:** Agis Sapitri  
**NPM:** 25430033  
**Kelas:** B  
**Tanggal:** 7 Oktober 2026  
**Proyek Basis Data:** Perpustakaan Nusa Cendekia (`perpus_nusa_cendekia_033` / `perpus_033`)  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Perpustakaan Nusa Cendekia merupakan unit layanan literasi akademis yang memfasilitasi pengelolaan koleksi pustaka, pencatatan keanggotaan, serta pemprosesan sirkulasi peminjaman dan pengembalian buku. Seiring pesatnya pertumbuhan jumlah anggota dan koleksi bahan pustaka, pengelolaan data secara manual berbasis dokumen kertas berpotensi menimbulkan redundansi data, hilangnya rekam jejak transaksi sirkulasi, serta timbulnya ketidakakuratan perhitungan laporan denda harian. 

Oleh karena itu, diperlukan perancangan sistem basis data relasional **`perpus_nusa_cendekia_033`** (disingkat `perpus_033`) yang terstruktur, aman, dan efisien untuk mendukung otomatisasi serta transparansi operasional di Perpustakaan Nusa Cendekia.

---

## 2. Aktor dan Proses Bisnis

### A. Tabel Aktor Sistem
| ID Aktor | Nama Aktor | Peran dan Tanggung Jawab |
| :--- | :--- | :--- |
| **AKT-01** | Staf / Pustakawan | Mengelola katalog buku, memproses pendaftaran anggota, melayani transaksi peminjaman/pengembalian, dan mencatat denda. |
| **AKT-02** | Anggota Perpustakaan | Melakukan pencarian buku, meminjam buku, serta mengembalikan buku sesuai batas waktu yang ditentukan. |
| **AKT-03** | Kepala Perpustakaan | Mengakses rekapitulasi statistik peminjaman dan meninjau laporan denda bulanan untuk keperluan evaluasi. |

![Tabel Aktor Sistem](<image/tabel_aktor_sistem.png>)

### B. Tabel Proses Bisnis (PB-xx)
| Kode PB | Nama Proses Bisnis | Deskripsi Ringkas | Aktor Terlibat |
| :--- | :--- | :--- | :--- |
| **PB-01** | Registrasi Anggota | Menginput dan mengonfirmasi data calon anggota baru ke dalam sistem untuk aktivasi status keanggotaan. | AKT-01, AKT-02 |
| **PB-02** | Pengelolaan Katalog Buku | Menambah, memperbarui, atau menghapus data buku beserta kelompok kategori ke dalam basis data. | AKT-01 |
| **PB-03** | Transaksi Peminjaman | Mencatat transaksi peminjaman buku, memeriksa stok ketersediaan, dan menetapkan batas waktu pengembalian. | AKT-01, AKT-02 |
| **PB-04** | Transaksi Pengembalian | Memeriksa kondisi fisik buku yang dikembalikan, menghitung keterlambatan, dan mencatat denda jika ada. | AKT-01, AKT-02 |
| **PB-05** | Pelaporan Sirkulasi | Mengompilasi ringkasan transaksi sirkulasi dan rekapitulasi denda sebagai bahan laporan resmi pimpinan. | AKT-01, AKT-03 |

---

## 3. Dokumen Sumber yang Dianalisis
1. **Formulir Pendaftaran Anggota:** Lembar fisik pendataan yang memuat informasi nama lengkap, identitas (NPM/NIK), email, nomor telepon, dan tanggal pendaftaran.
2. **Buku Induk Katalog Pustaka:** Dokumen inventaris fisik yang mencantumkan judul buku, nomor ISBN, penulis, penerbit, tahun terbit, dan ketersediaan stok.
3. **Resi / Kartu Sirkulasi Peminjaman:** Bukti transaksi yang mencantumkan ID transaksi, nama peminjam, rincian buku yang dipinjam, tanggal pinjam, dan batas waktu pengembalian.
4. **Bukti Pembayaran Denda:** Struk catatan resmi terkait penyelesaian keterlambatan pengembalian buku beserta nominal denda yang dibayarkan.

---

## 4. Entitas Kandidat dan Elemen Data

1. **Anggota (`anggota`)**
   * Elemen Data: `id_anggota` (PK), `npm_nik`, `nama_lengkap`, `email`, `nomor_telepon`, `tanggal_mendaftar`.
2. **Kategori (`kategori`)**
   * Elemen Data: `id_kategori` (PK), `nama_kategori`.
3. **Buku (`buku`)**
   * Elemen Data: `id_buku` (PK), `isbn`, `judul`, `penulis`, `penerbit`, `tahun_terbit`, `stok`, `id_kategori` (FK).
4. **Peminjaman (`peminjaman`)**
   * Elemen Data: `id_peminjaman` (PK), `id_anggota` (FK), `tanggal_pinjam`, `tanggal_tenggat`, `status`.
5. **Detail Peminjaman (`detail_peminjaman`)**
   * Elemen Data: `id_detail` (PK), `id_peminjaman` (FK), `id_buku` (FK), `jumlah`.

---

## 5. Aturan Bisnis (Tabel AB-xx)

| Kode AB | Pernyataan Aturan Bisnis | Implikasi Pada Basis Data |
| :--- | :--- | :--- |
| **AB-01** | Setiap anggota Perpustakaan Nusa Cendekia wajib memiliki nomor identitas (NPM/NIK) dan email yang terdaftar secara unik. | Kolom `npm_nik` dan `email` diberikan batasan `UNIQUE` dan `NOT NULL`. |
| **AB-02** | Satu entri buku wajib terhubung dengan tepat satu kelompok kategori pustaka. | Kolom `id_kategori` pada tabel `buku` diset sebagai *Foreign Key* merujuk ke tabel `kategori`. |
| **AB-03** | Satu transaksi peminjaman dapat memuat lebih dari satu judul buku sekaligus. | Dibuat tabel perantara *many-to-many* (`detail_peminjaman`) untuk menghubungkan tabel `peminjaman` dan `buku`. |
| **AB-04** | Status transaksi peminjaman dibatasi pada pilihan: 'dipinjam', 'dikembalikan', atau 'terlambat'. | Kolom `status` menerapkan tipe data `ENUM('dipinjam', 'dikembalikan', 'terlambat')`. |
| **AB-05** | Jumlah stok buku tidak boleh bernilai negatif dan secara standar bernilai 0 jika belum diisi. | Kolom `stok` dikonfigurasi `INT NOT NULL DEFAULT 0`. |

---

## 6. Kebutuhan Informasi (Tabel KI-xx)

| Kode KI | Kebutuhan Informasi | Sumber Data (Tabel) |
| :--- | :--- | :--- |
| **KI-01** | Daftar seluruh anggota aktif Perpustakaan Nusa Cendekia beserta informasi kontak lengkap. | `anggota` |
| **KI-02** | Pencarian ketersediaan stok buku berdasarkan judul atau kelompok kategori pustaka. | `buku`, `kategori` |
| **KI-03** | Rekap harian transaksi peminjaman yang belum dikembalikan (*active loans*). | `peminjaman`, `anggota`, `detail_peminjaman`, `buku` |
| **KI-04** | Laporan riwayat transaksi peminjaman dari setiap anggota dalam rentang waktu tertentu. | `anggota`, `peminjaman`, `detail_peminjaman` |

---

## 7. Matriks CRUD

| Entitas / Tabel | PB-01 (Registrasi) | PB-02 (Katalog Buku) | PB-03 (Peminjaman) | PB-04 (Pengembalian) | PB-05 (Pelaporan) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **`anggota`** | **C, R, U** | - | **R** | **R** | **R** |
| **`kategori`** | - | **C, R, U, D** | **R** | - | **R** |
| **`buku`** | - | **C, R, U, D** | **R, U** | **R, U** | **R** |
| **`peminjaman`** | - | - | **C, R** | **R, U** | **R** |
| **`detail_peminjaman`** | - | - | **C, R** | **R** | **R** |

*(Keterangan: **C** = Create, **R** = Read, **U** = Update, **D** = Delete)*

---

## 8. Kamus Data Awal

| Nama Tabel | Nama Kolom | Tipe Data | Batasan / Constraint | Penanggung Jawab Data |
| :--- | :--- | :--- | :--- | :--- |
| **`anggota`** | `id_anggota` | INT | PRIMARY KEY, AUTO_INCREMENT | Petugas Administrasi |
| | `npm_nik` | VARCHAR(20) | NOT NULL, UNIQUE | Petugas Administrasi |
| | `nama_lengkap` | VARCHAR(100) | NOT NULL | Petugas Administrasi |
| | `email` | VARCHAR(100) | NOT NULL, UNIQUE | Petugas Administrasi |
| | `nomor_telepon` | VARCHAR(15) | NULL | Petugas Administrasi |
| | `tanggal_mendaftar`| DATE | DEFAULT CURRENT_DATE | Petugas Administrasi |
| **`kategori`** | `id_kategori` | INT | PRIMARY KEY, AUTO_INCREMENT | Pustakawan Katalog |
| | `nama_kategori` | VARCHAR(50) | NOT NULL, UNIQUE | Pustakawan Katalog |
| **`buku`** | `id_buku` | INT | PRIMARY KEY, AUTO_INCREMENT | Pustakawan Katalog |
| | `isbn` | VARCHAR(20) | NOT NULL, UNIQUE | Pustakawan Katalog |
| | `judul` | VARCHAR(150) | NOT NULL | Pustakawan Katalog |
| | `penulis` | VARCHAR(100) | NOT NULL | Pustakawan Katalog |
| | `penerbit` | VARCHAR(100) | NULL | Pustakawan Katalog |
| | `tahun_terbit` | INT | NULL | Pustakawan Katalog |
| | `stok` | INT | NOT NULL, DEFAULT 0 | Pustakawan Katalog |
| | `id_kategori` | INT | FOREIGN KEY (`kategori`) | Pustakawan Katalog |
| **`peminjaman`**| `id_peminjaman`| INT | PRIMARY KEY, AUTO_INCREMENT | Petugas Sirkulasi |
| | `id_anggota` | INT | FOREIGN KEY (`anggota`) | Petugas Sirkulasi |
| | `tanggal_pinjam` | DATE | NOT NULL | Petugas Sirkulasi |
| | `tanggal_tenggat` | DATE | NOT NULL | Petugas Sirkulasi |
| | `status` | ENUM | DEFAULT 'dipinjam' | Petugas Sirkulasi |

---

## 9. Kebutuhan Non-Fungsional Data

1. **Kapasitas Pemrosesan:**
   * Basis data disiapkan untuk mengelola estimasi hingga **15.000 anggota aktif**, **30.000 koleksi buku**, serta **100.000 log transaksi peminjaman** per tahun tanpa penurunan performa kueri yang signifikan.
2. **Manajemen Retensi:**
   * Rekam transaksi peminjaman disimpan dalam sistem aktif selama **5 tahun** operasional. Setelah melewati periode tersebut, data transaksi lama dipindahkan ke basis data arsip tersendiri.
3. **Privasi dan Keamanan Data:**
   * Data kontak sensitif anggota (`email`, `nomor_telepon`) hanya boleh diakses oleh pengguna akun kerja `dev_033` dan administrator.
   * Hak akses pengunjung/publik (`tamu_033`) dibatasi hanya pada wewenang baca (`SELECT`) katalog buku.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Duplikasi Identitas Anggota:**
   * *Antisipasi:* Menerapkan batasan `UNIQUE` pada kolom `npm_nik` dan `email`.
2. **Inkonsistensi Kategorisasi Buku:**
   * *Antisipasi:* Menggunakan relasi `FOREIGN KEY` ke tabel referensi `kategori` alih-alih menginput teks kategori secara manual.
3. **Data Peminjaman Tanpa Referensi Sah (*Orphan Records*):**
   * *Antisipasi:* Menggunakan klausa `FOREIGN KEY ... ON DELETE CASCADE ON UPDATE CASCADE` agar integritas relasi antar-tabel terjamin otomatis.
4. **Kesalahan Format Tanggal dan Status:**
   * *Antisipasi:* Mengunci format tanggal dengan tipe `DATE` dan membatasi pilihan status transaksi menggunakan `ENUM('dipinjam', 'dikembalikan', 'terlambat')`.

---

## 11. Bukti Git

- **Link Repositori:** https://github.com/agissapitrr/basisdata_25430033
- **Tangkapan Layar Git Log:**

![Bukti Git Log Modul 2 Nusa Cendekia](<image/git_log_perpus_nusa_cendekiawa.png>)