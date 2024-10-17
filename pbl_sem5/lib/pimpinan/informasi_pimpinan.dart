import 'package:flutter/material.dart';
import 'header_informasi_pimpinan.dart'; // Import header
import 'navbar.dart'; // Import navbar
import 'detail_informasi_pimpinan.dart'; // Import halaman detail


class InformasiPimpinan extends StatefulWidget {
  const InformasiPimpinan({super.key});

  @override
  _InformasiPimpinanState createState() => _InformasiPimpinanState();
}

class _InformasiPimpinanState extends State<InformasiPimpinan> {
  bool _isSemuaActive = true; // Menyimpan status tombol Semua aktif
  bool _isSertifikasiActive = false; // Menyimpan status tombol Sertifikasi aktif
  bool _isPelatihanActive = false; // Menyimpan status tombol Pelatihan aktif

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const InformasiPimpinanHeader(), // Memanggil header tanpa ikon kembali
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Memberi padding di seluruh konten
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab untuk Semua, Sertifikasi, dan Pelatihan
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSemuaActive = true; // Set Semua sebagai tombol aktif
                      _isSertifikasiActive = false; // Nonaktifkan Sertifikasi
                      _isPelatihanActive = false; // Nonaktifkan Pelatihan
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSemuaActive ? Color(0xFF0E1F43) : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    'Semua',
                    style: TextStyle(
                      color: _isSemuaActive ? Colors.white : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSemuaActive = false; // Nonaktifkan Semua
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
                      _isSemuaActive = false; // Nonaktifkan Semua
                      _isSertifikasiActive = false; // Nonaktifkan Sertifikasi
                      _isPelatihanActive = true; // Set Pelatihan sebagai tombol aktif
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
              child: _isSemuaActive
                  ? ListView(
                      children: [
                        // Semua Pengajuan (Sertifikasi dan Pelatihan)
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
                    )
                  : _isSertifikasiActive
                      ? ListView(
                          children: [
                            // Sertifikasi
                            _buildCard(
                              title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                              jenisKegiatan: 'Sertifikasi',
                              subtitles: [
                                'Tempat: ITS, Surabaya\nTanggal: 25 September 2024\nWaktu: 08.00 WIB - selesai',
                              ],
                              isHighlight: true,
                            ),
                          ],
                        )
                      : ListView(
                          children: [
                            // Pelatihan
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
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(), // Memanggil navbar
    );
  }

  // Fungsi untuk membuat Card dengan parameter title, jenis kegiatan, dan list subtitle
  Widget _buildCard({
    required String title,
    required String jenisKegiatan, // Tambahkan jenis kegiatan
    required List<String> subtitles,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap: () {
// Navigasi ke halaman DetailPengajuan
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailInformasiPimpinan()
          ),
        );      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isHighlight ? Color(0x4DFDE1B9) : Colors.white,
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
            // Tambahkan jenis kegiatan di bawah judul
            Text(
              jenisKegiatan,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF737985),
              ),
            ),
            const SizedBox(height: 8),
            // Menampilkan semua subtitle
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
