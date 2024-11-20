// pengajuan_model.dart
import 'pelatihan_rekomendasi_model.dart';
import 'sertifikasi_rekomendasi_model.dart';

class Pengajuan {
  final String pengajuanId;
  final String? sertifikasiRekomendasiId;
  final String? pelatihanRekomendasiId;
  final String jenisPengajuan;
  final String status;
  final DateTime createdAt;
  final Pelatihan? pelatihanRekomendasi;
  final Sertifikasi? sertifikasiRekomendasi;

  Pengajuan({
    required this.pengajuanId,
    this.sertifikasiRekomendasiId,
    this.pelatihanRekomendasiId,
    required this.jenisPengajuan,
    required this.status,
    required this.createdAt,
    this.pelatihanRekomendasi,
    this.sertifikasiRekomendasi,
  });

  factory Pengajuan.fromJson(Map<String, dynamic> json) {
    return Pengajuan(
      pengajuanId: json['pengajuan_id'],
      sertifikasiRekomendasiId: json['sertifikasi_rekomendasi_id'],
      pelatihanRekomendasiId: json['pelatihan_rekomendasi_id'],
      jenisPengajuan: json['jenis_pengajuan'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      pelatihanRekomendasi: json['pelatihan_rekomendasi'] != null 
          ? Pelatihan.fromJson(json['pelatihan_rekomendasi'])
          : null,
      sertifikasiRekomendasi: json['sertifikasi_rekomendasi'] != null 
          ? Sertifikasi.fromJson(json['sertifikasi_rekomendasi'])
          : null,
    );
  }
}