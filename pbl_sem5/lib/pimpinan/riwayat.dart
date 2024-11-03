import 'package:flutter/material.dart';
import 'package:pbl_sem5/pimpinan/detail_pengajuan.dart';
import 'navbar.dart';
import 'header_riwayat_pimpin.dart';
import 'detail_riwayat_rekom.dart'; // Import halaman detail informasi pimpinan

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RiwayatPage(),
    );
  }
}

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  bool isRekomSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderRiwayatPimpin(showBackButton: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTabButton("Rekom", isRekomSelected, () {
                  setState(() {
                    isRekomSelected = true;
                  });
                }),
                const SizedBox(width: 16),
                _buildTabButton("Mandiri", !isRekomSelected, () {
                  setState(() {
                    isRekomSelected = false;
                  });
                }),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isRekomSelected ? RekomContent() : MandiriContent(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(selectedIndex: 6,),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        backgroundColor: isSelected ? const Color(0xFF0E1F43) : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class RekomContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildCard(
          title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
          jenisKegiatan: 'Sertifikasi',
          subtitles: ['Kuota Peserta', '10 Orang'],
          isHighlight: true,
          onTap: () {
            // Navigasi ke halaman detail informasi pimpinan
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DetailRiwayatRekom()),
            );
          },
        ),
      ],
    );
  }
}

class MandiriContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        _buildCard(
          title: 'Google Indonesia - Web Development',
          jenisKegiatan: 'Sertifikasi',
          subtitles: ['Pengaju', 'Alex Bagaskara'],
          isHighlight: true,
          onTap: () {
            Navigator.push(
              context,
                MaterialPageRoute(
                builder: (context) => DetailPengajuan(
                  title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                  subtitles: ['Kuota Peserta', '10 Orang'],
                )
                )
            );
          },
        ),
      ],
    );
  }
}

Widget _buildCard({
  required String title,
  required String jenisKegiatan,
  required List<String> subtitles,
  bool isHighlight = false,
  required VoidCallback onTap, // Tambahkan parameter onTap
}) {
  return GestureDetector(
    onTap: onTap, // Panggil onTap saat kartu diklik
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0x4DFDE1B9), // Mengatur warna card
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF0E1F43),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            jenisKegiatan,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF737985),
            ),
          ),
          const SizedBox(height: 8),
          // Menampilkan subtitle dengan format yang diminta
          Text(
            subtitles[0],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold, // Bold untuk Kuota Peserta
            ),
          ),
          Text(
            subtitles[1],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ),
  );
}
