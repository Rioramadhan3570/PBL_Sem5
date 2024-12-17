// lib/models/rekomendasi/download_response.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbl_sem5/models/dosen/rekomendasi/download_model.dart';

class DownloadResponse {
  final bool status;
  final String message;
  final DownloadData? data;

  DownloadResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory DownloadResponse.fromResponse(http.Response response) {
    if (response.statusCode == 200) {
      return DownloadResponse(
        status: true,
        message: 'Download berhasil',
        data: DownloadData(fileBytes: response.bodyBytes),
      );
    } else {
      Map<String, dynamic> json = jsonDecode(response.body);
      return DownloadResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? 'Download gagal',
        data: null,
      );
    }
  }
}