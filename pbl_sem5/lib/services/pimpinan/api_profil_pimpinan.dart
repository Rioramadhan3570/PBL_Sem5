import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pbl_sem5/models/profil/profil_response.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProfilPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiProfilPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<void> _persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    this.token = token;
  }

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<ProfileResponse> getProfile() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching profile with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profil-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return ProfileResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      debugPrint('Error in getProfile: $e');
      rethrow;
    }
  }

  Future<ProfileResponse> updateProfile({
    required String nama,
    required String nip,
    required String posisi,
    required String telepon,
    required String username,
    File? avatar,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/profil-pimpinan/update'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll({
        'nama': nama,
        'pimpinan_nip': nip,
        'pimpinan_posisi': posisi,
        'pimpinan_telepon': telepon,
        'username': username,
      });

      // Perbaikan pada penambahan file avatar
      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'pimpinan_avatar', // Nama field harus sama dengan yang diharapkan di backend
          avatar.path,
          contentType:
              MediaType('image', 'jpeg'), // Explicitly set content type
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update profile response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return ProfileResponse.fromJson(responseData);
        } else {
          throw Exception(
              responseData['message'] ?? 'Failed to update profile');
        }
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      debugPrint('Error in updateProfile: $e');
      rethrow;
    }
  }

  Future<bool> updateUserCredentials({
    required String username,
    String? currentPassword,
    String? newPassword,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      Map<String, dynamic> body = {'username': username};

      if (newPassword != null && currentPassword != null) {
        body.addAll({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        });
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/profil-pimpinan/update-credentials'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      debugPrint('Update credentials response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['token'] != null) {
          await _persistToken(responseData['token']);
        }

        return responseData['status'] == true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update credentials');
      }
    } catch (e) {
      debugPrint('Error in updateUserCredentials: $e');
      rethrow;
    }
  }
}
