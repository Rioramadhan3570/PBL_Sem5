import 'package:flutter/material.dart';
import 'header_pengajuan.dart'; // Import header
import 'navbar.dart'; // Import navbar

class DetailPengajuan extends StatelessWidget {
  final String title;
  final List<String> subtitles;

  const DetailPengajuan({Key? key, required this.title, required this.subtitles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan MediaQuery untuk mendapatkan lebar layar
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const PengajuanHeader(showBackButton: true), // Memanggil header dengan ikon kembali
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView
          child: Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.9), // Atur lebar maksimum untuk kartu
            margin: const EdgeInsets.only(top: 25.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE1B9).withOpacity(0.3), // Warna latar belakang dengan 30% transparansi
              borderRadius: BorderRadius.circular(12), // Sudut membulat
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding di dalam card
              child: Column(
                mainAxisSize: MainAxisSize.min, // Menyesuaikan tinggi kolom dengan konten
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menambahkan dua bagian dengan judul
                  const Text(
                    'TOEIC Profesional',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Sertifikasi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF737985),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(color: Colors.black54), // Garis pemisah
                  const SizedBox(height: 16),

                  // Mengatur bagian detail
                  _buildDetailSection('Biaya', 'Rp1.000.000'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Sumber', 'infopelatihan@dosen.com'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Pelaksanaan', _buildPelaksanaanDetail()),
                  const SizedBox(height: 8),
                  _buildDetailSection('Vendor', 'PT Google Indonesia'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Jenis', 'Profesi'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Tag Bidang Minat', 'Data Mining'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Tag Mata Kuliah', 'Data Mining'),
                  const SizedBox(height: 8),

                  // Ikon centang dan silang
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, // Mengatur tombol ke kanan
                    children: [
                      IconButton(
                        onPressed: () {
                          // Fungsi untuk tombol check
                        },
                        icon: const Icon(Icons.check, color: Colors.green), // Ikon centang berwarna hijau
                        iconSize: 35,
                      ),
                      const SizedBox(width: 1), // Jarak antara ikon
                      IconButton(
                        onPressed: () {
                          // Fungsi untuk tombol cancel
                        },
                        icon: const Icon(Icons.close, color: Colors.red), // Ikon silang berwarna merah
                        iconSize: 35,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(), // Memanggil navbar
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menggunakan Column untuk menampilkan judul dan nilai secara vertikal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title :',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4), // Jarak antara judul dan nilai
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Menambahkan method untuk detail pelaksanaan
  static String _buildPelaksanaanDetail() {
    return 'Tempat: ITS, Surabaya\nTanggal: 25 September 2024\nWaktu: 08.00 WIB - selesai';
  }
}
