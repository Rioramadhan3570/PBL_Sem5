// lib/models/dosen/beranda/beranda_model.dart
import 'package:pbl_sem5/models/dosen/beranda/profil_data.dart';
import 'package:pbl_sem5/models/dosen/beranda/rekomendasi_model.dart';

class BerandaData {
  final UserInfo userInfo;
  final int totalSertifikasi;
  final int totalPelatihan;
  final List<RekomendasiItem> latestRekomendasi;

  BerandaData({
    required this.userInfo,
    required this.totalSertifikasi,
    required this.totalPelatihan,
    required this.latestRekomendasi,
  });

  factory BerandaData.fromJson(Map<String, dynamic> json) {
    return BerandaData(
      userInfo: UserInfo.fromJson(json['user_info']),
      totalSertifikasi: json['total_sertifikasi'] ?? 0,
      totalPelatihan: json['total_pelatihan'] ?? 0,
      latestRekomendasi: (json['latest_rekomendasi'] as List)
          .map((x) => RekomendasiItem.fromJson(x))
          .toList(),
    );
  }
}