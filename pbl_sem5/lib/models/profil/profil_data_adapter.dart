// lib/models/dosen/profil/profile_data_adapter.dart

import 'package:pbl_sem5/models/login/user_model.dart';
import 'package:pbl_sem5/models/login/level_model.dart';

class ProfileDataAdapter {
  static UserModel adaptUser(Map<String, dynamic> json) {
    // Adaptasi format level dari string ke object UserLevel
    final levelStr = json['level'] ?? '';
    final levelObject = {
      'kode': _getLevelKode(levelStr),
      'nama': levelStr,
    };

    return UserModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      username: json['username'] ?? '',
      level: UserLevel.fromJson(levelObject),
      lastLogin: json['last_login'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static String _getLevelKode(String levelName) {
    switch (levelName.toUpperCase()) {
      case 'DOSEN':
        return 'DOS';
      case 'PIMPINAN':
        return 'PMP';
      default:
        return 'UNK';
    }
  }
}