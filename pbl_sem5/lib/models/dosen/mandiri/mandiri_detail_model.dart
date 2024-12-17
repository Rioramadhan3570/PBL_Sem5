// lib/models/dosen/mandiri/mandiri_detail_model.dart
import 'package:equatable/equatable.dart';

class MandiriDetail extends Equatable {
  final String judul;
  final String jenis;
  final String tempat;
  final String tanggal;
  final String waktu;
  final int biaya; // Menggunakan int karena API mengirim number
  final String vendorId;
  final String vendorNama;
  final String jenisId;
  final String? jenisSertifikasi;
  final String jenisKompetensi;
  final String level;
  final List<Map<String, dynamic>> bidangMinat;
  final List<Map<String, dynamic>> mataKuliah;

  const MandiriDetail({
    required this.judul,
    required this.jenis,
    required this.tempat,
    required this.tanggal,
    required this.waktu,
    required this.biaya,
    required this.vendorId,
    required this.vendorNama,
    required this.jenisId,
    this.jenisSertifikasi,
    required this.jenisKompetensi,
    required this.level,
    required this.bidangMinat,
    required this.mataKuliah,
  });

  factory MandiriDetail.fromJson(Map<String, dynamic> json) {
    return MandiriDetail(
      judul: json['judul'] ?? '',
      jenis: json['jenis'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
      biaya: json['biaya'] is int
          ? json['biaya']
          : int.parse(json['biaya'].toString()),
      vendorId: json['vendor_id']?.toString() ?? '',
      vendorNama: json['vendorNama'] ?? '',
      jenisId: json['jenis_id']?.toString() ?? '',
      jenisSertifikasi: json['jenis_sertifikasi'],
      jenisKompetensi: json['jenis_kompetensi'] ?? '',
      level: json['level'] ?? '',
      bidangMinat: (json['bidang_minat'] as List?)
              ?.map((item) => {
                    'id': item['id']?.toString() ?? '',
                    'nama': item['nama']?.toString() ?? '',
                  })
              .toList() ??
          [],
      mataKuliah: (json['mata_kuliah'] as List?)
              ?.map((item) => {
                    'id': item['id']?.toString() ?? '',
                    'nama': item['nama']?.toString() ?? '',
                  })
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'judul': judul,
        'jenis': jenis,
        'tempat': tempat,
        'tanggal': tanggal,
        'waktu': waktu,
        'biaya': biaya,
        'vendor_id': vendorId,
        'jenis_id': jenisId,
        'jenis_sertifikasi': jenisSertifikasi,
        'jenis_kompetensi': jenisKompetensi,
        'level': level,
        'bidang_minat': bidangMinat,
        'mata_kuliah': mataKuliah,
      };

  @override
  List<Object?> get props => [
        judul,
        jenis,
        tempat,
        tanggal,
        waktu,
        biaya,
        vendorId,
        jenisId,
        jenisSertifikasi,
        jenisKompetensi,
        level,
        bidangMinat,
        mataKuliah,
      ];
}
