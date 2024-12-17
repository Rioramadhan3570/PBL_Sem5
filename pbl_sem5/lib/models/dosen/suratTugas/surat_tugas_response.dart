// lib/models/surat_tugas/surat_tugas_response.dart
import 'package:pbl_sem5/models/dosen/suratTugas/surat_tugas_model.dart';

class SuratTugasResponse {
  final bool status;
  final String message;
  final List<SuratTugasModel> data;

  SuratTugasResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SuratTugasResponse.fromJson(Map<String, dynamic> json) {
    return SuratTugasResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => SuratTugasModel.fromJson(item))
          .toList(),
    );
  }
}