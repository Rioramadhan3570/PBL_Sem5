// lib/models/history_item_model.dart
class HistoryItemModel {
  final String judul;
  final String kategori;
  final String tanggal;

  HistoryItemModel({
    required this.judul,
    required this.kategori,
    required this.tanggal,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      judul: json['judul'] ?? '',
      kategori: json['kategori'] ?? '', // Akan diisi di CalonPesertaModel
      tanggal: json['tanggal'] ?? '',
    );
  }
}