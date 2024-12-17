// lib/services/api_notifikasi_pimpinan.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/pimpinan/pimpinan_notifikasi/notifikasi_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_config.dart';

class ApiNotifikasiPimpinan {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiNotifikasiPimpinan({this.token});

  bool get hasValidToken => token != null && token!.isNotEmpty;

  Future<String?> _getToken() async {
    if (token != null && token!.isNotEmpty) {
      return token;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<NotifikasiResponse> getNotifications() async {
    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token not available. Please login again.');
      }

      debugPrint('Fetching notifications with token: $token');

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/notifikasi-pimpinan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return NotifikasiResponse.fromJson(jsonResponse);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized. Please login again.');
      } else {
        final Map<String, dynamic> errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to load notifications');
      }
    } catch (e) {
      debugPrint('Error in getNotifications: $e');
      rethrow;
    }
  }
}