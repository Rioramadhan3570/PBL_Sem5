// lib/pages/login_base_mixin.dart
import 'package:flutter/material.dart';

mixin LoginValidationMixin {
  String? validateLogin(String? username, String? password) {
    if (username == null || username.isEmpty) {
      if (password == null || password.isEmpty) {
        return "Username dan Password Belum Di Masukkan";
      }
      return "Username belum di masukkan";
    } else if (password == null || password.isEmpty) {
      return "Password belum di masukkan";
    }
    return null;
  }

  void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
