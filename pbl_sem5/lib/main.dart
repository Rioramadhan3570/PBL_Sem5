import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/informasi.dart';
import 'package:pbl_sem5/dosen/navbar.dart';
import 'package:pbl_sem5/dosen/utama.dart';
import 'package:pbl_sem5/dosen/riwayat.dart';
import 'package:pbl_sem5/dosen/profil.dart';
import 'package:pbl_sem5/dosen/notifikasi.dart'; // Import halaman Notifikasi

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Dosen',
      initialRoute: '/utama',
      routes: {
        '/utama': (context) => Utama(),
        '/informasi': (context) => Informasi(),
        // '/pengajuan': (context) => Pengajuan(), // Tambahkan halaman pengajuan
        '/riwayat': (context) => Riwayat(), // Tambahkan halaman riwayat
        '/profil': (context) => Profil(),
        '/notifikasi': (context) => Notifikasi(), // Route untuk halaman notifikasi
      },
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: Utama()), // Halaman default Anda
            Navbar(), // Menempatkan Navbar di bawah
          ],
        ),
      ),
    );
  }
}
