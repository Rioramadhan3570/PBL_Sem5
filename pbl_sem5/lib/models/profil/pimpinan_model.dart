// lib/models/pimpinan/pimpinan_model.dart
class PimpinanModel {
  final String nip;
  final String posisi;
  final String telepon;
  final String? avatar;

  PimpinanModel({
    required this.nip,
    required this.posisi,
    required this.telepon,
    this.avatar,
  });

  factory PimpinanModel.fromJson(Map<String, dynamic> json) {
    return PimpinanModel(
      nip: json['NIP']?.toString() ?? '',
      posisi: json['Posisi']?.toString() ?? '',
      telepon: json['Telepon']?.toString() ?? '',
      avatar: json['pimpinan_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NIP': nip,
      'Posisi': posisi,
      'Telepon': telepon,
      'pimpinan_avatar': avatar,
    };
  }
}