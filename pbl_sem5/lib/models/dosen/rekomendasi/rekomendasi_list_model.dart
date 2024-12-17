// lib/models/rekomendasi/rekomendasi_list_model.dart
class RekomendasiItem {
  final String id;
  final String judul;
  final String tipe;
  final String tempat;
  final String tanggal;
  final String level;

  RekomendasiItem({
    required this.id,
    required this.judul,
    required this.tipe,
    required this.tempat,
    required this.tanggal,
    required this.level,
  });

  factory RekomendasiItem.fromJson(Map<String, dynamic> json) {
    return RekomendasiItem(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? '',
      tipe: json['tipe'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      level: json['level'] ?? '',
    );
  }
}