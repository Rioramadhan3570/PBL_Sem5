// lib/services/login_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/login/login_response.dart';
import 'package:pbl_sem5/models/login/logout_response.dart';
import 'package:pbl_sem5/models/login/user_model.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          'username': username.trim(),
          'password': password,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }

      if (response.body.toLowerCase().contains('<!doctype html>')) {
        throw const FormatException('Received HTML instead of JSON response');
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      final loginResponse = LoginResponse.fromJson(responseData);

      if (loginResponse.success && loginResponse.data != null) {
        // Menggunakan roleMap untuk memetakan kode level ke role yang diharapkan
        final roleMap = {
          'DOS': 'dosen',
          'PMP': 'pimpinan',
        };

        final userLevel = loginResponse.data!.user.level.kode.toUpperCase();

        // Validasi role
        if (roleMap[userLevel] == expectedRole.toLowerCase()) {
          final prefs = await SharedPreferences.getInstance();
          // Menyimpan token
          await prefs.setString('token', loginResponse.data!.token);
          // Menyimpan data user dalam format JSON
          await prefs.setString(
              'user_data', json.encode(loginResponse.data!.user.toJson()));

          // Simpan dosen_id jika user adalah dosen
          if (loginResponse.data!.user.dosen != null) {
            await prefs.setString(
                'dosen_id', loginResponse.data!.user.dosen!.dosenId.toString());
          }

          return {
            'success': true,
            'message': 'Login berhasil',
            'data': loginResponse.data!.user
          };
        } else {
          return {
            'success': false,
            'message':
                'Anda tidak memiliki akses untuk login sebagai ${_capitalizeRole(expectedRole)}'
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
      return {
        'success': false,
        'message': 'Terjadi kesalahan pada server: ${e.toString()}'
      };
    }
  }

  String _capitalizeRole(String role) {
    if (role.isEmpty) return role;
    return role[0].toUpperCase() + role.substring(1).toLowerCase();
  }

  // Tambahkan method untuk mendapatkan dosen_id
  Future<String?> getDosenId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('dosen_id');
    } catch (e) {
      print('Error getting dosen_id: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        await prefs.clear();
        return {'success': true, 'message': 'Berhasil logout'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Logout response: ${response.body}');

      if (response.statusCode != 200) {
        return {
          'success': false,
          'message': 'Gagal logout: ${response.statusCode}'
        };
      }

      final logoutResponse =
          LogoutResponse.fromJson(json.decode(response.body));

      // Clear all stored data regardless of response
      await prefs.clear();

      return {
        'success': true,
        'message': logoutResponse.message ?? 'Berhasil logout'
      };
    } catch (e) {
      print('Error during logout: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}'
      };
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
        final userData = json.decode(userDataString);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error getting stored user data: $e');
      return null;
    }
  }
}
