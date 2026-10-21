# Normalisasi Proyek Perpustakaan Nusa Cendekia - Pertemuan 04
**Nama:** Agis Sapitri  
**NIM:** 25430033  
**Kelas:** B  
**Proyek Basis Data:** Perpustakaan Nusa Cendekia (`perpus_nusa_cendekia_033` / `perpus_033`)

---

# F. Tugas Mandiri: Milestone Proyek 4

## F1. Dokumen Sumber dan Aturan Bisnis

Dokumen sumber yang saya ambil dari P02 adalah **Slip Peminjaman Buku** (dokumen sumber nomor 2) sebagai titik awal UNF. Slip ini memuat kode peminjaman, identitas anggota, nama petugas, tanggal pinjam, tanggal jatuh tempo, serta daftar buku dan jumlahnya. Data kategori buku saya lengkapi dari **Buku Induk Koleksi** (nomor 3). Bagian pengembalian dinormalisasi terpisah dari **Slip Pengembalian dan Denda** (nomor 4) pada F4.2.

Aturan bisnis yang dipakai (sesuai P02):

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap anggota memiliki nomor anggota yang unik. |
| AB-02 | Setiap buku masuk tepat satu kategori terdaftar. |
| AB-03 | Satu peminjaman dapat memuat beberapa buku sekaligus. |
| AB-04 | Status peminjaman hanya `dipinjam` atau `dikembalikan`. |
| AB-05 | Setiap peminjaman dan pengembalian dicatat oleh seorang petugas; setiap peminjaman dimiliki seorang anggota. |
| AB-06 | Status denda hanya `lunas` atau `belum_lunas`; nilai denda minimal 0. |
| AB-07 | Stok buku tidak boleh negatif. |

## F2. Bentuk UNF

```text
SLIP_PEMINJAMAN_UNF (
    kode_peminjaman, tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam,
    nomor_anggota, nama_anggota, no_hp_anggota,
    username, nama_petugas,
    { isbn, judul_buku, penulis, id_kategori, nama_kategori, jumlah }
)
```

Kelompok `{ ... }` berulang karena satu slip dapat memuat beberapa buku (AB-03). Data berikut hanya ilustrasi:

| kode_peminjaman | tgl_pinjam | jatuh_tempo | status | anggota | petugas | buku yang dipinjam |
|---|---|---|---|---|---|---|
| PMJ-0001 | 2026-10-05 | 2026-10-12 | dikembalikan | AGT-0007 Nur Aisyah | petugas_dina (Dina Marlina) | 978-602-1111-01-0 Pemrograman Web Dasar, K-01 Komputer, 1; 978-602-1111-02-7 Sejarah Nusantara, K-02 Sejarah, 1 |
| PMJ-0002 | 2026-10-08 | 2026-10-15 | dipinjam | AGT-0012 Rizky Pratama | petugas_hadi (Hadi Kusuma) | 978-602-1111-01-0 Pemrograman Web Dasar, K-01 Komputer, 1 |

### Anomali pada Bentuk UNF/1NF
* **Anomali ubah:** nama kategori "Komputer" tertulis di setiap baris buku. Bila diganti menjadi "Teknologi Informasi" dan ada satu baris terlewat, kategori yang sama punya dua nama.
* **Anomali sisip:** kategori baru (misalnya "Sains") atau anggota baru tidak dapat dicatat sebelum ada peminjaman yang memuatnya.
* **Anomali hapus:** bila PMJ-0002 dihapus, seluruh data anggota Rizky Pratama (AGT-0012) ikut hilang karena hanya muncul di slip itu.

## F3. Dependensi Fungsional

Dependensi disusun dari aturan bisnis dan kamus data P02, bukan dari contoh data di atas.

| FD | Dependensi | Dasar |
|---|---|---|
| FD1 | `kode_peminjaman` → `tanggal_pinjam`, `tanggal_jatuh_tempo`, `status_pinjam`, `nomor_anggota`, `username` | AB-04, AB-05 |
| FD2 | `nomor_anggota` → `nama_anggota`, `no_hp_anggota` | AB-01 |
| FD3 | `username` → `nama_petugas` | AB-05 (kamus data: `username` UNIQUE) |
| FD4 | `isbn` → `judul_buku`, `penulis`, `id_kategori` | AB-02 |
| FD5 | `id_kategori` → `nama_kategori` | AB-02 |
| FD6 | (`kode_peminjaman`, `isbn`) → `jumlah` | AB-03 |

Dependensi yang sengaja **tidak** saya tulis: `nama_anggota → apa pun`, karena dua anggota bisa bernama sama, dan `kode_peminjaman → daftar isbn`, karena itu adalah himpunan, bukan satu nilai.

## F4. Tahapan Normalisasi

### F4.1 Slip peminjaman

**1NF.** Satu baris per buku per slip. Kunci primer menjadi komposit (`kode_peminjaman`, `isbn`).

```text
PEMINJAMAN_1NF (kode_peminjaman, isbn, tanggal_pinjam, tanggal_jatuh_tempo,
                status_pinjam, nomor_anggota, nama_anggota, no_hp_anggota,
                username, nama_petugas, judul_buku, penulis,
                id_kategori, nama_kategori, jumlah)
```

