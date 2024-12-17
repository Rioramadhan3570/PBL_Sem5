// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pbl_sem5/models/profil/profil_response.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiService({this.token});

    // Tambahkan getter untuk mengecek token
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

  Future<List<Map<String, dynamic>>> getAvailableKeahlian() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/keahlian'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Keahlian response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data
              .map((item) => {
                    'id': item['keahlian_id'],
                    'kode': item['keahlian_kode'],
                    'nama': item['keahlian_nama'],
                  })
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load keahlian list');
      }
    } catch (e) {
      debugPrint('Error in getAvailableKeahlian: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableMataKuliah() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/matkul'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Matkul response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data
              .map((item) => {
                    'id': item['matkul_id'],
                    'kode': item['matkul_kode'],
                    'nama': item['matkul_nama'],
                  })
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load matkul list');
      }
    } catch (e) {
      debugPrint('Error in getAvailableMataKuliah: $e');
      rethrow;
    }
  }

  Future<ProfileResponse> getProfile() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching profile with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profil-dosen'),
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

  Future<bool> updateProfile({
    required String nama,
    required String nip,
    required String prodi,
    required String telepon,
    required String username,
    List<String>? keahlianIds,
    List<String>? matkulIds,
    File? avatar,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('Token not available. Please login again.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/profil-dosen/update'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll({
        'nama': nama,
        'dosen_nip': nip,
        'dosen_prodi': prodi,
        'dosen_telepon': telepon,
        'username': username,
      });

      if (keahlianIds != null) {
        for (var i = 0; i < keahlianIds.length; i++) {
          request.fields['keahlian[$i]'] = keahlianIds[i];
        }
      }

      if (matkulIds != null) {
        for (var i = 0; i < matkulIds.length; i++) {
          request.fields['matkul[$i]'] = matkulIds[i];
        }
      }

      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'dosen_avatar',
          avatar.path,
          contentType: MediaType('image', 'jpeg'), // Explicitly set content type
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update profile response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return true;
        }
        throw Exception(responseData['message'] ?? 'Failed to update profile');
      } else {
        throw Exception('Failed to update profile');
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
      
      // Hanya tambahkan field password jika ada perubahan password
      if (newPassword != null && currentPassword != null) {
        body.addAll({
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        });
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/profil-dosen/update-credentials'),
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
        
        // Jika ada token baru dari response, simpan
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