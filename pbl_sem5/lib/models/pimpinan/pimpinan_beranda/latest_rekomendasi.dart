// lib/models/beranda/latest_rekomendasi.dart
class LatestRekomendasi {
  final String id;
  final String judul;
  final String kategori;
  final String status;
  final String createdAt;

  LatestRekomendasi({
    required this.id,
    required this.judul,
    required this.kategori,
    this.status = 'pending',
    required this.createdAt,
  });

  factory LatestRekomendasi.fromJson(Map<String, dynamic> json) {
    return LatestRekomendasi(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] ?? '',
    );
  }
}