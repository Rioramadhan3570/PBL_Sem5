import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/dosen/utama_dosen.dart';
import 'package:pbl_sem5/dosen/riwayat_dosen.dart';
import 'package:pbl_sem5/dosen/profil_dosen.dart';
import 'package:pbl_sem5/dosen/notifikasi_dosen.dart';
import 'package:pbl_sem5/dosen/pengajuan_dosen.dart';
import 'package:pbl_sem5/pages/login/mulai.dart';
import 'package:pbl_sem5/models/dosen/informasi/login_user_page.dart';  // Tambahkan import
import 'package:pbl_sem5/pages/dosen/informasi/informasi_dosen_page.dart';
import 'package:pbl_sem5/pimpinan/utama_pimpinan.dart';
import 'package:pbl_sem5/pimpinan/monitoring_pimpinan.dart';
import 'package:pbl_sem5/pimpinan/informasi_pimpinan.dart';
import 'package:pbl_sem5/pimpinan/pengajuan.dart';
import 'package:pbl_sem5/pimpinan/notifikasi_pimpinan.dart';
import 'package:pbl_sem5/pimpinan/profil_pimpinan.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Future.wait([
    initializeDateFormatting('id_ID', null),
    initializeDateFormatting('en', null),
  ]);

  Intl.defaultLocale = 'id_ID';
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Dosen & Pimpinan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0E1F43),
        scaffoldBackgroundColor: Colors.white,
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('id', 'ID'),
        Locale('en', 'US'),
      ],
      locale: const Locale('id', 'ID'),
      
      initialRoute: '/',
      routes: {
        '/': (context) => const Mulai(),
        '/login_dosen': (context) => const LoginPage(),  // Tambahkan route
        '/utama_dosen': (context) => const HalamanUtamaDosen(),
        '/informasi_dosen': (context) => const HalamanInformasiDosen(),
        '/riwayat_dosen': (context) => const RiwayatDosen(),
        '/profil_dosen': (context) => const ProfilDosen(),
        '/notifikasi_dosen': (context) => NotifikasiDosen(),
        '/pengajuan_dosen': (context) => const PengajuanDosen(),
        '/utama_pimpinan': (context) => const HalamanUtamaPimpinan(),
        '/monitoring_pimpinan': (context) => const MonitoringPimpinan(),
        '/informasi_pimpinan': (context) => const InformasiPimpinan(),
        '/pengajuan': (context) => const Pengajuan(),
        '/notifikasi_pimpinan': (context) => NotifikasiPimpinan(),
        '/profil_pimpinan': (context) => const ProfilPimpinan(),
      },
    );
  }
}