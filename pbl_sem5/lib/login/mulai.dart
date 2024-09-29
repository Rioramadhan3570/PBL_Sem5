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
                    // Tambahkan konten lainnya di sini jika perlu
                  ],
                ),
              ),
              // Tombol Mulai di bagian bawah
              Padding(
                padding: const EdgeInsets.all(1.0), // Padding di sekitar tombol
                child: SizedBox(
                  width: 350, // Tombol mengisi lebar yang tersedia
                  height: 60, // Tinggi tombol dapat disesuaikan
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Warna tombol
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Sudut melengkung tombol
                      ),
                    ),
                    onPressed: () {
                      // Aksi ketika tombol diklik (navigasi ke halaman login)
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
                        fontSize: 30,
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
