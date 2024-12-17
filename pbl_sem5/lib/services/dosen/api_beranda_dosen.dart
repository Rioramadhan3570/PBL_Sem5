// lib/services/api_beranda_dosen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/beranda/beranda_model.dart';
import 'package:pbl_sem5/models/dosen/beranda/beranda_response.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBerandaDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiBerandaDosen({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<BerandaData> getDashboard() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/beranda-dosen'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Dashboard response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return BerandaResponse.fromJson(jsonResponse).data;
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception(json.decode(response.body)['message'] ??
            'Failed to load dashboard');
      }
    } catch (e) {
      debugPrint('Error in getDashboard: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getDetail(String id, String kategori) async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/rekomendasi-dosen/$id/$kategori'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Detail response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success' &&
            jsonResponse['data'] != null) {
          return jsonResponse['data'];
        }
        throw Exception('Invalid response format');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load detail');
      }
    } catch (e) {
      debugPrint('Error in getDetail: $e');
      rethrow;
    }
  }
}