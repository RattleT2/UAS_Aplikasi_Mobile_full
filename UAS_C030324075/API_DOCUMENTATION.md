# WebSpace Support — API Documentation

**Base URL:** `http://127.0.0.1:8000/api`

---

## Authentication

Sistem menggunakan **JWT (JSON Web Token)**. Setelah login/register, simpan `token` dari response dan kirimkan di header:

```
Authorization: Bearer {token}
Accept: application/json
Content-Type: application/json
```

Token berlaku **60 menit** (konfigurasi `JWT_TTL` di `.env`).

---

## Response Format

Seluruh response API menggunakan struktur JSON yang konsisten:

```json
{
  "status": true,
  "message": "Deskripsi hasil",
  "data": { ... }
}
```

| HTTP Code | Keterangan |
|:---|:---|
| `201` | Resource created |
| `200` | Request sukses |
| `401` | Unauthorized (token invalid/kadaluarsa) |
| `403` | Forbidden (role tidak sesuai) |
| `422` | Validasi gagal |
| `404` | Resource tidak ditemukan |

---

## Demo Account

| Role | Email | Password |
|:---|:---|:---|
| Admin | `admin@webspace.test` | `password` |
| User | `user@webspace.test` | `password` |

---

## Endpoints

---

### 1. Register

**`POST /api/register`**

Mendaftarkan akun baru. Role otomatis `user`.

**Request Body:**

```json
{
  "name": "Nama Lengkap",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123"
}
```

**Success Response (201):**

```json
{
  "status": true,
  "message": "Pendaftaran berhasil",
  "data": {
    "user": {
      "id": 3,
      "name": "Nama Lengkap",
      "email": "user@example.com",
      "role": "user"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "bearer"
  }
}
```

**Error Response (422):**

```json
{
  "status": false,
  "message": "Validasi gagal",
  "data": {
    "email": ["The email has already been taken."],
    "password": ["The password field confirmation does not match."]
  }
}
```

**cURL Example:**

```bash
curl -X POST http://127.0.0.1:8000/api/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"name":"Nama Lengkap","email":"user@example.com","password":"password123","password_confirmation":"password123"}'
```

---

### 2. Login

**`POST /api/login`**

Login dengan email & password untuk mendapatkan JWT token.

**Request Body:**

```json
{
  "email": "user@webspace.test",
  "password": "password"
}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Login berhasil",
  "data": {
    "user": {
      "id": 2,
      "name": "User Demo",
      "email": "user@webspace.test",
      "role": "user"
    },
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "bearer"
  }
}
```

**Error Response (401):**

```json
{
  "status": false,
  "message": "Email atau password salah",
  "data": null
}
```

**cURL Example:**

```bash
curl -X POST http://127.0.0.1:8000/api/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"email":"user@webspace.test","password":"password"}'
```

---

### 3. Logout

**`POST /api/logout`**

Mencabut (invalidate) token yang sedang aktif.

**Headers:**

```
Authorization: Bearer {token}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Logout berhasil",
  "data": null
}
```

**Error Response (401):**

```json
{
  "message": "Unauthenticated."
}
```

**cURL Example:**

