// lib/models/level_model.dart
class UserLevel {
  final String kode;
  final String nama;

  UserLevel({
    required this.kode,
    required this.nama,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      kode: json['kode'].toString(), // Ensure String type
      nama: json['nama'].toString(), // Ensure String type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'nama': nama,
    };
  }
}