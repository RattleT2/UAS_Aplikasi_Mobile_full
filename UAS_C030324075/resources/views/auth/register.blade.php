@extends('layouts.app')
@section('title', 'Daftar - WebSpace Support')

@section('content')
<div class="min-h-screen flex">
    <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-purple-600 via-indigo-700 to-indigo-800 items-center justify-center p-12 relative overflow-hidden">
        <div class="absolute inset-0 opacity-10">
            <div class="absolute top-20 left-10 w-72 h-72 bg-white rounded-full blur-3xl"></div>
            <div class="absolute bottom-10 right-10 w-96 h-96 bg-indigo-300 rounded-full blur-3xl"></div>
        </div>
        <div class="relative text-white text-center max-w-md">
            <div class="w-20 h-20 bg-white/20 backdrop-blur rounded-2xl flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z"/></svg>
            </div>
            <h1 class="text-4xl font-bold mb-3">Bergabung Sekarang</h1>
            <p class="text-lg text-indigo-200">Daftar akun baru dan mulai ajukan tiket support untuk website Anda. Gratis dan mudah.</p>
        </div>
    </div>
    <div class="flex-1 flex items-center justify-center p-6 bg-white">
        <div class="w-full max-w-sm">
            <div class="lg:hidden text-center mb-8">
                <div class="w-14 h-14 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center mx-auto mb-3">
                    <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/></svg>
                </div>
                <h1 class="text-2xl font-bold text-gray-900">WebSpace Support</h1>
            </div>
            <h2 class="text-2xl font-bold text-gray-900 mb-1">Buat Akun</h2>
            <p class="text-gray-500 mb-8">Daftar untuk mulai menggunakan layanan</p>
            <form id="registerForm" class="space-y-4">
                <div id="registerError" class="hidden bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm"></div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Nama Lengkap</label>
                    <input type="text" name="name" required placeholder="Nama Anda"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Email</label>
                    <input type="email" name="email" required placeholder="email@example.com"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Password</label>
                    <input type="password" name="password" required placeholder="Minimal 6 karakter"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Konfirmasi Password</label>
                    <input type="password" name="password_confirmation" required placeholder="Ulangi password"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2.5 rounded-lg transition-colors text-sm disabled:opacity-50" id="registerBtn">
                    <span id="registerText">Daftar</span>
                    <span id="registerSpinner" class="hidden"><svg class="inline w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg></span>
                </button>
            </form>
            <p class="mt-6 text-center text-sm text-gray-500">
                Sudah punya akun? <a href="/login" class="text-indigo-600 font-medium hover:text-indigo-700">Masuk</a>
            </p>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
document.getElementById('registerForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const btn = document.getElementById('registerBtn');
    const error = document.getElementById('registerError');
    btn.disabled = true;
    document.getElementById('registerText').classList.add('hidden');
    document.getElementById('registerSpinner').classList.remove('hidden');
    error.classList.add('hidden');

    const formData = new FormData(this);
    const body = Object.fromEntries(formData);

    if (body.password !== body.password_confirmation) {
        error.textContent = 'Konfirmasi password tidak cocok.';
        error.classList.remove('hidden');
        btn.disabled = false;
        document.getElementById('registerText').classList.remove('hidden');
        document.getElementById('registerSpinner').classList.add('hidden');
        return;
    }

    const result = await api('POST', '/register', body);
    btn.disabled = false;
    document.getElementById('registerText').classList.remove('hidden');
    document.getElementById('registerSpinner').classList.add('hidden');

    if (!result.ok) {
        const msg = result.data?.data ? Object.values(result.data.data).flat().join('<br>') : (result.data?.message || 'Registrasi gagal.');
        error.innerHTML = msg;
        error.classList.remove('hidden');
        return;
    }
    setToken(result.data.data.token);
    setUser(result.data.data.user);
    window.location.href = '/dashboard';
});

async function api(method, url, body = null) {
    const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' };
    const opts = { method, headers };
    if (body) opts.body = JSON.stringify(body);
    try {
        const res = await fetch('/api' + url, opts);
        const data = await res.json();
        return { status: res.status, ok: res.ok, data };
    } catch(e) {
        return { status: 0, ok: false, data: null };
    }
}
</script>
@endpush
