// lib/models/keahlian_model.dart
class KeahlianModel {
  final int id;
  final String kode;
  final String nama;

  KeahlianModel({
    required this.id,
    required this.kode,
    required this.nama,
  });

  factory KeahlianModel.fromJson(Map<String, dynamic> json) {
    return KeahlianModel(
      id: json['keahlian_id'] ?? 0,
      kode: json['keahlian_kode'] ?? '',
      nama: json['keahlian_nama'] ?? '',
    );
  }
}