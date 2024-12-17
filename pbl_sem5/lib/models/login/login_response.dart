// lib/models/login_response.dart
import 'user_model.dart';

class LoginResponse {
  final bool success;
  final String? message;
  final LoginData? data;

  LoginResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message']?.toString(),
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }
}

class LoginData {
  final UserModel user;
  final String token;

  LoginData({
    required this.user,
    required this.token,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: UserModel.fromJson(json['user']),
      token: json['token'].toString(), // Ensure String type
    );
  }
}