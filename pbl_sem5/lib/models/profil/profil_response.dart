import 'package:pbl_sem5/models/profil/dosen_model.dart';
import 'package:pbl_sem5/models/profil/pimpinan_model.dart';
import 'package:pbl_sem5/models/profil/profil_data_adapter.dart';
import 'package:pbl_sem5/models/login/user_model.dart';

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
    try {
      return ProfileResponse(
        status: json['status'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
      );
    } catch (e) {
      print('Error parsing ProfileResponse: $e');
      rethrow;
    }
  }
}

class ProfileData {
  final UserModel user;
  final dynamic role;

  ProfileData({
    required this.user,
    required this.role,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    try {
      final userJson = json['user'] as Map<String, dynamic>;
      final userModel = ProfileDataAdapter.adaptUser(userJson);
      
      // Determine role type based on user level
      dynamic roleModel;
      if (userModel.level.nama.toUpperCase() == 'DOSEN') {
        roleModel = DosenModel.fromJson(json['dosen'] as Map<String, dynamic>);
      } else if (userModel.level.nama.toUpperCase() == 'PIMPINAN') {
        roleModel = PimpinanModel.fromJson(json['pimpinan'] as Map<String, dynamic>);
      }

      return ProfileData(
        user: userModel,
        role: roleModel,
      );
    } catch (e) {
      print('Error parsing ProfileData: $e');
      rethrow;
    }
  }

  DosenModel get dosen => role as DosenModel;
  PimpinanModel get pimpinan => role as PimpinanModel;
}