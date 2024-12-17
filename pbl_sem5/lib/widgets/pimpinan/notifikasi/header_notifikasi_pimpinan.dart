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
  bool _isNotified = false;
  final LoginService _loginService = LoginService(); // Instance login service

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified;
    });
    Navigator.pushNamed(context, '/notifikasi_dosen');
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
      color: const Color(0xFFFFC300),
      padding: const EdgeInsets.only(top: 40, left: 16, right: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Notifikasi',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
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
          if (widget.showBackButton)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBackPressed ??
                    () {
                      Navigator.pop(context);
                    },
              ),
            ),
        ],
      ),
    );
  }
}
