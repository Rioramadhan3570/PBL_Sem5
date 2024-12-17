class RekomendasiModel {
  final String id;
  final String judul;
  final String tipe;
  final String tempat;
  final String tanggal;
  final String level;

  RekomendasiModel({
    required this.id,
    required this.judul,
    required this.tipe,
    required this.tempat,
    required this.tanggal,
    required this.level,
  });

  factory RekomendasiModel.fromJson(Map<String, dynamic> json) {
    return RekomendasiModel(
      id: json['id'],
      judul: json['judul'],
      tipe: json['tipe'],
      tempat: json['tempat'],
      tanggal: json['tanggal'],
      level: json['level'],
    );
  }
}