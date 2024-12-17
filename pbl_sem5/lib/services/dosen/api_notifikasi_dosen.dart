import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/notifikasi/notifikasi_model.dart';
import 'package:pbl_sem5/models/dosen/notifikasi/rekomendasi_model.dart';
import 'package:pbl_sem5/models/dosen/notifikasi/bukti_model.dart';
import 'package:pbl_sem5/models/dosen/notifikasi/surat_tugas_model.dart';
import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiNotifikasiDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiNotifikasiDosen({this.token});

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

  Future<List<NotifikasiModel>> getNotifikasi() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifikasi-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Notifikasi response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => NotifikasiModel.fromJson(item)).toList();
        }
        return [];
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load notifikasi');
      }
    } catch (e) {
      debugPrint('Error in getNotifikasi: $e');
      rethrow;
    }
  }

  Future<List<RekomendasiModel>> getRekomendasi() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifikasi-dosen/rekomendasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Rekomendasi response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => RekomendasiModel.fromJson(item)).toList();
        }
        return [];
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load rekomendasi');
      }
    } catch (e) {
      debugPrint('Error in getRekomendasi: $e');
      rethrow;
    }
  }

  Future<List<BuktiModel>> getBukti() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifikasi-dosen/bukti'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Bukti response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) => BuktiModel.fromJson(item)).toList();
        }
        return [];
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load bukti');
      }
    } catch (e) {
      debugPrint('Error in getBukti: $e');
      rethrow;
    }
  }

  Future<SuratTugasModel?> getSuratTugas(String id, String tipe) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/notifikasi-dosen/surat-tugas/$id?tipe=$tipe'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Surat tugas response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          final Map<String, dynamic> data = jsonResponse['data'];
          return SuratTugasModel.fromJson(data);
        }
        return null;
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load surat tugas');
      }
    } catch (e) {
      debugPrint('Error in getSuratTugas: $e');
      rethrow;
    }
  }

  Future<RiwayatModel> getRiwayatById(String id) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/riwayat/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
          return RiwayatModel.fromJson(jsonResponse['data']);
        }
        throw Exception(
            jsonResponse['message'] ?? 'Failed to load riwayat detail');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(
            errorBody['message'] ?? 'Failed to load riwayat detail');
      }
    } catch (e) {
      debugPrint('Error in getRiwayatById: $e');
      rethrow;
    }
  }
}
