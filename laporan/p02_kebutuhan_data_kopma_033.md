# Laporan Praktikum Basis Data - Pertemuan 2: Dokumen Kebutuhan Data

**Nama:** Agis Sapitri  
**NPM:** 25430033  
**Kelas:** B  
**Tanggal:** 7 Oktober 2026  
**Proyek Basis Data:** Koperasi Mahasiswa Nusa Cendekia (`kopma_nusa_cendekia_033` / `kopma_033`)  

---

## 1. Latar Belakang dan Aktivitas Organisasi
Koperasi Mahasiswa (Kopma) Nusa Cendekia merupakan unit kegiatan usaha mahasiswa yang bergerak dalam penyediaan produk kebutuhan harian, pengelolaan keanggotaan, serta pencatatan transaksi belanja inventaris. Seiring berjalannya operasional, pencatatan transaksi harian yang masih berbasis dokumen kertas berisiko menyebabkan selisih perhitungan stok, keterlambatan pencatatan penjualan, serta kendala dalam mengkalkulasi Sisa Hasil Usaha (SHU) anggota secara presisi.

Guna mengatasi tantangan operasional tersebut, dirancang sistem basis data relasional **`kopma_nusa_cendekia_033`** (disingkat `kopma_033`). Pembuatan sistem basis data ini bertujuan untuk menghadirkan media penyimpanan yang aman, terintegrasi, serta mampu mendukung otomatisasi layanan toko dan transparansi laporan keuangan di Kopma Nusa Cendekia.

---

## 2. Aktor dan Proses Bisnis

### A. Tabel Aktor Sistem
| ID Aktor | Nama Aktor | Peran dan Tanggung Jawab |
| :--- | :--- | :--- |
| **AKT-01** | Kasir / Staf Toko | Melayani transaksi penjualan harian, menginput barang belanjaan, dan memproses bukti pembayaran. |
| **AKT-02** | Anggota Kopma | Melakukan transaksi pembelian barang toko serta menerima hak distribusi Sisa Hasil Usaha (SHU). |
| **AKT-03** | Pengurus Kopma | Mengelola inventaris ketersediaan barang, pembaruan data keanggotaan, serta meninjau laporan keuangan. |

![Tabel Aktor Sistem](img/p2.png)

### B. Tabel Proses Bisnis (PB-xx)
| Kode PB | Nama Proses Bisnis | Deskripsi Ringkas | Aktor Terlibat |
| :--- | :--- | :--- | :--- |
| **PB-01** | Registrasi Anggota | Menginput identitas mahasiswa ke dalam sistem untuk aktivasi status anggota resmi Kopma. | AKT-02, AKT-03 |
| **PB-02** | Pengelolaan Inventaris Produk | Memperbarui katalog barang mencakup penambahan produk baru, pembaruan harga, dan penyesuaian stok. | AKT-03 |
| **PB-03** | Transaksi Penjualan | Mencatat barang yang dibeli oleh pelanggan/anggota serta mengurangi jumlah stok barang secara otomatis. | AKT-01, AKT-02 |
| **PB-04** | Pelaporan Rekapitulasi Keuangan | Mengompilasi rekap harian penjualan dan menghitung alokasi SHU berkala bagi pengurus. | AKT-03 |

---

## 3. Dokumen Sumber yang Dianalisis
1. **Formulir Pendaftaran Keanggotaan Kopma:** Lembar pendataan fisik yang memuat identitas mahasiswa (NPM), nama lengkap, email, nomor telepon, dan status keanggotaan.
2. **Nota / Struk Transaksi Penjualan:** Bukti pembayaran belanja mencantumkan kode transaksi, waktu transaksi, ID kasir, rincian barang, kuantitas, dan total nominal.
3. **Buku Induk Inventaris Barang:** Catatan rekap persediaan produk yang memuat kode produk, nama barang, kategori, harga pokok, harga jual, dan jumlah stok tersisa.

---

## 4. Entitas Kandidat dan Elemen Data

