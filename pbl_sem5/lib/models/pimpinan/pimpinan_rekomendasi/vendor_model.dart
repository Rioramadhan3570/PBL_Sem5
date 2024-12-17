// lib/models/vendor_model.dart
class VendorModel {
  final int id;
  final String nama;
  final String alamat;
  final String kota;
  final String telepon;
  final String alamatWeb;

  VendorModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.telepon,
    required this.alamatWeb,
  });
  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['vendor_id'] ?? 0,
      nama: json['vendor_nama'] ?? '',
      alamat: json['vendor_alamat'] ?? '',
      kota: json['vendor_kota'] ?? '',
      telepon: json['vendor_telepon'] ?? '',
      alamatWeb: json['vendor_alamat_web'] ?? '',
    );
  }
}