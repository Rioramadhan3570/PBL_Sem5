class KegiatanModel {
  final int id;
  final String judul;
  final String kategori;
  final String tanggalMulai;

  KegiatanModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tanggalMulai,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'],
      judul: json['judul'],
      kategori: json['kategori'],
      tanggalMulai: json['tanggal_mulai'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'tanggal_mulai': tanggalMulai,
    };
  }
}