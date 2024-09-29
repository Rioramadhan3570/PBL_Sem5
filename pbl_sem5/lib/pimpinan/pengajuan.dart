import 'package:flutter/material.dart';
import 'header_pengajuan.dart'; // Import header
import 'navbar.dart'; // Import navbar

class Pengajuan extends StatefulWidget {
  const Pengajuan({super.key});

  @override
  _PengajuanState createState() => _PengajuanState();
}

class _PengajuanState extends State<Pengajuan> {
  bool _isSertifikasiActive = true; // Menyimpan status tombol Sertifikasi aktif
  bool _isPelatihanActive = false; // Menyimpan status tombol Pelatihan aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const PengajuanHeader(), // Memanggil header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberi padding di seluruh konten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab untuk Sertifikasi dan Pelatihan
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSertifikasiActive = true; // Set Sertifikasi sebagai tombol aktif
                      _isPelatihanActive = false; // Nonaktifkan Pelatihan
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSertifikasiActive ? Color(0xFF0E1F43) : Colors.grey[300],
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
                      _isPelatihanActive = true; // Set Pelatihan sebagai tombol aktif
                      _isSertifikasiActive = false; // Nonaktifkan Sertifikasi
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPelatihanActive ? Color(0xFF0E1F43) : Colors.grey[300],
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
                          title: 'Agus Nugraha S.Pd. M.Kom Melakukan Pengajuan!',
                          subtitles: [
                            'Nama      : Agus Nugraha S.Pd M.Kom',
                            'NIP          : 220202020220',
                            'Kegiatan : Sertifikasi TOEIC Profesional',
                          ],
                          isHighlight: true,
                        ),
                      ],
                    )
                  : ListView(
                      children: [
                        // Pelatihan 1
                        _buildCard(
                          title: 'Agus Nugraha S.Pd. M.Kom Melakukan Pengajuan!',
                          subtitles: [
                            'Nama      : Agus Nugraha S.Pd M.Kom',
                            'NIP          : 220202020220',
                            'Kegiatan : Pelatihan TOEIC Profesional',
                          ],
                          isHighlight: true,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(), // Memanggil navbar
    );
  }

  // Fungsi untuk membuat Card dengan parameter title dan list subtitle
  Widget _buildCard({required String title, required List<String> subtitles, bool isHighlight = false}) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailInformasi
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailPengajuan(
        //       title: title,
        //       subtitles: subtitles,
        //     ),
        //   ),
        // );
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0x4DFDE1B9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFF1511B),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            // Menampilkan semua subtitle
            for (var subtitle in subtitles)
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
