// lib/models/beranda/profile_data.dart
class ProfileData {
  final String nama;
  final String role;
  final String? nip;
  final String? avatar;

  ProfileData({
    required this.nama,
    required this.role,
    this.nip,
    this.avatar,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      nama: json['nama'] ?? '',
      role: json['role'] ?? '',
      nip: json['nip'],
      avatar: json['avatar'],
    );
  }
}