// lib/models/upload_response_model.dart
class UploadResponseModel {
  final String? bukti;
  final String? tanggalKadaluwarsa;
  final String? statusBukti;
  final String? komentar;

  UploadResponseModel({
    this.bukti,
    this.tanggalKadaluwarsa,
    this.statusBukti,
    this.komentar,
  });

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      bukti: json['bukti'],
      tanggalKadaluwarsa: json['tanggal_kadaluwarsa'] as String?,
      statusBukti: json['status_bukti'] as String?,
      komentar: json['komentar'] as String?,
    );
  }
}