import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'navbar.dart';

class HalamanUtamaDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanUtamaDosen({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  _HalamanUtamaDosenState createState() => _HalamanUtamaDosenState();
}

class _HalamanUtamaDosenState extends State<HalamanUtamaDosen> {
  @override
  void initState() {
    super.initState();
    // Inisialisasi format tanggal untuk bahasa Indonesia
    // Ini memungkinkan penggunaan format tanggal dalam bahasa Indonesia
    initializeDateFormatting('id_ID', null);
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar untuk halaman
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(), // Bagian atas halaman
          _buildStatsSection(), // Bagian statistik
          Expanded(
            child: _buildRecentInfoSection(), // Bagian informasi terbaru
          ),
        ],
      ),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }

  // Membangun bagian header dengan gradien warna dan informasi profil
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        // Gradien warna untuk latar belakang header
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffffebf11), Color(0xffff1511b), Color(0xFFF36619)],
          stops: [0.70, 1.0, 1.0],
        ),
        // Membuat sudut bawah header melengkung
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Bagian atas header dengan foto profil, nama, dan tombol
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              children: [
                // Foto profil
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      'https://statik.tempo.co/data/2024/02/29/id_1283533/1283533_720.jpg'),
                ),
                const SizedBox(width: 16),
                // Informasi nama dan ID dosen
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Axel Bagaskoro | Dosen',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        '238155036',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Tombol notifikasi
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Handle notification icon press
                  },
                ),
                // Tombol logout
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    // Handle logout icon press
                  },
                ),
              ],
            ),
          ),
          // Bagian bawah header dengan sapaan dan tanggal
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 50),
            child: Column(
              children: [
                const Text(
                  'Hallo, Rizky!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  // Menampilkan tanggal hari ini dalam format Indonesia
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                      .format(DateTime.now()),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget ini tidak digunakan dalam build utama, bisa dihapus jika tidak diperlukan
  Widget _buildMainContent() {
    return Column(
      children: [
        // _buildProfileSection(),
        _buildStatsSection(),
        Expanded(
          child: _buildRecentInfoSection(),
        ),
      ],
    );
  }

  // Membangun bagian statistik dengan dua card
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('Total Sertifikasi', '10'),
          _buildStatCard('Total Pelatihan', '2'),
        ],
      ),
    );
  }

  // Membangun card statistik individual
  Widget _buildStatCard(String title, String value) {
    return Container(
      width: 175,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Gradien warna untuk latar belakang card
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFBBC09),
            Color(0xFFFDD015),
          ],
          stops: [0.0, 0.56],
        ),
        borderRadius: BorderRadius.circular(8),
        // Efek bayangan untuk card
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Membangun bagian informasi terbaru
  Widget _buildRecentInfoSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 50, 16, 8),
            child: Text(
              'Informasi Terbaru',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            // ListView untuk menampilkan daftar informasi yang dapat di-scroll
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildInfoItem(
                    'Microsoft Technology Associate (MTA) - Web Development Fundamentals'),
                _buildInfoItem(
                    'Manajemen Database MySQL untuk Pengembangan Web'),
                _buildInfoItem(
                    'Microsoft Technology Associate (MTA) - Web Development Fundamentals'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Membangun item informasi individual
  Widget _buildInfoItem(String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(
            0x66FDE1B9), // Warna latar belakang abu-abu sangat terang
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
