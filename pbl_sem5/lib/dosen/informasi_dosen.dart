import 'package:flutter/material.dart';
import 'navbar.dart';

// StatefulWidget untuk halaman informasi dosen
class HalamanInformasiDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanInformasiDosen({Key? key, this.selectedIndex = 1})
      : super(key: key);

  @override
  _HalamanInformasiDosenState createState() => _HalamanInformasiDosenState();
}

class _HalamanInformasiDosenState extends State<HalamanInformasiDosen> {
  // Daftar kategori yang tersedia
  final List<String> _categories = ['Semua', 'Sertifikasi', 'Pelatihan'];
  // Indeks kategori yang dipilih, default 0 (Semua)
  int _selectedCategoryIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar untuk halaman
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(), // Bagian atas halaman
          const SizedBox(height: 16), // Spasi vertikal
          _buildCategorySelector(), // Pemilih kategori
          Expanded(
            child: _buildSelectedView(), // Tampilan konten yang dipilih
          ),
        ],
      ),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }

  // Membangun bagian header dengan judul dan tombol-tombol
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(115, 20, 16, 16),
      decoration: const BoxDecoration(
        // Gradien warna untuk latar belakang header
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFDD015),
            Color(0xFFFEBF11),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'Informasi',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Row(
              children: [
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
          ],
        ),
      ),
    );
  }

  // Membangun pemilih kategori
  Widget _buildCategorySelector() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_categories.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  // Warna latar belakang berubah saat dipilih
                  color: _selectedCategoryIndex == index
                      ? Color(0xFF0E1F43)
                      : Color(0xFFDBDDE3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      // Warna teks berubah saat dipilih
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Memilih tampilan berdasarkan kategori yang dipilih
  Widget _buildSelectedView() {
    switch (_selectedCategoryIndex) {
      case 0:
        return _buildAllView();
      case 1:
        return _buildCertificationView();
      case 2:
        return _buildTrainingView();
      default:
        return Container(); // Tampilan kosong jika tidak ada yang cocok
    }
  }

  // Tampilan untuk kategori 'Semua'
  Widget _buildAllView() {
    return ListView(
      children: [
        _buildInfoItem(
            'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
            Icons.school),
        _buildInfoItem(
            'Manajemen Database MySQL untuk Pengembangan Web', Icons.computer),
        _buildInfoItem(
            'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
            Icons.school),
      ],
    );
  }

  // Tampilan untuk kategori 'Sertifikasi'
  Widget _buildCertificationView() {
    return ListView(
      children: [
        _buildInfoItem(
            'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
            Icons.school),
        _buildInfoItem(
            'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
            Icons.school),
      ],
    );
  }

  // Tampilan untuk kategori 'Pelatihan'
  Widget _buildTrainingView() {
    return ListView(
      children: [
        _buildInfoItem(
            'Manajemen Database MySQL untuk Pengembangan Web', Icons.computer),
      ],
    );
  }

  // Membangun item informasi individual
  Widget _buildInfoItem(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
