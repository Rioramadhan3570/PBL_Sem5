import 'package:flutter/material.dart';
import 'header_profil.dart'; // Import Header
import 'navbar.dart'; // Import BottomNavbar

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Header sebagai AppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), 
        child: const ProfileHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            // Avatar gambar profil
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://4.bp.blogspot.com/_Cc3gulUhlvs/S7c6zkOEvMI/AAAAAAAAByc/T8rY2V_ZcnE/s1600/kucing-turki.jpg'),
            ),
            SizedBox(height: 20),
            // Nama dan informasi profil
            Text(
              'Axel Bagaskara',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '2241650098 | Dosen',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            // Container untuk membungkus dua item menu
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(
                children: [
                  // Item menu "Edit Profile"
                  ProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () {
                      // Aksi ketika "Edit Profile" ditekan
                    },
                  ),
                  Divider(height: 1, color: const Color.fromARGB(255, 255, 255, 255)), // Pembatas antar item
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: 'Postingan yang Disukai',
                    onTap: () {
                      // Aksi ketika "Postingan yang Disukai" ditekan
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Menggunakan BottomNavbar sebagai navigasi bawah
      bottomNavigationBar: const Navbar(),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            // Ikon dengan ukuran dan padding lebih besar
            Icon(icon, size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Ikon panah ke kanan
            Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}