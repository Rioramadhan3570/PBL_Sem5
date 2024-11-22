import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pbl_sem5/models/dosen/informasi/pelatihan_rekomendasi_model.dart';
import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
import 'api_config.dart';

class InformasiService {

DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return null;
    }

    // Trim string dan hapus karakter whitespace
    dateTimeStr = dateTimeStr.trim();

    // Daftar format tanggal yang mungkin
    final formatters = [
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('yyyy/MM/dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ'),
    ];

    // Coba parse dengan semua format yang tersedia
    for (var formatter in formatters) {
      try {
        return formatter.parse(dateTimeStr);
      } catch (_) {
        continue;
      }
    }

    // Jika semua format gagal, coba parse manual
    try {
      final parts = dateTimeStr.split(RegExp(r'[ T]'))[0].split('-');
      if (parts.length >= 3) {
        return DateTime(
          int.parse(parts[0]), // year
          int.parse(parts[1]), // month
          int.parse(parts[2]), // day
        );
      }
    } catch (_) {
      print('Failed to parse date: $dateTimeStr');
    }

    return null;
  }

  Future<List<dynamic>> getInformasi({required String type}) async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}/informasi?type=$type'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (!responseData.containsKey('data')) {
          return [];
        }

        final data = responseData['data'];

        if (type == 'all') {
          List<dynamic> allItems = [];

          if (data is Map<String, dynamic>) {
            if (data.containsKey('sertifikasi')) {
              final sertifikasiList = data['sertifikasi'] as List;
              final sertifikasiItems = sertifikasiList.map((item) {
                return _processSertifikasiItem(item);
              }).toList();
              allItems.addAll(sertifikasiItems);
            }

            if (data.containsKey('pelatihan')) {
              final pelatihanList = data['pelatihan'] as List;
              final pelatihanItems = pelatihanList.map((item) {
                return _processPelatihanItem(item);
              }).toList();
              allItems.addAll(pelatihanItems);
            }

            return allItems;
          }
        } else {
          if (data is List) {
            return data.map((item) {
              return type == 'sertifikasi'
                  ? _processSertifikasiItem(item)
                  : _processPelatihanItem(item);
            }).toList();
          } else if (data is Map<String, dynamic>) {
            final items = data[type] as List?;
            if (items != null) {
              return items.map((item) {
                return type == 'sertifikasi'
                    ? _processSertifikasiItem(item)
                    : _processPelatihanItem(item);
              }).toList();
            }
          }
        }
      }

      return [];
    } catch (e, stackTrace) {
      print('Error in getInformasi: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Sertifikasi _processSertifikasiItem(Map<String, dynamic> item) {
    // Cek semua kemungkinan field tanggal
    final startDate = _parseDateTime(item['sertifikasi_start']?.toString()) ??
        _parseDateTime(item['tanggal_mulai']?.toString()) ??
        _parseDateTime(item['start_date']?.toString());

    final endDate = _parseDateTime(item['sertifikasi_end']?.toString()) ??
        _parseDateTime(item['tanggal_selesai']?.toString()) ??
        _parseDateTime(item['end_date']?.toString());

    final waktu = item['waktu']?.toString();

    // Debug print
    print('Processing Sertifikasi:');
    print(
        'Raw start date: ${item['tanggal_mulai'] ?? item['sertifikasi_start']}');
    print(
        'Raw end date: ${item['tanggal_selesai'] ?? item['sertifikasi_end']}');
    print('Parsed start date: $startDate');
    print('Parsed end date: $endDate');
    print('Waktu: $waktu');

    return Sertifikasi.fromJson({
      ...item,
      'id': item['id']?.toString() ?? '',
      'nama': item['nama']?.toString() ?? '',
      'tempat': item['tempat']?.toString() ?? '',
      'sertifikasi_start': startDate?.toIso8601String(),
      'sertifikasi_end': endDate?.toIso8601String(),
      'waktu': waktu,
      'kuota': item['kuota'] ?? 0,
      'biaya': item['biaya'] ?? 0,
      'jenis_sertifikasi': item['jenis_sertifikasi']?.toString() ?? '',
      'level': item['level']?.toString() ?? '',
      'vendor': item['vendor'] ?? {'vendor_nama': ''},
      'jenis': item['jenis'] ?? {'jenis_nama': item['jenis_kompetensi'] ?? ''},
      'bidang_minat': _convertToList(item['bidang_minat']),
      'mata_kuliah': _convertToList(item['mata_kuliah']),
      'type': 'sertifikasi'
    });
  }

  Pelatihan _processPelatihanItem(Map<String, dynamic> item) {
    // Cek semua kemungkinan field tanggal
    final startDate = _parseDateTime(item['pelatihan_start']?.toString()) ??
        _parseDateTime(item['tanggal_mulai']?.toString()) ??
        _parseDateTime(item['start_date']?.toString());

    final endDate = _parseDateTime(item['pelatihan_end']?.toString()) ??
        _parseDateTime(item['tanggal_selesai']?.toString()) ??
        _parseDateTime(item['end_date']?.toString());

    final waktu = item['waktu']?.toString();

    // Debug print
    print('Processing Pelatihan:');
    print(
        'Raw start date: ${item['tanggal_mulai'] ?? item['pelatihan_start']}');
    print('Raw end date: ${item['tanggal_selesai'] ?? item['pelatihan_end']}');
    print('Parsed start date: $startDate');
    print('Parsed end date: $endDate');
    print('Waktu: $waktu');

    return Pelatihan.fromJson({
      ...item,
      'id': item['id']?.toString() ?? '',
      'nama': item['nama']?.toString() ?? '',
      'tempat': item['tempat']?.toString() ?? '',
      'pelatihan_start': startDate?.toIso8601String(),
      'pelatihan_end': endDate?.toIso8601String(),
      'waktu': waktu,
      'kuota': item['kuota'] ?? 0,
      'biaya': item['biaya'] ?? 0,
      'level': item['level']?.toString() ?? '',
      'vendor': item['vendor'] ?? {'vendor_nama': ''},
      'jenis': item['jenis'] ?? {'jenis_nama': item['jenis_kompetensi'] ?? ''},
      'bidang_minat': _convertToList(item['bidang_minat']),
      'mata_kuliah': _convertToList(item['mata_kuliah']),
      'type': 'pelatihan'
    });
  }

  List<Map<String, dynamic>> _convertToList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      return value.map((item) {
        if (item is Map<String, dynamic>) return item;
        return {'keahlian_nama': item.toString()};
      }).toList();
    }
    return [
      {'keahlian_nama': value.toString()}
    ];
  }
}
