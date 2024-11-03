import 'package:flutter/material.dart';
import 'header_detail_riwayat.dart';
import 'navbar.dart';

class PesertaRiwayatRekom extends StatelessWidget {
  const PesertaRiwayatRekom({Key? key}) : super(key: key);

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
                  const Divider(color: Colors.black54),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Peserta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E1F43),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildParticipantItem('Axel Bagaskara'),
                  _buildParticipantItem('Dimas Anggara'),
                  _buildParticipantItem('Rizky Ridho'),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 6),
    );
  }

  Widget _buildParticipantItem(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF0E1F43),
        ),
      ),
    );
  }
}