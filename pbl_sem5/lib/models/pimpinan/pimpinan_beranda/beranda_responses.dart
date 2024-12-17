// lib/models/beranda/beranda_response.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/latest_rekomendasi.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/profile_data.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/statistics_data.dart';

class BerandaResponse {
  final ProfileData profile;
  final StatisticsData statistics;
  final List<LatestRekomendasi> latestRekomendasi;

  BerandaResponse({
    required this.profile,
    required this.statistics,
    required this.latestRekomendasi,
  });

  factory BerandaResponse.fromJson(Map<String, dynamic> json) {
    return BerandaResponse(
      profile: ProfileData.fromJson(json['profile']),
      statistics: StatisticsData.fromJson(json['statistics']),
      latestRekomendasi: (json['latest_rekomendasi'] as List)
          .map((item) => LatestRekomendasi.fromJson(item))
          .toList(),
    );
  }
}