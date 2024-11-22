// lib/models/user_model.dart
import 'package:pbl_sem5/models/login/level_model.dart';

class UserModel {
  final int userId;
  final String username;
  final String nama;
  final UserLevel level;

  UserModel({
    required this.userId,
    required this.username,
    required this.nama,
    required this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] == null 
        ? 0  // Default value jika null
        : (json['user_id'] is String 
          ? int.tryParse(json['user_id']) ?? 0 
          : json['user_id']),
      username: json['username'] ?? '',
      nama: json['nama'] ?? '',
      level: json['level'] != null 
        ? UserLevel.fromJson(json['level']) 
        : UserLevel(kode: '', nama: ''), // Default level jika null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'nama': nama,
      'level': level.toJson(),
    };
  }
}