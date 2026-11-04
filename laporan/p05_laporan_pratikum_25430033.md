# LAPORAN PRAKTIKUM BASIS DATA PERTEMUAN 5 Membangun Struktur Dengan Ddl Dan Constraint
**Nama:** Agis Sapitri  
**NIM:** 25430033  
**Kelas:** B  
**Tanggal:** 20 Oktober 2026  
**Proyek Basis Data:** Perpustakaan Nusa Cendekia (perpus_nusa_cendekia_033 / perpus_033)

---

# 1. Tujuan Praktikum

Pada pertemuan 05, saya membangun struktur basis data perpustakaan nusa cendekia di mariadb berdasarkan skema relasional dan erd yang telah dirancang pada pertemuan sebelumnya. tujuan praktikum ini adalah:

- menerjemahkan skema relasional menjadi perintah create table dengan tipe data yang sesuai.

- menerapkan primary key, foreign key, unique, not null, default, dan check sesuai aturan data perpustakaan.

- mengubah dan menghapus struktur menggunakan alter table dan drop table dengan urutan yang benar.

- menguji constraint agar data yang tidak sesuai aturan ditolak oleh mariadb.

- membandingkan struktur tabel hasil ddl dengan erd fisik proyek.

# 2. Ringkasan Dasar Teori

DDL (Data Definition Language) adalah bagian sql untuk membuat, mengubah, dan menghapus struktur basis data, misalnya melalui create database, create table, alter table, dan drop table. tipe data dipilih berdasarkan bentuk nilai: varchar untuk kode atau teks, date untuk tanggal, int untuk bilangan bulat, dan decimal untuk nilai uang agar presisinya terjaga.

constraint merupakan aturan yang dijaga langsung oleh server. primary key mengidentifikasi setiap baris, foreign key menjaga hubungan antartabel, unique mencegah nilai kembar, not null mewajibkan nilai, default memberi nilai awal, dan check membatasi nilai berdasarkan kondisi. tabel induk dibuat sebelum tabel anak; saat penghapusan, tabel anak dihapus lebih dahulu.

# 3. Hasil Langkah Percobaan

## 3.1 Membuat database dan menyiapkan skrip

saya menggunakan database perpus_nusa_cendekia_033. skrip diawali dengan create database if not exists dan use agar perintah berikutnya dijalankan pada database proyek. skrip juga menghapus tabel lama dari tabel anak ke tabel induk agar dapat dijalankan ulang.

> CREATE DATABASE IF NOT EXISTS perpus_nusa_cendekia_033  
> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;  
> USE perpus_nusa_cendekia_033;  
>   
> SET FOREIGN_KEY_CHECKS = 0;  
> DROP TABLE IF EXISTS pengembalian;  
> DROP TABLE IF EXISTS detail_peminjaman;  
> DROP TABLE IF EXISTS peminjaman;  
> DROP TABLE IF EXISTS buku;  
> DROP TABLE IF EXISTS petugas;  
> DROP TABLE IF EXISTS anggota;  
> DROP TABLE IF EXISTS katagori;  
> SET FOREIGN_KEY_CHECKS = 1;

## 3.2 Membuat tujuh tabel proyek

Berdasarkan file p05_ddl_25430033.sql, basis data proyek memiliki tujuh tabel berikut.

| **Tabel**         | **Fungsi**                                                                           |
|-------------------|--------------------------------------------------------------------------------------|
| anggota           | Menyimpan nomor, nama, alamat, nomor HP, dan tanggal pendaftaran anggota.            |
| katagori          | Menyimpan daftar kategori buku.                                                      |
| petugas           | Menyimpan identitas petugas, username, password hash, dan nomor telepon.             |
| buku              | Menyimpan ISBN, judul, penulis, penerbit, tahun terbit, stok, dan kategori.          |
| peminjaman        | Menyimpan kode transaksi, anggota, petugas, tanggal pinjam, jatuh tempo, dan status. |
| detail_peminjaman | Menyimpan buku dan jumlah eksemplar pada setiap transaksi peminjaman.                |
| pengembalian      | Menyimpan tanggal kembali, petugas, denda, dan status denda.                         |

