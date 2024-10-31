import 'package:flutter/material.dart';
import 'package:pbl_sem5/pimpinan/surat_tugas_pimpinan.dart';
import 'header_profil.dart'; // Import Header
import 'navbar.dart'; // Import BottomNavbar
import 'riwayat.dart'; // Import Header
import 'edit_profil_pimpinan.dart'; // Pastikan ini diimpor


class ProfilPimpinan extends StatelessWidget {
  final int selectedIndex;
  const ProfilPimpinan({super.key, this.selectedIndex = 4});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Header sebagai AppBar
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ProfileHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Avatar gambar profil
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://4.bp.blogspot.com/_Cc3gulUhlvs/S7c6zkOEvMI/AAAAAAAAByc/T8rY2V_ZcnE/s1600/kucing-turki.jpg'),
            ),
            const SizedBox(height: 20),
            // Nama dan informasi profil
            const Text(
              'Dimas Anggoro',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '2241650098 | Pimpinan',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
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
                      // Navigasi ke halaman EditProfilDosen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfilPimpinan(),
                        ),
                      );
                    },
                  ),
                  const Divider(
                      height: 1,
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // Pembatas antar item
                  ProfileMenuItem(
                    icon: Icons.history,
                    title: 'Riwayat',
                    onTap: () {
                       Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RiwayatPage()),
                    );
                    },
                  ),
                  const Divider(
                      height: 1,
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // Pembatas antar item
                  ProfileMenuItem(
                    icon: Icons.message,
                    title: 'Surat Tugas',
                    onTap: () {
                      // Aksi ketika "Surat Tugas" ditekan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuratTugasPimpinan(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Menggunakan BottomNavbar sebagai navigasi bawah
      bottomNavigationBar: Navbar(selectedIndex: 4,),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({super.key, 
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
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            // Ikon panah ke kanan
            const Icon(Icons.chevron_right_sharp, size: 24),
          ],
        ),
      ),
    );
  }
}
