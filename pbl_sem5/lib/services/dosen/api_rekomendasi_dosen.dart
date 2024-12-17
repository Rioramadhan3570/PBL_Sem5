// lib/services/api_rekomendasi_dosen.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/download_model.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/download_response.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_detail_response.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_sem5/services/api_config.dart';

class ApiRekomendasiDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiRekomendasiDosen({this.token});

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

  // Get All Rekomendasi (Tab Semua)
  Future<RekomendasiListResponse> getAllRekomendasi() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('getAllRekomendasi Response: ${response.body}');

      if (response.statusCode == 200) {
        return RekomendasiListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get rekomendasi list');
      }
    } catch (e) {
      debugPrint('Error in getAllRekomendasi: $e');
      rethrow;
    }
  }

  // Get Rekomendasi Sertifikasi (Tab Sertifikasi)
  Future<RekomendasiListResponse> getRekomendasiSertifikasi() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-dosen/sertifikasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('getRekomendasiSertifikasi Response: ${response.body}');

      if (response.statusCode == 200) {
        return RekomendasiListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get sertifikasi list');
      }
    } catch (e) {
      debugPrint('Error in getRekomendasiSertifikasi: $e');
      rethrow;
    }
  }

  // Get Rekomendasi Pelatihan (Tab Pelatihan)
  Future<RekomendasiListResponse> getRekomendasiPelatihan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-dosen/pelatihan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('getRekomendasiPelatihan Response: ${response.body}');

      if (response.statusCode == 200) {
        return RekomendasiListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to get pelatihan list');
      }
    } catch (e) {
      debugPrint('Error in getRekomendasiPelatihan: $e');
      rethrow;
    }
  }

// Get Detail Rekomendasi
  Future<RekomendasiDetailResponse> getDetailRekomendasi(
      String id, String tipe) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Calling API with ID: $id, Tipe: $tipe');

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-dosen/$id/detail?tipe=$tipe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status code: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        debugPrint('Decoded response: $decodedResponse');

        return RekomendasiDetailResponse.fromJson(decodedResponse);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Failed to get rekomendasi detail');
      }
    } catch (e) {
      debugPrint('Error in getDetailRekomendasi: $e');
      rethrow;
    }
  }

// Modified download function to handle errors better
  Future<DownloadResponse> downloadSuratTugas(String id, String tipe) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        return DownloadResponse(
          status: false,
          message: 'Token tidak tersedia. Silakan login kembali.',
        );
      }

      debugPrint('Downloading file with ID: $id and Type: $tipe');
      final response = await http.get(
        Uri.parse(
            '$baseUrl/rekomendasi-dosen/$id/download-surat-tugas?tipe=$tipe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('downloadSuratTugas Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      // Handle different response status codes
      if (response.statusCode == 200) {
        final fileName = 'surat_tugas_$id.pdf'; // Nama file bisa disesuaikan
        final file =
            await _saveFile(fileName, response.bodyBytes); // Simpan file
        return DownloadResponse(
          status: true,
          message: 'Download berhasil',
          data:
              DownloadData(fileBytes: response.bodyBytes, filePath: file.path),
        );
      } else if (response.statusCode == 404) {
        return DownloadResponse(
          status: false,
          message: 'Surat tugas tidak tersedia',
        );
      } else {
        Map<String, dynamic> errorBody = {};
        try {
          errorBody = jsonDecode(response.body);
        } catch (e) {
          // If response body is not valid JSON
          debugPrint('Failed to decode error body: ${response.body}');
          return DownloadResponse(
            status: false,
            message: 'Terjadi kesalahan saat mengunduh surat tugas',
          );
        }
        return DownloadResponse(
          status: false,
          message: errorBody['message'] ?? 'Gagal mengunduh surat tugas',
        );
      }
    } catch (e) {
      debugPrint('Error in downloadSuratTugas: $e');
      return DownloadResponse(
        status: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  Future<File> _saveFile(String fileName, List<int> bytes) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDir.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    debugPrint('File saved at: $filePath');
    return file;
  }
}
