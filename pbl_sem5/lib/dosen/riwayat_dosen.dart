import 'package:flutter/material.dart';
import 'navbar.dart';
import 'detail_informasiRiwayat.dart'; // Pastikan ini diimpor
import 'header_riwayat.dart';

class RiwayatDosen extends StatefulWidget {
  const RiwayatDosen({Key? key}) : super(key: key);

  @override
  _RiwayatDosenState createState() => _RiwayatDosenState();
}

class _RiwayatDosenState extends State<RiwayatDosen> {
  bool _isMandiriActive = true; // Menyimpan status tombol Mandiri aktif
  bool _isRekomActive = false; // Menyimpan status tombol Rekom aktif

  // Menyimpan status untuk setiap card
  List<String> cardStatuses = [
    'Disetujui', // Status untuk Mandiri 1
    'Ditolak', // Status untuk Mandiri 2
    'Disetujui', // Status untuk Mandiri 3
    'Ditolak', // Status untuk Rekom 1
    'Disetujui', // Status untuk Rekom 2
    'Ditolak', // Status untuk Rekom 3
  ];

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
            // Tab untuk Mandiri dan Rekom
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isMandiriActive = true;
                      _isRekomActive = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isMandiriActive ? const Color(0xFF0E1F43) : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Mandiri',
                    style: TextStyle(
                      color: _isMandiriActive ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isRekomActive = true;
                      _isMandiriActive = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRekomActive ? const Color(0xFF0E1F43) : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Rekom',
                    style: TextStyle(
                      color: _isRekomActive ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Konten sesuai tombol aktif
            Expanded(
              child: _isMandiriActive
                  ? ListView(
                      children: [
                        // Mandiri 1
                        _buildCard(
                          title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                          subtitle: 'Aktif Sampai 12-09-2026',
                          status: cardStatuses[0],
                        ),
                        const SizedBox(height: 10),
                        // Mandiri 2
                        _buildCard(
                          title: 'Oracle Certified Associate (OCA) - Java Programmer',
                          subtitle: 'Aktif Sampai 15-10-2027',
                          status: cardStatuses[1],
                        ),
                        const SizedBox(height: 10),
                        // Mandiri 3
                        _buildCard(
                          title: 'Cisco Certified Network Associate (CCNA)',
                          subtitle: 'Aktif Sampai 20-12-2025',
                          status: cardStatuses[2],
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        // Rekom 1
                        _buildCard(
                          title: 'Google Indonesia - Web Development',
                          subtitle: 'Aktif Sampai 12-09-2026',
                          status: cardStatuses[3],
                        ),
                        const SizedBox(height: 10),
                        // Rekom 2
                        _buildCard(
                          title: 'Microsoft Azure - Cloud Fundamentals',
                          subtitle: 'Aktif Sampai 15-11-2025',
                          status: cardStatuses[4],
                        ),
                        const SizedBox(height: 10),
                        // Rekom 3
                        _buildCard(
                          title: 'Amazon Web Services (AWS) - Cloud Practitioner',
                          subtitle: 'Aktif Sampai 22-08-2024',
                          status: cardStatuses[5],
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

  // Fungsi untuk membuat Card dengan parameter title, subtitle, dan status
  Widget _buildCard({required String title, required String subtitle, required String status}) {
    Color buttonColor;

    // Menentukan warna tombol berdasarkan status
    if (status == 'Disetujui') {
      buttonColor = Colors.green;
    } else {
      buttonColor = Colors.red;
    }

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
            const SizedBox(height: 10),
            // Menampilkan status dalam bentuk button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () {}, // Tombol tidak bisa diklik
                child: Text(status),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Warna berdasarkan status
                  foregroundColor: Colors.white, // Warna teks tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