Urutan pembuatan dimulai dari tabel master (anggota, katagori, petugas), dilanjutkan buku, peminjaman, detail_peminjaman, dan pengembalian. Urutan ini memastikan tabel induk sudah tersedia ketika foreign key dibuat.

![Table Perpustakaan Nusa Cendekia](<image/p05_tabel.png>)

> **[MASUKKAN FOTO 1: HASIL SHOW TABLES]**
>
> *Masukkan satu screenshot phpMyAdmin yang memperlihatkan database perpus_nusa_cendekia_033 dan seluruh tujuh tabel setelah skrip dijalankan.*

## 3.3 Penerapan tipe data dan constraint

| **Kolom / atribut**                            | **Tipe data / constraint**  | **Alasan**                                                    |
|------------------------------------------------|-----------------------------|---------------------------------------------------------------|
| id\_\*                                         | INT UNSIGNED AUTO_INCREMENT | ID otomatis, bilangan bulat tidak negatif.                    |
| nomor_anggota, ISBN, kode_peminjaman, username | VARCHAR + UNIQUE            | Kode teks; tidak digunakan untuk perhitungan dan harus unik.  |
| nama, judul, penulis, penerbit                 | VARCHAR                     | Menyimpan teks dengan panjang bervariasi.                     |
| alamat_anggota                                 | TEXT NULL                   | Alamat dapat memiliki panjang bervariasi dan boleh kosong.    |
| no_hp_anggota, no_telp_petugas                 | VARCHAR(12) NULL            | Nomor telepon adalah teks agar angka 0 di depan tidak hilang. |
| tanggal\_\*                                    | DATE                        | Menyimpan tanggal tanpa jam.                                  |
| tahun_terbit                                   | SMALLINT UNSIGNED           | Menyimpan tahun terbit sebagai bilangan bulat nonnegatif.     |
| stok, jumlah                                   | INT / INT UNSIGNED          | Menyimpan jumlah buku dan kuantitas.                          |
| denda                                          | DECIMAL(10,2)               | Menyimpan nilai uang dengan dua angka desimal.                |
| status_pinjam, status_denda                    | ENUM + DEFAULT              | Membatasi status pada pilihan yang telah ditentukan.          |

constraint yang terdapat pada ddl antara lain primary key di seluruh tabel; unique untuk nomor anggota, isbn, username, kode peminjaman, nama kategori, dan id_peminjaman pada pengembalian; foreign key untuk semua relasi; check stok \>= 0, jumlah \> 0, tanggal jatuh tempo tidak sebelum tanggal pinjam, dan denda \>= 0; serta default untuk stok, status peminjaman, denda, dan status denda.

> **[MASUKKAN FOTO 2: SHOW CREATE TABLE]**
>
> *Masukkan satu screenshot yang paling jelas dari SHOW CREATE TABLE peminjaman atau detail_peminjaman. Pastikan terlihat PRIMARY KEY, UNIQUE, CHECK, dan FOREIGN KEY.*

## 3.4 Pengujian constraint

Pengujian dilakukan dengan memasukkan atau mengubah nilai yang melanggar aturan. Berdasarkan skrip, pengujian yang perlu dilakukan adalah:

> -- Uji FOREIGN KEY: gunakan id_petugas yang tidak tersedia  
> INSERT INTO peminjaman  
> (kode_peminjaman,id_anggota,id_petugas,tanggal_pinjam,tanggal_jatuh_tempo)  
> VALUES ('PMJ-UJI-99',1,999999,'2026-11-01','2026-11-08');  
>   
> -- Uji CHECK stok: nilai stok negatif harus ditolak  
> UPDATE buku SET stok = -1 WHERE id_buku = 1;  
>   
> -- Uji UNIQUE ISBN: ISBN yang sama harus ditolak  
> INSERT INTO buku (isbn,judul_buku,stok,id_katagori)  
> VALUES ('ISBN-YANG-SUDAH-ADA','Buku Duplikat',1,1);

hasil yang diharapkan: foreign key menolak id petugas yang tidak ditemukan; check menolak stok negatif; unique menolak isbn duplikat. kode galat yang lazim muncul adalah 1452 untuk foreign key, 4025 untuk check, dan 1062 untuk unique. catat kode galat yang benar-benar tampil pada komputer saat praktikum.

