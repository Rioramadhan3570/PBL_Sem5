// lib/models/peserta_model.dart
class PesertaModel {
  final String id;  // Ubah ke String untuk mengakomodasi ID yang diterima
  final String nama;

  PesertaModel({
    required this.id,
    required this.nama,
  });

  factory PesertaModel.fromJson(Map<String, dynamic> json) {
    return PesertaModel(
      id: json['id'].toString(), // Konversi ke String
      nama: json['nama'] ?? '',
    );
  }
}