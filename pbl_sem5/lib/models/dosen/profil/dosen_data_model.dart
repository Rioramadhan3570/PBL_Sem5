// dosen_data_model.dart
import 'package:pbl_sem5/models/dosen/profil/detail_keahlian_model.dart';
import 'package:pbl_sem5/models/dosen/profil/detail_matkul_model.dart';

class DosenData {
  final int dosenId;
  final int userId;
  final String dosenNip;
  final String dosenProdi;
  final String dosenTelepon;
  final String? dosenAvatar;
  final List<DetailKeahlian> detailKeahlian;
  final List<DetailMatkul> detailMatkul;

  DosenData({
    required this.dosenId,
    required this.userId,
    required this.dosenNip,
    required this.dosenProdi,
    required this.dosenTelepon,
    this.dosenAvatar,
    required this.detailKeahlian,
    required this.detailMatkul,
  });

  factory DosenData.fromJson(Map<String, dynamic> json) {
    return DosenData(
      dosenId: json['dosen_id'],
      userId: json['user_id'],
      dosenNip: json['dosen_nip'],
      dosenProdi: json['dosen_prodi'],
      dosenTelepon: json['dosen_telepon'],
      dosenAvatar: json['dosen_avatar'],
      detailKeahlian: (json['detail_keahlian'] as List?)
          ?.map((x) => DetailKeahlian.fromJson(x))
          .toList() ?? [],
      detailMatkul: (json['detail_matkul'] as List?)
          ?.map((x) => DetailMatkul.fromJson(x))
          .toList() ?? [],
    );
  }
}