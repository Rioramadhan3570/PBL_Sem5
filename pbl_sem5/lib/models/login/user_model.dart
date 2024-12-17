// lib/models/user_model.dart
import 'package:pbl_sem5/models/login/dosen_model.dart';
import 'package:pbl_sem5/models/login/level_model.dart';

class UserModel {
  final int id;
  final String nama;
  final String username;
  final UserLevel level;
   final DosenModel? dosen;
  final String? lastLogin;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.username,
    required this.level,
     this.dosen,
    this.lastLogin,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      username: json['username'] ?? '',
      level: UserLevel.fromJson(json['level'] ?? {}),
      dosen: json['dosen'] != null ? DosenModel.fromJson(json['dosen']) : null,
      lastLogin: json['last_login'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'username': username,
      'level': level.toJson(),
      'dosen': dosen?.toJson(),
      'last_login': lastLogin,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}