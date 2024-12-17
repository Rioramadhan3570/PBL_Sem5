// models/jenis.dart
import 'package:equatable/equatable.dart';

class Jenis extends Equatable {
  final String jenisId;
  final String jenisKode;
  final String jenisNama;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Jenis({
    required this.jenisId,
    required this.jenisKode,
    required this.jenisNama,
    this.createdAt,
    this.updatedAt,
  });

  factory Jenis.fromJson(Map<String, dynamic> json) {
    return Jenis(
      jenisId: json['jenis_id'].toString(),
      jenisKode: json['jenis_kode'],
      jenisNama: json['jenis_nama'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'jenis_id': jenisId,
    'jenis_kode': jenisKode,
    'jenis_nama': jenisNama,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [jenisId, jenisKode, jenisNama, createdAt, updatedAt];
}