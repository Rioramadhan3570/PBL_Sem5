// lib/models/dosen/dosen_model.dart

import 'package:flutter/material.dart';

class DosenModel {
  final String nip;
  final String prodi;
  final String telepon;
  final String? avatar;
  final List<String> keahlian;
  final List<String> mataKuliah;
  final List<String> keahlianIds;
  final List<String> mataKuliahIds;

  DosenModel({
    required this.nip,
    required this.prodi,
    required this.telepon,
    this.avatar,
    required this.keahlian,
    required this.mataKuliah,
    required this.keahlianIds,
    required this.mataKuliahIds,
  });

  factory DosenModel.fromJson(Map<String, dynamic> json) {
    // Print untuk debug
    debugPrint('DosenModel JSON: $json');
    
    return DosenModel(
      nip: json['NIP']?.toString() ?? '',
      prodi: json['Prodi']?.toString() ?? '',
      telepon: json['Telepon']?.toString() ?? '',
      avatar: json['dosen_avatar'], // Sesuaikan dengan key dari API
      keahlian: _parseList(json['Keahlian']),
      mataKuliah: _parseList(json['Mata Kuliah']),
      keahlianIds: _parseList(json['keahlian_ids']),
      mataKuliahIds: _parseList(json['matkul_ids']),
    );
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) return [value];
    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'NIP': nip,
      'Prodi': prodi,
      'Telepon': telepon,
      'dosen_avatar': avatar,
      'Keahlian': keahlian,
      'Mata Kuliah': mataKuliah,
      'keahlian_ids': keahlianIds,
      'matkul_ids': mataKuliahIds,
    };
  }
}
