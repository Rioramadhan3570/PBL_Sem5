// lib/models/monitoring/jenis_model.dart
class JenisModel {
  final String kategori;
  final String aksi;

  JenisModel({
    required this.kategori,
    required this.aksi,
  });

  factory JenisModel.fromJson(Map<String, dynamic> json) {
    return JenisModel(
      kategori: json['kategori'] ?? '',
      aksi: json['aksi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategori': kategori,
      'aksi': aksi,
    };
  }
}