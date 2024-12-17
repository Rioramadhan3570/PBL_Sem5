// lib/services/api_beranda_pimpinan.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/beranda_responses.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBerandaPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiBerandaPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<BerandaResponse> getBerandaData() async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/beranda-pimpinan'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Koneksi timeout. Silakan coba lagi.');
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (!responseData.containsKey('data')) {
          throw Exception('Format response tidak valid');
        }

        return BerandaResponse.fromJson(responseData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Sesi telah berakhir, silakan login kembali');
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Terjadi kesalahan pada server');
      }
    } catch (e) {
      debugPrint('Error in getBerandaData: $e');
      throw Exception('Gagal memuat data: ${e.toString()}');
    }
  }
}