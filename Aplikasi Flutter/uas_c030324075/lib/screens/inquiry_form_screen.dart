import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/custom_widgets.dart';

class InquiryFormScreen extends StatefulWidget {
  const InquiryFormScreen({super.key});

  @override
  State<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends State<InquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _telpController = TextEditingController();
  final _pesanController = TextEditingController();
  final _apiService = ApiService();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _isLoading = false;
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadUserData();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _apiService.getCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memuat kategori')),
        );
      }
    }
  }

  Future<void> _loadUserData() async {
    final user = await _apiService.getStoredUser();
    if (user != null && mounted) {
      setState(() {
        _namaController.text = user.name;
        _emailController.text = user.email;
      });
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _telpController.dispose();
    _pesanController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kategori terlebih dahulu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Normalize website: auto-prefix https:// if user omitted scheme
      String websiteValue = _websiteController.text.trim();
      if (websiteValue.isNotEmpty && !websiteValue.startsWith(RegExp(r'https?://'))) {
        websiteValue = 'https://$websiteValue';
      }

      final response = await _apiService.createInquiry(
        categoryId: _selectedCategory!.id,
        nama: _namaController.text.trim(),
        email: _emailController.text.trim(),
        website: websiteValue,
        telp: _telpController.text.trim(),
        pesan: _pesanController.text.trim(),
      );

      if (!mounted) return;

      if (response.status) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tiket berhasil dibuat!')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateNama(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Nama tidak boleh kosong';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Format email Invalid';
    }
    if (!ApiService.isValidEmail(value!)) {
      return 'Format email Invalid';
    }
    return null;
  }

  String? _validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak valid';
    }

    // Accept domain-only input by testing with https:// prefix if needed
    String candidate = value.trim();
    if (!candidate.startsWith(RegExp(r'https?://'))) {
      candidate = 'https://$candidate';
    }

    if (!ApiService.isValidUrl(candidate)) {
      return 'URL tidak valid';
    }

    return null;
  }

  String? _validateTelp(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Nomor HP hanya boleh angka';
    }
    if (!ApiService.isValidPhoneNumber(value!)) {
      return 'Nomor HP hanya boleh angka';
    }
    return null;
  }

  String? _validatePesan(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Pesan tidak boleh kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        title: const Text(
          'Buat Tiket Support',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _isLoadingCategories
                ? const Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Dropdown
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<Category>(
                            isExpanded: true,
                            value: _selectedCategory,
                            hint: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('Pilih Kategori'),
                            ),
                            items: _categories.map((category) {
                              return DropdownMenuItem<Category>(
                                value: category,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(category.name),
                                ),
                              );
                            }).toList(),
                            onChanged: (category) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            underline: const SizedBox(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nama
                        TextFormField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama',
                            hintText: 'Aris Samaudin',
                            prefixIcon: const Icon(Icons.person, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: _validateNama,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'warunghebalar',
                            errorStyle: const TextStyle(color: Colors.red),
                            prefixIcon: const Icon(Icons.email, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // Website
                        TextFormField(
                          controller: _websiteController,
                          decoration: InputDecoration(
                            labelText: 'Website',
                            hintText: 'warunghebalar.net',
                            errorStyle: const TextStyle(color: Colors.red),
                            prefixIcon: const Icon(Icons.language, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: _validateWebsite,
                        ),
                        const SizedBox(height: 16),

                        // Telp
                        TextFormField(
                          controller: _telpController,
                          decoration: InputDecoration(
                            labelText: 'Telp',
                            hintText: '081-8680099',
                            errorStyle: const TextStyle(color: Colors.red),
                            prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.phone,
                          validator: _validateTelp,
                        ),
                        const SizedBox(height: 16),

                        // Pesan
                        TextFormField(
                          controller: _pesanController,
                          decoration: InputDecoration(
                            labelText: 'Pesan',
                            hintText: 'Deskripsi masalah Anda...',
                            errorStyle: const TextStyle(color: Colors.red),
                            prefixIcon: const Icon(Icons.message, color: Colors.blue),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          maxLines: 5,
                          validator: _validatePesan,
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        CustomButton(
                          text: 'Kirim Tiket',
                          onPressed: _submitForm,
                          isLoading: _isLoading,
                          width: double.infinity,
                          color: Colors.blue.shade600,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
