@extends('layouts.app')
@section('title', 'Login - WebSpace Support')

@section('content')
<div class="min-h-screen flex">
    <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-indigo-600 via-indigo-700 to-purple-800 items-center justify-center p-12 relative overflow-hidden">
        <div class="absolute inset-0 opacity-10">
            <div class="absolute top-20 left-10 w-72 h-72 bg-white rounded-full blur-3xl"></div>
            <div class="absolute bottom-10 right-10 w-96 h-96 bg-purple-300 rounded-full blur-3xl"></div>
        </div>
        <div class="relative text-white text-center max-w-md">
            <div class="w-20 h-20 bg-white/20 backdrop-blur rounded-2xl flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/></svg>
            </div>
            <h1 class="text-4xl font-bold mb-3">WebSpace Support</h1>
            <p class="text-lg text-indigo-200">Solusi lengkap untuk kebutuhan website Anda. Ajukan tiket support, konsultasi, dan kelola layanan dalam satu tempat.</p>
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
            <h2 class="text-2xl font-bold text-gray-900 mb-1">Selamat Datang</h2>
            <p class="text-gray-500 mb-8">Masuk ke akun Anda untuk melanjutkan</p>
            <form id="loginForm" class="space-y-4">
                <div id="loginError" class="hidden bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm"></div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Email</label>
                    <input type="email" name="email" required placeholder="email@example.com"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Password</label>
                    <input type="password" name="password" required placeholder="********"
                        class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                </div>
                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2.5 rounded-lg transition-colors text-sm disabled:opacity-50" id="loginBtn">
                    <span id="loginText">Masuk</span>
                    <span id="loginSpinner" class="hidden"><svg class="inline w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg></span>
                </button>
            </form>
            <p class="mt-6 text-center text-sm text-gray-500">
                Belum punya akun? <a href="/register" class="text-indigo-600 font-medium hover:text-indigo-700">Daftar</a>
            </p>
            <div class="mt-6 p-4 bg-gray-50 rounded-lg">
                <p class="text-xs font-medium text-gray-500 mb-2">Akun Demo:</p>
                <div class="text-xs text-gray-600 space-y-1">
                    <p>Admin: <span class="font-mono text-indigo-600">admin@webspace.test</span> / password</p>
                    <p>User: <span class="font-mono text-indigo-600">user@webspace.test</span> / password</p>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
document.getElementById('loginForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const btn = document.getElementById('loginBtn');
    const error = document.getElementById('loginError');
    btn.disabled = true;
    document.getElementById('loginText').classList.add('hidden');
    document.getElementById('loginSpinner').classList.remove('hidden');
    error.classList.add('hidden');

    const formData = new FormData(this);
    const body = Object.fromEntries(formData);

    const result = await api('POST', '/login', body);
    btn.disabled = false;
    document.getElementById('loginText').classList.remove('hidden');
    document.getElementById('loginSpinner').classList.add('hidden');

    if (!result.ok) {
        error.textContent = result.data?.message || 'Login gagal. Periksa kembali email dan password.';
        error.classList.remove('hidden');
        return;
    }
    setToken(result.data.data.token);
    setUser(result.data.data.user);
    window.location.href = result.data.data.user.role === 'admin' ? '/admin' : '/dashboard';
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
