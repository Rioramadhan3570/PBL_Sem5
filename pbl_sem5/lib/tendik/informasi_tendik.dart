import 'package:flutter/material.dart';
import 'navbar.dart';
import 'detail_informasi_tendik.dart';
import 'header_informasi.dart';

class HalamanInformasiTendik extends StatefulWidget {
  final int selectedIndex;
  const HalamanInformasiTendik({Key? key, this.selectedIndex = 1})
      : super(key: key);

  @override
  _HalamanInformasiTendikState createState() => _HalamanInformasiTendikState();
}

class _HalamanInformasiTendikState extends State<HalamanInformasiTendik> {
  final List<String> _categories = ['Semua', 'Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;

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
    // Add more items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderInformasi(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildCategorySelector(),
          const SizedBox(height: 8),
          Expanded(
            child: _buildSelectedView(),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_categories.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: _selectedCategoryIndex == index
                      ? const Color(0xFF0E1F43)
                      : const Color(0xFFDBDDE3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectedView() {
    List<InformasiDetail> filteredList;
    switch (_selectedCategoryIndex) {
      case 1:
        filteredList = _allInformasi
            .where((info) => info.kategori == 'Sertifikasi')
            .toList();
        break;
      case 2:
        filteredList = _allInformasi
            .where((info) => info.kategori == 'Pelatihan')
            .toList();
        break;
      default:
        filteredList = _allInformasi;
    }

    return ListView.builder(
      itemCount: filteredList.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return _buildInfoItem(filteredList[index]);
      },
    );
  }

 Widget _buildInfoItem(InformasiDetail informasi) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetailInformasiTendik(
              informasi: informasi,
              onNavigateBack: () {
                Navigator.pop(context);
                // Di sini Anda bisa menambahkan logika untuk memperbarui daftar
                // jika diperlukan setelah pengajuan
                setState(() {
                  // Misalnya, memperbarui status informasi yang diajukan
                });
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
