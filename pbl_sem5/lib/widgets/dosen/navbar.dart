import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final int selectedIndex; // Tambahkan parameter untuk indeks yang dipilih

  const Navbar({super.key, this.selectedIndex = 0});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  late int _selectedIndex; // Indeks default
  Color notificationIconColor = Colors.black; // Warna awal ikon notifikasi

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex; // Inisialisasi dengan parameter yang diberikan
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
        Navigator.pushReplacementNamed(context, '/utama_dosen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/informasi_dosen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/mandiri_dosen');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/riwayat_dosen');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil_dosen');
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
            _buildNavItem(context, Icons.home, 'Beranda', 0),
            _buildNavItem(context, Icons.info, 'Rekom', 1),
            _buildNavItem(context, Icons.note_add, 'Mandiri', 2),
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
