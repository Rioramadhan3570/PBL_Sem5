// lib/services/api_mandiri_dosen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/mandiri/mandiri_detail_model.dart';
import 'package:pbl_sem5/models/dosen/mandiri/pelatihan_mandiri.dart';
import 'package:pbl_sem5/models/dosen/mandiri/sertifikasi_mandiri.dart';
import 'package:pbl_sem5/models/dosen/mandiri/vendor.dart';
import 'package:pbl_sem5/services/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiMandiriDosen {
  static const String baseUrl = ApiConfig.baseUrl;
  String? token;

  ApiMandiriDosen({this.token}) {
    _initToken();
  }

  Future<void> _initToken() async {
    if (token == null) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token');
    }
  }

  Future<String?> _getToken() async {
    if (token != null) return token;
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    return token;
  }

  Future<String?> getDosenId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('dosen_id');
  }

  // Create new sertifikasi
  Future<void> createSertifikasi(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mandiri-dosen/sertifikasi'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 201) {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to create sertifikasi');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Create new pelatihan
  Future<void> createPelatihan(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mandiri-dosen/pelatihan'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 201) {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to create pelatihan');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get mandiri data
  Future<Map<String, dynamic>> getMandiriData() async {
    try {
      final token = await _getToken(); // Tambahkan ini
      if (token == null || token.isEmpty) {
        // Tambahkan ini
        throw Exception('Token not available. Please login again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/show'),
        headers: {
          'Authorization':
              'Bearer $token', // Sekarang menggunakan token yang sudah diambil
          'Accept': 'application/json',
        },
      );

      debugPrint(
          'Get Mandiri Data response: ${response.body}'); // Tambahkan log untuk debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        return {
          'sertifikasi': (jsonResponse['sertifikasi'] as List)
              .map((e) => SertifikasiMandiri.fromJson(e))
              .toList(),
          'pelatihan': (jsonResponse['pelatihan'] as List)
              .map((e) => PelatihanMandiri.fromJson(e))
              .toList(),
        };
      } else if (response.statusCode == 401) {
        // Tambahkan handling untuk unauthorized
        throw Exception('Unauthenticated');
      } else {
        throw Exception(
            json.decode(response.body)['message'] ?? 'Failed to get data');
      }
    } catch (e, stackTrace) {
      debugPrint('Error: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Get detail data
    Future<MandiriDetail> getDetail(String id, String type) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/detail/$id?tipe=$type'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return MandiriDetail.fromJson(jsonResponse['data']);
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to get detail');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  // Update sertifikasi
    Future<void> updateSertifikasi(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mandiri-dosen/sertifikasi/$id'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to update sertifikasi');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update pelatihan
  Future<void> updatePelatihan(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/mandiri-dosen/pelatihan/$id'),
        headers: await _getHeaders(),
        body: json.encode(data),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['message'] ?? 'Failed to update pelatihan');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get vendors
  Future<List<Vendor>> getVendors() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/vendors'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => Vendor.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load vendors');
      }
    } catch (e) {
      debugPrint('Error in getVendors: $e');
      rethrow;
    }
  }

  // Get jenis sertifikasi
  Future<List<String>> getJenisSertifikasi() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/jenis-sertifikasi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception('Failed to load jenis sertifikasi');
      }
    } catch (e) {
      debugPrint('Error in getJenisSertifikasi: $e');
      rethrow;
    }
  }

  // Get jenis kompetensi
  Future<List<Map<String, dynamic>>> getJenisKompetensi() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/jenis-kompetensi'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load jenis kompetensi');
      }
    } catch (e) {
      debugPrint('Error in getJenisKompetensi: $e');
      rethrow;
    }
  }

  // Get level
  Future<List<String>> getLevel(String type) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/level?type=$type'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        return data.map((item) => item.toString()).toList();
      } else {
        throw Exception('Failed to load levels');
      }
    } catch (e) {
      debugPrint('Error in getLevel: $e');
      rethrow;
    }
  }

  // Get bidang minat
  Future<List<Map<String, dynamic>>> getBidangMinat() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/bidang-minat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data
            .map((item) => {
                  'id': item['keahlian_id'].toString(),
                  'nama': item['keahlian_nama'].toString(),
                })
            .toList();
      } else {
        throw Exception('Failed to load bidang minat');
      }
    } catch (e) {
      debugPrint('Error in getBidangMinat: $e');
      rethrow;
    }
  }

  // Get mata kuliah
  Future<List<Map<String, dynamic>>> getMataKuliah() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/mandiri-dosen/mata-kuliah'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data
            .map((item) => {
                  'id': item['matkul_id'].toString(),
                  'nama': item['matkul_nama'].toString(),
                })
            .toList();
      } else {
        throw Exception('Failed to load mata kuliah');
      }
    } catch (e) {
      debugPrint('Error in getMataKuliah: $e');
      rethrow;
    }
  }

  // Create vendor
  Future<Vendor> createVendor(Map<String, dynamic> data) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/mandiri-dosen/vendor'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        return Vendor.fromJson(json.decode(response.body)['data']);
      } else {
        throw Exception('Failed to create vendor');
      }
    } catch (e) {
      debugPrint('Error in createVendor: $e');
      rethrow;
    }
  }

  Future<void> deleteMandiri(String id, String type) async {
    try {
      final token = await _getToken();
      // Hapus 'api/' yang double
      final response = await http.delete(
        Uri.parse('$baseUrl/mandiri-dosen/${type.toLowerCase()}/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Failed to delete ${type.toLowerCase()}');
      }
    } catch (e) {
      debugPrint('Error in deleteMandiri: $e');
      rethrow;
    }
  }
}
