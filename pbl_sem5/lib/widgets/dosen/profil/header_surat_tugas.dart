import 'package:flutter/material.dart';

class HeaderSuratTugas extends StatefulWidget {
  const HeaderSuratTugas({super.key});

  @override
  _HeaderSuratTugasState createState() => _HeaderSuratTugasState();
}

class _HeaderSuratTugasState extends State<HeaderSuratTugas> {
  Color notificationIconColor = Colors.black; // Warna awal ikon notifikasi
  bool _isNotified = false;

  void _onBackButtonPressed() {
    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified; // Mengubah status notifikasi
    });

    // Navigasi ke halaman notifikasi
    Navigator.pushNamed(context, '/notifikasi_dosen');
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
            'Surat Tugas',
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
              icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
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
                  icon: Icon(
                    Icons.notifications,
                    color: _isNotified ? Colors.white : Colors.white,
                  ),
                  onPressed: _toggleNotification,
                ),
                IconButton(
                  icon: const Icon(Icons.logout,
                      color: Colors.white), // Ikon logout
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
