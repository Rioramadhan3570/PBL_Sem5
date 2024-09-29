import 'package:flutter/material.dart';
import 'header_pengajuan.dart'; // Import header
import 'navbar.dart'; // Import navbar

class UtamaPimpinan extends StatelessWidget {
  const UtamaPimpinan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const PengajuanHeader(), // Memanggil header
      ),
      body: const Center(
        child: Text('Isi dari halaman utama PIMPINAN'), // Konten body
      ),
      bottomNavigationBar: const Navbar(), // Memanggil navbar
);
}
}