// models/dropdown_response.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/dosen/mandiri/dropdown_item.dart';
import 'package:pbl_sem5/models/dosen/mandiri/vendor.dart';

class DropdownResponse extends Equatable {
  final List<DropdownItem> jenis;
  final List<Vendor> vendor;
  final List<DropdownItem> keahlian;
  final List<DropdownItem> matkul;

  const DropdownResponse({
    required this.jenis,
    required this.vendor,
    required this.keahlian,
    required this.matkul,
  });

  factory DropdownResponse.fromJson(Map<String, dynamic> json) {
    debugPrint('Dropdown response JSON: $json');
    return DropdownResponse(
      jenis:
          (json['jenis'] as List).map((e) => DropdownItem.fromJson(e)).toList(),
      vendor: (json['vendor'] as List).map((e) => Vendor.fromJson(e)).toList(),
      keahlian: (json['keahlian'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
      matkul: (json['matkul'] as List)
          .map((e) => DropdownItem.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [
        jenis,
        vendor,
        keahlian,
        matkul,
      ];
}