class BuktiModel {
  final String id;
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggalMulai;
  final String waktu;
  final String pendanaan;
  final int biaya;
  final String statusBukti;
  final String? bukti;
  final String? tanggalKadaluwarsa;
  final String? komentar;

  BuktiModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggalMulai,
    required this.waktu,
    required this.pendanaan,
    required this.biaya,
    required this.statusBukti,
    this.bukti,
    this.tanggalKadaluwarsa,
    this.komentar,
  });

  factory BuktiModel.fromJson(Map<String, dynamic> json) {
    return BuktiModel(
      id: json['id'],
      judul: json['judul'],
      kategori: json['kategori'],
      tempat: json['tempat'],
      tanggalMulai: json['tanggal_mulai'],
      waktu: json['waktu'],
      pendanaan: json['pendanaan'],
      biaya: json['biaya'],
      statusBukti: json['status_bukti'],
      bukti: json['bukti'],
      tanggalKadaluwarsa: json['tanggal_kadaluwarsa'],
      komentar: json['komentar'],
    );
  }
}