1. **Anggota (`anggota`)**
   * Elemen Data: `id_anggota` (PK), `npm`, `nama_lengkap`, `email`, `nomor_telepon`, `tanggal_daftar`.
2. **Kategori (`kategori`)**
   * Elemen Data: `id_kategori` (PK), `nama_kategori`.
3. **Produk (`produk`)**
   * Elemen Data: `id_produk` (PK), `kode_produk`, `nama_produk`, `harga`, `stok`, `id_kategori` (FK).
4. **Penjualan (`penjualan`)**
   * Elemen Data: `id_penjualan` (PK), `id_anggota` (FK), `tanggal_transaksi`, `total_bayar`, `metode_pembayaran`.
5. **Detail Penjualan (`detail_penjualan`)**
   * Elemen Data: `id_detail` (PK), `id_penjualan` (FK), `id_produk` (FK), `jumlah`, `subtotal`.

---

## 5. Aturan Bisnis (Tabel AB-xx)

| Kode AB | Pernyataan Aturan Bisnis | Implikasi Pada Basis Data |
| :--- | :--- | :--- |
| **AB-01** | Setiap anggota Kopma wajib memiliki nomor identitas mahasiswa (NPM) dan email yang terdaftar secara unik. | Kolom `npm` dan `email` dikonfigurasi dengan batasan `UNIQUE` dan `NOT NULL`. |
| **AB-02** | Setiap jenis barang/produk wajib terkelompokkan ke dalam satu kategori terdaftar. | Kolom `id_kategori` pada tabel `produk` diset sebagai *Foreign Key* merujuk ke tabel `kategori`. |
| **AB-03** | Satu transaksi transaksi penjualan dapat mencakup beberapa item produk sekaligus. | Dibuat tabel perantara *many-to-many* (`detail_peminjaman`/`detail_penjualan`) untuk menghubungkan tabel `penjualan` dan `produk`. |
| **AB-04** | Metode pembayaran transaksi dibatasi pada pilihan: 'tunai', 'qris', atau 'transfer'. | Kolom `metode_pembayaran` dikunci menggunakan tipe data `ENUM('tunai', 'qris', 'transfer')`. |
| **AB-05** | Stok barang tidak boleh bernilai negatif dan harga produk diset minimal bernilai 0. | Kolom `stok` dan `harga` dikonfigurasi `NOT NULL` dengan nilai *default* 0. |

---

## 6. Kebutuhan Informasi (Tabel KI-xx)

| Kode KI | Kebutuhan Informasi | Sumber Data (Tabel) |
| :--- | :--- | :--- |
| **KI-01** | Data seluruh anggota aktif Kopma sebagai acuan perhitungan dan pembagian SHU. | `anggota` |
| **KI-02** | Informasi ketersediaan stok barang beserta rincian harga jual berdasarkan kategori. | `produk`, `kategori` |
| **KI-03** | Rekap harian nilai transaksi penjualan berdasarkan pilihan metode pembayaran. | `penjualan` |
| **KI-04** | Laporan daftar produk terlaris berdasarkan total kuantitas item terjuall. | `detail_penjualan`, `produk` |

---

## 7. Matriks CRUD

| Entitas / Tabel | PB-01 (Registrasi) | PB-02 (Produk) | PB-03 (Penjualan) | PB-04 (Pelaporan) |
| :--- | :---: | :---: | :---: | :---: |
| **`anggota`** | **C, R, U** | - | **R** | **R** |
| **`kategori`** | - | **C, R, U, D** | **R** | **R** |
| **`produk`** | - | **C, R, U, D** | **R, U** | **R** |
| **`penjualan`** | - | - | **C, R** | **R** |
| **`detail_penjualan`** | - | - | **C, R** | **R** |

*(Keterangan: **C** = Create, **R** = Read, **U** = Update, **D** = Delete)*

---

## 8. Kamus Data Awal

