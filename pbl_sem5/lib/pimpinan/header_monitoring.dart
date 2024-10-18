import 'package:flutter/material.dart';

class HeaderMonitoring extends StatefulWidget {
  const HeaderMonitoring({Key? key}) : super(key: key);

  @override
  _HeaderMonitoringState createState() => _HeaderMonitoringState();
}

class _HeaderMonitoringState extends State<HeaderMonitoring> {
  bool _isNotified = false;

  void _toggleNotification() {
    setState(() {
      _isNotified = !_isNotified; // Mengubah status notifikasi
    });

    // Navigasi ke halaman notifikasi
    Navigator.pushNamed(context, '/notifikasi_pimpinan');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFC300), // Warna latar belakang kuning
      padding: const EdgeInsets.only(top: 40, left: 16, right: 8, bottom: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Teks "Profil" yang terpusat
          const Text(
            'Monitoring',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // Ikon yang diposisikan di sebelah kanan
          Positioned(
            right: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: _isNotified ? Colors.white : Colors.white,
                  ),
                  onPressed: _toggleNotification,
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}