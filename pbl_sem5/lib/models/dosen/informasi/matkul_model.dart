// matkul_model.dart
class Matkul {
  final String matkulId;
  final String kode;
  final String nama;

  Matkul({
    required this.matkulId,
    required this.kode,
    required this.nama,
  });

  factory Matkul.fromJson(Map<String, dynamic> json) {
    return Matkul(
      matkulId: json['matkul_id'].toString(),
      kode: json['matkul_kode'] ?? '',
      nama: json['matkul_nama'] ?? '',
    );
  }
}