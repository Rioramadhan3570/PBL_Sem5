// models/dosen_model.dart
class DosenModel {
  final String nip;
  final String prodi;
  final String telepon;
  final List<String> keahlian;
  final List<String> mataKuliah;
  final String? avatar;

  DosenModel({
    required this.nip,
    required this.prodi,
    required this.telepon,
    required this.keahlian,
    required this.mataKuliah,
    this.avatar,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      nip: json['NIP'] ?? '',
      prodi: json['Prodi'] ?? '',
      telepon: json['Telepon'] ?? '',
      keahlian: List<String>.from(json['Keahlian'] ?? []),
      mataKuliah: List<String>.from(json['Mata Kuliah'] ?? []),
      avatar: json['avatar'],
    );
  }
}