class ReuploadResponse {
  final String? bukti;
  final String? tanggalKadaluwarsa;
  final String? statusBukti;
  final String? komentar;

  ReuploadResponse({
    this.bukti,
    this.tanggalKadaluwarsa,
    this.statusBukti,
    this.komentar,
  });

  factory ReuploadResponse.fromJson(Map<String, dynamic> json) {
    return ReuploadResponse(
      bukti: json['bukti'],
      tanggalKadaluwarsa: json['tanggal_kadaluwarsa'] as String?,
      statusBukti: json['status_bukti'] as String?,
      komentar: json['komentar'] as String?,
    );
  }
}