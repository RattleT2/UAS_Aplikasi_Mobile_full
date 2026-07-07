import 'package:flutter/material.dart';
import '../models/inquiry.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'admin_ticket_detail_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _apiService = ApiService();
  User? _user;
  List<Inquiry> _allInquiries = [];
  List<Inquiry> _filteredInquiries = [];
  String _statusFilter = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _apiService.getStoredUser();
    final inquiries = await _apiService.getAllInquiries();
    if (mounted) {
      setState(() {
        _user = user;
        _allInquiries = inquiries;
        _filteredInquiries = _statusFilter.isEmpty
            ? inquiries
            : inquiries.where((i) => i.status == _statusFilter).toList();
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String status) {
    setState(() {
      _statusFilter = status;
      _filteredInquiries = status.isEmpty
          ? _allInquiries
          : _allInquiries.where((i) => i.status == status).toList();
    });
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _apiService.logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  int _countStatus(String status) =>
      _allInquiries.where((i) => i.status == status).length;

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _logout),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.admin_panel_settings, size: 32, color: Colors.blue.shade600),
                ),
                const SizedBox(height: 10),
                Text(
                  _user?.name ?? 'Admin',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Text(
                  _user?.email ?? '',
                  style: const TextStyle(fontSize: 13, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard('Total', _allInquiries.length.toString(), Colors.white),
                    const SizedBox(width: 10),
                    _buildStatCard('Open', _countStatus('open').toString(), Colors.orange.shade100),
                    const SizedBox(width: 10),
                    _buildStatCard('Proses', _countStatus('in_progress').toString(), Colors.blue.shade100),
                    const SizedBox(width: 10),
                    _buildStatCard('Closed', _countStatus('closed').toString(), Colors.green.shade100),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Text('Status:', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 12),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua', ''),
                        _buildFilterChip('Open', 'open'),
                        _buildFilterChip('Proses', 'in_progress'),
                        _buildFilterChip('Closed', 'closed'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: _filteredInquiries.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text('Tidak ada tiket', style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredInquiries.length,
                      itemBuilder: (context, index) {
                        final inquiry = _filteredInquiries[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AdminTicketDetailScreen(inquiryId: inquiry.id),
                                ),
                              );
                              _loadData();
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          inquiry.category.name,
                                          style: TextStyle(fontSize: 11, color: Colors.blue.shade600, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(inquiry.status).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          _getStatusLabel(inquiry.status),
                                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _getStatusColor(inquiry.status)),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text('#${inquiry.id}', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    inquiry.website,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    inquiry.pesan,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'oleh: ${inquiry.user?.name ?? '-'} (${inquiry.user?.email ?? '-'})',
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _statusFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : Colors.grey.shade700)),
        selected: isSelected,
        onSelected: (_) => _applyFilter(value),
        selectedColor: Colors.blue.shade600,
        backgroundColor: Colors.grey.shade100,
        checkmarkColor: Colors.white,
      ),
    );
  }
}
