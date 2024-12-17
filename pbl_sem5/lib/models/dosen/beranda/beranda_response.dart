// lib/models/dosen/beranda/beranda_response.dart
import 'package:pbl_sem5/models/dosen/beranda/beranda_model.dart';

class BerandaResponse {
  final bool status;
  final BerandaData data;

  BerandaResponse({
    required this.status,
    required this.data,
  });

  factory BerandaResponse.fromJson(Map<String, dynamic> json) {
    return BerandaResponse(
      status: json['status'] == 'success',
      data: BerandaData.fromJson(json['data']),
    );
  }
}