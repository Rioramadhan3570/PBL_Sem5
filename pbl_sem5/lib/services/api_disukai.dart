import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/informasi/pelatihan_rekomendasi_model.dart';
import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisukaiService {
  final String baseUrl = '${ApiConfig.baseUrl}/disukai';
  
  String? _token;

   Future<String?> _getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    return _token;
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (userId == null) {
      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        try {
          final userData = json.decode(userDataString);
          userId = userData['user_id']?.toString();
          if (userId != null && userId.isNotEmpty) {
            await prefs.setString('user_id', userId);
          }
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }
    }
    return userId;
  }

  Future<List<dynamic>> fetchDisukaiItems() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<dynamic> validItems = [];

        for (var item in data) {
          if (item == null) continue;

          final String? tipe = item['tipe']?.toString().toLowerCase();
          if (tipe == null || tipe.isEmpty) continue;

          try {
            Map<String, dynamic> itemData;
            if (tipe == 'sertifikasi') {
              itemData = item['sertifikasi_rekomendasi'] ?? {};
              if (itemData.isNotEmpty) {
                itemData['disukai_id'] = item['id']?.toString();
                validItems.add(Sertifikasi.fromJson(itemData));
              }
            } else if (tipe == 'pelatihan') {
              itemData = item['pelatihan_rekomendasi'] ?? {};
              if (itemData.isNotEmpty) {
                itemData['disukai_id'] = item['id']?.toString();
                validItems.add(Pelatihan.fromJson(itemData));
              }
            }
          } catch (e) {
            print('Error parsing item: $e');
            continue;
          }
        }
        return validItems;
      } else {
        throw Exception('Failed to load disukai items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in fetchDisukaiItems: $e');
      rethrow;
    }
  }

  Future<bool> addDisukai({
    required String userId,
    String? sertifikasiRekomendasiId,
    String? pelatihanRekomendasiId,
    required String tipe,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      if (tipe == 'sertifikasi' && (sertifikasiRekomendasiId == null || sertifikasiRekomendasiId.isEmpty)) {
        throw Exception('sertifikasi_rekomendasi_id diperlukan untuk tipe sertifikasi');
      }
      if (tipe == 'pelatihan' && (pelatihanRekomendasiId == null || pelatihanRekomendasiId.isEmpty)) {
        throw Exception('pelatihan_rekomendasi_id diperlukan untuk tipe pelatihan');
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          if (tipe == 'sertifikasi') 'sertifikasi_rekomendasi_id': sertifikasiRekomendasiId,
          if (tipe == 'pelatihan') 'pelatihan_rekomendasi_id': pelatihanRekomendasiId,
          'tipe': tipe,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error adding to disukai: $e');
      return false;
    }
  }

  Future<bool> removeDisukai(String disukaiId) async {
    try {
      if (disukaiId.isEmpty) throw Exception('Invalid disukai ID');

      final token = await _getToken();
      if (token == null) throw Exception('Token tidak ditemukan');

      final response = await http.delete(
        Uri.parse('$baseUrl/$disukaiId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error removing from disukai: $e');
      return false;
    }
  }
}