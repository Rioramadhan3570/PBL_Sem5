// jenis_model.dart
class Jenis {
  final String jenisId;
  final String kode;
  final String nama;

  Jenis({
    required this.jenisId,
    required this.kode,
    required this.nama,
  });

  factory Jenis.fromJson(Map<String, dynamic> json) {
    return Jenis(
      jenisId: json['jenis_id'].toString(),
      kode: json['jenis_kode'] ?? '',
      nama: json['jenis_nama'] ?? '',
    );
  }
}