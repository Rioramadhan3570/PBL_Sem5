// detail_matkul_model.dart
import 'package:pbl_sem5/models/dosen/informasi/matkul_model.dart';

class DetailMatkul {
  final int detailMatkulId;
  final int dosenId;
  final int matkulId;
  final Matkul matkul;

  DetailMatkul({
    required this.detailMatkulId,
    required this.dosenId,
    required this.matkulId,
    required this.matkul,
  });

  factory DetailMatkul.fromJson(Map<String, dynamic> json) {
    return DetailMatkul(
      detailMatkulId: json['detail_matkul_id'],
      dosenId: json['dosen_id'],
      matkulId: json['matkul_id'],
      matkul: Matkul.fromJson(json['matkul']),
    );
  }
}