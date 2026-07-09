# 🚀 WebSpace Support - Aplikasi Flutter untuk Sistem Support Hosting

Aplikasi mobile Flutter untuk manajemen tiket support dan inquiry WebSpace Hosting. Aplikasi ini memungkinkan pengguna untuk membuat tiket support, melihat status tiket, dan berkomunikasi dengan tim support melalui sistem reply.

## 📋 Fitur Utama

### 👤 Autentikasi & Profil
- ✅ Register akun baru dengan validasi lengkap
- ✅ Login dengan email dan password
- ✅ Logout dan clear session
- ✅ Penyimpanan token JWT di SharedPreferences
- ✅ Auto-login jika token masih valid

### 🎫 Manajemen Tiket Support
- ✅ Buat tiket support baru dengan form yang user-friendly
- ✅ Validasi form sesuai dengan standar API backend
- ✅ Pilih kategori dari dropdown (Beli Domain, Sewa Hosting, Bantuan Teknis, dll)
- ✅ Lihat daftar semua tiket milik user
- ✅ Lihat detail tiket dengan informasi lengkap

### 💬 Sistem Reply & Percakapan
- ✅ Lihat riwayat percakapan dalam tiket
- ✅ Kirim balasan pada tiket yang masih dibuka
- ✅ Tampilkan siapa yang mengirim pesan (Admin/User)
- ✅ Status percakapan (Dibuka, Sedang Diproses, Ditutup)

### 🎨 UI/UX yang Menarik
- ✅ Gradient design yang modern
- ✅ Material Design 3 components
- ✅ Responsive layout untuk berbagai ukuran layar
- ✅ Loading states dan error handling
- ✅ Toast notifications untuk feedback

## 🛠️ Tech Stack

| Komponen | Teknologi |
|:---|:---|
| Framework | Flutter 3.x |
| Bahasa | Dart |
| API Client | http 1.1.0 |
| Local Storage | shared_preferences 2.2.0 |
| Localization | intl 0.19.0 |
| UI Components | Material Design 3 |

## 📁 Struktur Proyek

```
lib/
├── main.dart                          # Entry point & routing
├── models/                            # Data models
│   ├── user.dart                     # User model
│   ├── category.dart                 # Category model
│   ├── inquiry.dart                  # Inquiry & Reply models
│   └── auth_response.dart            # API response models
├── services/                          # Business logic
│   └── api_service.dart              # API integration
├── screens/                           # UI Screens
│   ├── splash_screen.dart            # Splash screen
│   ├── login_screen.dart             # Login screen
│   ├── register_screen.dart          # Register screen
│   ├── home_screen.dart              # Dashboard/home
│   ├── inquiry_form_screen.dart      # Form untuk buat tiket
│   ├── inquiry_list_screen.dart      # Daftar tiket user
│   └── inquiry_detail_screen.dart    # Detail & reply tiket
└── widgets/                           # Reusable widgets
    └── custom_widgets.dart           # Custom buttons, dialogs, dll
```

## 🔌 API Integration

Aplikasi ini mengintegrasikan dengan API backend Laravel yang sudah Anda buat:

### Base URL
```
http://127.0.0.1:8000/api
```

### Authentication
```
Authorization: Bearer {token}
Accept: application/json
Content-Type: application/json
```

### Endpoints yang Digunakan

| Endpoint | Method | Deskripsi |
|:---|:---|:---|
| `/register` | POST | Register akun baru |
| `/login` | POST | Login |
| `/logout` | POST | Logout |
| `/categories` | GET | Ambil daftar kategori |
| `/inquiries` | POST | Buat tiket baru |
| `/inquiries` | GET | Ambil tiket milik user |
| `/inquiries/{id}` | GET | Detail tiket |
| `/inquiries/{id}/replies` | POST | Kirim reply |

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK (versi 3.x ke atas)
- Dart SDK
- Backend API sudah berjalan di `http://127.0.0.1:8000`

### Instalasi

1. **Clone atau buka project ini**
```bash
cd "path/to/uas_c030324075"
```

2. **Ambil dependencies**
```bash
flutter pub get
```

3. **Jalankan aplikasi**
```bash
# Untuk Android emulator
flutter run

# Untuk device tertentu
flutter run -d <device-id>

# Dalam release mode
flutter run --release
```

## 📱 Cara Penggunaan

