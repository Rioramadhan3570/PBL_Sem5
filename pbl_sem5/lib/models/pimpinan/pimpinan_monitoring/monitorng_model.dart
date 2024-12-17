// lib/models/monitoring/monitoring_model.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/jenis_model.dart';

class MonitoringModel {
  final String nama;
  final List<JenisModel> jenis;
  final String userId;

  MonitoringModel({
    required this.nama,
    required this.jenis,
    required this.userId,
  });

  factory MonitoringModel.fromJson(Map<String, dynamic> json) {
    return MonitoringModel(
      nama: json['nama'] ?? '',
      jenis: (json['jenis'] as List? ?? [])
          .map((item) => JenisModel.fromJson(item))
          .toList(),
      userId: json['user_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jenis': jenis.map((item) => item.toJson()).toList(),
      'user_id': userId,
    };
  }
}