// lib/models/dosen/beranda/profil_data.dart
class UserInfo {
  final String? avatar;
  final String nama;
  final String role;
  final String nip;

  UserInfo({
    this.avatar,
    required this.nama,
    required this.role,
    required this.nip,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      avatar: json['avatar'],
      nama: json['nama'] ?? '',
      role: json['role'] ?? '',
      nip: json['nip'] ?? '',
    );
  }
}