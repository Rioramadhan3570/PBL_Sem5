// lib/models/dosen/mandiri/bidang_minat.dart
import 'package:equatable/equatable.dart';

class BidangMinat extends Equatable {
  final String keahlianId;
  final String keahlianNama;

  const BidangMinat({
    required this.keahlianId,
    required this.keahlianNama,
  });

  factory BidangMinat.fromJson(Map<String, dynamic> json) {
    return BidangMinat(
      keahlianId: json['keahlian_id'].toString(),
      keahlianNama: json['keahlian_nama'],
    );
  }

  Map<String, dynamic> toJson() => {
    'keahlian_id': keahlianId,
    'keahlian_nama': keahlianNama,
  };

  @override
  List<Object?> get props => [keahlianId, keahlianNama];
}