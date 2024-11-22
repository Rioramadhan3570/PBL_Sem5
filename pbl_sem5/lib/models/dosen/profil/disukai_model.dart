// lib/models/dosen/profil/disukai_model.dart
// lib/models/dosen/profil/disukai_model.dart
class DisukaiModel {
  final String disukaiId;
  final String userId;  // Ubah ke String
  final String? sertifikasiRekomendasiId;
  final String? pelatihanRekomendasiId;
  final String tipe;
  final Map<String, dynamic>? sertifikasiRekomendasi;
  final Map<String, dynamic>? pelatihanRekomendasi;

  DisukaiModel({
    required this.disukaiId,
    required this.userId,
    this.sertifikasiRekomendasiId,
    this.pelatihanRekomendasiId,
    required this.tipe,
    this.sertifikasiRekomendasi,
    this.pelatihanRekomendasi,
  });

  factory DisukaiModel.fromJson(Map<String, dynamic> json) {
    return DisukaiModel(
      disukaiId: json['disukai_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      sertifikasiRekomendasiId: json['sertifikasi_rekomendasi_id']?.toString(),
      pelatihanRekomendasiId: json['pelatihan_rekomendasi_id']?.toString(),
      tipe: json['tipe']?.toString() ?? '',
      sertifikasiRekomendasi: json['sertifikasi_rekomendasi'] as Map<String, dynamic>?,
      pelatihanRekomendasi: json['pelatihan_rekomendasi'] as Map<String, dynamic>?,
    );
  }
}