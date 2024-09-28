import 'package:flutter/material.dart';

class NotifikasiHeader extends StatefulWidget {
  const NotifikasiHeader({Key? key}) : super(key: key);

  @override
  _NotifikasiHeaderState createState() => _NotifikasiHeaderState();
}

class _NotifikasiHeaderState extends State<NotifikasiHeader> {
  Color notificationIconColor = Colors.black; // Warna awal ikon notifikasi

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
              icon: Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
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
                  icon: Icon(Icons.notifications, color: notificationIconColor), // Ikon notifikasi
                  onPressed: () {
                    // Menangani penekanan ikon notifikasi
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white), // Ikon logout
                  onPressed: () {
                    // Menangani penekanan ikon logout
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
