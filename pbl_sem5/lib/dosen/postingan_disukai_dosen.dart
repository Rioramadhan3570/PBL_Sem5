import 'package:flutter/material.dart';
import 'navbar.dart';
import 'detail_informasi_dosen.dart';
import 'header_disukai.dart';

class PostinganDisukaiDosen extends StatefulWidget {
  final int selectedIndex;
  const PostinganDisukaiDosen({Key? key, this.selectedIndex = 1})
      : super(key: key);

  @override
  _PostinganDisukaiDosenState createState() => _PostinganDisukaiDosenState();
}

class _PostinganDisukaiDosenState extends State<PostinganDisukaiDosen> {
  final List<InformasiDetail> _allInformasi = [
    InformasiDetail(
      title:
          'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
      tempat: 'Gedung AH, Politeknik Negeri Malang',
      tanggal: '12 Januari 2025',
      waktu: '08.00 WIB - selesai',
      biaya: 'Rp5.000.000 (Lima Juta Rupiah)',
      vendor: 'PT. Microsoft Indonesia',
      jenis: 'Profesi',
      tagBidangMinat: ['Clustering', 'Data Analysis', 'Data Mining'],
      tagMataKuliah: ['Data Mining', 'Basis Data'],
      kuotaPeserta: '10 Orang',
      kategori: 'Sertifikasi',
    ),
    InformasiDetail(
      title:
          'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
      tempat: 'Gedung AH, Politeknik Negeri Malang',
      tanggal: '12 Januari 2025',
      waktu: '08.00 WIB - selesai',
      biaya: 'Rp5.000.000 (Lima Juta Rupiah)',
      vendor: 'PT. Microsoft Indonesia',
      jenis: 'Profesi',
      tagBidangMinat: ['Clustering', 'Data Analysis', 'Data Mining'],
      tagMataKuliah: ['Data Mining', 'Basis Data'],
      kuotaPeserta: '10 Orang',
      kategori: 'Pelatihan',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderDisukai(),
      ),
      body: ListView.builder(
        itemCount: _allInformasi.length,
        padding: const EdgeInsets.only(top: 16),
        itemBuilder: (context, index) {
          return _buildInfoItem(_allInformasi[index]);
        },
      ),
      bottomNavigationBar: Navbar(selectedIndex: 6),
    );
  }

  Widget _buildInfoItem(InformasiDetail informasi) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetailInformasiDosen(
              informasi: informasi,
              onNavigateBack: () {
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5E6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              informasi.title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              informasi.kategori,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tempat : ${informasi.tempat}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tanggal : ${informasi.tanggal}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Waktu : ${informasi.waktu}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}