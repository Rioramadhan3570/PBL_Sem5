// lib/models/notifikasi/notifikasi_response.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_notifikasi/notifikasi_data.dart';

class NotifikasiResponse {
  final String status;
  final List<NotifikasiData> data;

  NotifikasiResponse({
    required this.status,
    required this.data,
  });

  factory NotifikasiResponse.fromJson(Map<String, dynamic> json) {
    var notifications = List<NotifikasiData>.from(
        json['data'].map((x) => NotifikasiData.fromJson(x)));
    
    // Sort by sortDate
    notifications.sort((a, b) => b.sortDate.compareTo(a.sortDate));

    return NotifikasiResponse(
      status: json['status'],
      data: notifications,
    );
  }
}