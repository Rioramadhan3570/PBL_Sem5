class DetailRiwayatResponse {
  final String status;
  final DetailRiwayatData data;

  DetailRiwayatResponse({
    required this.status,
    required this.data,
  });

  factory DetailRiwayatResponse.fromJson(Map<String, dynamic> json) {
    return DetailRiwayatResponse(
      status: json['status'],
      data: DetailRiwayatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': data.toJson(),
  };
}

class DetailRiwayatData {
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggal;
  final String waktu;
  final String biaya;
  final String vendor;
  final String? jenisSertifikasi; // Hanya untuk sertifikasi
  final String jenisKompetensi;
  final String level;
  final List<String> bidangMinat;
  final List<String> mataKuliah;
  final int kuota;
  final String? vendorWeb;

  DetailRiwayatData({
    required this.judul,
    required this.kategori,
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
    this.vendorWeb,
  });

  factory DetailRiwayatData.fromJson(Map<String, dynamic> json) {
    return DetailRiwayatData(
      judul: json['judul'],
      kategori: json['kategori'],
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
      vendorWeb: json['vendor_web'],
    );
  }

  Map<String, dynamic> toJson() => {
    'judul': judul,
    'kategori': kategori,
    'tempat': tempat,
    'tanggal': tanggal,
    'waktu': waktu,
    'biaya': biaya,
    'vendor': vendor,
    'jenis_sertifikasi': jenisSertifikasi,
    'jenis_kompetensi': jenisKompetensi,
    'level': level,
    'bidang_minat': bidangMinat,
    'mata_kuliah': mataKuliah,
    'kuota': kuota,
    'vendor_web': vendorWeb,
  };
}