# Dokumen Kebutuhan Data - Perpustakaan Nusa Cendekia (perpus_nusa_cendekia_033)

**Nama:** Agis Sapitri  
**NPM:** 25430033  
**Kelas:** B  
**Tanggal:** 7 Oktober 2026  
**Proyek Basis Data:** Perpustakaan Nusa Cendekia (`perpus_nusa_cendekia_033` / `perpus_033`)  

---

## 1. Latar Belakang dan Aktivitas Organisasi

Perpustakaan Nusa Cendekia adalah unit layanan yang menyediakan koleksi buku, mengelola keanggotaan, serta mencatat peminjaman dan pengembalian buku oleh mahasiswa. Pencatatan yang masih berbasis dokumen kertas berisiko menimbulkan selisih stok buku, keterlambatan pencatatan peminjaman, serta kesulitan menghitung denda keterlambatan secara akurat.

Untuk mengatasi hal tersebut, dirancang basis data relasional perpus_nusa_cendekia_033 (disingkat perpus_033). Basis data ini bertujuan menyediakan media penyimpanan yang aman dan terintegrasi, serta mendukung layanan peminjaman, pengembalian, dan pelaporan perpustakaan secara tertib dan transparan.

## 2. Aktor dan Proses Bisnis

### A. Tabel Aktor Sistem

| ID Aktor | Nama Aktor | Peran dan Tanggung Jawab |
|---|---|---|
| AKT-01 | Petugas Perpustakaan | Melayani peminjaman dan pengembalian buku, mencatat transaksi, serta mencatat denda keterlambatan atau kerusakan. |
| AKT-02 | Anggota Perpustakaan | Mendaftar sebagai anggota, meminjam buku, mengembalikan buku, dan membayar denda bila ada. |
| AKT-03 | Pengelola Perpustakaan | Mengelola katalog buku dan katagori, memperbarui data keanggotaan dan petugas, serta meninjau laporan. |

### B. Tabel Proses Bisnis (PB-xx)

| Kode PB | Nama Proses Bisnis | Deskripsi Ringkas | Aktor Terlibat |
|---|---|---|---|
| PB-01 | Registrasi Anggota | Mencatat identitas anggota (nomor anggota, nama, alamat, nomor HP, tanggal pendaftaran) ke dalam sistem. | AKT-02, AKT-03 |
| PB-02 | Pengelolaan Koleksi Buku | Memperbarui katalog: menambah buku baru, mengubah data buku, mengelompokkan ke katagori, dan menyesuaikan stok. | AKT-03 |
| PB-03 | Transaksi Peminjaman | Mencatat peminjaman oleh anggota beserta daftar buku yang dipinjam, tanggal pinjam, tanggal jatuh tempo, dan petugas yang melayani. | AKT-01, AKT-02 |
| PB-04 | Pengembalian dan Denda | Mencatat tanggal pengembalian, menghitung denda, mencatat status denda, dan memperbarui status peminjaman. | AKT-01, AKT-02 |
| PB-05 | Pelaporan Perpustakaan | Menyusun rekap peminjaman, buku terpopuler, ketersediaan stok, dan rekap denda bagi pengelola. | AKT-03 |

## 3. Dokumen Sumber yang Dianalisis

- **Formulir Pendaftaran Anggota Perpustakaan:** lembar pendataan yang memuat nomor anggota, nama, alamat, nomor HP, dan tanggal pendaftaran.
- **Slip Peminjaman Buku:** bukti peminjaman yang memuat kode peminjaman, identitas anggota, nama petugas, tanggal pinjam, tanggal jatuh tempo, serta daftar buku dan jumlahnya.
- **Buku Induk Koleksi:** catatan koleksi yang memuat ISBN, judul, penulis, penerbit, tahun terbit, katagori, dan jumlah stok.
- **Slip Pengembalian dan Denda:** bukti pengembalian yang memuat tanggal dikembalikan, petugas penerima, nominal denda, dan status denda.
- **Data Petugas:** catatan petugas yang memuat nama, username, password, dan nomor telepon.

## 4. Entitas Kandidat dan Elemen Data

### Entitas dan Elemen Data

