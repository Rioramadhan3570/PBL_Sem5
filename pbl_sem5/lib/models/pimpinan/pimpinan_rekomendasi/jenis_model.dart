// lib/models/jenis_model.dart
class JenisModel {
  final int id;
  final String kode;
  final String nama;

  JenisModel({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory JenisModel.fromJson(Map<String, dynamic> json) {
    return JenisModel(
      id: json['jenis_id'] ?? 0,
      kode: json['jenis_kode'] ?? '',
      nama: json['jenis_nama'] ?? '',
    );
  }
}