> **[MASUKKAN FOTO 3: HASIL UJI CONSTRAINT]**
>
> *Satu screenshot hasil uji yang memperlihatkan pesan galat constraint. Jika semua pengujian tidak muat dalam satu layar, pilih bukti yang paling jelas; hasil uji lain dapat dijelaskan dalam teks.*

## 3.5 ERD fisik proyek

erd fisik menggambarkan tabel, atribut, tipe data, primary key, foreign key, dan constraint. gambar erd proyek yang dikirim disertakan di bawah ini sebagai rancangan yang dibandingkan dengan skrip ddl.

![ERD fisik Perpustakaan Nusa Cendekia](img/p05_erd_fisik_25430033.png)

*Gambar 3.1 ERD fisik Perpustakaan Nusa Cendekia dari pengguna.*

catatan pemeriksaan: nama tabel kategori pada gambar harus disamakan dengan ddl. file sql menggunakan nama tabel katagori dan kolom id_katagori. jika erd menulis kategori/id_kategori, ubah salah satunya agar konsisten. periksa juga bahwa tipe data, null/not null, default, enum, check, dan aksi on delete pada gambar sama dengan definisi sql.

# 4. Jawaban Titik Analisis

## Titik Analisis 1 – Alasan ON DELETE CASCADE dan RESTRICT

Pada relasi detail_peminjaman ke peminjaman digunakan ON DELETE CASCADE karena detail buku merupakan bagian dari satu transaksi peminjaman. Jika transaksi induk dihapus, baris detailnya tidak lagi memiliki arti sehingga dapat ikut dihapus. Sebaliknya, relasi detail_peminjaman ke buku menggunakan ON DELETE RESTRICT agar buku yang sudah tercatat dalam transaksi tidak dapat dihapus sembarangan. Penghapusan buku dapat merusak riwayat peminjaman dan laporan.

## Titik Analisis 2 – Pemetaan kode galat constraint

| **Kode galat** | **Penyebab**                                            | **Constraint / aturan**                                 |
|----------------|---------------------------------------------------------|---------------------------------------------------------|
| 1452           | Memasukkan peminjaman dengan id_petugas yang tidak ada. | FOREIGN KEY: transaksi wajib merujuk petugas terdaftar. |
| 4025           | Mengubah stok buku menjadi -1.                          | CHECK ck_buku_stok: stok tidak boleh negatif.           |
| 1062           | Memasukkan ISBN yang sudah digunakan.                   | UNIQUE uq_buku_isbn: ISBN harus unik.                   |

Aturan yang tidak dapat dijaga hanya dengan constraint sederhana adalah aturan yang membutuhkan pemeriksaan banyak baris atau proses lintas tabel. Contohnya memastikan satu transaksi memiliki setidaknya satu detail buku dan memastikan stok otomatis berkurang ketika peminjaman terjadi. Aturan seperti itu membutuhkan logika transaksi atau mekanisme tambahan.

## Titik Analisis 3 – Urutan DROP TABLE

Tabel anak harus dihapus sebelum tabel induk karena foreign key pada tabel anak masih merujuk tabel induk. Jika tabel induk dihapus lebih dahulu ketika masih direferensikan, MariaDB dapat menolak penghapusan dengan galat terkait foreign key. Oleh sebab itu urutan penghapusan dimulai dari pengembalian dan detail_peminjaman, dilanjutkan peminjaman, buku, petugas, anggota, dan katagori sesuai hubungan pada skema.

# 5. Hasil Latihan dan Modifikasi

Latihan pada bagian E di buku modul 5 menggunakan skema kopma. laporan ini berfokus pada proyek perpustakaan nusa cendekia, sehingga latihan diterapkan pada aturan yang relevan dengan skema perpustakaan, bukan mencampur tabel kopma ke dalam database perpustakaan.

## 5.1 CHECK untuk jumlah buku

ddl yang dikirim sudah memiliki check jumlah \> 0. namun, nim 25430033 menghasilkan parameter p = (33 mod 9) + 1 = 7, sehingga batas p + 2 adalah 9. jika aturan modul diterapkan pada jumlah eksemplar per judul dalam satu transaksi, constraint sebaiknya diperbarui menjadi:

