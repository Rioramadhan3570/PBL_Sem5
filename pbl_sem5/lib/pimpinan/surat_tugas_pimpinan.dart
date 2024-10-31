import 'package:flutter/material.dart';
import 'navbar.dart';
import 'header_surat_tugas.dart';

class SuratTugasPimpinan extends StatefulWidget {
  const SuratTugasPimpinan({super.key});

  @override
  _SuratTugasPimpinanState createState() => _SuratTugasPimpinanState();
}

class _SuratTugasPimpinanState extends State<SuratTugasPimpinan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderSuratTugas(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
              jenisKegiatan: 'Sertifikasi',
              subtitles: [
                'Tempat: ITS, Surabaya\nTanggal: 25 September 2024\nWaktu: 08.00 WIB - selesai',
              ],
              isHighlight: true,
            ),
            const SizedBox(height: 15),
            _buildCard(
              title: 'Manajemen Database MySQL untuk Pengembangan Web',
              jenisKegiatan: 'Pelatihan',
              subtitles: [
                'Tempat: ITS, Surabaya\nTanggal: 25 September 2024\nWaktu: 08.00 WIB - selesai',
              ],
              isHighlight: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(selectedIndex: 6,),
    );
  }

  Widget _buildCard({
    required String title,
    required String jenisKegiatan,
    required List<String> subtitles,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailPengajuan    
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isHighlight ? const Color(0x4DFDE1B9) : Colors.white,
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
            for (var subtitle in subtitles)
              Text(
                subtitle,
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
}