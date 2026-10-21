# Normalisasi Kopma - Pertemuan 04
**Nama:** Agis Sapitri  
**NIM:** 25430033  
**Kelas:** B  

---

# D. Langkah Percobaan

## D.1 Dari UNF ke 1NF

### Relasi spreadsheet lama (UNF)

Satu nota di spreadsheet lama menyimpan grup berulang barang. Grup itu saya tandai dengan `{ }`:

```text
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

Data berikut hanya ilustrasi, dibuat untuk mempraktikkan langkah normalisasi:

| no_nota | tgl | petugas | anggota | barang di nota (kode, nama, qty x harga = subtotal) | jumlah | diskon | total |
|---|---|---|---|---|---|---|---|
| PJ-2610-0001 | 2026-10-01 | P01 Maya Sari | A001 Dewi Lestari | B01 Pulpen Gel 0.5, 2 x 4000 = 8000; B02 Buku Tulis, 1 x 5000 = 5000 | 13000 | 650 | 12350 |
| PJ-2610-0002 | 2026-10-02 | P02 Rudi Hartono | (tanpa anggota) | B01 Pulpen Gel 0.5, 1 x 4500 = 4500 | 4500 | 0 | 4500 |
| PJ-2610-0003 | 2026-10-05 | P01 Maya Sari | A001 Dewi Lestari | B03 Air Mineral, 3 x 3000 = 9000 | 9000 | 450 | 8550 |

Harga Pulpen Gel berbeda pada dua nota (4000 dan 4500). Ini disengaja karena harga di nota dapat berbeda dari harga barang saat ini (AB-04).

### Anomali pada data yang belum dinormalisasi

* **Anomali ubah:** nama "Dewi Lestari" tertulis di semua baris nota milik A001. Jika ejaannya dikoreksi di satu baris saja, anggota yang sama punya dua nama.
* **Anomali sisip:** barang baru (misalnya Penghapus) atau anggota baru yang belum berbelanja tidak dapat dicatat sebelum ada nota yang memuatnya.
* **Anomali hapus:** menghapus nota PJ-2610-0002 ikut menghilangkan data petugas Rudi Hartono (P02), karena petugas itu hanya muncul di nota tersebut.

### Menghilangkan grup berulang (1NF)

Setiap barang di setiap nota menjadi satu baris sendiri. Kunci primer menjadi komposit `(no_nota_penjualan, kode_barang)`.

```text
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
          total_penjualan)
```

| no_nota | kode_barang | tgl | kode_petugas | nama_petugas | no_anggota | nama_anggota | nama_barang | qty | harga |
|---|---|---|---|---|---|---|---|---|---|
| PJ-2610-0001 | B01 | 2026-10-01 | P01 | Maya Sari | A001 | Dewi Lestari | Pulpen Gel 0.5 | 2 | 4000 |
| PJ-2610-0001 | B02 | 2026-10-01 | P01 | Maya Sari | A001 | Dewi Lestari | Buku Tulis | 1 | 5000 |
| PJ-2610-0002 | B01 | 2026-10-02 | P02 | Rudi Hartono | - | - | Pulpen Gel 0.5 | 1 | 4500 |
| PJ-2610-0003 | B03 | 2026-10-05 | P01 | Maya Sari | A001 | Dewi Lestari | Air Mineral | 3 | 3000 |

Kolom `subtotal_detail_penjualan`, `jumlah_penjualan`, `diskon_penjualan`, dan `total_penjualan` tidak ditampilkan di tabel, tetapi ikut terulang di setiap baris nota.

---

## D.2 Dependensi Fungsional

Dependensi diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi tabel contoh di atas.

| FD | Dependensi | Alasan | Dasar |
|---|---|---|---|
| FD1 | `no_nota_penjualan` → `tgl_penjualan`, `kode_petugas`, `no_anggota` | Satu nota hanya punya satu tanggal, satu petugas, dan paling banyak satu anggota. | AB-01 |
| FD2 | `kode_petugas` → `nama_petugas` | Satu kode petugas mewakili satu orang. | - |
| FD3 | `no_anggota` → `nama_anggota` | Nomor anggota mengidentifikasi satu anggota. | AB-05 |
| FD4 | `kode_barang` → `nama_barang` | Satu kode barang mewakili satu nama barang. | - |
| FD5 | (`no_nota_penjualan`, `kode_barang`) → `qty_detail_penjualan`, `harga_satuan_detail_penjualan` | Jumlah dan harga ditentukan oleh pasangan nota dan barang, karena harga tiap nota dapat berbeda. | AB-04 |
| FD6 | `qty_detail_penjualan`, `harga_satuan_detail_penjualan` → `subtotal_detail_penjualan` | Subtotal adalah hasil kali, jadi turunan. | turunan |

Dependensi yang sengaja **tidak** saya tulis karena salah menurut aturan bisnis:
* `kode_barang → harga_satuan_detail_penjualan`: harga di nota bisa berbeda dari harga barang saat ini (AB-04). Pada contoh, Pulpen Gel terjual Rp4.000 dan Rp4.500.
* `nama_anggota → no_anggota`: dua anggota dapat bernama sama.

---

## D.3 Menuju 2NF dan 3NF

### 2NF

Pada kunci komposit `(no_nota_penjualan, kode_barang)`:
* **FD1** hanya bergantung pada `no_nota_penjualan`, sehingga atribut nota dipisah ke relasi `PENJUALAN`.
* **FD4** hanya bergantung pada `kode_barang`, sehingga atribut barang dipisah ke relasi `BARANG`.
* **FD5** bergantung pada seluruh kunci, sehingga menjadi relasi `DETAIL_PENJUALAN`.

```text
PENJUALAN (no_nota_penjualan (PK), tgl_penjualan, kode_petugas, nama_petugas,
           no_anggota, nama_anggota, ...)
