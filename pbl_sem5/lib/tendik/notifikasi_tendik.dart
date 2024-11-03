import 'package:flutter/material.dart';
import 'header_notifikasi.dart'; // Import Header Notifikasi
import 'navbar.dart'; // Import Bottom Navbar

class NotifikasiTendik extends StatelessWidget {
  // Daftar notifikasi yang akan ditampilkan
  final List<Map<String, String>> notifications = [
    {
      'title': 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
      'source': 'MICROSOFT INDONESIA',
      'date': '12-09-2024',
    },
    {
      'title': 'Pelatihan FGA Java (Java Foundations & Java Programming)',
      'source': 'DIGITALENT',
      'date': '01-08-2023',
    },
    // Tambahkan lebih banyak notifikasi jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: const NotifikasiHeader(), // Gunakan Header Notifikasi Anda
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0), // Jarak lebih besar antara header dan isi
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16), // Jarak kecil antar kotak
              decoration: BoxDecoration(
                color: const Color(0x4DFDE1B9), // Warna dengan transparansi 30%
                borderRadius: BorderRadius.circular(8), // Sudut melengkung
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anda Direkomendasikan!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFF1511B),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4), // Jarak antar teks dikecilkan
                    Text(
                      notification['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4), // Jarak antar teks dikecilkan
                    Text(
                      notification['source']!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4), // Jarak antar teks dikecilkan
                    Align(
                      alignment: Alignment.bottomRight, // Untuk menyelaraskan ke kanan bawah
                      child: Text(
                        notification['date']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 6), // Gunakan Navbar di bawah
    );
  }
}