```bash
curl -X POST http://127.0.0.1:8000/api/logout \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

---

### 4. Get Categories

**`GET /api/categories`**

Mendapatkan daftar kategori layanan (untuk dropdown di aplikasi Flutter).

> **Public** — tidak perlu token.

**Success Response (200):**

```json
{
  "status": true,
  "message": "Data kategori berhasil diambil",
  "data": [
    { "id": 1, "name": "Beli Domain", "slug": "beli-domain" },
    { "id": 2, "name": "Sewa Hosting", "slug": "sewa-hosting" },
    { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" },
    { "id": 4, "name": "Konsultasi Website", "slug": "konsultasi-website" },
    { "id": 5, "name": "Lainnya", "slug": "lainnya" }
  ]
}
```

**cURL Example:**

```bash
curl -X GET http://127.0.0.1:8000/api/categories \
  -H "Accept: application/json"
```

---

### 5. Create Inquiry

**`POST /api/inquiries`**

Membuat tiket baru. Status awal: `open`.

> **Auth:** User

**Headers:**

```
Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "category_id": 3,
  "website": "https://websaya.id",
  "telp": "081234567890",
  "pesan": "Website saya error 500 setelah update plugin."
}
```

> **Catatan:** `nama` dan `email` bersifat **opsional**. Jika tidak dikirim, akan otomatis diambil dari profil user yang sedang login.

| Field | Wajib? | Aturan |
|:---|:---|:---|
| `category_id` | Ya | exists:categories,id |
| `nama` | Tidak | Diisi dari user profile |
| `email` | Tidak | Diisi dari user profile |
| `website` | Ya | Format URL |
| `telp` | Ya | Hanya angka |
| `pesan` | Ya | Tidak boleh kosong |

**Success Response (201):**

```json
{
  "status": true,
  "message": "Tiket berhasil dibuat",
  "data": {
    "id": 4,
    "user_id": 2,
    "category_id": 3,
    "nama": "User Demo",
    "email": "user@webspace.test",
    "website": "https://websaya.id",
    "telp": "081234567890",
    "pesan": "Website saya error 500 setelah update plugin.",
    "status": "open",
    "category": { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" }
  }
}
```

**Validation Errors (422):**

| Field | Rule | Custom Error Message |
|:---|:---|:---|
| `category_id` | required, exists:categories,id | — |
| `nama` | nullable | — |
| `email` | nullable, email | `"Format email Invalid"` |
| `website` | required, url | `"URL tidak valid"` |
| `telp` | required, numeric | `"Nomor HP hanya boleh angka"` |
| `pesan` | required | `"Pesan tidak boleh kosong"` |

**Error Response (422):**

```json
{
  "status": false,
  "message": "Validasi gagal",
  "data": {
    "email": ["Format email Invalid"],
    "website": ["URL tidak valid"],
    "telp": ["Nomor HP hanya boleh angka"],
    "pesan": ["Pesan tidak boleh kosong"]
  }
}
```

**cURL Example:**

```bash
curl -X POST http://127.0.0.1:8000/api/inquiries \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"category_id":3,"website":"https://websaya.id","telp":"081234567890","pesan":"Butuh bantuan teknis."}'
```

---

### 6. Get My Inquiries

**`GET /api/inquiries`**

Melihat daftar tiket milik sendiri (user yang sedang login).

> **Auth:** User

**Headers:**

```
Authorization: Bearer {token}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Data tiket berhasil diambil",
  "data": [
    {
      "id": 2,
      "user_id": 2,
      "category_id": 2,
      "nama": "User Demo",
      "email": "user@webspace.test",
      "website": "https://tokoonline.id",
      "telp": "081234567890",
      "pesan": "Saya ingin upgrade paket hosting...",
      "status": "in_progress",
      "category": { "id": 2, "name": "Sewa Hosting", "slug": "sewa-hosting" }
    },
    {
      "id": 1,
      "user_id": 2,
      "category_id": 3,
      "nama": "User Demo",
      "email": "user@webspace.test",
      "website": "https://websaya.id",
      "telp": "081234567890",
      "pesan": "Website saya tiba-tiba error 500...",
      "status": "open",
      "category": { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" }
    }
  ]
}
```

**cURL Example:**

```bash
curl -X GET http://127.0.0.1:8000/api/inquiries \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

---

### 7. Get Inquiry Detail

**`GET /api/inquiries/{id}`**

Melihat detail tiket beserta seluruh balasan (thread percakapan).

> **Auth:** User (hanya bisa melihat tiket miliknya sendiri)

**Headers:**

```
Authorization: Bearer {token}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Detail tiket berhasil diambil",
  "data": {
    "id": 1,
    "user_id": 2,
    "category_id": 3,
    "nama": "User Demo",
    "email": "user@webspace.test",
    "website": "https://websaya.id",
    "telp": "081234567890",
    "pesan": "Website saya tiba-tiba error 500...",
    "status": "open",
    "category": { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" },
    "replies": [
      {
        "id": 1,
        "inquiry_id": 1,
        "user_id": 2,
        "message": "Ini screenshot error-nya...",
        "user": { "id": 2, "name": "User Demo", "email": "user@webspace.test", "role": "user" }
      },
      {
        "id": 2,
        "inquiry_id": 1,
        "user_id": 1,
        "message": "Baik Pak, kami akan cek log server Anda...",
        "user": { "id": 1, "name": "Admin WebSpace", "email": "admin@webspace.test", "role": "admin" }
      }
    ]
  }
}
```

**Error Response (404):**

```json
{
  "message": "No query results for model [App\\Models\\Inquiry] 99."
}
```

**cURL Example:**

```bash
curl -X GET http://127.0.0.1:8000/api/inquiries/1 \
  -H "Authorization: Bearer {token}" \
  -H "Accept: application/json"
```

---

### 8. Send Reply

**`POST /api/inquiries/{inquiryId}/replies`**

Mengirim balasan pada tiket. User hanya bisa membalas tiket miliknya sendiri. Admin bisa membalas tiket siapa pun.

> **Auth:** Semua role

**Headers:**

```
Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "message": "Terima kasih infonya. Saya tunggu kabar selanjutnya."
}
```

**Success Response (201):**

```json
{
  "status": true,
  "message": "Balasan berhasil dikirim",
  "data": {
    "id": 7,
    "inquiry_id": 1,
    "user_id": 2,
    "message": "Terima kasih infonya. Saya tunggu kabar selanjutnya.",
    "user": { "id": 2, "name": "User Demo", "email": "user@webspace.test", "role": "user" }
  }
}
```

**Error Response (403) — User mencoba membalas tiket orang lain:**

```json
{
  "status": false,
  "message": "Akses ditolak",
  "data": null
}
```

**cURL Example:**

```bash
curl -X POST http://127.0.0.1:8000/api/inquiries/1/replies \
  -H "Authorization: Bearer {token}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"message":"Terima kasih, saya tunggu update selanjutnya."}'
```

---

### 9. Admin — Get All Inquiries

**`GET /api/admin/inquiries`**

Melihat seluruh tiket dari semua user (admin only).

> **Auth:** Admin

**Headers:**

```
Authorization: Bearer {token}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Data seluruh tiket berhasil diambil",
  "data": [
    {
      "id": 3,
      "user_id": 2,
      "category_id": 1,
      "nama": "User Demo",
      "email": "user@webspace.test",
      "website": "https://brandbaru.id",
      "telp": "081234567890",
      "pesan": "Saya sudah transfer untuk pembelian domain...",
      "status": "closed",
      "user": { "id": 2, "name": "User Demo", "email": "user@webspace.test", "role": "user" },
      "category": { "id": 1, "name": "Beli Domain", "slug": "beli-domain" }
    }
  ]
}
```

**Error Response (403) — User biasa mengakses:**

```json
{
  "status": false,
  "message": "Akses ditolak. Anda tidak memiliki hak akses.",
  "data": null
}
```

**cURL Example:**

```bash
curl -X GET http://127.0.0.1:8000/api/admin/inquiries \
  -H "Authorization: Bearer {token_admin}" \
  -H "Accept: application/json"
```

---

### 10. Admin — Get Inquiry Detail

**`GET /api/admin/inquiries/{id}`**

Melihat detail tiket (dari user mana pun) beserta seluruh balasan.

> **Auth:** Admin

**Headers:**

```
Authorization: Bearer {token}
```

**Success Response (200):**

```json
{
  "status": true,
  "message": "Detail tiket berhasil diambil",
  "data": {
    "id": 1,
    "user_id": 2,
    "category_id": 3,
    "nama": "User Demo",
    "email": "user@webspace.test",
    "website": "https://websaya.id",
    "telp": "081234567890",
    "pesan": "Website saya tiba-tiba error 500...",
    "status": "open",
    "user": { "id": 2, "name": "User Demo", "email": "user@webspace.test", "role": "user" },
    "category": { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" },
    "replies": [
      {
        "id": 1,
        "inquiry_id": 1,
        "user_id": 2,
        "message": "Ini screenshot error-nya...",
        "user": { "id": 2, "name": "User Demo", "email": "user@webspace.test", "role": "user" }
      }
    ]
  }
}
```

**Error Response (403):**

```json
{
  "status": false,
  "message": "Akses ditolak. Anda tidak memiliki hak akses.",
  "data": null
}
```

**cURL Example:**

```bash
curl -X GET http://127.0.0.1:8000/api/admin/inquiries/1 \
  -H "Authorization: Bearer {token_admin}" \
  -H "Accept: application/json"
```

---

### 11. Admin — Update Inquiry Status

**`PUT /api/admin/inquiries/{id}/status`**

Mengubah status tiket (`open` → `in_progress` → `closed`).

> **Auth:** Admin

**Headers:**

```
Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "status": "in_progress"
}
```

**Valid values:** `open`, `in_progress`, `closed`

**Success Response (200):**

```json
{
  "status": true,
  "message": "Status tiket berhasil diubah",
  "data": {
    "id": 1,
    "user_id": 2,
    "category_id": 3,
    "nama": "User Demo",
    "email": "user@webspace.test",
    "website": "https://websaya.id",
    "telp": "081234567890",
    "pesan": "Website saya tiba-tiba error 500...",
    "status": "in_progress",
    "category": { "id": 3, "name": "Bantuan Teknis", "slug": "bantuan-teknis" }
  }
}
```

**Error Response (403):**

```json
{
  "status": false,
  "message": "Akses ditolak. Anda tidak memiliki hak akses.",
  "data": null
}
```

**Error Response (422):**

```json
{
  "status": false,
  "message": "Validasi gagal",
  "data": {
    "status": ["The selected status is invalid."]
  }
}
```

**cURL Example:**

```bash
curl -X PUT http://127.0.0.1:8000/api/admin/inquiries/1/status \
  -H "Authorization: Bearer {token_admin}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"status":"in_progress"}'
```

---

## Database Schema

| Table | Columns |
|:---|:---|
| **users** | `id`, `name`, `email` (unique), `password`, `role` (enum: `user`, `admin`), `email_verified_at`, `remember_token`, `timestamps` |
| **categories** | `id`, `name`, `slug` (unique), `timestamps` |
| **inquiries** | `id`, `user_id` (FK), `category_id` (FK), `nama`, `email`, `website`, `telp`, `pesan` (text), `status` (enum: `open`, `in_progress`, `closed`), `timestamps` |
| **inquiry_replies** | `id`, `inquiry_id` (FK), `user_id` (FK), `message` (text), `timestamps` |

---

## Tech Stack

| Komponen | Teknologi |
|:---|:---|
| Framework | Laravel 13.x |
| PHP | ^8.3 |
| Autentikasi | JWT (`php-open-source-saver/jwt-auth`) |
| Database | MySQL / SQLite |
| Role | RBAC (user, admin) via custom middleware `CheckRole` |
| Validasi | Form Request `InquiryRequest` + custom messages Bahasa Indonesia |
