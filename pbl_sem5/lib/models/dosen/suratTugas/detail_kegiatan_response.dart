// lib/models/surat_tugas/detail_kegiatan_response.dart
import 'package:pbl_sem5/models/dosen/suratTugas/detail_kegatan_model.dart';

class DetailKegiatanResponse {
  final bool status;
  final String message;
  final DetailKegiatanModel data;

  DetailKegiatanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DetailKegiatanResponse.fromJson(Map<String, dynamic> json) {
    return DetailKegiatanResponse(
      status: json['status'],
      message: json['message'],
      data: DetailKegiatanModel.fromJson(json['data']),
    );
  }
}