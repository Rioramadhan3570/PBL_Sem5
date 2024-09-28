import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/informasi.dart'; 
import 'package:pbl_sem5/dosen/riwayat.dart'; 
import 'package:pbl_sem5/dosen/utama.dart';      
import 'package:pbl_sem5/dosen/profil.dart';     
import 'package:pbl_sem5/dosen/notifikasi.dart'; // Import halaman notifikasi

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0; // Indeks default
  Color notificationIconColor = Colors.black; // Warna awal ikon notifikasi

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentRoute = ModalRoute.of(context)?.settings.name;

    switch (currentRoute) {
      case '/utama':
        _selectedIndex = 0;
        break;
      case '/informasi':
        _selectedIndex = 1;
        break;
      case '/pengajuan':
        _selectedIndex = 2;
        break;
      case '/riwayat':
        _selectedIndex = 3;
        break;
      case '/profil':
        _selectedIndex = 4;
        break;
      case '/notifikasi':
        _selectedIndex = -1; // Ketika di halaman notifikasi
        notificationIconColor = Colors.white; // Ubah warna ikon notifikasi menjadi putih
        break;
      default:
        _selectedIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        notificationIconColor = Colors.black; // Reset warna jika navigasi ke Profil
      }
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/utama');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/informasi');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/pengajuan');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF99D1C),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
    final isSelected = _selectedIndex == index;
    final isNotifikasi = _selectedIndex == -1; // Mengecek apakah halaman notifikasi

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            icon,
            color: (isNotifikasi || !isSelected) ? Colors.white : Colors.black, // Semua ikon putih jika notifikasi
          ),
          Text(
            title,
            style: TextStyle(
              color: (isNotifikasi || !isSelected) ? Colors.white : Colors.black, // Teks tetap putih jika notifikasi
            ),
          ),
        ],
      ),
    );
  }
}
