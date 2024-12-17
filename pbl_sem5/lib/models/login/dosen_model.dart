// lib/models/login/dosen_model.dart
class DosenModel {
  final int dosenId;
  final String? dosenNip;
  final String? dosenProdi;

  DosenModel({
    required this.dosenId,
    this.dosenNip,
    this.dosenProdi,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    return DosenModel(
      dosenId: json['dosen_id'] ?? 0,
      dosenNip: json['dosen_nip'],
      dosenProdi: json['dosen_prodi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dosen_id': dosenId,
      'dosen_nip': dosenNip,
      'dosen_prodi': dosenProdi,
    };
  }
}