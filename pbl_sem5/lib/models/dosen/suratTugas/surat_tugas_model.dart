class SuratTugasModel {
  final int id;
  final String judul;
  final String kategori;
  final String tanggal;

  SuratTugasModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggal,
  });

  factory SuratTugasModel.fromJson(Map<String, dynamic> json) {
    return SuratTugasModel(
      id: json['id'],
      judul: json['judul'],
      kategori: json['kategori'],
      tanggal: json['tanggal'],
    );
  }
}