> CONSTRAINT ck_detail_peminjaman_jumlah  
> CHECK (jumlah BETWEEN 1 AND 9)

Perubahan ini harus diterapkan pada file sql dengan mengganti check jumlah \> 0. Catatan: batas jumlah baris judul berbeda dalam satu peminjaman tidak dapat dijaga oleh check karena membutuhkan hitungan beberapa baris; aturan tersebut dicatat untuk ditangani dengan transaksi atau mekanisme lain pada modul lanjutan.

## 5.2 Aturan penghapusan anggota dan riwayat

Pada proyek perpustakaan, peminjaman merujuk anggota dengan ON DELETE RESTRICT. Pilihan ini menjaga riwayat transaksi tetap utuh. Berbeda dengan contoh kopma yang memperbolehkan anggota dihapus dan id_anggota pada nota menjadi null, data anggota perpustakaan yang sudah mempunyai riwayat peminjaman sebaiknya tidak dihapus langsung. Jika keanggotaan berakhir, pendekatan yang lebih aman adalah menambahkan status keanggotaan/nonaktif pada rancangan berikutnya.

# 6. Tugas Mandiri: Milestone Proyek 5

Milestone proyek pada pertemuan ini adalah membangun seluruh tabel perpustakaan nusa cendekia dengan ddl yang dapat dijalankan ulang, memastikan setiap relasi erd diterapkan sebagai foreign key, dan mendokumentasikan erd fisik.

## 6.1 Pemetaan aturan bisnis ke constraint

| **Aturan proyek**                                                             | **Penerapan pada DDL**                                        | **Keterangan**                                                                         |
|-------------------------------------------------------------------------------|---------------------------------------------------------------|----------------------------------------------------------------------------------------|
| AB-01 Nomor anggota wajib dan unik.                                           | nomor_anggota NOT NULL + uq_anggota_nomor                     | Dijaga constraint.                                                                     |
| AB-02 Buku harus terhubung dengan kategori terdaftar.                         | fk_buku_katagori                                              | Dijaga foreign key.                                                                    |
| AB-03 Satu transaksi dapat memiliki beberapa detail buku.                     | fk_detail_peminjaman_peminjaman dan fk_detail_peminjaman_buku | Relasi kepala-detail dibentuk dengan foreign key.                                      |
| AB-04 Status peminjaman hanya dipinjam/dikembalikan.                          | ENUM status_pinjam + DEFAULT 'dipinjam'                       | Dijaga tipe ENUM.                                                                      |
| AB-05 Peminjaman wajib memiliki anggota dan petugas terdaftar.                | fk_peminjaman_anggota dan fk_peminjaman_petugas               | Dijaga foreign key dan NOT NULL.                                                       |
| AB-06 Pengembalian dicatat sekali untuk satu peminjaman; denda tidak negatif. | uq_pengembalian_peminjaman dan ck_pengembalian_denda          | Dijaga UNIQUE dan CHECK.                                                               |
| AB-07 Stok buku tidak boleh negatif.                                          | ck_buku_stok                                                  | Dijaga CHECK.                                                                          |
| AB-08 Jumlah eksemplar per judul maksimal P+2 = 9.                            | Perlu ubah CHECK menjadi BETWEEN 1 AND 9.                     | Belum ada batas atas pada DDL yang dikirim; wajib diperbaiki jika aturan P diterapkan. |

## 6.2 Pemetaan tipe data

tipe data pada ddl dipilih berdasarkan fungsi atribut. int unsigned auto_increment digunakan untuk id; varchar digunakan untuk kode, nama, isbn, dan nomor telepon; text untuk alamat; date untuk tanggal; smallint unsigned untuk tahun terbit; decimal(10,2) untuk denda; dan enum untuk status transaksi. password disimpan pada kolom varchar(210) sebagai hash, bukan teks biasa.

## 6.3 Relasi dan aksi foreign key

