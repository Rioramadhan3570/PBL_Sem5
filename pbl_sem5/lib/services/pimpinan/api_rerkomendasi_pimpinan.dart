// lib/services/api_rekomendasi_pimpinan.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/calon_peserta_model.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/detail_kegiatan_model.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/kegiatan_model.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/peserta_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_sem5/services/api_config.dart';

class ApiRekomendasiPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiRekomendasiPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  // Get list kegiatan
  Future<List<KegiatanModel>> getKegiatan() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => KegiatanModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load kegiatan');
      }
    } catch (e) {
      debugPrint('Error in getKegiatan: $e');
      rethrow;
    }
  }

  // Get detail kegiatan
  Future<DetailKegiatanModel> getDetailKegiatan(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

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
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Get latest status
        final statusResponse = await getStatus(id, kategori);
        final detailData = responseData['data'];
        detailData['status'] = statusResponse;

        return DetailKegiatanModel.fromJson(detailData);
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

  // Get list peserta
  Future<List<PesertaModel>> getPeserta(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori/peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => PesertaModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load peserta');
      }
    } catch (e) {
      debugPrint('Error in getPeserta: $e');
      rethrow;
    }
  }

  // Get list calon peserta
  Future<List<CalonPesertaModel>> getCalonPesertaWithHistory(
      String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori/calon-peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((json) => CalonPesertaModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load calon peserta');
      }
    } catch (e) {
      debugPrint('Error in getCalonPeserta: $e');
      rethrow;
    }
  }

  // Update peserta
  Future<bool> updatePeserta(
      String id, String kategori, List<String> pesertaIds) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori/peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'peserta_ids': pesertaIds,
        }),
      );

      debugPrint('Update peserta response status: ${response.statusCode}');
      debugPrint('Update peserta response body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update peserta');
      }
    } catch (e) {
      debugPrint('Error in updatePeserta: $e');
      rethrow;
    }
  }

    Future<String> getStatus(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data']['status'] ?? 'pending';
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to get status');
      }
    } catch (e) {
      debugPrint('Error in getStatus: $e');
      return 'pending'; // Return default status on error
    }
  }

Future<bool> updateStatus(String id, String kategori, String status) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rekomendasi-pimpinan/$id/$kategori/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': status,
        }),
      );

      debugPrint('Update status response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        // Store status in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('status_${id}_$kategori', status);
        
        return responseData['status'] == 'success';
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to update status');
      }
    } catch (e) {
      debugPrint('Error in updateStatus: $e');
      rethrow;
    }
  }
}
