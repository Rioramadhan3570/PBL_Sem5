// lib/models/dosen/mandiri/vendor.dart
import 'package:equatable/equatable.dart';

class Vendor extends Equatable {
  final String vendorId;
  final String vendorNama;
  final String? vendorAlamat;
  final String? vendorKota;
  final String? vendorTelepon;
  final String? vendorAlamatWeb;

  const Vendor({
    required this.vendorId,
    required this.vendorNama,
    this.vendorAlamat,
    this.vendorKota,
    this.vendorTelepon,
    this.vendorAlamatWeb,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendor_id'].toString(),
      vendorNama: json['vendor_nama'],
      vendorAlamat: json['vendor_alamat'],
      vendorKota: json['vendor_kota'],
      vendorTelepon: json['vendor_telepon'],
      vendorAlamatWeb: json['vendor_alamat_web'],
    );
  }

  Map<String, dynamic> toJson() => {
    'vendor_id': vendorId,
    'vendor_nama': vendorNama,
    'vendor_alamat': vendorAlamat,
    'vendor_kota': vendorKota,
    'vendor_telepon': vendorTelepon,
    'vendor_alamat_web': vendorAlamatWeb,
  };

  @override
  List<Object?> get props => [
    vendorId, 
    vendorNama, 
    vendorAlamat, 
    vendorKota, 
    vendorTelepon, 
    vendorAlamatWeb,
  ];
}