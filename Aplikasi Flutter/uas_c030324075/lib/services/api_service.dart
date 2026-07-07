import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_response.dart';
import '../models/category.dart';
import '../models/inquiry.dart';
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  String? _token;

  // Get stored token from SharedPreferences
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  // Set token in memory and SharedPreferences
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Clear token
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Get stored user from SharedPreferences
  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Set user in SharedPreferences
  Future<void> setStoredUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  // Clear stored user
  Future<void> clearStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<bool> _handleAuthError(int statusCode) async {
    if (statusCode == 401) {
      await clearToken();
      await clearStoredUser();
      return true;
    }
    return false;
  }

  // ============== AUTH ENDPOINTS ==============

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

      if (authResponse.status && authResponse.token != null) {
        await setToken(authResponse.token!);
        if (authResponse.user != null) {
          await setStoredUser(authResponse.user!);
        }
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        status: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorBody = jsonDecode(response.body);
        return AuthResponse(
          status: false,
          message: errorBody['message'] ?? 'Login gagal',
        );
      }

      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));

      if (authResponse.status && authResponse.token != null) {
        await setToken(authResponse.token!);
        if (authResponse.user != null) {
          await setStoredUser(authResponse.user!);
        }
      }

      return authResponse;
    } catch (e) {
      return AuthResponse(
        status: false,
        message: 'Error: ${e.toString()}',
      );
    }
  }

  Future<bool> logout() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: await _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        await clearToken();
        await clearStoredUser();
        return true;
      }
      return false;
    } catch (e) {
      await clearToken();
      await clearStoredUser();
      return false;
    }
  }

  // ============== CATEGORY ENDPOINTS ==============

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];
        return data.map((c) => Category.fromJson(c)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ============== INQUIRY ENDPOINTS ==============

  Future<ApiResponse<Inquiry>> createInquiry({
    required int categoryId,
    required String nama,
    required String email,
    required String website,
    required String telp,
    required String pesan,
  }) async {
    try {
      final body = {
        'category_id': categoryId,
        'nama': nama,
        'email': email,
        'website': website,
        'telp': telp,
        'pesan': pesan,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/inquiries'),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode(body),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 201 && json['status'] == true) {
        final inquiry = Inquiry.fromJson(json['data']);
        return ApiResponse(
          status: true,
          message: json['message'],
          data: inquiry,
        );
      }

      // Handle validation errors (status 422)
      if (response.statusCode == 422) {
            final errors = json['data'] as Map<String, dynamic>?;
        String errorMessage = json['message'] ?? 'Validasi gagal';
        
        if (errors != null && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first.toString();
          }
        }

        return ApiResponse(
          status: false,
          message: errorMessage,
          data: null,
        );
      }

      return ApiResponse(
        status: false,
        message: json['message'] ?? 'Gagal membuat inquiry',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        status: false,
        message: 'Error: ${e.toString()}',
        data: null,
      );
    }
  }

  Future<List<Inquiry>> getMyInquiries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inquiries'),
        headers: await _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          final List<dynamic> data = json['data'];
          return data.map((i) => Inquiry.fromJson(i)).toList();
        }
      }
      await _handleAuthError(response.statusCode);
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Inquiry?> getInquiryDetail(int inquiryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inquiries/$inquiryId'),
        headers: await _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          return Inquiry.fromJson(json['data']);
        }
      }
      await _handleAuthError(response.statusCode);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Reply?> sendReply(int inquiryId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inquiries/$inquiryId/replies'),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          return Reply.fromJson(json['data']);
        }
      }
      await _handleAuthError(response.statusCode);
      return null;
    } catch (e) {
      return null;
    }
  }

  // ============== ADMIN ENDPOINTS ==============

  Future<List<Inquiry>> getAllInquiries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/inquiries'),
        headers: await _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          final List<dynamic> data = json['data'];
          return data.map((i) => Inquiry.fromJson(i)).toList();
        }
      }
      await _handleAuthError(response.statusCode);
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Inquiry?> getAdminInquiryDetail(int inquiryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/inquiries/$inquiryId'),
        headers: await _getHeaders(includeAuth: true),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == true) {
          return Inquiry.fromJson(json['data']);
        }
      }
      await _handleAuthError(response.statusCode);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateInquiryStatus(int inquiryId, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/inquiries/$inquiryId/status'),
        headers: await _getHeaders(includeAuth: true),
        body: jsonEncode({
          'status': status,
        }),
      );

      await _handleAuthError(response.statusCode);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  // Validate URL
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  // Validate phone number
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(phone) &&
        phone.replaceAll(RegExp(r'[^\d]'), '').length >= 8;
  }
}
