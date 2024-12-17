// lib/models/dosen/mandiri/pelatihan_mandiri.dart
import 'package:equatable/equatable.dart';
import 'package:pbl_sem5/models/dosen/mandiri/jenis.dart';
import 'package:pbl_sem5/models/dosen/mandiri/vendor.dart';
import 'package:pbl_sem5/models/dosen/mandiri/bidang_minat.dart';
import 'package:pbl_sem5/models/dosen/mandiri/mata_kuliah.dart';

class PelatihanMandiri extends Equatable {
  final String pelatihanMandiriId;
  final String jenisId;
  final String vendorId;
  final String pelatihanNama;
  final DateTime pelatihanStart;
  final DateTime pelatihanEnd;
  final String pelatihanTempat;
  final double pelatihanBiaya;
  final String pelatihanLevel;
  final List<BidangMinat> bidangMinat;
  final List<MataKuliah> mataKuliah;
  final Vendor? vendor;
  final Jenis? jenis;

  const PelatihanMandiri({
    required this.pelatihanMandiriId,
    required this.jenisId,
    required this.vendorId,
    required this.pelatihanNama,
    required this.pelatihanStart,
    required this.pelatihanEnd,
    required this.pelatihanTempat,
    required this.pelatihanBiaya,
    required this.pelatihanLevel,
    required this.bidangMinat,
    required this.mataKuliah,
    this.vendor,
    this.jenis,
  });

  factory PelatihanMandiri.fromJson(Map<String, dynamic> json) {
    return PelatihanMandiri(
      pelatihanMandiriId: json['pelatihan_mandiri_id'].toString(),
      jenisId: json['jenis_id'].toString(),
      vendorId: json['vendor_id'].toString(),
      pelatihanNama: json['pelatihan_nama'],
      pelatihanStart: DateTime.parse(json['pelatihan_start']),
      pelatihanEnd: DateTime.parse(json['pelatihan_end']),
      pelatihanTempat: json['pelatihan_tempat'],
      pelatihanBiaya: double.parse(json['pelatihan_biaya'].toString()),
      pelatihanLevel: json['pelatihan_level'],
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
        'pelatihan_mandiri_id': pelatihanMandiriId,
        'jenis_id': jenisId,
        'vendor_id': vendorId,
        'pelatihan_nama': pelatihanNama,
        'pelatihan_start': pelatihanStart.toIso8601String(),
        'pelatihan_end': pelatihanEnd.toIso8601String(),
        'pelatihan_tempat': pelatihanTempat,
        'pelatihan_biaya': pelatihanBiaya,
        'pelatihan_level': pelatihanLevel,
        'bidang_minat': bidangMinat.map((e) => e.toJson()).toList(),
        'mata_kuliah': mataKuliah.map((e) => e.toJson()).toList(),
        'vendor': vendor?.toJson(),
      };

  @override
  List<Object?> get props => [
        pelatihanMandiriId,
        jenisId,
        vendorId,
        pelatihanNama,
        pelatihanStart,
        pelatihanEnd,
        pelatihanTempat,
        pelatihanBiaya,
        pelatihanLevel,
        bidangMinat,
        mataKuliah,
        vendor,
        jenis,
      ];
}