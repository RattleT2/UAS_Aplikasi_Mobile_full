@extends('layouts.dashboard')
@section('title', 'Dashboard - WebSpace Support')
@section('page_title', 'Tiket Saya')

@section('page_content')
<button id="createTicketBtn" onclick="openCreateModal()" class="mb-6 inline-flex items-center gap-2 px-4 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-lg transition-colors shadow-sm">
    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
    Buat Tiket Baru
</button>

<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6" id="statsGrid"></div>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-4 border-b border-gray-100 flex items-center justify-between">
        <h3 class="font-semibold text-gray-800">Daftar Tiket</h3>
        <span class="text-xs text-gray-400" id="ticketCount"></span>
    </div>
    <div id="ticketList" class="divide-y divide-gray-100">
        <div class="p-8 text-center text-gray-400">
            <svg class="w-10 h-10 mx-auto mb-2 opacity-50 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
            <p class="text-sm">Memuat tiket...</p>
        </div>
    </div>
</div>

<div id="createModal" class="fixed inset-0 z-50 hidden items-center justify-center p-4">
    <div class="absolute inset-0 bg-black/50" onclick="closeCreateModal()"></div>
    <div class="relative bg-white rounded-2xl shadow-xl w-full max-w-lg max-h-[90vh] overflow-y-auto fade-in">
        <div class="p-6 border-b border-gray-100 flex items-center justify-between sticky top-0 bg-white rounded-t-2xl z-10">
            <h3 class="text-lg font-bold text-gray-900">Buat Tiket Baru</h3>
            <button onclick="closeCreateModal()" class="p-1.5 hover:bg-gray-100 rounded-lg text-gray-400 hover:text-gray-600">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>
        </div>
        <form id="createForm" class="p-6 space-y-4">
            <div id="createError" class="hidden bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm"></div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1.5">Kategori <span class="text-red-500">*</span></label>
                <select name="category_id" required class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm">
                    <option value="">Pilih kategori</option>
                </select>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Nama</label>
                    <input type="text" name="nama" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1.5">Email</label>
                    <input type="email" name="email" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm">
                </div>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1.5">Website <span class="text-red-500">*</span></label>
                <input type="url" name="website" required placeholder="https://websiteanda.com" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1.5">No. Telepon <span class="text-red-500">*</span></label>
                <input type="text" name="telp" required placeholder="08123456789" class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm">
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1.5">Pesan <span class="text-red-500">*</span></label>
                <textarea name="pesan" required rows="4" placeholder="Jelaskan masalah atau kebutuhan Anda..." class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm resize-none"></textarea>
            </div>
            <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-semibold py-2.5 rounded-lg transition-colors text-sm disabled:opacity-50" id="createBtn">
                <span id="createBtnText">Kirim Tiket</span>
                <span id="createBtnSpinner" class="hidden"><svg class="inline w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg></span>
            </button>
        </form>
    </div>
</div>
@endsection

@push('more_scripts')
<script>
let allTickets = [];

async function loadTickets() {
    const result = await api('GET', '/inquiries');
    if (!result || !result.ok) return;
    const tickets = result.data.data;
    allTickets = tickets;

    document.getElementById('ticketCount').textContent = tickets.length + ' tiket';

    const stats = { open: 0, in_progress: 0, closed: 0 };
    tickets.forEach(t => { if (stats[t.status] !== undefined) stats[t.status]++; });

    document.getElementById('statsGrid').innerHTML = `
        <div class="bg-white rounded-xl border border-gray-200 p-4"><p class="text-xs text-gray-500 mb-1">Total</p><p class="text-2xl font-bold text-gray-800">${tickets.length}</p></div>
        <div class="bg-yellow-50 rounded-xl border border-yellow-200 p-4"><p class="text-xs text-yellow-600 mb-1">Open</p><p class="text-2xl font-bold text-yellow-700">${stats.open}</p></div>
        <div class="bg-blue-50 rounded-xl border border-blue-200 p-4"><p class="text-xs text-blue-600 mb-1">Proses</p><p class="text-2xl font-bold text-blue-700">${stats.in_progress}</p></div>
        <div class="bg-green-50 rounded-xl border border-green-200 p-4"><p class="text-xs text-green-600 mb-1">Closed</p><p class="text-2xl font-bold text-green-700">${stats.closed}</p></div>`;

    if (tickets.length === 0) {
        document.getElementById('ticketList').innerHTML = `<div class="p-12 text-center">
            <svg class="w-14 h-14 mx-auto mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
            <p class="text-gray-400 font-medium">Belum ada tiket</p><p class="text-gray-400 text-sm mt-1">Klik tombol di atas untuk membuat tiket pertama Anda.</p></div>`;
        return;
    }

    document.getElementById('ticketList').innerHTML = tickets.map(t => `
        <a href="/dashboard/tickets/${t.id}" class="block px-6 py-4 hover:bg-gray-50 transition-colors">
            <div class="flex items-start justify-between gap-4">
                <div class="flex-1 min-w-0">
                    <div class="flex items-center gap-2 mb-1">
                        <span class="text-xs text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded font-medium">${t.category?.name || 'Umum'}</span>
                        ${statusBadge(t.status)}
                    </div>
                    <p class="text-sm font-medium text-gray-800 mb-1 truncate">${escapeHtml(t.website)}</p>
                    <p class="text-xs text-gray-500 truncate">${escapeHtml(truncate(t.pesan, 100))}</p>
                </div>
                <div class="text-xs text-gray-400 whitespace-nowrap">${formatDate(t.created_at)}</div>
            </div>
        </a>`).join('');
}

async function loadCategories() {
    const result = await api('GET', '/categories');
    if (!result || !result.ok) return;
    const select = document.querySelector('#createForm select[name="category_id"]');
    result.data.data.forEach(c => {
        select.innerHTML += `<option value="${c.id}">${c.name}</option>`;
    });
}

function openCreateModal() {
    document.getElementById('createModal').classList.remove('hidden');
    document.getElementById('createModal').classList.add('flex');
    document.getElementById('createError').classList.add('hidden');
    document.getElementById('createForm').reset();
}

function closeCreateModal() {
    document.getElementById('createModal').classList.add('hidden');
    document.getElementById('createModal').classList.remove('flex');
}

document.getElementById('createForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const btn = document.getElementById('createBtn');
    const error = document.getElementById('createError');
    btn.disabled = true;
    document.getElementById('createBtnText').classList.add('hidden');
    document.getElementById('createBtnSpinner').classList.remove('hidden');
    error.classList.add('hidden');

    const formData = new FormData(this);
    const body = Object.fromEntries(formData);

    const result = await api('POST', '/inquiries', body);
    btn.disabled = false;
    document.getElementById('createBtnText').classList.remove('hidden');
    document.getElementById('createBtnSpinner').classList.add('hidden');

    if (!result.ok) {
        const msg = result.data?.data ? Object.values(result.data.data).flat().join('<br>') : (result.data?.message || 'Gagal membuat tiket.');
        error.innerHTML = msg;
        error.classList.remove('hidden');
        return;
    }
    closeCreateModal();
    showToast('Tiket berhasil dibuat!');
    loadTickets();
});

function escapeHtml(text) {
    const d = document.createElement('div');
    d.textContent = text;
    return d.innerHTML;
}

loadTickets();
loadCategories();
</script>
@endpush
