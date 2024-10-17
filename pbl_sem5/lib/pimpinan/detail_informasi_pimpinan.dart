import 'package:flutter/material.dart';
import 'header_informasi_pimpinan.dart'; // Import header
import 'navbar.dart'; // Import navbar

class DetailInformasiPimpinan extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const InformasiPimpinanHeader(showBackButton: true), // Memanggil header dengan ikon kembali
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Membungkus konten dalam SingleChildScrollView untuk scroll
          child: Container(
            margin: const EdgeInsets.only(top: 25.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE1B9).withOpacity(0.3), // Warna latar belakang dengan 30% transparansi
              borderRadius: BorderRadius.circular(12), // Sudut membulat
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), // Padding di dalam card
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menambahkan dua bagian dengan judul
                  const Text(
                    'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E1F43),
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
                  _buildDetailSection('Pelaksanaan', _buildPelaksanaanDetail()),
                  const SizedBox(height: 8),
                  _buildDetailSection('Biaya', 'Rp1.000.000'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Vendor', 'PT. Microsoft Indonesia'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Jenis', 'Profesi'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Tag Bidang Minat', 'Clustering, Data Analysis, Data Mining'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Tag Mata Kuliah', 'Data Mining, Basis Data'),
                  const SizedBox(height: 8),
                  _buildDetailSection('Kuota Peserta', '10 Orang'),
                  const SizedBox(height: 8),
                  const Text(
                    'Pengaju :',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Mengatur bagian pengaju dengan ikon silang dan centang di masing-masing nama
                  _buildPengajuList(),

                  const SizedBox(height: 8),
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
                    fontSize: 14,
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

  // Membuat daftar pengaju dengan ikon silang dan centang
  Widget _buildPengajuList() {
    List<String> pengajuList = ['Alex Bagaskara', 'Dimas Anggara', 'Rizky Ridho'];
    
    return Column(
      children: pengajuList.map((pengaju) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.5), // Jarak antara setiap pengaju
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pengaju,
                style: const TextStyle(fontSize: 14),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Fungsi untuk tombol check per pengaju
                    },
                    icon: const Icon(Icons.check, color: Colors.green), // Ikon centang berwarna hijau
                    iconSize: 25,
                  ),
                  IconButton(
                    onPressed: () {
                      // Fungsi untuk tombol cancel per pengaju
                    },
                    icon: const Icon(Icons.close, color: Colors.red), // Ikon silang berwarna merah
                    iconSize: 25,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
