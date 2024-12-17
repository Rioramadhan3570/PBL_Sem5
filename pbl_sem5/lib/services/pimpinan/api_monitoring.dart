// lib/services/api_monitoring.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/monitoring_response_model.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/detail_response_model.dart';
import 'package:pbl_sem5/services/api_config.dart';

class ApiMonitoring {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiMonitoring({this.token});

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

  Future<MonitoringResponseModel> getMonitoring() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      debugPrint('Fetching monitoring data with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/monitoring-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Filter data sebelum membuat model
        var filteredData = (jsonResponse['data'] as List? ?? []).where((item) {
          // Cek apakah item memiliki jenis dengan total > 0
          List jenisList = (item['jenis'] as List? ?? []);
          return jenisList.any((jenis) => (jenis['total'] ?? 0) > 0);
        }).toList();

        // Update jsonResponse dengan data yang sudah difilter
        jsonResponse['data'] = filteredData;
        
        return MonitoringResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Tidak terautentikasi. Silakan login kembali.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memuat data monitoring');
      }
    } catch (e) {
      debugPrint('Error in getMonitoring: $e');
      rethrow;
    }
  }

  Future<DetailResponseModel> getDetailMonitoring(String userId, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak tersedia. Silakan login kembali.');
      }

      debugPrint('Fetching detail monitoring with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/monitoring-pimpinan/$userId/$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Cek apakah data kosong sebelum membuat model
        final dataList = jsonResponse['data'] as List? ?? [];
        if (dataList.isEmpty) {
          throw Exception('Tidak ada data untuk ditampilkan');
        }

        return DetailResponseModel.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Tidak terautentikasi. Silakan login kembali.');
      } else if (response.statusCode == 404) {
        throw Exception('Data tidak ditemukan');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Gagal memuat detail monitoring');
      }
    } catch (e) {
      debugPrint('Error in getDetailMonitoring: $e');
      rethrow;
    }
  }
}