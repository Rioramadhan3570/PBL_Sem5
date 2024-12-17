// lib/models/rekomendasi/rekomendasi_list_response.dart
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_list_model.dart';

class RekomendasiListResponse {
  final bool status;
  final String message;
  final List<RekomendasiItem> data;

  RekomendasiListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RekomendasiListResponse.fromJson(Map<String, dynamic> json) {
    return RekomendasiListResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => RekomendasiItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}