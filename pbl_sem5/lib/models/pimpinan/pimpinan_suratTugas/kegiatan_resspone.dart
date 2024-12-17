import 'package:pbl_sem5/models/pimpinan/pimpinan_suratTugas/kegiatan_model.dart';

class KegiatanResponse {
  final bool status;
  final String message;
  final List<KegiatanModel> data;

  KegiatanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KegiatanResponse.fromJson(Map<String, dynamic> json) {
    return KegiatanResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => KegiatanModel.fromJson(item))
          .toList(),
    );
  }
}