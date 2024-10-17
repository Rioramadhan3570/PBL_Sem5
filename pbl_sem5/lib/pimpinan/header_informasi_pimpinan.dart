import 'package:flutter/material.dart';

class InformasiPimpinanHeader extends StatefulWidget {
  final bool showBackButton; // Tambahkan parameter

  const InformasiPimpinanHeader({Key? key, this.showBackButton = false}) : super(key: key); // Default false

  @override
  _InformasiPimpinanHeaderState createState() => _InformasiPimpinanHeaderState();
}

class _InformasiPimpinanHeaderState extends State<InformasiPimpinanHeader> {
  bool _isNotified = false; // Pastikan variabel ini dideklarasikan

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
          const Text(
            'Informasi',
            style: TextStyle(
              fontSize: 21,
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
          // Menambahkan ikon kembali jika diperlukan
          if (widget.showBackButton)
            Positioned(
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white), // Ikon kembali
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman sebelumnya
                },
              ),
            ),
        ],
      ),
    );
  }
}
