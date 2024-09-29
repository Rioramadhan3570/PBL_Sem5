import 'package:flutter/material.dart';
import 'navbar.dart';
import 'detail_informasiRiwayat.dart'; // Pastikan ini diimpor
import 'header_riwayat.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  _RiwayatState createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  bool _isSertifikasiActive = true; // Menyimpan status tombol Sertifikasi aktif
  bool _isPelatihanActive = false; // Menyimpan status tombol Pelatihan aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderRiwayat(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding di seluruh konten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab untuk Sertifikasi dan Pelatihan
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSertifikasiActive = true;
                      _isPelatihanActive = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSertifikasiActive ? Colors.blue[900] : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Sertifikasi',
                    style: TextStyle(
                      color: _isSertifikasiActive ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isPelatihanActive = true;
                      _isSertifikasiActive = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPelatihanActive ? Colors.blue[900] : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Pelatihan',
                    style: TextStyle(
                      color: _isPelatihanActive ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Konten sesuai tombol aktif
            Expanded(
              child: _isSertifikasiActive
                  ? ListView(
                      children: [
                        // Sertifikasi 1
                        _buildCard(
                          title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                          subtitle: 'Aktif Sampai 12-09-2026',
                        ),
                        const SizedBox(height: 10),
                        // Sertifikasi 2
                        _buildCard(
                          title: 'Oracle Certified Associate (OCA) - Java Programmer',
                          subtitle: 'Aktif Sampai 15-10-2027',
                        ),
                        const SizedBox(height: 10),
                        // Sertifikasi 3
                        _buildCard(
                          title: 'Cisco Certified Network Associate (CCNA)',
                          subtitle: 'Aktif Sampai 20-12-2025',
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        // Pelatihan 1
                        _buildCard(
                          title: 'Google Indonesia - Web Development',
                          subtitle: 'Aktif Sampai 12-09-2026',
                        ),
                        const SizedBox(height: 10),
                        // Pelatihan 2
                        _buildCard(
                          title: 'Microsoft Azure - Cloud Fundamentals',
                          subtitle: 'Aktif Sampai 15-11-2025',
                        ),
                        const SizedBox(height: 10),
                        // Pelatihan 3
                        _buildCard(
                          title: 'Amazon Web Services (AWS) - Cloud Practitioner',
                          subtitle: 'Aktif Sampai 22-08-2024',
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3), // Memastikan navbar tetap pada Riwayat
    );
  }

  // Fungsi untuk membuat Card dengan parameter title dan subtitle
  Widget _buildCard({required String title, required String subtitle}) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailInformasiRiwayat
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailInformasi(
              title: title,
              subtitle: subtitle,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.orange[50], // Background warna cream
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
