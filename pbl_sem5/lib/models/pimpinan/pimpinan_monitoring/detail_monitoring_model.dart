// lib/models/monitoring/detail_monitoring_model.dart
class DetailMonitoringModel {
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggal;

  DetailMonitoringModel({
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggal,
  });

  factory DetailMonitoringModel.fromJson(Map<String, dynamic> json) {
    return DetailMonitoringModel(
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '',
      tempat: json['tempat'] ?? '',
      tanggal: json['tanggal'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul': judul,
      'kategori': kategori,
      'tempat': tempat,
      'tanggal': tanggal,
    };
  }
}
