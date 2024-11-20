class Level {
  final String kode;
  final String nama;

  Level({
    required this.kode,
    required this.nama,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      kode: json['kode'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'nama': nama,
    };
  }
}