| kode_peminjaman | isbn | tgl_pinjam | nomor_anggota | nama_anggota | username | judul_buku | nama_kategori | jumlah |
|---|---|---|---|---|---|---|---|---|
| PMJ-0001 | 978-602-1111-01-0 | 2026-10-05 | AGT-0007 | Nur Aisyah | petugas_dina | Pemrograman Web Dasar | Komputer | 1 |
| PMJ-0001 | 978-602-1111-02-7 | 2026-10-05 | AGT-0007 | Nur Aisyah | petugas_dina | Sejarah Nusantara | Sejarah | 1 |
| PMJ-0002 | 978-602-1111-01-0 | 2026-10-08 | AGT-0012 | Rizky Pratama | petugas_hadi | Pemrograman Web Dasar | Komputer | 1 |

**2NF.** Ketergantungan sebagian pada kunci komposit: FD1, FD2, dan FD3 hanya bergantung pada `kode_peminjaman`, sedangkan FD4 dan FD5 hanya bergantung pada `isbn`. Hanya `jumlah` (FD6) yang bergantung pada seluruh kunci. Hasil pemisahan:

```text
PEMINJAMAN (kode_peminjaman (PK), tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam,
            nomor_anggota, nama_anggota, no_hp_anggota, username, nama_petugas)
BUKU (isbn (PK), judul_buku, penulis, id_kategori, nama_kategori)
DETAIL_PEMINJAMAN (kode_peminjaman (PK, FK), isbn (PK, FK), jumlah)
```

**3NF.** Masih ada tiga rantai transitif:
* `kode_peminjaman → nomor_anggota → nama_anggota, no_hp_anggota` pada PEMINJAMAN.
* `kode_peminjaman → username → nama_petugas` pada PEMINJAMAN.
* `isbn → id_kategori → nama_kategori` pada BUKU.

Ketiganya dipisah menjadi ANGGOTA, PETUGAS, dan KATEGORI. Atribut lain dari kamus data P02 (alamat, tanggal pendaftaran, penerbit, tahun terbit, stok, telepon petugas, dan lainnya) ikut ditempatkan pada entitasnya:

```text
KATEGORI (id_kategori (PK), nama_kategori)
BUKU (isbn (PK), judul_buku, penulis, penerbit, tahun_terbit, stok, id_kategori (FK))
ANGGOTA (nomor_anggota (PK), nama_anggota, alamat_anggota, no_hp_anggota, tanggal_pendaftaran)
PETUGAS (username (PK), nama_petugas, password, no_telp_petugas)
PEMINJAMAN (kode_peminjaman (PK), tanggal_pinjam, tanggal_jatuh_tempo, status_pinjam,
            nomor_anggota (FK), username (FK))
DETAIL_PEMINJAMAN (kode_peminjaman (PK, FK), isbn (PK, FK), jumlah)
```

### F4.2 Slip pengembalian dan denda

Slip ini tidak memiliki kelompok berulang, sehingga sudah 1NF. Isinya per peminjaman: tanggal dikembalikan, petugas penerima, kondisi buku, denda, dan status denda.

```text
PENGEMBALIAN (kode_peminjaman (PK, FK), tanggal_dikembalikan, username_penerima (FK),
              kondisi_buku, denda, status_denda)
```

Kuncinya satu kolom (`kode_peminjaman`), sehingga otomatis 2NF. Tidak ada atribut non-kunci yang menentukan atribut non-kunci lain, sehingga 3NF juga terpenuhi.

Data pengembalian dipisah dari PEMINJAMAN karena hubungannya 1 : 0..1 (AB-04). Selama buku masih dipinjam, kolom `tanggal_dikembalikan`, `denda`, dan lainnya belum punya nilai. Memisahkannya menghindari kolom berisi NULL (alasan yang sama dengan keputusan tinjauan P03).

Data ilustrasi PMJ-0001 yang sudah dikembalikan:

| kode_peminjaman | tanggal_dikembalikan | username_penerima | kondisi_buku | denda | status_denda |
|---|---|---|---|---|---|
| PMJ-0001 | 2026-10-15 | petugas_hadi | utuh | 4500.00 | belum_lunas |

### Ringkasan Tahapan

| Tahap | Relasi hasil | Yang dihilangkan |
|---|---|---|
| UNF | SLIP_PEMINJAMAN_UNF | - |
| 1NF | PEMINJAMAN_1NF | Grup berulang buku |
| 2NF | PEMINJAMAN, BUKU, DETAIL_PEMINJAMAN | FD1-FD5 yang hanya bergantung pada sebagian kunci |
| 3NF | KATEGORI, BUKU, ANGGOTA, PETUGAS, PEMINJAMAN, DETAIL_PEMINJAMAN, PENGEMBALIAN | Rantai transitif via `nomor_anggota`, `username`, `id_kategori` |

## F5. Pemeriksaan BCNF dan Kecocokan dengan Kunci P02

P02 memakai kunci pengganti `id_*` sebagai kunci primer. Kunci alami yang saya pakai di atas menjadi kunci unik di rancangan DDL:

