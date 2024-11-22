// lib/services/api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/profil/profil_response.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiService({this.token});

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
      debugPrint('URL: $baseUrl/api/profil');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profil'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        return ProfileResponse.fromJson(decodedResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load profile');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    } on HttpException {
      throw Exception('Failed to communicate with server');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }

  Future<ProfileResponse> updateProfile({
    required String nama,
    required String nip,
    required String prodi,
    required String telepon,
    List<String>? keahlian,
    List<String>? mataKuliah,
    File? avatar,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/profil/update'),
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
      });

      if (keahlian != null) {
        for (var skill in keahlian) {
          request.fields['keahlian[]'] = skill;
        }
      }

      if (mataKuliah != null) {
        for (var course in mataKuliah) {
          request.fields['matkul[]'] = course;
        }
      }

      if (avatar != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'dosen_avatar',
          avatar.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Update profile response: ${response.body}');

      if (response.statusCode == 200) {
        return ProfileResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('Error updating profile: ${e.toString()}');
    }
  }
}