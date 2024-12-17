// lib/models/dosen/beranda/rekomendasi_model.dart
class RekomendasiItem {
  final String id;
  final String judul;
  final String tipe;

  RekomendasiItem({
    required this.id,
    required this.judul, 
    required this.tipe,
  });

  factory RekomendasiItem.fromJson(Map<String, dynamic> json) {
    return RekomendasiItem(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      tipe: json['tipe'] ?? '',
    );
  }
}