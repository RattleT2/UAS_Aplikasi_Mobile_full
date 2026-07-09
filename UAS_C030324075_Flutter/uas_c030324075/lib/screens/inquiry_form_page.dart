import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InquiryFormPage extends StatefulWidget {
  final String token; // Token JWT dari login

  const InquiryFormPage({Key? key, required this.token}) : super(key: key);

  @override
  State<InquiryFormPage> createState() => _InquiryFormPageState();
}

class _InquiryFormPageState extends State<InquiryFormPage> {
  // TextEditingController untuk setiap field
  final TextEditingController namaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController telpController = TextEditingController();
  final TextEditingController pesanController = TextEditingController();

  // FocusNode untuk better UX
  final FocusNode namaFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode websiteFocus = FocusNode();
  final FocusNode telpFocus = FocusNode();
  final FocusNode pesanFocus = FocusNode();

  // State untuk error handling
  Map<String, String> errors = {};
  bool isLoading = false;
  String? successMessage;

  // API Configuration
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const int categoryId = 3; // Hardcode category: Bantuan Teknis

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    websiteController.dispose();
    telpController.dispose();
    pesanController.dispose();
    namaFocus.dispose();
    emailFocus.dispose();
    websiteFocus.dispose();
    telpFocus.dispose();
    pesanFocus.dispose();
    super.dispose();
  }

  /// Fungsi untuk submit form ke API
  Future<void> submitForm() async {
    // Clear previous errors & messages
    setState(() {
      errors.clear();
      successMessage = null;
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inquiries'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'category_id': categoryId,
          'nama': namaController.text.trim(),
          'email': emailController.text.trim(),
          'website': websiteController.text.trim(),
          'telp': telpController.text.trim(),
          'pesan': pesanController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        // Success: Inquiry created
        final responseData = jsonDecode(response.body);
        setState(() {
          isLoading = false;
          successMessage =
              responseData['message'] ?? 'Tiket berhasil dibuat!';
        });

        // Clear form
        namaController.clear();
        emailController.clear();
        websiteController.clear();
        telpController.clear();
        pesanController.clear();

        // Show snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage!),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );

          // Optional: Navigate back after delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else if (response.statusCode == 422) {
        // Validation error
        final responseData = jsonDecode(response.body);
        final errorData = responseData['data'] as Map<String, dynamic>?;

        setState(() {
          isLoading = false;
          // Parse error messages
          if (errorData != null) {
            errorData.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                errors[key] = value[0].toString();
              }
            });
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Validasi gagal. Periksa kembali form Anda.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token tidak valid. Silakan login kembali.'),
              backgroundColor: Colors.red,
            ),
          );
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) Navigator.pop(context);
          });
        }
      } else {
        // Other errors
        setState(() => isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Widget untuk build text field dengan error handling
  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required String fieldKey,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final hasError = errors.containsKey(fieldKey);
    final errorMessage = errors[fieldKey];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          maxLines: maxLines,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            // Clear error when user starts typing
            if (hasError) {
              setState(() {
                errors.remove(fieldKey);
              });
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.blue,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: suffixIcon,
          ),
        ),
        // Error message
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          'Form Pengaduan',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Silakan isi form berikut untuk mengirim pengaduan Anda. Kami akan merespons dalam waktu 24 jam.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Success message
              if (successMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          successMessage!,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (successMessage != null) const SizedBox(height: 20),

              // Form fields
              buildTextField(
                label: 'Nama',
                controller: namaController,
                focusNode: namaFocus,
                fieldKey: 'nama',
                keyboardType: TextInputType.name,
                hintText: 'Masukkan nama lengkap Anda',
              ),
              buildTextField(
                label: 'Email',
                controller: emailController,
                focusNode: emailFocus,
                fieldKey: 'email',
                keyboardType: TextInputType.emailAddress,
                hintText: 'contoh@email.com',
              ),
              buildTextField(
                label: 'Website',
                controller: websiteController,
                focusNode: websiteFocus,
                fieldKey: 'website',
                keyboardType: TextInputType.url,
                hintText: 'https://example.com',
              ),
              buildTextField(
                label: 'Telp',
                controller: telpController,
                focusNode: telpFocus,
                fieldKey: 'telp',
                keyboardType: TextInputType.phone,
                hintText: '081234567890',
              ),
              buildTextField(
                label: 'Pesan',
                controller: pesanController,
                focusNode: pesanFocus,
                fieldKey: 'pesan',
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                hintText: 'Jelaskan detail pengaduan Anda di sini...',
              ),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    disabledBackgroundColor: Colors.grey.shade400,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Kirim',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Additional info
              Center(
                child: Text(
                  'Anda akan menerima email konfirmasi segera.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