**Anggota (`anggota`)**
Elemen data: id_anggota (PK), nomor_anggota, nama_anggota, alamat_anggota, no_hp_anggota, tanggal_pendaftaran.

**Katagori (`katagori`)**
Elemen data: id_katagori (PK), nama_katagori.

**Buku (`buku`)**
Elemen data: id_buku (PK), isbn, judul_buku, penulis, penerbit, tahun_terbit, stok, id_katagori (FK).

**Petugas (`petugas`)**
Elemen data: id_petugas (PK), nama_petugas, username, password, no_telp_petugas.

**Peminjaman (`peminjaman`)**
Elemen data: id_peminjaman (PK), kode_peminjaman, id_anggota (FK), id_petugas (FK), tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam.

**Detail Peminjaman (`detail_peminjaman`)**
Elemen data: id_detail_peminjaman (PK), id_peminjaman (FK), id_buku (FK), jumlah.

**Pengembalian (`pengembalian`)**
Elemen data: id_pengembalian (PK), id_peminjaman (FK), id_petugas (FK), tanggal_dikembalikan, denda, status_denda.

### Relasi Antar Tabel

| Tabel Induk | Tabel Anak | Kolom Penghubung | Keterangan |
|---|---|---|---|
| katagori | buku | id_katagori | Satu katagori memiliki banyak buku. |
| anggota | peminjaman | id_anggota | Satu anggota dapat melakukan banyak peminjaman. |
| petugas | peminjaman | id_petugas | Satu petugas dapat melayani banyak peminjaman. |
| peminjaman | detail_peminjaman | id_peminjaman | Satu peminjaman memiliki satu atau lebih detail buku. |
| buku | detail_peminjaman | id_buku | Satu buku dapat muncul pada banyak detail peminjaman. |
| peminjaman | pengembalian | id_peminjaman | Satu peminjaman dicatat pengembaliannya pada tabel pengembalian. |
| petugas | pengembalian | id_petugas | Satu petugas dapat menerima banyak pengembalian. |

## 5. Aturan Bisnis (Tabel AB-xx)

| Kode AB | Pernyataan Aturan Bisnis | Implikasi Pada Basis Data |
|---|---|---|
| AB-01 | Setiap anggota wajib memiliki nomor anggota yang terdaftar secara unik. | Kolom nomor_anggota dikonfigurasi dengan batasan UNIQUE dan NOT NULL. |
| AB-02 | Setiap buku wajib terkelompokkan ke dalam satu katagori terdaftar. | Kolom id_katagori pada tabel buku diset sebagai FOREIGN KEY yang merujuk ke tabel katagori. |
| AB-03 | Satu transaksi peminjaman dapat mencakup beberapa buku sekaligus. | Dibuat tabel perantara detail_peminjaman untuk menghubungkan tabel peminjaman dan buku. |
| AB-04 | Status peminjaman dibatasi pada pilihan: 'dipinjam' atau 'dikembalikan'. | Kolom status_pinjam menggunakan tipe data ENUM('dipinjam','dikembalikan'). |
| AB-05 | Setiap peminjaman dan pengembalian wajib dicatat oleh seorang petugas, dan setiap peminjaman wajib dimiliki seorang anggota. | Kolom id_petugas dan id_anggota pada tabel peminjaman, serta id_petugas pada tabel pengembalian, diset sebagai FOREIGN KEY. |
| AB-06 | Status denda dibatasi pada pilihan: 'lunas' atau 'belum_lunas', dan nilai denda minimal 0. | Kolom status_denda menggunakan ENUM('lunas','belum_lunas'); kolom denda bertipe DECIMAL(10,2) dengan nilai default 0. |
| AB-07 | Stok buku tidak boleh bernilai negatif. | Kolom stok dikonfigurasi NOT NULL dengan nilai default 0. |

## 6. Kebutuhan Informasi (Tabel KI-xx)

| Kode KI | Kebutuhan Informasi | Sumber Data (Tabel) |
|---|---|---|
| KI-01 | Data seluruh anggota perpustakaan beserta tanggal pendaftarannya. | anggota |
| KI-02 | Informasi ketersediaan stok buku berdasarkan katagori. | buku, katagori |
| KI-03 | Daftar peminjaman yang masih berstatus 'dipinjam' beserta tanggal jatuh tempo dan nama anggotanya. | peminjaman, anggota, detail_peminjaman, buku |
| KI-04 | Rekap denda pengembalian berdasarkan status denda (lunas atau belum lunas). | pengembalian |
| KI-05 | Laporan daftar buku terpopuler berdasarkan total jumlah buku yang dipinjam. | detail_peminjaman, buku |

