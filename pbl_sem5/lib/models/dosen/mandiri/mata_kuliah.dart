// lib/models/dosen/mandiri/mata_kuliah.dart
import 'package:equatable/equatable.dart';

class MataKuliah extends Equatable {
  final String matkulId;
  final String matkulNama;

  const MataKuliah({
    required this.matkulId,
    required this.matkulNama,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      matkulId: json['matkul_id'].toString(),
      matkulNama: json['matkul_nama'],
    );
  }

  Map<String, dynamic> toJson() => {
    'matkul_id': matkulId,
    'matkul_nama': matkulNama,
  };

  @override
  List<Object?> get props => [matkulId, matkulNama];
}