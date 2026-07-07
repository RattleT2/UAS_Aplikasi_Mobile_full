@extends('layouts.app')

@section('content')
<div class="flex h-screen overflow-hidden">
    <aside class="fixed inset-y-0 left-0 w-64 bg-slate-900 z-30 transform -translate-x-full lg:translate-x-0 transition-transform duration-200 ease-in-out flex flex-col" id="sidebar">
        <div class="flex items-center gap-3 px-5 py-5 border-b border-slate-700/50">
            <div class="w-9 h-9 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-lg flex items-center justify-center">
                <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/></svg>
            </div>
            <span class="text-white font-bold text-lg tracking-tight">WebSpace</span>
        </div>
        <nav class="flex-1 px-3 py-4 space-y-1 overflow-y-auto" id="sidebarNav">
        </nav>
        <div class="px-3 py-4 border-t border-slate-700/50">
            <button onclick="logout()" class="flex items-center gap-3 w-full px-3 py-2.5 text-slate-400 hover:text-red-400 hover:bg-slate-800 rounded-lg transition-colors text-sm font-medium">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                Keluar
            </button>
        </div>
    </aside>
    <div class="flex-1 flex flex-col lg:ml-64">
        <header class="sticky top-0 z-20 bg-white border-b border-gray-200 px-4 lg:px-8 py-3 flex items-center justify-between shadow-sm">
            <div class="flex items-center gap-3">
                <button onclick="toggleSidebar()" class="lg:hidden p-2 -ml-2 rounded-lg hover:bg-gray-100 text-gray-500">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
                </button>
                <h1 class="text-lg font-semibold text-gray-800" id="pageTitle">@yield('page_title', 'Dashboard')</h1>
            </div>
            <div class="flex items-center gap-4">
                <span class="text-sm text-gray-500 hidden sm:block" id="headerRole"></span>
                <div class="flex items-center gap-2">
                    <div class="w-8 h-8 bg-primary-100 rounded-full flex items-center justify-center">
                        <span class="text-primary-700 text-sm font-semibold" id="headerInitials">U</span>
                    </div>
                    <span class="text-sm font-medium text-gray-700 hidden sm:block" id="headerName">User</span>
                </div>
            </div>
        </header>
        <main class="flex-1 overflow-y-auto p-4 lg:p-8" id="mainContent">
            @yield('page_content')
        </main>
    </div>
</div>
<div class="fixed inset-0 bg-black/50 z-20 hidden" id="sidebarOverlay" onclick="toggleSidebar()"></div>
<script>
const API_BASE = '/api';

async function api(method, url, body = null) {
    const headers = { 'Accept': 'application/json', 'Content-Type': 'application/json' };
    const token = getToken();
    if (token) headers['Authorization'] = 'Bearer ' + token;
    const opts = { method, headers };
    if (body) opts.body = JSON.stringify(body);
    try {
        const res = await fetch(API_BASE + url, opts);
        const data = await res.json();
        if (res.status === 401) { clearAuth(); window.location.href = '/login'; return null; }
        return { status: res.status, ok: res.ok, data };
    } catch(e) {
        return { status: 0, ok: false, data: null, error: 'Network error' };
    }
}

function logout() {
    api('POST', '/logout').finally(() => {
        clearAuth();
        window.location.href = '/login';
    });
}

function formatDate(d) {
    if (!d) return '-';
    return new Date(d).toLocaleDateString('id-ID', { day:'numeric', month:'short', year:'numeric', hour:'2-digit', minute:'2-digit' });
}

function statusBadge(status) {
    const map = {
        open: 'bg-yellow-100 text-yellow-800 border-yellow-200',
        in_progress: 'bg-blue-100 text-blue-800 border-blue-200',
        closed: 'bg-green-100 text-green-800 border-green-200'
    };
    const label = { open:'Open', in_progress:'Proses', closed:'Closed' };
    return `<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${map[status] || ''}">${label[status] || status}</span>`;
}

function truncate(str, len = 80) {
    if (!str) return '';
    return str.length > len ? str.substring(0, len) + '...' : str;
}

function showToast(message, type = 'success') {
    const colors = { success:'bg-green-500', error:'bg-red-500', info:'bg-blue-500' };
    const toast = document.createElement('div');
    toast.className = `fixed top-4 right-4 z-50 px-5 py-3 rounded-lg text-white text-sm font-medium shadow-lg fade-in ${colors[type] || colors.info}`;
    toast.textContent = message;
    document.body.appendChild(toast);
    setTimeout(() => { toast.remove(); }, 3500);
}

function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('sidebarOverlay');
    sidebar.classList.toggle('-translate-x-full');
    overlay.classList.toggle('hidden');
}

function initDashboard() {
    const user = getUser();
    if (!user || !getToken()) { window.location.href = '/login'; return null; }

    const path = window.location.pathname;
    if (user.role === 'admin' && path.startsWith('/dashboard')) { window.location.href = '/admin'; return null; }
    if (user.role === 'user' && path.startsWith('/admin')) { window.location.href = '/dashboard'; return null; }
    document.getElementById('headerName').textContent = user.name || 'User';
    document.getElementById('headerInitials').textContent = (user.name || 'U').charAt(0).toUpperCase();
    const roleBadge = document.getElementById('headerRole');
    if (user.role === 'admin') {
        roleBadge.innerHTML = '<span class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-700">Admin</span>';
    } else {
        roleBadge.textContent = '';
    }
    const nav = document.getElementById('sidebarNav');
    if (user.role === 'admin') {
        nav.innerHTML = `
            <a href="/admin" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${window.location.pathname === '/admin' || window.location.pathname.startsWith('/admin/tickets') ? 'bg-indigo-50 text-indigo-700' : 'text-slate-300 hover:bg-slate-800 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                Semua Tiket
            </a>`;
    } else {
        nav.innerHTML = `
            <a href="/dashboard" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${window.location.pathname === '/dashboard' || window.location.pathname.startsWith('/dashboard/tickets') ? 'bg-indigo-50 text-indigo-700' : 'text-slate-300 hover:bg-slate-800 hover:text-white'}">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                Tiket Saya
            </a>
            <a href="/dashboard" class="flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors text-slate-300 hover:bg-slate-800 hover:text-white" onclick="document.getElementById('createTicketBtn')?.click(); return false;">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Buat Tiket
            </a>`;
    }
    return user;
}

window.addEventListener('DOMContentLoaded', () => { initDashboard(); });
</script>
@stack('more_scripts')
@endsection