| Tabel | Kunci primer (P02) | Kunci kandidat lain | Kunci tamu |
|---|---|---|---|
| `kategori` | `id_kategori` | - | - |
| `buku` | `id_buku` | `isbn` | `id_kategori` |
| `anggota` | `id_anggota` | `nomor_anggota` | - |
| `petugas` | `id_petugas` | `username` | - |
| `peminjaman` | `id_peminjaman` | `kode_peminjaman` | `id_anggota`, `id_petugas` |
| `detail_peminjaman` | `id_detail_peminjaman` | (`id_peminjaman`, `id_buku`) | `id_peminjaman`, `id_buku` |
| `pengembalian` | `id_pengembalian` | `id_peminjaman` | `id_peminjaman`, `id_petugas` |

| Tabel | Penentu pada FD | Kunci kandidat? | Hasil |
|---|---|---|---|
| kategori | `id_kategori` | Ya | BCNF |
| buku | `id_buku`, `isbn` | Ya, keduanya | BCNF |
| anggota | `id_anggota`, `nomor_anggota` | Ya, keduanya (AB-01) | BCNF |
| petugas | `id_petugas`, `username` | Ya, keduanya | BCNF |
| peminjaman | `id_peminjaman`, `kode_peminjaman` | Ya, keduanya | BCNF |
| detail_peminjaman | `id_detail_peminjaman`, (`id_peminjaman`, `id_buku`) | Ya, keduanya | BCNF |
| pengembalian | `id_pengembalian`, `id_peminjaman` | Ya, keduanya | BCNF |

Kunci pengganti tidak menghapus dependensi fungsional, sehingga pemeriksaan tetap dilakukan lewat kunci alami (misalnya `isbn → judul_buku` tetap berlaku dan `isbn` berstatus UNIQUE).

## F6. Keputusan Penyimpanan Nilai Turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| Lama keterlambatan (hari) | **Dihitung, tidak disimpan** | Dapat diturunkan dari `tanggal_dikembalikan` dan `tanggal_jatuh_tempo` (minimal 0). Menyimpannya membuka peluang tidak konsisten dengan kedua tanggal itu. Sesuai catatan desain P03. |
| `denda` | **Disimpan** (`DECIMAL(10,2)`, default 0) | Tarif denda dapat berubah sewaktu-waktu. Nominal pada saat pengembalian harus tetap tercatat agar laporan denda lama tidak berubah (AB-06). |
| `status_denda` | **Disimpan** | Berubah setelah transaksi (dari `belum_lunas` menjadi `lunas`), sehingga bukan hasil hitung dari kolom lain (AB-06). |
| `status_pinjam` | **Disimpan** | Sebenarnya sejalan dengan ada tidaknya baris `pengembalian`, tetapi AB-04 menetapkannya sebagai kolom, dan kueri daftar peminjaman aktif menjadi lebih sederhana. Konsekuensinya ada redundansi, sehingga status harus diubah bersamaan dengan pencatatan pengembalian dalam satu transaksi. |
| `stok` | **Disimpan** | Berubah setiap peminjaman dan pengembalian, dan tidak dapat diturunkan karena penerimaan buku baru tidak dicatat di model ini. Tidak boleh negatif (AB-07). |
| `jumlah` | **Disimpan** | Kuantitas yang dicatat saat transaksi, bukan hasil hitung. |
| Total buku dipinjam, jumlah transaksi, rekap denda, buku terpopuler | **Dihitung saat dibutuhkan** | Dapat diperoleh dari `detail_peminjaman`, `peminjaman`, dan `pengembalian`; tidak perlu disimpan berulang. |

## F7. Evaluasi dan Perubahan ERD Proyek

Perubahan dibandingkan dengan kamus data P02 dan ERD P03:

| No. | Lokasi di ERD | Perubahan | Alasan |
|---|---|---|---|
| 1 | `pengembalian` | Menambahkan atribut `kondisi_buku` (utuh, rusak, atau hilang). | Hasil tinjauan sejawat P03; belum ada di kamus data P02 sehingga perlu dimasukkan sebelum DDL. |
| 2 | `pengembalian` | Lama keterlambatan tidak digambar sebagai atribut tersimpan; ditandai sebagai atribut turunan pada legenda. | Keputusan F6, sesuai catatan desain P03. |
| 3 | `kategori` | Nama entitas ditulis `kategori`, bukan `katagori` seperti di P02. | Menyamakan dengan ERD P03. |
| 4 | `detail_peminjaman` | `id_detail_peminjaman` tetap sebagai kunci primer, dengan (`id_peminjaman`, `id_buku`) sebagai kunci unik. | Mencegah buku yang sama tercatat dua kali dalam satu peminjaman; kuantitas ditampung di `jumlah`. |

Catatan: `kondisi_buku` melekat pada satu pengembalian secara keseluruhan. Bila satu peminjaman memuat beberapa buku dengan kondisi berbeda, atribut itu sebaiknya dipindah ke `detail_peminjaman`. Untuk saat ini saya mempertahankannya di `pengembalian` sesuai keputusan P03.
