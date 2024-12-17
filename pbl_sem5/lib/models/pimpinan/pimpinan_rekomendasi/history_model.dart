// lib/models/history_model.dart
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/history_item_model.dart';

class HistoryModel {
  final List<HistoryItemModel> sertifikasi;
  final List<HistoryItemModel> pelatihan;

  HistoryModel({
    required this.sertifikasi,
    required this.pelatihan,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      sertifikasi: (json['sertifikasi'] as List)
          .map((item) => HistoryItemModel.fromJson({
                ...item,
                'kategori': 'Sertifikasi',
              }))
          .toList(),
      pelatihan: (json['pelatihan'] as List)
          .map((item) => HistoryItemModel.fromJson({
                ...item,
                'kategori': 'Pelatihan',
              }))
          .toList(),
    );
  }
}