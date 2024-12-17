import 'package:flutter/material.dart';

class RiwayatResponse {
  final String status;
  final List<RiwayatData> data;

  RiwayatResponse({
    required this.status,
    required this.data,
  });

  factory RiwayatResponse.fromJson(Map<String, dynamic> json) {
    return RiwayatResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => RiwayatData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class RiwayatData {
  final String id;
  final String judul;
  final String kategori;
  final String tanggalKonfirmasi;

  RiwayatData({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggalKonfirmasi,
  });

  factory RiwayatData.fromJson(Map<String, dynamic> json) {
    try {
      return RiwayatData(
        id: json['id']?.toString() ?? '',
        judul: json['judul']?.toString() ?? 'Judul tidak tersedia',
        kategori: json['kategori']?.toString() ?? 'Kategori tidak tersedia',
        tanggalKonfirmasi: json['tanggal_konfirmasi']?.toString() ?? 'Tanggal tidak tersedia',
      );
    } catch (e) {
      debugPrint('Error parsing RiwayatData: $e');
      rethrow;
    }
  }
}