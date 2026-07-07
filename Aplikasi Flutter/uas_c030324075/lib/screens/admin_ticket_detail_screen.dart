import 'package:flutter/material.dart';
import '../models/inquiry.dart';
import '../services/api_service.dart';

class AdminTicketDetailScreen extends StatefulWidget {
  final int inquiryId;

  const AdminTicketDetailScreen({super.key, required this.inquiryId});

  @override
  State<AdminTicketDetailScreen> createState() => _AdminTicketDetailScreenState();
}

class _AdminTicketDetailScreenState extends State<AdminTicketDetailScreen> {
  final _apiService = ApiService();
  final _replyController = TextEditingController();
  Inquiry? _inquiry;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _loadInquiry();
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _loadInquiry() async {
    final inquiry = await _apiService.getAdminInquiryDetail(widget.inquiryId);
    if (mounted) {
      setState(() {
        _inquiry = inquiry;
        _selectedStatus = inquiry?.status ?? '';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(String newStatus) async {
    if (_inquiry == null) return;
    final success = await _apiService.updateInquiryStatus(_inquiry!.id, newStatus);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status tiket diperbarui!')),
      );
      _loadInquiry();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status.')),
      );
    }
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesan tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final reply = await _apiService.sendReply(
        widget.inquiryId,
        _replyController.text.trim(),
      );

      if (!mounted) return;

      if (reply != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Balasan berhasil dikirim!')),
        );
        _replyController.clear();
        _loadInquiry();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim balasan')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'open': return 'Open';
      case 'in_progress': return 'Proses';
      case 'closed': return 'Closed';
      default: return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'open': return Colors.orange;
      case 'in_progress': return Colors.blue;
      case 'closed': return Colors.green;
      default: return Colors.grey;
    }
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final dt = DateTime.parse(dateStr);
      final months = ['Jan','Feb','Mar','Apr','Mei','Jun','Jul','Agu','Sep','Okt','Nov','Des'];
      return '${dt.day} ${months[dt.month-1]} ${dt.year}, ${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_inquiry == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tiket', style: TextStyle(color: Colors.white))),
        body: const Center(child: Text('Tiket tidak ditemukan atau akses ditolak.', style: TextStyle(color: Colors.red))),
      );
    }

    final inquiry = _inquiry!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        title: Text('Tiket #${inquiry.id}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade400]),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                              child: Text(inquiry.category.name, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: Text(_getStatusLabel(inquiry.status), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _getStatusColor(inquiry.status))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    child: Text((inquiry.user?.name ?? '?')[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inquiry.user?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                      Text(inquiry.user?.email ?? '-', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(inquiry.website, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15)),
                              const SizedBox(height: 6),
                              Text(inquiry.pesan, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text('Status:', style: TextStyle(fontWeight: FontWeight.w600)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                                child: DropdownButton<String>(
                                  value: _selectedStatus,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: const [
                                    DropdownMenuItem(value: 'open', child: Text('Open')),
                                    DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
                                    DropdownMenuItem(value: 'closed', child: Text('Closed')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null && value != inquiry.status) {
                                      _updateStatus(value);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow('Nama', inquiry.nama),
                        _buildInfoRow('Email', inquiry.email),
                        _buildInfoRow('Website', inquiry.website),
                        _buildInfoRow('Telepon', inquiry.telp),
                      ],
                    ),
                  ),
                  Container(height: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Percakapan (${inquiry.replies?.length ?? 0})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 12),
                        if (inquiry.replies == null || inquiry.replies!.isEmpty)
                          const Center(child: Text('Belum ada balasan', style: TextStyle(color: Colors.grey)))
                        else
                          ...inquiry.replies!.map((reply) => _buildReplyBubble(reply)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (inquiry.status != 'closed')
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tulis balasan...',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _isSubmitting ? null : _sendReply,
                    icon: _isSubmitting
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Icon(Icons.send, color: Colors.blue.shade600),
                    style: IconButton.styleFrom(backgroundColor: Colors.blue.shade50, padding: const EdgeInsets.all(12)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 60, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildReplyBubble(Reply reply) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border(left: BorderSide(color: reply.user.role == 'admin' ? Colors.indigo : Colors.blue, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reply.user.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  _formatDate(reply.createdAt),
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(reply.message, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
