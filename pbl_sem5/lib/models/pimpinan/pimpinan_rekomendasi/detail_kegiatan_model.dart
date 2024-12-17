// lib/models/detail_kegiatan_model.dart
class DetailKegiatanModel {
  final String id;
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggal; 
  final String tanggalMulai;
  final String tanggalSelesai;
  final String waktu;
  final String biaya;
  final String vendor;
  final String? jenisSertifikasi;
  final String jenisKompetensi;
  final String level;
  final List<String> bidangMinat;
  final List<String> mataKuliah;
  final int kuota;
  final String vendorWeb;
  final String status;

  DetailKegiatanModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggal,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.waktu,
    required this.biaya,
    required this.vendor,
    this.jenisSertifikasi,
    required this.jenisKompetensi,
    required this.level,
    required this.bidangMinat,
    required this.mataKuliah,
    required this.kuota,
    required this.vendorWeb,
    this.status = 'pending',
  });

  factory DetailKegiatanModel.fromJson(Map<String, dynamic> json) {
    return DetailKegiatanModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
      waktu: json['waktu'] ?? '',
      biaya: json['biaya'] ?? '',
      vendor: json['vendor'] ?? '',
      jenisSertifikasi: json['jenis_sertifikasi'],
      jenisKompetensi: json['jenis_kompetensi'] ?? '',
      level: json['level'] ?? '',
      bidangMinat: List<String>.from(json['bidang_minat'] ?? []),
      mataKuliah: List<String>.from(json['mata_kuliah'] ?? []),
      kuota: json['kuota'] ?? 0,
      vendorWeb: json['vendor_web'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }

  DetailKegiatanModel copyWith({
    String? status,
  }) {
    return DetailKegiatanModel(
      id: id,
      judul: judul,
      kategori: kategori,
      tempat: tempat,
      tanggal: tanggal,
      tanggalMulai: tanggalMulai,
      tanggalSelesai: tanggalSelesai,
      waktu: waktu,
      biaya: biaya,
      vendor: vendor,
      jenisSertifikasi: jenisSertifikasi,
      jenisKompetensi: jenisKompetensi,
      level: level,
      bidangMinat: bidangMinat,
      mataKuliah: mataKuliah,
      kuota: kuota,
      vendorWeb: vendorWeb,
      status: status ?? this.status,
    );
  }
}