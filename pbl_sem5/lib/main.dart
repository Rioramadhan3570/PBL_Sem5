import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/utama_dosen.dart'; // Halaman utama dosen
import 'package:pbl_sem5/dosen/informasi.dart'; // Halaman informasi
import 'package:pbl_sem5/dosen/riwayat.dart'; // Halaman riwayat
import 'package:pbl_sem5/dosen/profil.dart'; // Halaman profil
import 'package:pbl_sem5/dosen/notifikasi_dosen.dart'; // Halaman profil
import 'package:pbl_sem5/login/mulai.dart';
import 'package:pbl_sem5/login/login.dart'; // Halaman login
import 'package:pbl_sem5/pimpinan/utama_pimpinan.dart'; // Halaman utama dosen
import 'package:pbl_sem5/pimpinan/pengajuan.dart'; 
import 'package:pbl_sem5/pimpinan/notifikasi_pimpinan.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Dosen & Pimpinan',
      initialRoute: '/',
      routes: {
        '/': (context) => Mulai(), // Rute halaman login
        '/utama_dosen': (context) => UtamaDosen(),  // Rute halaman utama dosen
        '/informasi': (context) => Informasi(), // Rute halaman informasi
        '/riwayat': (context) => Riwayat(), // Rute halaman riwayat
        '/profil': (context) => Profil(), // Rute halaman profil
        '/notifikasi_dosen': (context) => NotifikasiDosen(), // Rute halaman profil


        '/utama_pimpinan': (context) => UtamaPimpinan(),  // Rute halaman utama pimpinan
        '/pengajuan': (context) => Pengajuan(),  // Rute halaman utama pimpinan
        '/notifikasi_pimpinan': (context) => NotifikasiPimpinan(),  // Rute halaman utama pimpinan

      },
    );
  }
}
