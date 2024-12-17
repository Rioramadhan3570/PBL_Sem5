import 'package:flutter/material.dart';
import 'package:pbl_sem5/pages/running_figure.dart';
import 'package:pbl_sem5/services/api_login.dart';

class HeaderNotifikasiPimpinan extends StatefulWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const HeaderNotifikasiPimpinan({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  _HeaderNotifikasiPimpinanState createState() => _HeaderNotifikasiPimpinanState();
}

class _HeaderNotifikasiPimpinanState extends State<HeaderNotifikasiPimpinan> {
  Color notificationIconColor = Colors.black; // Warna awal ikon notifikasi
  final LoginService _loginService = LoginService();

  void _onBackButtonPressed() {
    Navigator.pop(context); // Kembali ke halaman sebelumnya
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
          // Teks "Notifikasi" di tengah
          const Text(
            'Notifikasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Ikon diposisikan di sebelah kiri
          Positioned(
            left: 0, // Memposisikan tombol kembali ke kiri
            child: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Colors.white), // Ikon kembali
              onPressed: () {
                _onBackButtonPressed();
                // Kirim informasi kembali ke Navbar
                // Ini bisa dilakukan dengan menggunakan provider atau state management lain
              },
            ),
          ),
          // Ikon diposisikan ke kanan
          Positioned(
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications,
                      color: notificationIconColor), // Ikon notifikasi
                  onPressed: () {
                    // Menangani penekanan ikon notifikasi
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => showCustomLogoutDialog(context, _handleLogout),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
