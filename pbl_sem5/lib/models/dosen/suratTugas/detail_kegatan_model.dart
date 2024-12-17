class DetailKegiatanModel {
  final String judul;
  final String jenis;
  final String tempat;
  final String tanggal;
  final String waktu;
  final String biaya;
  final String vendor;
  final String? jenisSertifikasi;
  final String jenisKompetensi;
  final String level;
  final List<String> bidangMinat;
  final List<String> mataKuliah;
  final int kuota;
  final List<String> peserta;
  final String vendorWeb;
  final String? suratTugas;

  DetailKegiatanModel({
    required this.judul,
    required this.jenis,
    required this.tempat,
    required this.tanggal,
    required this.waktu,
    required this.biaya,
    required this.vendor,
    this.jenisSertifikasi,
    required this.jenisKompetensi,
    required this.level,
    required this.bidangMinat,
    required this.mataKuliah,
    required this.kuota,
    required this.peserta,
    required this.vendorWeb,
    this.suratTugas,
  });

  factory DetailKegiatanModel.fromJson(Map<String, dynamic> json) {
    return DetailKegiatanModel(
      judul: json['judul'],
      jenis: json['jenis'],
      tempat: json['tempat'],
      tanggal: json['tanggal'],
      waktu: json['waktu'],
      biaya: json['biaya'],
      vendor: json['vendor'],
      jenisSertifikasi: json['jenis_sertifikasi'],
      jenisKompetensi: json['jenis_kompetensi'],
      level: json['level'],
      bidangMinat: List<String>.from(json['bidang_minat']),
      mataKuliah: List<String>.from(json['mata_kuliah']),
      kuota: json['kuota'],
      peserta: List<String>.from(json['peserta']),
      vendorWeb: json['vendor_web'],
      suratTugas: json['surat_tugas'],
    );
  }
}