import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/informasi.dart';
import 'package:pbl_sem5/dosen/utama.dart';
import 'profil.dart'; // Pastikan untuk mengimpor file profil.dart

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0; // Indeks untuk melacak tombol yang dipilih

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah indeks yang dipilih
    });

    // Navigasi berdasarkan indeks yang dipilih
    switch (index) {
      case 0:
        // Navi
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Utama()), // Ganti dengan halaman profil
        );        
      break;
      case 1:
        // Navigasi ke halaman monitoring
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Informasi()), // Ganti dengan halaman profil
        );
        break;
      case 2:
        // Navigasi ke halaman informasi
        Navigator.pushNamed(context, '/pengajuan');
        break;
      case 3:
        // Navigasi ke halaman pengajuan
        Navigator.pushNamed(context, '/priwayat');
        break;
      case 4:
        // Navigasi ke halaman profil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()), // Ganti dengan halaman profil
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20), // Menambahkan radius pada sudut
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF99D1C), // Warna latar navbar
          borderRadius: BorderRadius.circular(20), // Radius untuk container
        ),
        padding: const EdgeInsets.symmetric(vertical: 10), // Jarak vertikal di dalam navbar
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Agar tombol tersebar merata
          children: <Widget>[
            _buildNavItem(context, Icons.home, 'Utama', 0),
            _buildNavItem(context, Icons.info, 'Informasi', 1),
            _buildNavItem(context, Icons.monitor_heart, 'Pengajuan', 2),
            _buildNavItem(context, Icons.assignment, 'Riwayat', 3),
            _buildNavItem(context, Icons.person, 'Profil', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, int index) {
  final isSelected = _selectedIndex == index; // Menentukan apakah tombol saat ini dipilih
  return Material(
    color: Colors.transparent, // Warna latar belakang material
    child: InkWell(
      onTap: () => _onItemTapped(index), // Mengubah warna saat tombol diklik
      splashColor: Colors.grey.withOpacity(0.3), // Warna efek ripple
      highlightColor: Colors.transparent, // Menghilangkan efek highlight
      child: Column(
        mainAxisSize: MainAxisSize.min, // Menghindari pengembangan yang tidak perlu
        children: <Widget>[
          Icon(icon, color: isSelected ? Colors.black : Colors.white), // Mengubah warna ikon
          Text(
            title,
            style: TextStyle(color: isSelected ? Colors.black : Colors.white), // Mengubah warna teks
          ),
        ],
      ),
    ),
  );
}

}
