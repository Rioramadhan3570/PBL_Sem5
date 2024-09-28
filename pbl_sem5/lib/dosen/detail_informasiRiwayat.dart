import 'package:flutter/material.dart';
import 'header_riwayat.dart'; // Pastikan Anda mengimpor header yang sama
import 'navbar.dart'; // Pastikan Anda mengimpor navbar yang sama

class DetailInformasi extends StatelessWidget {
  final String title;
  final String subtitle;

  const DetailInformasi({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ukuran header
        child: const Header(), // Memanggil header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card untuk Detail Informasi
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon dan Title
                  Row(
                    children: [
                      // Icon
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            // Placeholder for your icon
                            Container(
                              width: 30,
                              height: 30,
                              color: Colors.blue, // Ubah sesuai dengan logo atau icon yang diinginkan
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              color: Colors.red, // Ubah sesuai dengan logo atau icon yang diinginkan
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 10),

                  // Detail Pelaksanaan
                  Text(
                    'Pelaksanaan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tempat: Gedung AH, Politeknik Negeri Malang\n'
                    'Tanggal: 12 Januari 2025\n'
                    'Waktu: 08.00 WIB - selesai\n'
                    'Pendanaan: Internal\n'
                    'Biaya: Rp. 5.000.000',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bukti Upload Sertifikasi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Tindakan untuk tombol "Selengkapnya"
                        },
                        child: const Text('Selengkapnya'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Tindakan untuk tombol "Upload Sertifikat"
                        },
                        child: const Text('Upload Sertif'),
                      ),
                    ],
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
}