DETAIL_PENJUALAN (no_nota_penjualan (PK, FK), kode_barang (PK, FK),
                  qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (kode_barang (PK), nama_barang, ...)
```

### 3NF

Pada relasi `PENJUALAN` masih ada dua rantai transitif:
* `no_nota_penjualan → kode_petugas → nama_petugas`
* `no_nota_penjualan → no_anggota → nama_anggota`

Keduanya dipecah dengan memisahkan `PETUGAS` dan `ANGGOTA` menjadi relasi sendiri.

### Nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| `subtotal_detail_penjualan` | Tidak disimpan | Hasil kali `qty_detail_penjualan` dan `harga_satuan_detail_penjualan` (FD6). |
| `jumlah_penjualan` | Tidak disimpan | Jumlah seluruh subtotal pada satu nota. |
| `diskon_penjualan` | Tidak disimpan | Diturunkan dari jumlah dan status anggota (diskon 5% hanya untuk anggota aktif, AB-02). |
| `total_penjualan` | Tidak disimpan | Jumlah dikurangi diskon. |
| `bayar_penjualan` | Disimpan | Uang yang dibayarkan adalah data masukan di kasir, bukan hasil hitung. |

Contoh penghitungan untuk nota PJ-2610-0001 (anggota aktif): jumlah = 8000 + 5000 = 13000, diskon = 5% x 13000 = 650, total = 13000 - 650 = 12350. Nilai ini dihitung saat dibutuhkan, sehingga tidak mungkin tidak konsisten dengan detail nota.

### Hasil 3NF

Tanda `*` berarti kunci tamu. Atribut tambahan pada `BARANG`, `PETUGAS`, dan `ANGGOTA` berasal dari elemen data Pertemuan 2.

```text
PENJUALAN (no_nota_penjualan (PK), tgl_penjualan, kode_petugas (FK)*, no_anggota (FK)*, bayar_penjualan)
DETAIL_PENJUALAN (no_nota_penjualan (PK, FK)*, kode_barang (PK, FK)*, qty_detail_penjualan, harga_satuan_detail_penjualan)
BARANG (kode_barang (PK), nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)
PETUGAS (kode_petugas (PK), nama_petugas, peran_petugas)
ANGGOTA (no_anggota (PK), nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

Data contoh setelah 3NF (kolom lain tidak ditampilkan):

| PENJUALAN: no_nota | tgl | kode_petugas | no_anggota |
|---|---|---|---|
| PJ-2610-0001 | 2026-10-01 | P01 | A001 |
| PJ-2610-0002 | 2026-10-02 | P02 | NULL |
| PJ-2610-0003 | 2026-10-05 | P01 | A001 |

| DETAIL_PENJUALAN: no_nota | kode_barang | qty | harga_satuan |
|---|---|---|---|
| PJ-2610-0001 | B01 | 2 | 4000 |
| PJ-2610-0001 | B02 | 1 | 5000 |
| PJ-2610-0002 | B01 | 1 | 4500 |
| PJ-2610-0003 | B03 | 3 | 3000 |

| PETUGAS: kode | nama | | ANGGOTA: no_anggota | nama |
|---|---|---|---|---|
| P01 | Maya Sari | | A001 | Dewi Lestari |
| P02 | Rudi Hartono | | | |

Nama "Dewi Lestari" kini tersimpan satu kali, sehingga satu perubahan sudah cukup. Penjualan tanpa anggota cukup mengisi `no_anggota` dengan NULL (AB-02), sehingga tidak ada lagi baris "(tanpa anggota)" palsu.

### Ringkasan tahapan

| Tahap | Relasi hasil | Yang dihilangkan |
|---|---|---|
| UNF | NOTA_UNF | - |
| 1NF | NOTA_1NF | Grup berulang barang di dalam satu nota |
| 2NF | PENJUALAN, DETAIL_PENJUALAN, BARANG | Ketergantungan pada sebagian kunci (FD1, FD4) |
| 3NF | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA | Rantai transitif (FD2, FD3) dan nilai turunan (FD6) |

![Tahapan normalisasi Kopma](image/p04_tahapan_kopma.png)

*Gambar: tahapan normalisasi Kopma dari UNF sampai 3NF.*

---

## D.4 Mencocokkan dengan Skema Kanonik

### Perbandingan dengan skema kanonik (Tabel 4.2 buku)

Perbedaan utama antara hasil 3NF di atas dan skema kanonik adalah kunci pengganti (*surrogate key*) `id_*` sebagai kunci primer. Kode alami seperti `no_nota_penjualan` menjadi kunci unik.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| `petugas` | `id_petugas` | `kode_petugas` | - |
| `anggota` | `id_anggota` | `no_anggota`, `nim_anggota` | - |
| `barang` | `id_barang` | `kode_barang` | - |
| `pemasok` | `id_pemasok` | - | - |
| `penjualan` | `id_penjualan` | `no_nota_penjualan` | `id_petugas`, `id_anggota` (boleh NULL) |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | - | `id_penjualan`, `id_barang` |
| `pembelian` | `id_pembelian` | - | `id_pemasok` |
| `detail_pembelian` | (`id_pembelian`, `id_barang`) | - | `id_pembelian`, `id_barang` |

Relasi `PENJUALAN`, `DETAIL_PENJUALAN`, `BARANG`, `PETUGAS`, dan `ANGGOTA` dari D.3 cocok dengan lima tabel pertama di atas. Tabel `pemasok`, `pembelian`, dan `detail_pembelian` berasal dari sisi pembelian barang, yang tidak ada di spreadsheet penjualan ini.

### Pemeriksaan BCNF

| Tabel | Penentu pada FD | Kunci kandidat? | Hasil |
|---|---|---|---|
| `petugas` | `id_petugas`, `kode_petugas` | Ya, keduanya | Terpenuhi |
| `anggota` | `id_anggota`, `no_anggota`, `nim_anggota` | Ya, ketiganya (AB-05) | Terpenuhi |
| `barang` | `id_barang`, `kode_barang` | Ya, keduanya | Terpenuhi |
| `pemasok` | `id_pemasok` | Ya | Terpenuhi |
| `penjualan` | `id_penjualan`, `no_nota_penjualan` | Ya, keduanya (AB-01) | Terpenuhi |
| `detail_penjualan` | (`id_penjualan`, `id_barang`) | Ya | Terpenuhi (FD5 berlaku dengan kunci komposit ini) |
| `pembelian` | `id_pembelian` | Ya | Terpenuhi |
| `detail_pembelian` | (`id_pembelian`, `id_barang`) | Ya | Terpenuhi |

Karena kunci pengganti tidak menghapus dependensi fungsional, pemeriksaan tetap dilakukan lewat kunci alami. Misalnya `kode_barang → nama_barang` masih berlaku dan `kode_barang` berstatus kunci unik sehingga tidak melanggar BCNF. Tidak ada tabel yang perlu dipecah lagi.