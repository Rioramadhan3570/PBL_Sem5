// vendor_model.dart
class Vendor {
  final String vendorId;
  final String nama;
  final String alamat;
  final String kota;
  final String telepon;
  final String alamatWeb;

  Vendor({
    required this.vendorId,
    required this.nama,
    required this.alamat,
    required this.kota,
    required this.telepon,
    required this.alamatWeb,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'].toString(),
      nama: json['vendor_nama'] ?? '',
      alamat: json['vendor_alamat'] ?? '',
      kota: json['vendor_kota'] ?? '',
      telepon: json['vendor_telepon'] ?? '',
      alamatWeb: json['vendor_alamat_web'] ?? '',
    );
  }
}