// Update the existing CalonPesertaModel
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/history_model.dart';

class CalonPesertaModel {
  final String id;
  final String nama;
  final bool isPeserta;
  final int matchingPoints;
  final HistoryModel history;

  CalonPesertaModel({
    required this.id,
    required this.nama,
    required this.isPeserta,
    required this.matchingPoints,
    required this.history,
  });

  factory CalonPesertaModel.fromJson(Map<String, dynamic> json) {
    return CalonPesertaModel(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      isPeserta: json['is_selected'] ?? false,
      matchingPoints: json['matching_points'] ?? 0,
      history: HistoryModel.fromJson(json['history'] ?? {'sertifikasi': [], 'pelatihan': []}),
    );
  }
}