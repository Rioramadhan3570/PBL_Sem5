// lib/models/dosen/mandiri/sertifikasi_mandiri.dart
import 'package:equatable/equatable.dart';
import 'package:pbl_sem5/models/dosen/mandiri/jenis.dart';
import 'package:pbl_sem5/models/dosen/mandiri/vendor.dart';
import 'package:pbl_sem5/models/dosen/mandiri/bidang_minat.dart';
import 'package:pbl_sem5/models/dosen/mandiri/mata_kuliah.dart';

class SertifikasiMandiri extends Equatable {
  final String sertifikasiMandiriId;
  final String jenisId;
  final String vendorId;
  final String sertifikasiNama;
  final DateTime sertifikasiStart;
  final DateTime sertifikasiEnd;
  final String sertifikasiTempat;
  final double sertifikasiBiaya;
  final String sertifikasiJenis;
  final String sertifikasiLevel;
  final List<BidangMinat> bidangMinat;
  final List<MataKuliah> mataKuliah;
  final Vendor? vendor;
  final Jenis? jenis;

  const SertifikasiMandiri({
    required this.sertifikasiMandiriId,
    required this.jenisId,
    required this.vendorId,
    required this.sertifikasiNama,
    required this.sertifikasiStart,
    required this.sertifikasiEnd,
    required this.sertifikasiTempat,
    required this.sertifikasiBiaya,
    required this.sertifikasiJenis,
    required this.sertifikasiLevel,
    required this.bidangMinat,
    required this.mataKuliah,
    this.vendor,
    this.jenis,
  });

  factory SertifikasiMandiri.fromJson(Map<String, dynamic> json) {
    return SertifikasiMandiri(
      sertifikasiMandiriId: json['sertifikasi_mandiri_id'].toString(),
      jenisId: json['jenis_id'].toString(),
      vendorId: json['vendor_id'].toString(),
      sertifikasiNama: json['sertifikasi_nama'],
      sertifikasiStart: DateTime.parse(json['sertifikasi_start']),
      sertifikasiEnd: DateTime.parse(json['sertifikasi_end']),
      sertifikasiTempat: json['sertifikasi_tempat'],
      sertifikasiBiaya: double.parse(json['sertifikasi_biaya'].toString()),
      sertifikasiJenis: json['sertifikasi_jenis'],
      sertifikasiLevel: json['sertifikasi_level'],
      bidangMinat: (json['bidang_minat'] as List? ?? [])
          .map((e) => BidangMinat.fromJson(e))
          .toList(),
      mataKuliah: (json['mata_kuliah'] as List? ?? [])
          .map((e) => MataKuliah.fromJson(e))
          .toList(),
      vendor: json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null,
      jenis: json['jenis'] != null ? Jenis.fromJson(json['jenis']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'sertifikasi_mandiri_id': sertifikasiMandiriId,
        'jenis_id': jenisId,
        'vendor_id': vendorId,
        'sertifikasi_nama': sertifikasiNama,
        'sertifikasi_start': sertifikasiStart.toIso8601String(),
        'sertifikasi_end': sertifikasiEnd.toIso8601String(),
        'sertifikasi_tempat': sertifikasiTempat,
        'sertifikasi_biaya': sertifikasiBiaya,
        'sertifikasi_jenis': sertifikasiJenis,
        'sertifikasi_level': sertifikasiLevel,
        'bidang_minat': bidangMinat.map((e) => e.toJson()).toList(),
        'mata_kuliah': mataKuliah.map((e) => e.toJson()).toList(),
        'vendor': vendor?.toJson(),
      };

  @override
  List<Object?> get props => [
        sertifikasiMandiriId,
        jenisId,
        vendorId,
        sertifikasiNama,
        sertifikasiStart,
        sertifikasiEnd,
        sertifikasiTempat,
        sertifikasiBiaya,
        sertifikasiJenis,
        sertifikasiLevel,
        bidangMinat,
        mataKuliah,
        vendor,
        jenis,
      ];
}