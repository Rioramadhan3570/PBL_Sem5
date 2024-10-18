import 'package:flutter/material.dart';
import 'navbar.dart';
import 'header_monitoring.dart';
import 'detail_monitoring_pimpinan.dart';

class MonitoringPimpinan extends StatelessWidget {
  const MonitoringPimpinan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderMonitoring(),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey.shade300),
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('NAMA',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('JENIS',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text('AKSI',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  _buildTableRow(
                      context, 'Axel Bagaskara', 'Sertifikasi', axelKegiatan),
                  _buildTableRow(
                      context, 'Rizky Ridho', 'Sertifikasi', rizkyKegiatan),
                  _buildTableRow(
                      context, 'Dimas Anggara', 'Pelatihan', dimasKegiatan),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(),
    );
  }

  TableRow _buildTableRow(BuildContext context, String nama, String jenis,
      List<Map<String, String>> kegiatan) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(nama),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(jenis),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMonitoringPimpinan(
                    nama: nama,
                    jenis: jenis,
                    kegiatanList: kegiatan,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: Size(50, 25),
            ),
            child: const Text('Detail', style: TextStyle(fontSize: 12)),
          ),
        ),
      ],
    );
  }
}

final axelKegiatan = [
  {
    'judul':
        'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
    'tempat': 'ITS, Surabaya',
    'tanggal': '25 September 2024',
  },
  {
    'judul': 'Certified Information Systems Security Professional (CISSP)',
    'tempat': 'Online',
    'tanggal': '15 Oktober 2024',
  },
];

final rizkyKegiatan = [
  {
    'judul': 'AWS Certified Solutions Architect - Associate',
    'tempat': 'Jakarta Convention Center',
    'tanggal': '10 November 2024',
  },
  {
    'judul': 'Google Cloud Professional Cloud Architect',
    'tempat': 'Online',
    'tanggal': '5 Desember 2024',
  },
];

final dimasKegiatan = [
  {
    'judul': 'Machine Learning Fundamentals',
    'tempat': 'Universitas Indonesia, Depok',
    'tanggal': '20 Oktober 2024',
  },
  {
    'judul': 'Deep Learning Specialization',
    'tempat': 'Online',
    'tanggal': '1 November 2024 - 31 Januari 2025',
  },
];
