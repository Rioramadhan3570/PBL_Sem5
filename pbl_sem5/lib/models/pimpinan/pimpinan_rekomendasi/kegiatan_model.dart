// lib/models/kegiatan_model.dart
class KegiatanModel {
  final String id;
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggal;
  final String level;
  final String jenisKompetensi;
  final String? tanggalKonfirmasi;
  final String status;

  KegiatanModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggal,
    required this.level,
    required this.jenisKompetensi,
    this.tanggalKonfirmasi,
    this.status = 'pending',
  });

  KegiatanModel copyWith({
    String? status,
  }) {
    return KegiatanModel(
      id: id,
      judul: judul,
      kategori: kategori,
      tempat: tempat,
      tanggal: tanggal,
      level: level,
      jenisKompetensi: jenisKompetensi,
      status: status ?? this.status,
    );
  }

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      level: json['level'] ?? '',
      jenisKompetensi: json['jenis_kompetensi'] ?? '',
      tanggalKonfirmasi: json['tanggal_konfirmasi'],
      status: json['status'] ?? 'pending',
    );
  }
}