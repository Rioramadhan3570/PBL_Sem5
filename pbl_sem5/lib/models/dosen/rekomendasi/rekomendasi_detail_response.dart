// lib/models/rekomendasi/rekomendasi_detail_response.dart
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_detail_model.dart';

class RekomendasiDetailResponse {
  final bool status;
  final String message;
  final RekomendasiDetail data;

  RekomendasiDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RekomendasiDetailResponse.fromJson(Map<String, dynamic> json) {
    return RekomendasiDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: RekomendasiDetail.fromJson(json['data'] ?? {}),
    );
  }
}
