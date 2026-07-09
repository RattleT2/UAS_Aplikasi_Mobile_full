@extends('layouts.dashboard')
@section('title', 'Detail Tiket Admin - WebSpace Support')
@section('page_title', 'Detail Tiket')

@section('page_content')
<div id="ticketDetail" class="max-w-3xl mx-auto">
    <div class="p-12 text-center text-gray-400">
        <svg class="w-10 h-10 mx-auto mb-2 opacity-50 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
        Memuat tiket...
    </div>
</div>
<div id="replySection" class="max-w-3xl mx-auto mt-6 hidden">
    <div class="bg-white rounded-xl shadow-sm border border-gray-200 p-6">
        <h4 class="font-semibold text-gray-800 mb-4">Kirim Balasan</h4>
        <form id="replyForm">
            <div id="replyError" class="hidden bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm mb-3"></div>
            <textarea name="message" rows="3" required placeholder="Tulis balasan..."
                class="w-full px-4 py-2.5 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none text-sm resize-none"></textarea>
            <button type="submit" class="mt-3 px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-semibold rounded-lg transition-colors disabled:opacity-50" id="replyBtn">
                <span id="replyBtnText">Kirim Balasan</span>
                <span id="replyBtnSpinner" class="hidden"><svg class="inline w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg></span>
            </button>
        </form>
    </div>
</div>
@endsection

@push('more_scripts')
<script>
const ticketId = window.location.pathname.split('/').pop();

async function loadTicket() {
    const result = await api('GET', '/admin/inquiries/' + ticketId);
    if (!result || !result.ok) {
        document.getElementById('ticketDetail').innerHTML = '<div class="p-12 text-center text-red-500">Tiket tidak ditemukan atau akses ditolak.</div>';
        return;
    }
    const t = result.data.data;
    const user = getUser();

    document.getElementById('pageTitle').textContent = 'Tiket #' + t.id;

    document.getElementById('ticketDetail').innerHTML = `
        <a href="/admin" class="inline-flex items-center gap-1 text-sm text-gray-500 hover:text-indigo-600 mb-4 transition-colors">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg> Kembali
        </a>
        <div class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden mb-6">
            <div class="p-6 border-b border-gray-100">
                <div class="flex flex-wrap items-center justify-between gap-3 mb-3">
                    <div class="flex flex-wrap items-center gap-2">
                        <span class="text-sm text-indigo-600 bg-indigo-50 px-3 py-1 rounded-lg font-medium">${escapeHtml(t.category?.name || 'Umum')}</span>
                        ${statusBadge(t.status)}
                    </div>
                    <div class="flex items-center gap-2">
                        <span class="text-xs text-gray-400">Status:</span>
                        <select onchange="updateStatus(this.value)" class="px-3 py-1.5 border border-gray-300 rounded-lg text-xs font-medium focus:ring-2 focus:ring-indigo-500 outline-none" id="statusSelect">
                            <option value="open" ${t.status === 'open' ? 'selected' : ''}>Open</option>
                            <option value="in_progress" ${t.status === 'in_progress' ? 'selected' : ''}>In Progress</option>
                            <option value="closed" ${t.status === 'closed' ? 'selected' : ''}>Closed</option>
                        </select>
                    </div>
                </div>
                <div class="bg-gray-50 rounded-lg p-4 mb-3">
                    <p class="text-xs text-gray-500 mb-1">Diajukan oleh:</p>
                    <div class="flex items-center gap-3">
                        <div class="w-9 h-9 rounded-full bg-slate-500 flex items-center justify-center text-white text-xs font-semibold">
                            ${(t.user?.name || '?').charAt(0).toUpperCase()}
                        </div>
                        <div>
                            <p class="text-sm font-semibold text-gray-800">${escapeHtml(t.user?.name || '-')}</p>
                            <p class="text-xs text-gray-500">${escapeHtml(t.user?.email || '-')}</p>
                        </div>
                    </div>
                </div>
                <h3 class="text-lg font-semibold text-gray-900 mb-2">${escapeHtml(t.website)}</h3>
                <p class="text-sm text-gray-600">${escapeHtml(t.pesan)}</p>
                <div class="mt-4 flex flex-wrap gap-4 text-xs text-gray-500">
                    <span>Nama: ${escapeHtml(t.nama || '-')}</span>
                    <span>Email: ${escapeHtml(t.email || '-')}</span>
                    <span>Telp: ${escapeHtml(t.telp || '-')}</span>
                </div>
            </div>
            <div class="p-6">
                <h4 class="text-sm font-semibold text-gray-800 mb-4 flex items-center gap-2" id="repliesHeader">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/></svg>
                    Percakapan (<span id="repliesCount">${t.replies?.length || 0}</span>)
                </h4>
                <div id="repliesContainer">
                    ${renderReplies(t.replies || [], user)}
                </div>
            </div>
        </div>`;

    document.getElementById('replySection').classList.remove('hidden');
}

