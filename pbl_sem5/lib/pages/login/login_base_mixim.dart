// lib/pages/login_base_mixin.dart
import 'package:flutter/material.dart';

mixin LoginValidationMixin {
  String? validateLogin(String? username, String? password) {
    if (username == null || username.trim().isEmpty) {
      if (password == null || password.isEmpty) {
        return "Username dan Password Belum Dimasukkan";
      }
      return "Username belum dimasukkan";
    } else if (password == null || password.isEmpty) {
      return "Password belum dimasukkan";
    }
    return null;
  }

  void showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}