## 7. Matriks CRUD

| Entitas / Tabel | PB-01 (Registrasi) | PB-02 (Koleksi) | PB-03 (Peminjaman) | PB-04 (Pengembalian) | PB-05 (Pelaporan) |
|---|---|---|---|---|---|
| anggota | C, R, U | - | R | R | R |
| katagori | - | C, R, U, D | R | - | R |
| buku | - | C, R, U, D | R, U | R, U | R |
| petugas | - | - | R | R | R |
| peminjaman | - | - | C, R | R, U | R |
| detail_peminjaman | - | - | C, R | R | R |
| pengembalian | - | - | - | C, R, U | R |

(Keterangan: C = Create, R = Read, U = Update, D = Delete)

## 8. Kamus Data Awal

| Nama Tabel | Nama Kolom | Tipe Data | Batasan / Constraint | Penanggung Jawab Data |
|---|---|---|---|---|
| **anggota** | id_anggota | INT(10) | PRIMARY KEY, AUTO_INCREMENT | Pengelola Perpustakaan |
| | nomor_anggota | VARCHAR(28) | NOT NULL, UNIQUE | Pengelola Perpustakaan |
| | nama_anggota | VARCHAR(115) | NOT NULL | Pengelola Perpustakaan |
| | alamat_anggota | TEXT | NULL | Pengelola Perpustakaan |
| | no_hp_anggota | VARCHAR(12) | NULL | Pengelola Perpustakaan |
| | tanggal_pendaftaran | DATE | NOT NULL | Pengelola Perpustakaan |
| **katagori** | id_katagori | INT(7) | PRIMARY KEY, AUTO_INCREMENT | Pengelola Perpustakaan |
| | nama_katagori | VARCHAR(56) | NOT NULL | Pengelola Perpustakaan |
| **buku** | id_buku | INT(8) | PRIMARY KEY, AUTO_INCREMENT | Pengelola Perpustakaan |
| | isbn | VARCHAR(26) | NOT NULL, UNIQUE | Pengelola Perpustakaan |
| | judul_buku | VARCHAR(146) | NOT NULL | Pengelola Perpustakaan |
| | penulis | VARCHAR(125) | NULL | Pengelola Perpustakaan |
| | penerbit | VARCHAR(100) | NULL | Pengelola Perpustakaan |
| | tahun_terbit | INT(4) | NULL | Pengelola Perpustakaan |
| | stok | INT(9) | NOT NULL, DEFAULT 0 | Pengelola Perpustakaan |
| | id_katagori | INT(7) | FOREIGN KEY (katagori) | Pengelola Perpustakaan |
| **petugas** | id_petugas | INT(8) | PRIMARY KEY, AUTO_INCREMENT | Pengelola Perpustakaan |
| | nama_petugas | VARCHAR(100) | NOT NULL | Pengelola Perpustakaan |
| | username | VARCHAR(58) | NOT NULL, UNIQUE | Pengelola Perpustakaan |
| | password | VARCHAR(210) | NOT NULL | Pengelola Perpustakaan |
| | no_telp_petugas | VARCHAR(12) | NULL | Pengelola Perpustakaan |
| **peminjaman** | id_peminjaman | INT(6) | PRIMARY KEY, AUTO_INCREMENT | Petugas Perpustakaan |
| | kode_peminjaman | VARCHAR(20) | NOT NULL, UNIQUE | Petugas Perpustakaan |
| | id_anggota | INT(10) | FOREIGN KEY (anggota) | Petugas Perpustakaan |
| | id_petugas | INT(8) | FOREIGN KEY (petugas) | Petugas Perpustakaan |
| | tanggal_pinjam | DATE | NOT NULL | Petugas Perpustakaan |
| | tanggal_jatuh_tempo | DATE | NOT NULL | Petugas Perpustakaan |
| | status_pinjam | ENUM('dipinjam','dikembalikan') | NOT NULL, DEFAULT 'dipinjam' | Petugas Perpustakaan |
| **detail_peminjaman** | id_detail_peminjaman | INT(3) | PRIMARY KEY, AUTO_INCREMENT | Petugas Perpustakaan |
| | id_peminjaman | INT(6) | FOREIGN KEY (peminjaman) | Petugas Perpustakaan |
| | id_buku | INT(8) | FOREIGN KEY (buku) | Petugas Perpustakaan |
| | jumlah | INT(9) | NOT NULL | Petugas Perpustakaan |
| **pengembalian** | id_pengembalian | INT(5) | PRIMARY KEY, AUTO_INCREMENT | Petugas Perpustakaan |
| | id_peminjaman | INT(6) | FOREIGN KEY (peminjaman) | Petugas Perpustakaan |
| | id_petugas | INT(8) | FOREIGN KEY (petugas) | Petugas Perpustakaan |
| | tanggal_dikembalikan | DATE | NOT NULL | Petugas Perpustakaan |
| | denda | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Petugas Perpustakaan |
| | status_denda | ENUM('lunas','belum_lunas') | NOT NULL | Petugas Perpustakaan |