function renderReplies(replies, currentUser) {
    if (!replies || replies.length === 0) {
        return '<p class="text-sm text-gray-400 text-center py-6">Belum ada balasan.</p>';
    }
    return replies.map(r => renderReply(r, currentUser)).join('');
}

function renderReply(r, currentUser) {
    const isCurrentUser = r.user?.id === currentUser?.id;
    return `
    <div class="flex gap-3 mb-4 ${isCurrentUser ? 'flex-row-reverse' : ''} slide-in">
        <div class="w-8 h-8 rounded-full flex-shrink-0 flex items-center justify-center text-white text-xs font-semibold ${isCurrentUser ? 'bg-indigo-500' : 'bg-slate-500'}">
            ${(r.user?.name || '?').charAt(0).toUpperCase()}
        </div>
        <div class="${isCurrentUser ? 'bg-indigo-50 border-indigo-100' : 'bg-gray-50 border-gray-100'} border rounded-2xl px-4 py-3 max-w-[75%] ${isCurrentUser ? 'rounded-tr-md' : 'rounded-tl-md'}">
            <div class="flex items-center gap-2 mb-1">
                <span class="text-xs font-semibold text-gray-700">${escapeHtml(r.user?.name || 'Unknown')}</span>
                <span class="text-[10px] text-gray-400">${formatDate(r.created_at)}</span>
            </div>
            <p class="text-sm text-gray-700 whitespace-pre-wrap">${escapeHtml(r.message)}</p>
        </div>
    </div>`;
}

function appendReply(reply) {
    const container = document.getElementById('repliesContainer');
    const countEl = document.getElementById('repliesCount');
    const user = getUser();
    if (container && reply) {
        const emptyMsg = container.querySelector('.py-6');
        if (emptyMsg) container.innerHTML = '';
        container.insertAdjacentHTML('beforeend', renderReply(reply, user));
        if (countEl) countEl.textContent = parseInt(countEl.textContent) + 1;
    }
}

async function updateStatus(newStatus) {
    const result = await api('PUT', '/admin/inquiries/' + ticketId + '/status', { status: newStatus });
    if (result && result.ok) {
        showToast('Status tiket diperbarui!');
        loadTicket();
    } else {
        showToast('Gagal memperbarui status.', 'error');
    }
}

document.getElementById('replyForm').addEventListener('submit', async function(e) {
    e.preventDefault();
    const btn = document.getElementById('replyBtn');
    const error = document.getElementById('replyError');
    const formData = new FormData(this);
    const body = { message: formData.get('message') };

    btn.disabled = true;
    document.getElementById('replyBtnText').classList.add('hidden');
    document.getElementById('replyBtnSpinner').classList.remove('hidden');
    error.classList.add('hidden');

    const result = await api('POST', '/inquiries/' + ticketId + '/replies', body);
    btn.disabled = false;
    document.getElementById('replyBtnText').classList.remove('hidden');
    document.getElementById('replyBtnSpinner').classList.add('hidden');

    if (!result || !result.ok) {
        error.textContent = result?.data?.message || 'Gagal mengirim balasan.';
        error.classList.remove('hidden');
        return;
    }
    this.reset();
    showToast('Balasan terkirim!');
    appendReply(result.data.data);
});

function escapeHtml(text) {
    const d = document.createElement('div');
    d.textContent = text;
    return d.innerHTML;
}

loadTicket();
</script>
@endpush
