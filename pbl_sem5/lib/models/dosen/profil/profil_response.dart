// models/profile_response.dart
import 'package:pbl_sem5/models/dosen/profil/dosen_model.dart';
import 'package:pbl_sem5/models/dosen/profil/user_model.dart';

class ProfileResponse {
  final bool status;
  final String message;
  final ProfileData? data;

  ProfileResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final UserModel user;
  final DosenModel dosen;

  ProfileData({
    required this.user,
    required this.dosen,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: UserModel.fromJson(json['user']),
      dosen: DosenModel.fromJson(json['dosen']),
    );
  }
}