## 9. Kebutuhan Non-Fungsional Data

**Volume Data:**
Basis data disiapkan untuk mengelola perkiraan hingga 2.000 anggota aktif, 5.000 entri buku, serta kisaran 50.000 catatan peminjaman per tahun tanpa mengabaikan kecepatan respons kueri.

**Retensi Data:**
Rekam peminjaman dan pengembalian disimpan aktif selama 3 tahun untuk kebutuhan rekap bulanan dan audit denda.

**Keamanan dan Hak Akses:**
- Hak ubah struktur dan data basis data dibatasi khusus pada akun pengembang mhs_033 / dev_033.
- Hak akses pengunjung/publik (tamu_033) hanya diizinkan untuk membaca (SELECT) daftar katalog buku.
- Kolom password pada tabel petugas disimpan dalam bentuk hash, bukan teks biasa.

## 10. Isu Kualitas Data yang Diantisipasi

**Pencegahan Duplikasi Keanggotaan dan Buku:**
Antisipasi: penerapan aturan UNIQUE pada kolom nomor_anggota dan isbn untuk mencegah pencatatan ganda.

**Inkonsistensi Katagori Buku:**
Antisipasi: pemisahan tabel katagori dan penerapan FOREIGN KEY ke tabel buku agar pengelompokan buku selalu konsisten.

**Mencegah Stok Bernilai Negatif:**
Antisipasi: penerapan validasi logika kueri serta penggunaan tipe data integer non-negatif (UNSIGNED) atau batasan CHECK pada kolom stok.

**Penanganan Data Tanpa Induk (Orphan Records):**
Antisipasi: menggunakan pengkodean FOREIGN KEY ... ON DELETE CASCADE ON UPDATE CASCADE pada tabel detail_peminjaman.

**Ketidaksesuaian Status dan Denda:**
Antisipasi: pembatasan nilai status_pinjam dan status_denda dengan tipe ENUM, serta nilai denda yang tidak boleh negatif.

**Struk / Bukti peminjaman buku perpustakaan:**
```

         PERPUSTAKAAN NUSA CENDEKIA 033
          Bukti Transaksi Peminjaman
---------------------------------------
No. Transaksi  : PJ033-0001
Tanggal Pinjam : 18-10-2026
Jatuh Tempo    : 25-10-2026
Nama Anggota   : Agis Sapitri
No. Anggota    : AG033-001
Petugas        : Admin 033

Daftar Buku Dipinjam:
Dasar-Dasar Sistem Informasi        1 Pcs
Jaringan Komputer untuk Pemula      1 Pcs
Statistika Terapan Informatika      1 Pcs
---------------------------------------
Total Jenis Buku               3 Item
Status Peminjaman              Aktif
---------------------------------------
              Terima kasih
```

---

## 11. Bukti Git

- **Link Repositori:** https://github.com/agissapitrr/basisdata_25430033
- **Tangkapan Layar Git Log:**

![Bukti Git Log Modul 2 Nusa Cendekia](<image/git_log_perpus_nusa_cendekiawa.png>)
