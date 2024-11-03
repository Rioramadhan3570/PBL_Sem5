import 'package:flutter/material.dart';

class HeaderPengajuan extends StatefulWidget {
  const HeaderPengajuan({Key? key}) : super(key: key);

  @override
  _HeaderPengajuanState createState() => _HeaderPengajuanState();
}

class _HeaderPengajuanState extends State<HeaderPengajuan> {
  bool _isNotified = false;

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified; // Mengubah status notifikasi
    });

    Navigator.pushNamed(context, '/notifikasi_tendik');
  }

    void _onBackButtonPressed() {
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFC300), // Warna latar belakang kuning
      padding: const EdgeInsets.only(top: 40, left: 16, right: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Teks "Profil" yang terpusat
          const Text(
            'Pengajuan',
            style: TextStyle(
              fontSize: 20,
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
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
              ],
            ),
          ),
                    Positioned(
            left: 0, // Memposisikan tombol kembali ke kiri
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
              onPressed: () {
                _onBackButtonPressed();
                // Kirim informasi kembali ke Navbar
                // Ini bisa dilakukan dengan menggunakan provider atau state management lain
              },
            ),
          ),
        ],
      ),
    );
  }
}
