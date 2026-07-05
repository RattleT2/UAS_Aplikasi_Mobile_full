<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Inquiry;
use App\Models\InquiryReply;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    public function run(): void
    {
        $admin = User::create([
            'name' => 'Admin WebSpace',
            'email' => 'admin@webspace.test',
            'password' => bcrypt('password'),
            'role' => 'admin',
        ]);

        $user = User::create([
            'name' => 'User Demo',
            'email' => 'user@webspace.test',
            'password' => bcrypt('password'),
            'role' => 'user',
        ]);

        $categories = [
            ['name' => 'Beli Domain', 'slug' => 'beli-domain'],
            ['name' => 'Sewa Hosting', 'slug' => 'sewa-hosting'],
            ['name' => 'Bantuan Teknis', 'slug' => 'bantuan-teknis'],
            ['name' => 'Konsultasi Website', 'slug' => 'konsultasi-website'],
            ['name' => 'Lainnya', 'slug' => 'lainnya'],
        ];

        foreach ($categories as $cat) {
            Category::create($cat);
        }

        $inquiry1 = Inquiry::create([
            'user_id' => $user->id,
            'category_id' => 3,
            'nama' => 'User Demo',
            'email' => 'user@webspace.test',
            'website' => 'https://websaya.id',
            'telp' => '081234567890',
            'pesan' => 'Website saya tiba-tiba error 500 setelah update plugin. Mohon bantuannya.',
            'status' => 'open',
        ]);

        $inquiry2 = Inquiry::create([
            'user_id' => $user->id,
            'category_id' => 2,
            'nama' => 'User Demo',
            'email' => 'user@webspace.test',
            'website' => 'https://tokoonline.id',
            'telp' => '081234567890',
            'pesan' => 'Saya ingin upgrade paket hosting dari Starter ke Business karena traffic website meningkat.',
            'status' => 'in_progress',
        ]);

        $inquiry3 = Inquiry::create([
            'user_id' => $user->id,
            'category_id' => 1,
            'nama' => 'User Demo',
            'email' => 'user@webspace.test',
            'website' => 'https://brandbaru.id',
            'telp' => '081234567890',
            'pesan' => 'Saya sudah transfer untuk pembelian domain brandbaru.id. Mohon konfirmasi.',
            'status' => 'closed',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry1->id,
            'user_id' => $user->id,
            'message' => 'Ini screenshot error-nya: [terlampir]. Semua plugin sudah saya nonaktifkan tapi tetap error.',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry1->id,
            'user_id' => $admin->id,
            'message' => 'Baik Pak, kami akan cek log server Anda. Mohon tunggu sebentar ya. Apakah ada akses cPanel yang bisa kami gunakan?',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry2->id,
            'user_id' => $user->id,
            'message' => 'Traffic saya naik dari 1000 ke 5000 pengunjung per hari. Paket Starter sudah tidak cukup.',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry2->id,
            'user_id' => $admin->id,
            'message' => 'Baik, kami proses upgrade ke paket Business. Biaya tambahan Rp 50.000/bulan akan ditagihkan di invoice berikutnya. Upgrade selesai dalam 1x24 jam.',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry3->id,
            'user_id' => $user->id,
            'message' => 'Saya sudah transfer Rp 150.000 ke rekening BCA atas nama WebSpace. Berikut bukti transfernya.',
        ]);

        InquiryReply::create([
            'inquiry_id' => $inquiry3->id,
            'user_id' => $admin->id,
            'message' => 'Pembayaran sudah kami terima dan diverifikasi. Domain brandbaru.id sudah aktif. Silakan cek di https://brandbaru.id. Terima kasih!',
        ]);
    }
}
