// lib/models/detail_keahlian_model.dart
import 'package:pbl_sem5/models/dosen/informasi/keahlian_model.dart';

class DetailKeahlian {
  final int detailKeahlianId;
  final int dosenId;
  final int keahlianId;
  final Keahlian keahlian;

  DetailKeahlian({
    required this.detailKeahlianId,
    required this.dosenId,
    required this.keahlianId,
    required this.keahlian,
  });

  factory DetailKeahlian.fromJson(Map<String, dynamic> json) {
    return DetailKeahlian(
      detailKeahlianId: json['detail_keahlian_id'],
      dosenId: json['dosen_id'],
      keahlianId: json['keahlian_id'],
      keahlian: Keahlian.fromJson(json['keahlian']),
    );
  }
}