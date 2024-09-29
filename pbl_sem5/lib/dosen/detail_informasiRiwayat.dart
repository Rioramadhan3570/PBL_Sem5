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
        child: const HeaderRiwayat(), // Memanggil header
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
                      // Icon Placeholder atau bisa diganti dengan logo/icon yang sesuai
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.info, // Contoh ikon
                              color: Colors.blue,
                              size: 30,
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

                  // Bukti Upload Sertifikasi
                  Text(
                    'Bukti Upload Sertifikasi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Aksi (Selengkapnya dan Upload Sertifikat)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Tindakan untuk tombol "Selengkapnya"
                          // Anda bisa menambahkan aksi di sini
                        },
                        child: const Text('Selengkapnya'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Tindakan untuk tombol "Upload Sertifikat"
                          // Anda bisa menambahkan aksi di sini
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
      bottomNavigationBar: const Navbar(selectedIndex: 3), // Navbar dengan Riwayat sebagai aktif
    );
  }
}
