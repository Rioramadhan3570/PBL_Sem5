// error_dialog.dart
import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback? onClose;

  const ErrorDialog({
    super.key,
    required this.message,
    this.buttonText = 'Tutup',
    this.onClose,
  });

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorDialog(
          message: message,
          onClose: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Mencegah dialog ditutup dengan tombol back
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Error Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 2),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              
              // Error Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onClose ?? () => Navigator.of(context).pop(),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// error_messages.dart
class ErrorMessages {
  static const String usernameEmpty = 'Username tidak boleh kosong';
  static const String passwordEmpty = 'Password tidak boleh kosong';
  static const String invalidUsername = 'Username atau Password yang anda masukkan salah';
  static const String invalidPassword = 'Username atau Password  yang anda masukkan salah';
  static const String emptyCredentials = 'Username dan password harus diisi';
  static const String noDosenAccess = 'Anda tidak diberikan akses dosen';
  static const String noPimpinanAccess = 'Anda tidak diberikan akses pimpinan';
  static const String roleNotSelected = 'Silakan pilih role terlebih dahulu';
  static const String loginError = 'Terjadi kesalahan saat login';
  static const String serverError = 'Terjadi kesalahan pada server';
  static const String networkError = 'Koneksi internet bermasalah';
  static const String unauthorized = 'Akses tidak diizinkan';
}