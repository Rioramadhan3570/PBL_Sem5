// lib/models/notifikasi/notifikasi_data.dart
class NotifikasiData {
  final String id;
  final String message;
  final String judul;
  final String kategori;
  final String vendor;
  final String level;
  final String tempat;
  final String tanggal;
  final String tanggalPengajuan;
  final int sortDate;  // Tambahkan ini
  final String status;

  NotifikasiData({
    required this.id,
    required this.message,
    required this.judul,
    required this.kategori,
    required this.vendor,
    required this.level,
    required this.tempat,
    required this.tanggal,
    required this.tanggalPengajuan,
    required this.sortDate,
    this.status = 'pending',
  });

  factory NotifikasiData.fromJson(Map<String, dynamic> json) {
    return NotifikasiData(
      id: json['id'].toString(),
      message: json['message'] ?? '',
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      vendor: json['vendor'] ?? '',
      level: json['level'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
      tanggalPengajuan: json['tanggal_pengajuan'] ?? '',
      sortDate: json['sort_date'] ?? 0,
      status: json['status'] ?? 'pending',
    );
  }
}