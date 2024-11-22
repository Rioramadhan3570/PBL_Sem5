import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_sem5/models/login/login_response.dart';
import 'package:pbl_sem5/models/login/user_model.dart';

class LoginService {
  Future<Map<String, dynamic>> login(
      String username, String password, String expectedRole) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.body.toLowerCase().contains('<!doctype html>')) {
        throw FormatException('Received HTML instead of JSON response');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);

      if (response.statusCode == 200 && loginResponse.success) {
        final userLevel = loginResponse.data?.user.level.kode.toUpperCase();

        final roleMap = {'DOS': 'dosen', 'PMP': 'pimpinan'};

        if (roleMap[userLevel] == expectedRole.toLowerCase()) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', loginResponse.data!.token);
          await prefs.setString(
              'user_data', json.encode(loginResponse.data!.user.toJson()));

          return {
            'success': true,
            'message': 'Login berhasil',
            'data': loginResponse.data!.user
          };
        } else {
          return {
            'success': false,
            'message':
                'Anda tidak memiliki akses untuk login sebagai $expectedRole'
          };
        }
      }

      return {
        'success': false,
        'message': loginResponse.message ?? 'Terjadi kesalahan'
      };
    } catch (e) {
      print('Error during login: $e');
      if (e is FormatException) {
        return {
          'success': false,
          'message': 'Server mengembalikan format response yang tidak valid'
        };
      }
      return {'success': false, 'message': 'Terjadi kesalahan pada server'};
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/logout'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        print('Logout response: ${response.body}');
      }

      await prefs.clear();
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Gagal melakukan logout');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel?> getStoredUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        return UserModel.fromJson(json.decode(userDataString));
      }
      return null;
    } catch (e) {
      print('Error getting stored user data: $e');
      return null;
    }
  }
}