### 1️⃣ Registrasi Akun Baru
- Buka aplikasi
- Klik "Daftar sekarang" atau langsung register
- Isi form dengan:
  - Nama lengkap
  - Email
  - Password (min 6 karakter)
  - Konfirmasi password
- Klik tombol "Daftar"

### 2️⃣ Login
- Masukkan email
- Masukkan password
- Klik tombol "Login"
- Aplikasi akan menyimpan token secara otomatis

### 3️⃣ Membuat Tiket Support
- Dari home screen, klik "Buat Tiket Baru"
- Isi form dengan:
  - **Kategori**: Pilih dari dropdown
  - **Nama**: Nama Anda (terisi otomatis)
  - **Email**: Email Anda (terisi otomatis)
  - **Website**: URL website Anda
  - **Telp**: Nomor HP (angka saja)
  - **Pesan**: Deskripsi masalah Anda
- Validasi:
  - Email harus format valid
  - Website harus URL yang valid
  - Nomor telp hanya angka
  - Pesan tidak boleh kosong
- Klik "Kirim Tiket"

### 4️⃣ Melihat Tiket Anda
- Dari home, klik "Tiket Saya"
- Lihat daftar semua tiket Anda
- Tiket ditampilkan dengan status warna:
  - 🟠 **Dibuka** (orange)
  - 🔵 **Sedang Diproses** (blue)
  - 🟢 **Ditutup** (green)

### 5️⃣ Menanggapi Tiket
- Klik tiket untuk melihat detail
- Lihat percakapan sebelumnya
- Ketik balasan Anda di bagian bawah
- Klik "Kirim Balasan"
- Admin akan menerima notifikasi

## ✅ Form Validation

### Create Inquiry
| Field | Rule | Error Message |
|:---|:---|:---|
| Category ID | required | (error handling untuk dropdown) |
| Nama | required | Nama tidak boleh kosong |
| Email | required, email | Format email Invalid |
| Website | required, url | URL tidak valid |
| Telp | required, numeric | Nomor HP hanya boleh angka |
| Pesan | required | Pesan tidak boleh kosong |

## 🔐 Security

- ✅ Token JWT disimpan di SharedPreferences
- ✅ Token otomatis dikirim di header Authorization
- ✅ Token akan dihapus saat logout
- ✅ Validasi input di client side
- ✅ Error handling yang aman

## 🎯 Demo Accounts

| Role | Email | Password |
|:---|:---|:---|
| User | `user@webspace.test` | `password` |
| Admin | `admin@webspace.test` | `password` |

> **Note**: Demo accounts bekerja jika backend sudah dijalankan dan database sudah di-seed

## 📸 Screenshots

(Struktur form seuai dengan gambar referensi yang diberikan)

- **Login Screen**: Gradient blue dengan email & password field
- **Register Screen**: Form lengkap dengan validasi
- **Home Screen**: Dashboard dengan profil & menu
- **Inquiry Form**: Form sesuai dengan struktur gambar referensi
- **Inquiry List**: Daftar tiket dengan status color-coded
- **Inquiry Detail**: Chat-like interface untuk percakapan

## 🐛 Troubleshooting

### Error: "Koneksi ditolak ke API"
- Pastikan backend Laravel sudah berjalan
- Verifikasi URL API sudah benar: `http://127.0.0.1:8000/api`
- Untuk emulator Android, gunakan `http://10.0.2.2:8000` untuk localhost

### Error: "Validasi gagal"
- Pastikan semua field terisi dengan benar
- Email harus format valid (contoh: user@example.com)
- Website harus HTTPS/HTTP URL (contoh: https://example.com)
- Telp hanya angka tanpa spasi atau karakter khusus

### Token Expired
- Aplikasi otomatis redirect ke login
- Login ulang untuk mendapatkan token baru
- Token berlaku 60 menit

## 📝 Notes

- Aplikasi ini adalah UAS project, bersifat localhost
- Semua data disimpan di server backend (tidak ada local caching di aplikasi)
- Untuk production, perlu menambahkan:
  - SSL certificate verification
  - Better error handling
  - Offline capability
  - Push notifications
  - Image/file upload
  - Admin panel untuk manage semua tiket

## 👨‍💻 Developer

```
UAS - Sistem Support WebSpace Hosting
Created: July 2026
``` 

## 📄 License

Proyek ini adalah bagian dari UAS dan bersifat pribadi.

---

**Selamat menggunakan WebSpace Support! 🚀**

Jika ada pertanyaan atau bug, silakan hubungi tim development.
