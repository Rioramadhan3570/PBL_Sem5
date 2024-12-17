// lib/models/sertifikasi_pelatihan_model.dart
class SertifikasiPelatihanModel {
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggal;

  SertifikasiPelatihanModel({
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggal,
  });

  factory SertifikasiPelatihanModel.fromJson(Map<String, dynamic> json) {
    return SertifikasiPelatihanModel(
      judul: json['judul'] as String,
      kategori: json['kategori'] as String,
      tempat: json['tempat'] as String,
      tanggal: json['tanggal'] as String,
    );
  }
}
