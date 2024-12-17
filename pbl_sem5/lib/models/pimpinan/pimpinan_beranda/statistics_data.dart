// lib/models/beranda/statistics_data.dart
class StatisticsData {
  final int totalSertifikasi;
  final int totalPelatihan;

  StatisticsData({
    required this.totalSertifikasi,
    required this.totalPelatihan,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      totalSertifikasi: json['total_sertifikasi'] ?? 0,
      totalPelatihan: json['total_pelatihan'] ?? 0,
    );
  }
}