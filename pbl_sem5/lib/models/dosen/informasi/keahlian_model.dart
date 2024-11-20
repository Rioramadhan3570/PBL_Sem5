// keahlian_model.dart
class Keahlian {
  final String keahlianId;
  final String kode;
  final String nama;

  Keahlian({
    required this.keahlianId,
    required this.kode,
    required this.nama,
  });

  factory Keahlian.fromJson(Map<String, dynamic> json) {
    return Keahlian(
      keahlianId: json['keahlian_id'].toString(),
      kode: json['keahlian_kode'] ?? '',
      nama: json['keahlian_nama'] ?? '',
    );
  }
}