@extends('layouts.dashboard')
@section('title', 'Admin Dashboard - WebSpace Support')
@section('page_title', 'Semua Tiket')

@section('page_content')
<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6" id="statsGrid"></div>

<div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
    <div class="p-4 border-b border-gray-100 flex flex-wrap items-center justify-between gap-3">
        <h3 class="font-semibold text-gray-800">Daftar Semua Tiket</h3>
        <div class="flex items-center gap-2">
            <select id="statusFilter" onchange="renderTickets()" class="px-3 py-1.5 border border-gray-300 rounded-lg text-xs focus:ring-2 focus:ring-indigo-500 outline-none">
                <option value="">Semua Status</option>
                <option value="open">Open</option>
                <option value="in_progress">Proses</option>
                <option value="closed">Closed</option>
            </select>
            <span class="text-xs text-gray-400" id="ticketCount"></span>
        </div>
    </div>
    <div id="ticketList" class="divide-y divide-gray-100">
        <div class="p-8 text-center text-gray-400">
            <svg class="w-10 h-10 mx-auto mb-2 opacity-50 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
            <p class="text-sm">Memuat tiket...</p>
        </div>
    </div>
</div>
@endsection

@push('more_scripts')
<script>
let allTickets = [];

async function loadTickets() {
    const result = await api('GET', '/admin/inquiries');
    if (!result || !result.ok) {
        if (result && result.status === 403) {
            window.location.href = '/dashboard';
        }
        return;
    }
    allTickets = result.data.data;
    renderTickets();
}

function renderTickets() {
    const filter = document.getElementById('statusFilter').value;
    const tickets = filter ? allTickets.filter(t => t.status === filter) : allTickets;

    const stats = { open: 0, in_progress: 0, closed: 0 };
    allTickets.forEach(t => { if (stats[t.status] !== undefined) stats[t.status]++; });
    document.getElementById('statsGrid').innerHTML = `
        <div class="bg-white rounded-xl border border-gray-200 p-4"><p class="text-xs text-gray-500 mb-1">Total</p><p class="text-2xl font-bold text-gray-800">${allTickets.length}</p></div>
        <div class="bg-yellow-50 rounded-xl border border-yellow-200 p-4"><p class="text-xs text-yellow-600 mb-1">Open</p><p class="text-2xl font-bold text-yellow-700">${stats.open}</p></div>
        <div class="bg-blue-50 rounded-xl border border-blue-200 p-4"><p class="text-xs text-blue-600 mb-1">Proses</p><p class="text-2xl font-bold text-blue-700">${stats.in_progress}</p></div>
        <div class="bg-green-50 rounded-xl border border-green-200 p-4"><p class="text-xs text-green-600 mb-1">Closed</p><p class="text-2xl font-bold text-green-700">${stats.closed}</p></div>`;
    document.getElementById('ticketCount').textContent = tickets.length + ' tiket';

    if (tickets.length === 0) {
        document.getElementById('ticketList').innerHTML = '<div class="p-12 text-center text-gray-400">Tidak ada tiket.</div>';
        return;
    }

    document.getElementById('ticketList').innerHTML = tickets.map(t => `
        <a href="/admin/tickets/${t.id}" class="block px-6 py-4 hover:bg-gray-50 transition-colors">
            <div class="flex items-start justify-between gap-4">
                <div class="flex-1 min-w-0">
                    <div class="flex items-center gap-2 mb-1">
                        <span class="text-xs text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded font-medium">${escapeHtml(t.category?.name || 'Umum')}</span>
                        ${statusBadge(t.status)}
                        <span class="text-xs text-gray-400">#${t.id}</span>
                    </div>
                    <p class="text-sm font-medium text-gray-800 mb-1 truncate">${escapeHtml(t.website)}</p>
                    <p class="text-xs text-gray-500 truncate">${escapeHtml(truncate(t.pesan, 120))}</p>
                    <p class="text-xs text-gray-400 mt-1">oleh: ${escapeHtml(t.user?.name || 'Unknown')} (${escapeHtml(t.user?.email || '-')})</p>
                </div>
                <div class="text-xs text-gray-400 whitespace-nowrap">${formatDate(t.created_at)}</div>
            </div>
        </a>`).join('');
}

function escapeHtml(text) {
    const d = document.createElement('div');
    d.textContent = text;
    return d.innerHTML;
}

loadTickets();
</script>
@endpush
