import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/detail_riwayat_response.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/peserta_riwayat_response.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/riwayat_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config.dart';

class ApiRiwayatPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiRiwayatPimpinan({this.token});

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

  Future<RiwayatResponse> getRiwayatList() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching riwayat list with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/riwayat-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Validasi response
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return RiwayatResponse.fromJson(jsonResponse);
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load riwayat list');
      }
    } catch (e) {
      debugPrint('Error in getRiwayatList: $e');
      rethrow;
    }
  }

  Future<DetailRiwayatResponse> getDetailRiwayat(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching riwayat detail with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/riwayat-pimpinan/$id/$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Validasi response
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return DetailRiwayatResponse.fromJson(jsonResponse);
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load riwayat detail');
      }
    } catch (e) {
      debugPrint('Error in getDetailRiwayat: $e');
      rethrow;
    }
  }

  Future<PesertaRiwayatResponse> getPesertaRiwayat(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching peserta list with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/riwayat-pimpinan/$id/$kategori/peserta'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        
        // Validasi response
        if (jsonResponse['status'] == 'success' && jsonResponse['data'] != null) {
          return PesertaRiwayatResponse.fromJson(jsonResponse);
        } else {
          throw Exception('Invalid response format');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load peserta list');
      }
    } catch (e) {
      debugPrint('Error in getPesertaRiwayat: $e');
      rethrow;
    }
  }
}