import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RiwayatModel {
  final int id;
  final String judul;
  final String kategori;
  final String tempat;
  final String tanggalMulai;
  final String waktu;
  final String pendanaan;
  final String biaya;
  String? statusBukti;
  String? bukti;
  String? tanggalKadaluwarsa;
  bool isBuktiUploaded;
  String? komentar;

  RiwayatModel({
    required this.id,
    required this.judul,
    required this.kategori,
    required this.tempat,
    required this.tanggalMulai,
    required this.waktu,
    required this.pendanaan,
    required this.biaya,
    this.statusBukti,
    this.bukti,
    this.tanggalKadaluwarsa,
    this.isBuktiUploaded = false,
    this.komentar,
  });

  // Method untuk mengecek apakah sertifikat sudah kadaluarsa
  bool isExpired() {
    if (tanggalKadaluwarsa == null) return false;

    try {
      // Parse tanggal dengan format yang sesuai
      final expDate = DateFormat('yyyy-MM-dd').parse(tanggalKadaluwarsa!);
      return DateTime.now().isAfter(expDate);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return false;
    }
  }

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      judul: json['judul'],
      kategori: json['kategori'],
      tempat: json['tempat'],
      tanggalMulai: json['tanggal_mulai'],
      waktu: json['waktu'],
      pendanaan: json['pendanaan'],
      biaya: json['biaya'].toString(),
      statusBukti: json['status_bukti'],
      bukti: json['bukti'],
      tanggalKadaluwarsa: json['tanggal_kadaluwarsa'],
      isBuktiUploaded: json['bukti'] != null,
      komentar: json['komentar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'kategori': kategori,
      'tempat': tempat,
      'tanggal_mulai': tanggalMulai,
      'waktu': waktu,
      'pendanaan': pendanaan,
      'biaya': biaya,
      'status_bukti': statusBukti,
      'bukti': bukti,
      'tanggal_kadaluwarsa': tanggalKadaluwarsa,
    };
  }
}
