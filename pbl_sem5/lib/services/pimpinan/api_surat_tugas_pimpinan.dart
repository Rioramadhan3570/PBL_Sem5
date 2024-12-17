import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_suratTugas/kegiatan_resspone.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSuratTugasPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiSuratTugasPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<KegiatanResponse> getKegiatanList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching kegiatan list with token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/suratTugas-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return KegiatanResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load kegiatan list');
      }
    } catch (e) {
      debugPrint('Error in getKegiatanList: $e');
      rethrow;
    }
  }

  Future<String> downloadSuratTugas(int id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Downloading surat tugas with token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/suratTugas-pimpinan/download/$id?kategori=$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final fileName = 'surat_tugas_$id.pdf';
        final filePath = '${directory.path}/$fileName';

        // Write file
        File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        return filePath;
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to download surat tugas');
      }
    } catch (e) {
      debugPrint('Error in downloadSuratTugas: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDetailKegiatan(int id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching detail kegiatan with token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load detail kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getDetailKegiatan: $e');
      rethrow;
    }
  }
}