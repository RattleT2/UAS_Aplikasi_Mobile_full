# PRD - Backend API Sistem Inquiry & Tiket Layanan Web (UAS PPB - Final)

## Konteks Proyek
Pembuatan backend API menggunakan Framework Laravel untuk aplikasi mobile Flutter bernama **"WebSpace Support"**. Sistem ini berfungsi untuk menangani pengajuan konsultasi, pembelian domain/hosting, atau pelaporan masalah website. Fokus utama ujian ini adalah keamanan endpoint, validasi form yang ketat dengan pesan error kustom berbahasa Indonesia, serta penerapan arsitektur Role-Based Access Control (RBAC) dan sistem tiket (thread percakapan).

---

## 1. Kebutuhan Fungsional Sistem (KFS)

* **Manajemen Autentikasi:** Sistem menyediakan endpoint API terpusat untuk pendaftaran akun (*Register*), otentikasi masuk (*Login*), dan keluar (*Logout*) menggunakan Laravel Sanctum.
* **Manajemen Peran (Role):** Sistem membagi pengguna menjadi dua tipe hak akses, yaitu `user` (klien yang mengajukan tiket) dan `admin` (tim dukungan yang merespons tiket). Akun baru secara otomatis mendapat role `user`.
* **Master Data Kategori:** Sistem menyediakan API publik untuk mengambil daftar kategori layanan (misal: Beli Domain, Sewa Hosting, Bantuan Teknis) sebagai pilihan dropdown di aplikasi Flutter.
* **Pengajuan Tiket (Inquiry):** Sistem menerima data form dari Flutter dan melakukan validasi ketat sebelum menyimpannya sebagai tiket baru dengan status `open`.
* **Manajemen & Riwayat Tiket:** Sistem memungkinkan `user` untuk melihat daftar tiket miliknya sendiri, dan memungkinkan `admin` untuk melihat seluruh tiket yang masuk serta mengubah status tiket (`open`, `in_progress`, `closed`).
* **Sistem Balasan (Thread Reply):** Sistem memfasilitasi percakapan interaktif dengan memungkinkan `user` dan `admin` untuk mengirimkan pesan balasan secara berkali-kali pada tiket yang sama.

---

## 2. Kebutuhan Non-Fungsional Sistem (Non-KFS)

### Validasi Ketat Form Utama (Sesuai Gambar Soal)
* **Nama:** Tipe data string, wajib diisi.
* **Email:** Wajib diisi, wajib format email. Pesan error jika gagal: `"Format email Invalid"`.
* **Website:** Wajib diisi, wajib format URL aktif. Pesan error jika gagal: `"URL tidak valid"`.
* **Telp:** Wajib diisi, wajib angka murni (*numeric*). Pesan error jika gagal: `"Nomor HP hanya boleh angka"`.
* **Pesan:** Wajib diisi. Pesan error jika kosong: `"Pesan tidak boleh kosong"`.

### Standar Respons API
Seluruh output API wajib dikemas dalam struktur JSON yang konsisten (memiliki properti `status`, `message`, dan `data`). Jika validasi gagal, kembalikan HTTP Code `422 Unprocessable Entity`.

### Keamanan
Semua endpoint (kecuali Login, Register, dan Get Kategori) wajib dilindungi oleh middleware *authentication*. Endpoint khusus admin wajib dilindungi tambahan oleh *custom middleware* pengecekan role.

---

## 3. Struktur Tabel & Skema Database

| Nama Tabel | Kolom Utama (Tipe Data) | Keterangan & Relasi |
| :--- | :--- | :--- |
| **users** | `id (PK)`, `name`, `email (Unique)`, `password`, `role (Enum: 'user', 'admin')` | Data kredensial login dan hak akses. |
| **categories** | `id (PK)`, `name (String)`, `slug (String, Unique)` | Tabel master untuk pilihan jenis pengajuan. |
| **inquiries** | `id (PK)`, `user_id (FK)`, `category_id (FK)`, `nama`, `email`, `website`, `telp`, `pesan`, `status (Enum: 'open', 'in_progress', 'closed')` | Tabel utama tiket. Berelasi ke `users` dan `categories`. |
| **inquiry_replies** | `id (PK)`, `inquiry_id (FK)`, `user_id (FK)`, `message (Text)` | Tabel thread pesan balasan. Berelasi ke `inquiries` dan `users`. |

---

## 4. Desain Endpoint API Utama

| Metode | Endpoint API | Fungsi | Akses Role |
| :--- | :--- | :--- | :--- |
| **POST** | `/api/register` | Mendaftarkan akun user baru | Publik |
| **POST** | `/api/login` | Mendapatkan Bearer Token | Publik |
| **POST** | `/api/logout` | Mencabut Token aktif | Semua Role |
| **GET** | `/api/categories` | Mendapatkan pilihan kategori form | Publik |
| **POST** | `/api/inquiries` | Mengirim data form tiket baru | User |
| **GET** | `/api/inquiries` | Melihat list tiket milik sendiri | User |
| **GET** | `/api/inquiries/{id}` | Melihat detail tiket & isi percakapan chat | User |
| **POST** | `/api/inquiries/{id}/replies` | Mengirim pesan balasan ke dalam tiket | Semua Role |
| **GET** | `/api/admin/inquiries` | Melihat seluruh tiket masuk | Admin |
| **PUT** | `/api/admin/inquiries/{id}/status` | Mengubah status tiket (open/progress/closed) | Admin |

---

## Instruksi Tugas

Tolong bertindak sebagai **Backend Developer Senior**. Buatkan source code backend Laravel (versi terbaru) secara lengkap berdasarkan PRD di atas.

1. Berikan kode lengkap untuk **Migrations** dari ke-4 tabel tersebut.
2. Berikan kode **Models** beserta pendefinisian relasinya (`HasMany`, `BelongsTo`).
3. Buatkan **Custom Middleware** bernama `CheckRole` untuk memisahkan akses Admin.
4. Buatkan `InquiryRequest` untuk validasi input di `/api/inquiries`. Pastikan kamu mengatur parameter `messages()` di dalamnya dengan custom error Bahasa Indonesia persis seperti yang tertulis di bagian Non-KFS PRD ini.
5. Buatkan **Controllers** (`AuthController`, `CategoryController`, `InquiryController`, `InquiryReplyController`) yang mengembalikan data menggunakan Eloquent dalam format JSON yang bersih. Silakan sediakan isi file `routes/api.php` secara lengkap.
