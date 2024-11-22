// profil_model.dart
import 'package:pbl_sem5/models/dosen/profil/dosen_data_model.dart';
import 'package:pbl_sem5/models/login/user_model.dart';

class ProfilModel {
  final UserModel user;
  final DosenData dosen;

  ProfilModel({
    required this.user,
    required this.dosen,
  });

  factory ProfilModel.fromJson(Map<String, dynamic> json) {
    return ProfilModel(
      user: UserModel.fromJson(json['user']),
      dosen: DosenData.fromJson(json['dosen']),
    );
  }
}