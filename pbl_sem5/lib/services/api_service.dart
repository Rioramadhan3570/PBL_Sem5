// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pbl_sem5/models/dosen/profil/profil_model.dart';
// import 'package:pbl_sem5/models/login/login_response.dart';
// import 'package:pbl_sem5/models/login/user_model.dart';
// import 'package:pbl_sem5/models/dosen/informasi/pelatihan_rekomendasi_model.dart';
// import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
// import 'package:pbl_sem5/services/api_config.dart';

// class ApiService {
//   // Base URLs
//   final String profileBaseUrl = '${ApiConfig.baseUrl}/api/profil';
//   final String loginBaseUrl = '${ApiConfig.baseUrl}/login';
//   final String informasiBaseUrl = '${ApiConfig.baseUrl}/informasi';
//   final String disukaiBaseUrl = '${ApiConfig.baseUrl}/disukai';

//   String? _token;

//   Future<String?> _getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     return _token;
//   }

//   Future<ProfilModel> getProfile() async {
//     try {
//       final token = await _getToken();
//       if (token == null) throw Exception('Silahkan login kembali');

//       final response = await http.get(
//         Uri.parse('$profileBaseUrl/profil'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json',
//         },
//       ).timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           throw Exception('Koneksi timeout. Silahkan coba lagi.');
//         },
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         if (responseData['status'] == true && responseData['data'] != null) {
//           final userData = responseData['data']['user'];
//           final dosenData = responseData['data']['dosen'];
//           if (!userData.containsKey('level')) {
//             userData['level'] = {'kode': 'DOS', 'nama': 'Dosen'};
//           }
//           return ProfilModel.fromJson({'user': userData, 'dosen': dosenData});
//         }
//         throw Exception(responseData['message'] ?? 'Gagal memuat data profil');
//       }
//       if (response.statusCode == 401) {
//         throw Exception('Sesi anda telah berakhir. Silahkan login kembali.');
//       }
//       throw Exception('Terjadi kesalahan pada server');
//     } catch (e) {
//       throw Exception('Error getting profile: $e');
//     }
//   }

//   Future<Map<String, dynamic>> login(
//       String username, String password, String expectedRole) async {
//     try {
//       final response = await http.post(
//         Uri.parse(loginBaseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//         body: json.encode({
//           'username': username,
//           'password': password,
//         }),
//       );

//       if (response.body.toLowerCase().contains('<!doctype html>')) {
//         throw FormatException('Received HTML instead of JSON response');
//       }

//       final Map<String, dynamic> responseData = json.decode(response.body);
//       final loginResponse = LoginResponse.fromJson(responseData);

//       if (response.statusCode == 200 && loginResponse.success) {
//         final userLevel = loginResponse.data?.user.level.kode.toUpperCase();
//         final roleMap = {'DOS': 'dosen', 'PMP': 'pimpinan'};

//         if (roleMap[userLevel] == expectedRole.toLowerCase()) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('token', loginResponse.data!.token);
//           await prefs.setString(
//               'user_data', json.encode(loginResponse.data!.user.toJson()));
//           await prefs.setString('user_id',
//               loginResponse.data!.user.userId.toString());

//           return {
//             'success': true,
//             'message': 'Login berhasil',
//             'data': loginResponse.data!.user
//           };
//         }
//       }

//       return {
//         'success': false,
//         'message': loginResponse.message ?? 'Terjadi kesalahan'
//       };
//     } catch (e) {
//       return {'success': false, 'message': 'Terjadi kesalahan pada server'};
//     }
//   }

//   Future<List<dynamic>> getInformasi({required String type}) async {
//     try {
//       final response =
//           await http.get(Uri.parse('$informasiBaseUrl?type=$type'));
//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (!responseData.containsKey('data')) return [];
//         final data = responseData['data'];

//         if (type == 'all') {
//           List<dynamic> allItems = [];
//           if (data is Map<String, dynamic>) {
//             if (data.containsKey('sertifikasi')) {
//               allItems.addAll(data['sertifikasi']
//                   .map((item) => _processSertifikasiItem(item))
//                   .toList());
//             }
//             if (data.containsKey('pelatihan')) {
//               allItems.addAll(data['pelatihan']
//                   .map((item) => _processPelatihanItem(item))
//                   .toList());
//             }
//           }
//           return allItems;
//         } else {
//           if (data is List) {
//             return data.map((item) {
//               return type == 'sertifikasi'
//                   ? _processSertifikasiItem(item)
//                   : _processPelatihanItem(item);
//             }).toList();
//           }
//         }
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   Future<bool> addDisukai({
//     required String userId,
//     String? sertifikasiRekomendasiId,
//     String? pelatihanRekomendasiId,
//     required String tipe,
//   }) async {
//     try {
//       final token = await _getToken();
//       if (token == null) throw Exception('Token tidak ditemukan');

//       final response = await http.post(
//         Uri.parse(disukaiBaseUrl),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: json.encode({
//           'user_id': userId,
//           if (tipe == 'sertifikasi') 'sertifikasi_rekomendasi_id': sertifikasiRekomendasiId,
//           if (tipe == 'pelatihan') 'pelatihan_rekomendasi_id': pelatihanRekomendasiId,
//           'tipe': tipe,
//         }),
//       );
//       return response.statusCode == 201;
//     } catch (e) {
//       return false;
//     }
//   }

//   Sertifikasi _processSertifikasiItem(Map<String, dynamic> item) {
//     final startDate = _parseDateTime(item['sertifikasi_start']);
//     final endDate = _parseDateTime(item['sertifikasi_end']);
//     return Sertifikasi.fromJson({...item});
//   }

//   Pelatihan _processPelatihanItem(Map<String, dynamic> item) {
//     final startDate = _parseDateTime(item['pelatihan_start']);
//     final endDate = _parseDateTime(item['pelatihan_end']);
//     return Pelatihan.fromJson({...item});
//   }

//   DateTime? _parseDateTime(String? dateTimeStr) {
//     try {
//       return DateTime.parse(dateTimeStr ?? '');
//     } catch (_) {
//       return null;
//     }
//   }
// }
