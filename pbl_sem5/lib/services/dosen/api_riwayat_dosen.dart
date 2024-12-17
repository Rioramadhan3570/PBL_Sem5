import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/riwayat/reupload_response.dart';
import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
import 'package:pbl_sem5/models/dosen/riwayat/upload_response_mode.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiRiwayatDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiRiwayatDosen({this.token});

  // Getter untuk mengecek token
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

  // Get Riwayat Mandiri dan Rekomendasi
  Future<List<RiwayatModel>> getRiwayat() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/riwayat-dosen/mandiri'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Riwayat response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => RiwayatModel.fromJson(item)).toList();
        }
        return [];
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load riwayat');
      }
    } catch (e) {
      debugPrint('Error in getRiwayat: $e');
      rethrow;
    }
  }

  // Upload Bukti
  Future<UploadResponseModel> uploadBukti({
    required String id,
    required String tipe,
    required String jenis,
    required File bukti,
    required DateTime tanggalKadaluwarsa,
  }) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/riwayat-dosen/upload-bukti'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields.addAll({
        'id': id,
        'tipe': tipe,
        'jenis': jenis,
        'tanggal_kadaluwarsa': tanggalKadaluwarsa.toIso8601String(),
      });

      request.files.add(await http.MultipartFile.fromPath(
        'bukti',
        bukti.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Upload bukti response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          return UploadResponseModel.fromJson(jsonResponse['data']);
        }
        throw Exception('Failed to parse upload response');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to upload bukti');
      }
    } catch (e) {
      debugPrint('Error in uploadBukti: $e');
      rethrow;
    }
  }

  // Reupload Bukti when rejected
// Reupload Bukti (for both pending and rejected status)
Future<ReuploadResponse> reuploadBukti({
  required String id,
  required String tipe,
  required String jenis,
  required File bukti,
  required DateTime tanggalKadaluwarsa,
}) async {
  try {
    final token = await _getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token not available. Please login again.');
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}/riwayat-dosen/reupload-bukti'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields.addAll({
      'id': id,
      'tipe': tipe,
      'jenis': jenis,
      'tanggal_kadaluwarsa': tanggalKadaluwarsa.toIso8601String(),
    });

    request.files.add(await http.MultipartFile.fromPath(
      'bukti',
      bukti.path,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('Reupload bukti response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
        return ReuploadResponse.fromJson(jsonResponse['data']);
      }
      throw Exception('Failed to parse reupload response');
    } else {
      final Map<String, dynamic> errorBody = json.decode(response.body);
      throw Exception(errorBody['message'] ?? 'Failed to reupload bukti');
    }
  } catch (e) {
    debugPrint('Error in reuploadBukti: $e');
    rethrow;
  }
}
}
