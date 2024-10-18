import 'package:flutter/material.dart';
import 'header_detail_monitoring.dart';
import 'navbar.dart';

class DetailMonitoringPimpinan extends StatelessWidget {
  final String nama;
  final String jenis;
  final List<Map<String, String>> kegiatanList;

  const DetailMonitoringPimpinan({
    Key? key,
    required this.nama,
    required this.jenis,
    required this.kegiatanList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderDetailMonitoring(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: kegiatanList
                  .map((kegiatan) => _buildDetailCard(kegiatan))
                  .toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }

  Widget _buildDetailCard(Map<String, String> kegiatan) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFF8EA), // Light cream background color
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              kegiatan['judul'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              jenis,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Tempat', kegiatan['tempat'] ?? ''),
            _buildDetailRow('Tanggal', kegiatan['tanggal'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
