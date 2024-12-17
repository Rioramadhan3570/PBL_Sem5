import 'package:flutter/material.dart';
import 'package:pbl_sem5/pages/running_figure.dart';
import 'package:pbl_sem5/services/api_login.dart';

class HeaderRiwayatPimpinan extends StatefulWidget {
  final bool showBackButton; // Tambahkan parameter

  const HeaderRiwayatPimpinan({super.key, this.showBackButton = false}); // Default false

  @override
  _HeaderRiwayatPimpinanState createState() => _HeaderRiwayatPimpinanState();
}

class _HeaderRiwayatPimpinanState extends State<HeaderRiwayatPimpinan> {
  bool _isNotified = false; // Pastikan variabel ini dideklarasikan
final LoginService _loginService = LoginService(); // Instance login service

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified; // Mengubah status notifikasi
    });

    // Navigasi ke halaman notifikasi
    Navigator.pushNamed(context, '/notifikasi_pimpinan');
  }

    Future<void> _handleLogout() async {
    try {
      final result = await _loginService.logout();

      if (result['success']) {
        // Pastikan navigasi ke halaman login
        if (mounted) {
          // Hapus semua route dan navigasi ke login
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login_user', // Ganti dengan route login page Anda
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal logout'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFC300), // Warna latar belakang kuning
      padding: const EdgeInsets.only(top: 40, left: 16, right: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Riwayat',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Ikon yang diposisikan di sebelah kanan
          Positioned(
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: _isNotified ? Colors.white : Colors.white,
                  ),
                  onPressed: _toggleNotification,
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => showCustomLogoutDialog(context, _handleLogout),
                ),
              ],
            ),
          ),
          // Menambahkan ikon kembali jika diperlukan
          if (widget.showBackButton)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
              ),
            ),
        ],
      ),
    );
  }
}
