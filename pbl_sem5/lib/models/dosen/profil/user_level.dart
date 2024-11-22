class UserLevel {
  final String nama;

  UserLevel({required this.nama});

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      nama: json['nama'] ?? '',
    );
  }
}