| Nama Tabel | Nama Kolom | Tipe Data | Batasan / Constraint | Penanggung Jawab Data |
| :--- | :--- | :--- | :--- | :--- |
| **`anggota`** | `id_anggota` | INT | PRIMARY KEY, AUTO_INCREMENT | Pengurus Kopma |
| | `npm` | VARCHAR(20) | NOT NULL, UNIQUE | Pengurus Kopma |
| | `nama_lengkap` | VARCHAR(100) | NOT NULL | Pengurus Kopma |
| | `email` | VARCHAR(100) | NOT NULL, UNIQUE | Pengurus Kopma |
| | `nomor_telepon` | VARCHAR(15) | NULL | Pengurus Kopma |
| | `tanggal_daftar` | DATE | DEFAULT CURRENT_DATE | Pengurus Kopma |
| **`kategori`** | `id_kategori` | INT | PRIMARY KEY, AUTO_INCREMENT | Staf Inventaris |
| | `nama_kategori` | VARCHAR(50) | NOT NULL, UNIQUE | Staf Inventaris |
| **`produk`** | `id_produk` | INT | PRIMARY KEY, AUTO_INCREMENT | Staf Inventaris |
| | `kode_produk` | VARCHAR(20) | NOT NULL, UNIQUE | Staf Inventaris |
| | `nama_produk` | VARCHAR(100) | NOT NULL | Staf Inventaris |
| | `harga` | DECIMAL(10,2) | NOT NULL, DEFAULT 0 | Staf Inventaris |
| | `stok` | INT | NOT NULL, DEFAULT 0 | Staf Inventaris |
| | `id_kategori` | INT | FOREIGN KEY (`kategori`) | Staf Inventaris |
| **`penjualan`** | `id_penjualan` | INT | PRIMARY KEY, AUTO_INCREMENT | Kasir |
| | `id_anggota` | INT | FOREIGN KEY (`anggota`), NULL | Kasir |
| | `tanggal_transaksi`| DATETIME | DEFAULT CURRENT_TIMESTAMP | Kasir |
| | `total_bayar` | DECIMAL(10,2) | NOT NULL | Kasir |
| | `metode_pembayaran`| ENUM | DEFAULT 'tunai' | Kasir |

---

## 9. Kebutuhan Non-Fungsional Data

1. **Volume Data:**
   * Basis data disiapkan untuk mengelola perkiraan hingga **2.000 anggota aktif**, **5.000 entri produk**, serta kisaran **50.000 log transaksi penjualan** per tahun tanpa mengabaikan kecepatan respons kueri.
2. **Retensi Data:**
   * Rekam transaksi penjualan disimpan aktif selama **3 tahun** untuk kebutuhan pembukuan keuangan bulanan serta audit pembagian SHU.
3. **Keamanan dan Hak Akses:**
   * Hak ubah struktur dan data basis data dibatasi khusus pada akun pengembang `mhs_033` / `dev_033`.
   * Hak akses pengunjung/publik (`tamu_033`) hanya diizinkan untuk membaca (`SELECT`) daftar katalog produk.

---

## 10. Isu Kualitas Data yang Diantisipasi

1. **Pencegahan Duplikasi Keanggotaan:**
   * *Antisipasi:* Penerapan aturan `UNIQUE` pada kolom `npm` dan `email` untuk mencegah pencatatan ulang anggota yang sama.
2. **Inkonsistensi Kategori Produk:**
   * *Antisipasi:* Pemisahan tabel `kategori` dan penerapan relasi `FOREIGN KEY` ke tabel `produk` agar pengelompokan barang selalu konsisten.
3. **Mencegah Stok Bernilai Negatif:**
   * *Antisipasi:* Penerapan validasi logika kueri serta penggunaan tipe data integer non-negatif (`UNSIGNED`) atau batasan `CHECK`.
4. **Penanganan Data Tanpa Induk (*Orphan Records*):**
   * *Antisipasi:* Menggunakan pengkodean `FOREIGN KEY ... ON DELETE CASCADE ON UPDATE CASCADE` pada tabel `detail_penjualan`.

---

## 11. Bukti Git

- **Link Repositori:** https://github.com/agissapitrr/basisdata_25430033
- **Tangkapan Layar Git Log:**

![Bukti Git Log Modul 2](<image/tangkapan_layar_git_log_kopma_033.png>)