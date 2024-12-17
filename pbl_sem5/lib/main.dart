import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/pages/dosen/beranda/beranda_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/mandiri_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/notifikasi/notifikasi_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/riwayat/riwayat_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/profil/profil_dosen_page.dart';
import 'package:pbl_sem5/pages/pimpinan/profil/profil_pimpinan_page.dart';
import 'package:pbl_sem5/pages/dosen/rekomendasi/rekomendasi_dosen_page.dart';
import 'package:pbl_sem5/pages/login/mulai.dart';
import 'package:pbl_sem5/pages/login/login_user_page.dart';  // Tambahkan import
import 'package:pbl_sem5/pages/pimpinan/beranda/beranda_pimpinan_page.dart';
import 'package:pbl_sem5/pages/pimpinan/monitoring/monitoring_pimpinan_page.dart';
import 'package:pbl_sem5/pages/pimpinan/notifikasi/notifikasi_pimpinan_page.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/rekomendasi_pimpinan_page.dart';

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
        '/login_user': (context) => const LoginPage(),  // Tambahkan route
        '/utama_dosen': (context) => const HalamanUtamaDosen(),
        '/informasi_dosen': (context) => const HalamanRekomendasiDosen(),
        '/riwayat_dosen': (context) => const RiwayatDosen(),
        '/profil_dosen': (context) => const ProfilDosen(),
        '/notifikasi_dosen': (context) => NotifikasiDosen(),
        '/mandiri_dosen': (context) => const HalamanMandiriDosen(),
        '/utama_pimpinan': (context) => const HalamanUtamaPimpinan(),
        '/monitoring_pimpinan': (context) => const MonitoringPimpinan(),
        '/informasi_pimpinan': (context) => const HalamanRekomendasiPimpinan(),
        '/notifikasi_pimpinan': (context) => const NotifikasiPimpinan(),
        '/profil_pimpinan': (context) => const ProfilPimpinan(),
      },
    );
  }
}