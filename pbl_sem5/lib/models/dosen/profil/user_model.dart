// models/user_model.dart

class UserModel {
  final String nama;

  final String level;

  UserModel({
    required this.nama,
    required this.level,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nama: json['nama'] ?? '',
      level: json['level'] ?? '',
    );
  }
}
