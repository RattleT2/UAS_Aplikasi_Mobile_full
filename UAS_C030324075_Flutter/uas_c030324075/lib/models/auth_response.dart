import 'user.dart';

class AuthResponse {
  final bool status;
  final String message;
  final User? user;
  final String? token;
  final String? tokenType;

  AuthResponse({
    required this.status,
    required this.message,
    this.user,
    this.token,
    this.tokenType,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'],
      message: json['message'],
      user: json['data'] != null && json['data']['user'] != null
          ? User.fromJson(json['data']['user'])
          : null,
      token: json['data'] != null ? json['data']['token'] : null,
      tokenType: json['data'] != null ? json['data']['token_type'] : null,
    );
  }
}

class ApiResponse<T> {
  final bool status;
  final String message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>)? dataMapper) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null && dataMapper != null ? dataMapper(json['data']) : null,
    );
  }
}
