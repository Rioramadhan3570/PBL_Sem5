import 'package:flutter/material.dart';
import 'header_detail_riwayat.dart';
import 'navbar.dart';
import 'peserta_riwayat_rekom.dart'; // Import the PesertaRiwayatRekom page

class DetailRiwayatRekom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderDetailRiwayat(showBackButton: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 25.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE1B9).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Divider(color: Colors.black54),
                  const SizedBox(height: 16),

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
                  const SizedBox(height: 16),
                  
                  // Add Row for buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Selengkapnya button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E1F43),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Add functionality for Selengkapnya button if needed
                        },
                        child: const Text(
                          'Selengkapnya',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      // Peserta button with navigation
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF9F29),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PesertaRiwayatRekom(),
                            ),
                          );
                        },
                        child: const Text(
                          'Peserta',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Navbar(selectedIndex: 6),
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                const SizedBox(height: 4),
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

  static String _buildPelaksanaanDetail() {
    return 'Tempat: ITS, Surabaya\nTanggal: 25 September 2024\nWaktu: 08.00 WIB - selesai';
  }
}