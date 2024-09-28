import 'package:flutter/material.dart';
import 'header_profil.dart'; // Import header
import 'navbar.dart'; // Import navbar

class Utama extends StatelessWidget {
  const Utama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const ProfileHeader(), // Memanggil header
      ),
      body: const Center(
        child: Text('Isi dari halaman utama'), // Konten body
      ),
      bottomNavigationBar: const Navbar(), // Memanggil navbar
);
}
}