// lib/models/pengajuan_model.dart
class PengajuanModel {
  final String id;
  final String? sertifikasiRekomendasiId;
  final String? pelatihanRekomendasiId;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  PengajuanModel({
    required this.id,
    this.sertifikasiRekomendasiId,
    this.pelatihanRekomendasiId,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory PengajuanModel.fromJson(Map<String, dynamic> json) {
    return PengajuanModel(
      id: json['id'].toString(),
      sertifikasiRekomendasiId: json['sertifikasi_rekomendasi_id']?.toString(),
      pelatihanRekomendasiId: json['pelatihan_rekomendasi_id']?.toString(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}