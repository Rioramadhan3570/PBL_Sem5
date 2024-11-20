// lib/models/user_model.dart
class UserModel {
  final int userId;  // Changed from String to int
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
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'], // Handle both String and int
      username: json['username'],
      nama: json['nama'],
      level: UserLevel.fromJson(json['level']),
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

class UserLevel {
  final String kode;
  final String nama;

  UserLevel({
    required this.kode,
    required this.nama,
  });

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      kode: json['kode'].toString(), // Ensure String type
      nama: json['nama'].toString(), // Ensure String type
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'nama': nama,
    };
  }
}