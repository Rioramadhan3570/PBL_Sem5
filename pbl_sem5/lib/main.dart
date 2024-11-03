import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/utama_dosen.dart'; // Halaman utama dosen
import 'package:pbl_sem5/dosen/informasi_dosen.dart'; // Halaman informasi
import 'package:pbl_sem5/dosen/riwayat_dosen.dart'; // Halaman riwayat
import 'package:pbl_sem5/dosen/profil_dosen.dart'; // Halaman profil
import 'package:pbl_sem5/dosen/notifikasi_dosen.dart'; // Halaman notifikasi
import 'package:pbl_sem5/dosen/pengajuan_dosen.dart'; // Halaman Penajuan
import 'package:pbl_sem5/tendik/utama_tendik.dart'; // Halaman utama tendik
import 'package:pbl_sem5/tendik/informasi_tendik.dart'; // Halaman informasi
import 'package:pbl_sem5/tendik/riwayat_tendik.dart'; // Halaman riwayat
import 'package:pbl_sem5/tendik/profil_tendik.dart'; // Halaman profil
import 'package:pbl_sem5/tendik/notifikasi_tendik.dart'; // Halaman notifikasi
import 'package:pbl_sem5/tendik/pengajuan_tendik.dart'; // Halaman Penajuan
import 'package:pbl_sem5/login/confirm_regis.dart';
import 'package:pbl_sem5/login/mulai.dart';
import 'package:pbl_sem5/login/registrasi.dart';
import 'package:pbl_sem5/pimpinan/utama_pimpinan.dart'; // Halaman utama dosen
import 'package:pbl_sem5/pimpinan/monitoring_pimpinan.dart'; 
import 'package:pbl_sem5/pimpinan/informasi_pimpinan.dart'; 
import 'package:pbl_sem5/pimpinan/pengajuan.dart'; 
import 'package:pbl_sem5/pimpinan/notifikasi_pimpinan.dart'; 
import 'package:pbl_sem5/login/utamacontoh.dart';
import 'package:pbl_sem5/pimpinan/profil_pimpinan.dart';


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
        '/utama_dosen': (context) => HalamanUtamaDosen(),  // Rute halaman utama dosen
        '/informasi_dosen': (context) => HalamanInformasiDosen(), // Rute halaman informasi
        '/riwayat_dosen': (context) => RiwayatDosen(), // Rute halaman riwayat
        '/profil_dosen': (context) => ProfilDosen(), // Rute halaman profil
        '/notifikasi_dosen': (context) => NotifikasiDosen(), // Rute halaman profil
        '/pengajuan_dosen': (context) => PengajuanDosen(), // Rute halaman profil

        '/utama_tendik': (context) => HalamanUtamaTendik(),  // Rute halaman utama tendik
        '/informasi_tendik': (context) => HalamanInformasiTendik(), // Rute halaman informasi
        '/riwayat_tendik': (context) => RiwayatTendik(), // Rute halaman riwayat
        '/profil_tendik': (context) => ProfilTendik(), // Rute halaman profil
        '/notifikasi_tendik': (context) => NotifikasiTendik(), // Rute halaman profil
        '/pengajuan_tendik': (context) => PengajuanTendik(), // Rute halaman profil

        '/utama_pimpinan': (context) => HalamanUtamaPimpinan(),  // Rute halaman utama pimpinan
        '/monitoring_pimpinan': (context) => MonitoringPimpinan(), // Rute halaman monitoring pimpinan 
        '/informasi_pimpinan': (context) => InformasiPimpinan(),  // Rute halaman informasi pimpinan
        '/pengajuan': (context) => Pengajuan(),  // Rute halaman utama pimpinan
        '/notifikasi_pimpinan': (context) => NotifikasiPimpinan(),  // Rute halaman utama pimpinan
        '/registrasi': (context) => Registrasi(),  // Rute ke halaman registrasi
        '/confirmregis': (context) => ConfirmRegis(),  // Rute ke halaman registrasi
        '/profil_pimpinan' : (context) => ProfilPimpinan(), // Rute ke halaman profil

        '/utamacontoh': (context) => Utamacontoh(),  // DIRECT KE PILIHAN USER SEMENTARA YAAA
      },
    );
  }
}
