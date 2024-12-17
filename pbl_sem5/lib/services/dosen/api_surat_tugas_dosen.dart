// lib/services/api_surat_tugas_dosen.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiSuratTugasDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiSuratTugasDosen({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Get all surat tugas
  Future<List<Map<String, dynamic>>> getAllSuratTugas() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/suratTugas-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Surat Tugas response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data
              .map((item) => {
                    'id': item['id'],
                    'judul': item['judul'],
                    'kategori': item['kategori'],
                    'tanggal': item['tanggal'],
                  })
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to load surat tugas list');
      }
    } catch (e) {
      debugPrint('Error in getAllSuratTugas: $e');
      rethrow;
    }
  }

  // Get detail kegiatan
  Future<Map<String, dynamic>> getDetailKegiatan(int id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/suratTugas-dosen/$id/detail?kategori=$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Detail Kegiatan response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          return jsonResponse['data'];
        }
        throw Exception(jsonResponse['message'] ?? 'Failed to get detail kegiatan');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to get detail kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getDetailKegiatan: $e');
      rethrow;
    }
  }

  // Download surat tugas
  Future<File?> downloadSuratTugas(int id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/suratTugas-dosen/$id/download?kategori=$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Download Surat Tugas response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Get app directory for file storage
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'surat_tugas_$id.pdf';
        final filePath = '${directory.path}/$fileName';

        // Write file
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to download surat tugas');
      }
    } catch (e) {
      debugPrint('Error in downloadSuratTugas: $e');
      rethrow;
    }
  }
}