| **Relasi**                                                 | **Aksi ON DELETE** | **Alasan**                                              |
|------------------------------------------------------------|--------------------|---------------------------------------------------------|
| buku.id_katagori → katagori.id_katagori                    | RESTRICT           | Kategori yang masih digunakan buku tidak boleh dihapus. |
| peminjaman.id_anggota → anggota.id_anggota                 | RESTRICT           | Menjaga riwayat transaksi anggota.                      |
| peminjaman.id_petugas → petugas.id_petugas                 | RESTRICT           | Menjaga riwayat petugas yang mencatat transaksi.        |
| detail_peminjaman.id_peminjaman → peminjaman.id_peminjaman | CASCADE            | Detail ikut terhapus jika transaksi induk dihapus.      |
| detail_peminjaman.id_buku → buku.id_buku                   | RESTRICT           | Buku yang tercatat pada detail transaksi tidak dihapus. |
| pengembalian.id_peminjaman → peminjaman.id_peminjaman      | RESTRICT           | Riwayat pengembalian tetap terkait transaksi.           |
| pengembalian.id_petugas → petugas.id_petugas               | RESTRICT           | Petugas yang memproses pengembalian tetap tercatat.     |

## 6.4 Pemeriksaan yang perlu dilakukan

- Jalankan p05_ddl_25430033.sql dari database kosong dan pastikan tujuh tabel berhasil dibuat.

- Jalankan SHOW TABLES dan SHOW CREATE TABLE pada tabel utama.

- Uji minimal satu kasus FOREIGN KEY, satu UNIQUE, dan satu CHECK; catat pesan galat yang benar-benar muncul.

- Perbaiki batas jumlah menjadi 1 sampai 9 jika aturan parameter P + 2 diterapkan.

- Samakan nama katagori/id_katagori pada ERD dan DDL.

- Ekspor ERD fisik final sebagai PNG dan simpan juga file sumber draw.io.

# 7. Pembahasan dan Kendala

Hasil ddl menunjukkan bahwa struktur proyek terdiri atas tujuh tabel yang saling terhubung. primary key menjadi identitas setiap tabel, sedangkan foreign key menjaga konsistensi relasi antara buku dan kategori, peminjaman dan anggota/petugas, detail peminjaman dan buku/transaksi, serta pengembalian dan transaksi/petugas.

hal yang perlu diperbaiki sebelum pengumpulan adalah konsistensi ejaan tabel kategori. skrip sql yang dikirim menggunakan katagori dan id_katagori, sehingga erd harus menggunakan nama yang sama atau skrip diubah secara menyeluruh. selain itu, check jumlah pada skrip saat ini baru memastikan jumlah lebih dari nol. karena parameter p untuk nim 25430033 adalah 7, batas p+2 menjadi 9; bila aturan tersebut berlaku untuk jumlah eksemplar per judul, check perlu diubah menjadi between 1 and 9.

Bukti hasil eksekusi dan pengujian belum dapat dianggap tersedia hanya dari skrip. Screenshot pada laporan harus diambil dari phpMyAdmin setelah perintah benar-benar dijalankan. Jangan mengisi bagian hasil dengan gambar simulasi atau pesan galat yang belum muncul pada komputer.

# 8. Kesimpulan

Praktikum Modul 5 menerapkan DDL untuk membangun struktur basis data Perpustakaan Nusa Cendekia. Database dirancang dengan tujuh tabel, primary key, foreign key, unique key, serta constraint validasi yang sesuai dengan kebutuhan pengelolaan perpustakaan. Pengujian constraint diperlukan untuk membuktikan bahwa server menolak data yang tidak valid. Sebelum pengumpulan, ERD dan DDL harus diselaraskan, terutama pada nama tabel kategori dan penerapan batas jumlah berdasarkan parameter P.

# 9. Pernyataan Penggunaan AI

Saya menggunakan bantuan AI untuk memahami materi Modul 5, menyusun kerangka laporan, menjelaskan fungsi tipe data dan constraint, serta memeriksa kesesuaian ERD dengan skrip DDL proyek. Struktur SQL, hasil eksekusi, screenshot, dan pembahasan akhir tetap harus saya periksa dan verifikasi sendiri. Saya bertanggung jawab atas kebenaran isi laporan dan hasil praktikum.

# 10. Bukti Git

Repositori: <https://github.com/agissapitri409-cloud/basisdata_25430033>

Berkas DDL: p05_ddl_25430033.sql

Berkas laporan yang disarankan: laporan/p05_laporan_25430033.md
