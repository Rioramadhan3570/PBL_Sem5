class NotifikasiModel {
  final String id;
  final String pesan;
  final String judul;
  final String tipe;
  final String vendor;
  final String tanggal;
  final String url;

  NotifikasiModel({
    required this.id,
    required this.pesan,
    required this.judul,
    required this.tipe,
    required this.vendor,
    required this.tanggal,
    required this.url,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id']?.toString() ?? '',
      pesan: json['pesan'],
      judul: json['judul'] ?? '',
      tipe: json['tipe'] ?? '',
      vendor: json['vendor'],
      tanggal: json['tanggal'],
      url: json['url'],
    );
  }
}
