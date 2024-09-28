import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFEBF11), // Warna background #FEBF11
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Container( // Membungkus Text dengan Container untuk margin
          margin: const EdgeInsets.only(top: 20), // Jarak atas
          child: const Text(
            'Riwayat', 
            style: TextStyle(
              fontSize: 24, 
              color: Colors.white, // Warna teks putih
              fontWeight: FontWeight.bold,
            ),
          ),
          
        ),
      ),
    );
  }
}