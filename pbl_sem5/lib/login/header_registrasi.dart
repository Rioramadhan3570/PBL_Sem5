import 'package:flutter/material.dart';

class HeaderRegistrasi extends StatefulWidget {
  const HeaderRegistrasi({Key? key}) : super(key: key);

  @override
  _HeaderRegistrasiState createState() => _HeaderRegistrasiState();
}

class _HeaderRegistrasiState extends State<HeaderRegistrasi> {
  bool _isNotified = false;



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
            'Registrasi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

        ],
      ),
    );
  }
}
