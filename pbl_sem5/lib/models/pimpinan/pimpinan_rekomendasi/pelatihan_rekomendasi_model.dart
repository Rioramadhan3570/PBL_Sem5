// lib/models/pelatihan_rekomendasi_model.dart

class PelatihanRekomendasiModel {
  final int id;
  final String judul;
  final String kategori;
  final Map<String, String> pelaksanaan;
  final String biaya;
  final String vendor;
  final String jenisKompetensi;
  final String level;
  final List<String> tagBidangMinat;
  final List<String> tagMataKuliah;
  final String kuotaPeserta;
  final String linkWeb;

  PelatihanRekomendasiModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.pelaksanaan,
    required this.biaya,
    required this.vendor,
    required this.jenisKompetensi,
    required this.level,
    required this.tagBidangMinat,
    required this.tagMataKuliah,
    required this.kuotaPeserta,
    required this.linkWeb,
  });

  factory PelatihanRekomendasiModel.fromJson(Map<String, dynamic> json) {
    return PelatihanRekomendasiModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      pelaksanaan: Map<String, String>.from(json['pelaksanaan'] ?? {}),
      biaya: json['biaya'] ?? '',
      vendor: json['vendor'] ?? '',
      jenisKompetensi: json['jenis_kompetensi'] ?? '',
      level: json['level'] ?? '',
      tagBidangMinat: List<String>.from(json['tag_bidang_minat'] ?? []),
      tagMataKuliah: List<String>.from(json['tag_mata_kuliah'] ?? []),
      kuotaPeserta: json['kuota_peserta'] ?? '',
      linkWeb: json['link_web'] ?? '',
    );
  }
}