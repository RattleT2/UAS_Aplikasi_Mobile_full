-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 08 Jul 2026 pada 14.20
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uas_rio`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `cache`
--

INSERT INTO `cache` (`key`, `value`, `expiration`) VALUES
('laravel-cache-2lehCwd3roQft3DN', 'a:1:{s:11:\"valid_until\";i:1783074928;}', 1784284528),
('laravel-cache-606OFwDtZej7AhPk', 'a:1:{s:11:\"valid_until\";i:1783488770;}', 1784698370),
('laravel-cache-b3SKzyjnSZLvurWf', 'a:1:{s:11:\"valid_until\";i:1783505490;}', 1784715030),
('laravel-cache-bhW80D4wXVmK3lOU', 'a:1:{s:11:\"valid_until\";i:1783505701;}', 1784715301),
('laravel-cache-CjGfvZsTICU1SCW7', 'a:1:{s:11:\"valid_until\";i:1783489680;}', 1784699220),
('laravel-cache-clfhtkhJxCaTnf3J', 'a:1:{s:11:\"valid_until\";i:1783071783;}', 1784281203),
('laravel-cache-dbNeuTgJFt6qhbS3', 'a:1:{s:11:\"valid_until\";i:1783513033;}', 1784722513),
('laravel-cache-E5mCisdmucxIRoc5', 'a:1:{s:11:\"valid_until\";i:1783424792;}', 1784633552),
('laravel-cache-GPzjlhDOAv0FVHPQ', 'a:1:{s:11:\"valid_until\";i:1783513158;}', 1784722698),
('laravel-cache-GRxWzRZonDsJ82z4', 'a:1:{s:11:\"valid_until\";i:1783425550;}', 1784634490),
('laravel-cache-HDZSHiLTij5ZU0QC', 'a:1:{s:11:\"valid_until\";i:1783254741;}', 1784464341),
('laravel-cache-JOrO6hdmWqcotzD2', 'a:1:{s:11:\"valid_until\";i:1783428797;}', 1784638397),
('laravel-cache-jU7bt2OaADFQ909b', 'a:1:{s:11:\"valid_until\";i:1783488688;}', 1784698228),
('laravel-cache-LgrfYlAt5TauFn1f', 'a:1:{s:11:\"valid_until\";i:1783505510;}', 1784715170),
('laravel-cache-lZUzybjGWmboV0OO', 'a:1:{s:11:\"valid_until\";i:1783512786;}', 1784722206),
('laravel-cache-oasmT2TEHQQhcJ9F', 'a:1:{s:11:\"valid_until\";i:1783074279;}', 1784283099),
('laravel-cache-pd4sycFj89J5Q1c4', 'a:1:{s:11:\"valid_until\";i:1783429435;}', 1784639095),
('laravel-cache-T924yaa33KtQyWCn', 'a:1:{s:11:\"valid_until\";i:1783505697;}', 1784715237),
('laravel-cache-U9dkY7nfg2ulX312', 'a:1:{s:11:\"valid_until\";i:1783072445;}', 1784281685),
('laravel-cache-XdWvwrrz2hS8WNWB', 'a:1:{s:11:\"valid_until\";i:1783433397;}', 1784642997),
('laravel-cache-yCeWlfNyHlZHCvoJ', 'a:1:{s:11:\"valid_until\";i:1783505375;}', 1784714916),
('laravel-cache-yDdjorYnE9KFrUzf', 'a:1:{s:11:\"valid_until\";i:1783430001;}', 1784639121),
('laravel-cache-YZShcDijjZzojjWN', 'a:1:{s:11:\"valid_until\";i:1783428712;}', 1784638252),
('laravel-cache-ZdHxCczuU5OAnE3N', 'a:1:{s:11:\"valid_until\";i:1783429416;}', 1784638536),
('laravel-cache-ZKg1hnQtllje5wyx', 'a:1:{s:11:\"valid_until\";i:1783433300;}', 1784642721);

-- --------------------------------------------------------

--
-- Struktur dari tabel `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
(1, 'Beli Domain', 'beli-domain', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(2, 'Sewa Hosting', 'sewa-hosting', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(3, 'Bantuan Teknis', 'bantuan-teknis', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(4, 'Konsultasi Website', 'konsultasi-website', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(5, 'Lainnya', 'lainnya', '2026-07-02 06:12:47', '2026-07-02 06:12:47');

-- --------------------------------------------------------

--
-- Struktur dari tabel `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `inquiries`
--

CREATE TABLE `inquiries` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `website` varchar(255) NOT NULL,
  `telp` varchar(255) NOT NULL,
  `pesan` text NOT NULL,
  `status` enum('open','in_progress','closed') NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `inquiries`
--

INSERT INTO `inquiries` (`id`, `user_id`, `category_id`, `nama`, `email`, `website`, `telp`, `pesan`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 3, 'User Demo', 'user@webspace.test', 'https://websaya.id', '081234567890', 'Website saya tiba-tiba error 500 setelah update plugin. Mohon bantuannya.', 'open', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(2, 2, 2, 'User Demo', 'user@webspace.test', 'https://tokoonline.id', '081234567890', 'Saya ingin upgrade paket hosting dari Starter ke Business karena traffic website meningkat.', 'in_progress', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(3, 2, 1, 'User Demo', 'user@webspace.test', 'https://brandbaru.id', '081234567890', 'Saya sudah transfer untuk pembelian domain brandbaru.id. Mohon konfirmasi.', 'closed', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(4, 4, 1, 'User', 'user@webspace.com', 'https://belajar.com', '081234567890', 'Beli domain', 'open', '2026-07-03 02:35:17', '2026-07-03 02:35:17'),
(5, 4, 3, 'User', 'user@webspace.com', 'https://belajar.com', '0813876324', 'perbaiki website', 'open', '2026-07-07 03:58:21', '2026-07-07 03:58:21'),
(6, 4, 2, 'User', 'user@webspace.com', 'http://WRCrally.com', '08123412876', 'Ingin sewa hosting', 'open', '2026-07-07 03:59:04', '2026-07-07 05:24:35'),
(7, 2, 1, 'User Demo', 'user@webspace.test', 'http://gacorwak.com', '081234548765', 'Ingin membeli domain', 'in_progress', '2026-07-07 06:09:50', '2026-07-07 06:14:08'),
(8, 5, 1, 'Gacor jirr', 'gacorcoy@gmail.com', 'https://gacorcoyy.com', '081285768473', 'Ingin membeli website', 'in_progress', '2026-07-07 06:17:08', '2026-07-08 02:09:19'),
(9, 2, 1, 'Syarif Kurniawan', 'user@webspace.test', 'https://cobaja.com', '08123456789', 'Ingin membeli website', 'open', '2026-07-08 02:11:14', '2026-07-08 02:14:24');

-- --------------------------------------------------------

--
-- Struktur dari tabel `inquiry_replies`
--

CREATE TABLE `inquiry_replies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `inquiry_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `inquiry_replies`
--

INSERT INTO `inquiry_replies` (`id`, `inquiry_id`, `user_id`, `message`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 'Ini screenshot error-nya: [terlampir]. Semua plugin sudah saya nonaktifkan tapi tetap error.', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(2, 1, 1, 'Baik Pak, kami akan cek log server Anda. Mohon tunggu sebentar ya. Apakah ada akses cPanel yang bisa kami gunakan?', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(3, 2, 2, 'Traffic saya naik dari 1000 ke 5000 pengunjung per hari. Paket Starter sudah tidak cukup.', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(4, 2, 1, 'Baik, kami proses upgrade ke paket Business. Biaya tambahan Rp 50.000/bulan akan ditagihkan di invoice berikutnya. Upgrade selesai dalam 1x24 jam.', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(5, 3, 2, 'Saya sudah transfer Rp 150.000 ke rekening BCA atas nama WebSpace. Berikut bukti transfernya.', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(6, 3, 1, 'Pembayaran sudah kami terima dan diverifikasi. Domain brandbaru.id sudah aktif. Silakan cek di https://brandbaru.id. Terima kasih!', '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(7, 1, 2, 'halo kak', '2026-07-07 04:53:12', '2026-07-07 04:53:12'),
(8, 1, 2, 'iya ada apa', '2026-07-07 04:54:39', '2026-07-07 04:54:39'),
(9, 1, 2, 'halo kak', '2026-07-07 04:54:56', '2026-07-07 04:54:56'),
(10, 1, 1, 'halo kak', '2026-07-07 05:13:55', '2026-07-07 05:13:55'),
(11, 1, 2, 'saya ada keluhan terkait web kak', '2026-07-07 05:15:09', '2026-07-07 05:15:09'),
(12, 1, 2, 'dimana api nya error', '2026-07-07 05:16:22', '2026-07-07 05:16:22'),
(13, 1, 1, 'bagaimana kak apakah sudah bisa?', '2026-07-07 06:04:23', '2026-07-07 06:04:23'),
(14, 7, 1, 'halo kak apakah kaka ingin membeli domain??', '2026-07-07 06:10:33', '2026-07-07 06:10:33'),
(15, 7, 2, 'iya kak apakah layanan nya menggunakan hostinger??', '2026-07-07 06:11:02', '2026-07-07 06:11:02'),
(16, 7, 1, 'iya kak', '2026-07-07 06:11:35', '2026-07-07 06:11:35'),
(17, 7, 2, 'kira kira selesai dalam berapa hari kak??', '2026-07-07 06:13:21', '2026-07-07 06:13:21'),
(18, 7, 1, 'kemungkinan 2 hari', '2026-07-07 06:13:41', '2026-07-07 06:13:41'),
(19, 8, 1, 'iya kak ada yang bisa dibantu??', '2026-07-07 06:17:40', '2026-07-07 06:17:40'),
(20, 8, 5, 'ingin membeli website kak', '2026-07-07 06:19:43', '2026-07-07 06:19:43'),
(21, 8, 1, 'baik sedang diproses', '2026-07-08 02:09:07', '2026-07-08 02:09:07'),
(22, 9, 2, 'Permisi admin saya ingin membeli website', '2026-07-08 02:11:28', '2026-07-08 02:11:28'),
(23, 9, 1, 'baik saya akan konfirmasi', '2026-07-08 02:14:36', '2026-07-08 02:14:36');

-- --------------------------------------------------------

--
-- Struktur dari tabel `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '0001_01_01_000003_add_role_to_users_table', 1),
(5, '0001_01_01_000004_create_categories_table', 1),
(6, '0001_01_01_000005_create_inquiries_table', 1),
(7, '0001_01_01_000006_create_inquiry_replies_table', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('KOch2gNLs1bJ0DU2MACEZEoZVTnt5gZ1dyyPWrC7', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJ6VkpGcUY3d3VNcjhoM3lVYWNLam5NeTFPaDNjc3hDeXg3WVZXcVlSIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9hZG1pbiIsInJvdXRlIjoiYWRtaW4uZGFzaGJvYXJkIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1783512127),
('zt0lkMRQPRw9NY9BcA7Qfk2koknGSBIb1ByCBYhO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJ3UTNWcGJPb3JLOHBWUDJYenJDeXVrVXEzM2c5ejRvcHVxOGt4NE95IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHA6XC9cLzEyNy4wLjAuMTo4MDAwXC9sb2dpbiIsInJvdXRlIjoibG9naW4ifSwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1783513159);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `role`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin WebSpace', 'admin@webspace.test', NULL, '$2y$12$79NWa3BpMN/eroIPwTTZsOXTq.iWA5wgc/sLUWsHX1MyI5Eq3k6HC', 'admin', NULL, '2026-07-02 06:12:46', '2026-07-02 06:12:46'),
(2, 'User Demo', 'user@webspace.test', NULL, '$2y$12$xRrpRMAnYQfsO6iQZXGUPOe8RMfZBatRznS2XCC/Piuj/u/djsRNq', 'user', NULL, '2026-07-02 06:12:47', '2026-07-02 06:12:47'),
(3, 'Admins WebSpace', 'admins@webspace.test', NULL, '$2y$12$e2VzaKQeEGZlQ5yY43pnFOHIEeY0YtZ8htlzOnPpw4JpVpHhv.mKe', 'user', NULL, '2026-07-03 01:21:48', '2026-07-03 01:21:48'),
(4, 'User', 'user@webspace.com', NULL, '$2y$12$UVRYTpkqoidh7Wgg9WOeZuuHwuRYrWAjQALtvsg.xCNXcTKTcO0EC', 'user', NULL, '2026-07-03 01:42:56', '2026-07-03 01:42:56'),
(5, 'Gacor jirr', 'gacorcoy@gmail.com', NULL, '$2y$12$3nOf/x.Nw/zcio./tVekUewa4FEzQFYoP0smhgBGBOAPVmAwmc2nS', 'user', NULL, '2026-07-07 06:16:22', '2026-07-07 06:16:22');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indeks untuk tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

--
-- Indeks untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  ADD KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`);

--
-- Indeks untuk tabel `inquiries`
--
ALTER TABLE `inquiries`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inquiries_user_id_foreign` (`user_id`),
  ADD KEY `inquiries_category_id_foreign` (`category_id`);

--
-- Indeks untuk tabel `inquiry_replies`
--
ALTER TABLE `inquiry_replies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inquiry_replies_inquiry_id_foreign` (`inquiry_id`),
  ADD KEY `inquiry_replies_user_id_foreign` (`user_id`);

--
-- Indeks untuk tabel `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indeks untuk tabel `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indeks untuk tabel `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `inquiries`
--
ALTER TABLE `inquiries`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `inquiry_replies`
--
ALTER TABLE `inquiry_replies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT untuk tabel `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `inquiries`
--
ALTER TABLE `inquiries`
  ADD CONSTRAINT `inquiries_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inquiries_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `inquiry_replies`
--
ALTER TABLE `inquiry_replies`
  ADD CONSTRAINT `inquiry_replies_inquiry_id_foreign` FOREIGN KEY (`inquiry_id`) REFERENCES `inquiries` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inquiry_replies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
