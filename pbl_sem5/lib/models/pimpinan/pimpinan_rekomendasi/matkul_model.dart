// lib/models/matkul_model.dart
class MatkulModel {
  final int id;
  final String kode;
  final String nama;

  MatkulModel({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory MatkulModel.fromJson(Map<String, dynamic> json) {
    return MatkulModel(
      id: json['matkul_id'] ?? 0,
      kode: json['matkul_kode'] ?? '',
      nama: json['matkul_nama'] ?? '',
    );
  }
}