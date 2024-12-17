// lib/models/dosen/mandiri/kompetensi.dart
import 'package:equatable/equatable.dart';

class JenisKompetensi extends Equatable {
  final String jenisId;
  final String jenisNama;

  const JenisKompetensi({
    required this.jenisId,
    required this.jenisNama,
  });

  factory JenisKompetensi.fromJson(Map<String, dynamic> json) {
    return JenisKompetensi(
      jenisId: json['jenis_id'].toString(),
      jenisNama: json['jenis_nama'],
    );
  }

  Map<String, dynamic> toJson() => {
    'jenis_id': jenisId,
    'jenis_nama': jenisNama,
  };

  @override
  List<Object?> get props => [jenisId, jenisNama];
}