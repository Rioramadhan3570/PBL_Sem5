// lib/models/pimpinan/pimpinan_rekomendasi/riwayat_model.dart
enum RiwayatKategori { sertifikasi, pelatihan }

class RiwayatModel {
  final RiwayatKategori kategori;
  final String judul;
  final String? tempat;
  final String tanggal;

  RiwayatModel({
    required this.kategori,
    required this.judul,
    this.tempat,
    required this.tanggal,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    final kategoriString = json['kategori'] as String;
    final RiwayatKategori kategori;
    switch (kategoriString) {
      case 'sertifikasi':
        kategori = RiwayatKategori.sertifikasi;
        break;
      case 'pelatihan':
        kategori = RiwayatKategori.pelatihan;
        break;
      default:
        throw Exception('Invalid riwayat kategori: $kategoriString');
    }

    return RiwayatModel(
      kategori: kategori,
      judul: json['judul'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }
}