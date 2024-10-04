import 'package:flutter/material.dart';
import 'login.dart'; // Impor halaman login

class Mulai extends StatelessWidget {
  const Mulai({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Mulai.png'), // Sesuaikan dengan lokasi gambar Anda
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten di atas gambar
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Memisahkan konten ke atas dan bawah
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  ],
                ),
              ),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: SizedBox(
                width: 350, // Lebar tombol yang diinginkan
                height: 70, // Tinggi tombol yang lebih besar
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(), // Mengarahkan ke halaman login
                        ),
                      );
                    },
                    child: const Text(
                      'Mulai',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Memastikan teks tombol rata tengah
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
