// lib/pages/pimpinan/rekomendasi/halaman_rekomendasi_pimpinan.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/kegiatan_model.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_rerkomendasi_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/pengajuan/header_pengajuan_pimpinan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanRekomendasiPimpinan extends StatefulWidget {
  final int selectedIndex;
  const HalamanRekomendasiPimpinan({super.key, this.selectedIndex = 1});

  @override
  _HalamanRekomendasiPimpinanState createState() =>
      _HalamanRekomendasiPimpinanState();
}

class _HalamanRekomendasiPimpinanState
    extends State<HalamanRekomendasiPimpinan> {
  final List<String> _categories = ['Semua', 'Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;
  final ApiRekomendasiPimpinan _apiService = ApiRekomendasiPimpinan();
  List<KegiatanModel> _allKegiatan = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadKegiatan();
  }

  Future<void> _loadKegiatan() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final kegiatan = await _apiService.getKegiatan();
      // Check stored statuses
      final prefs = await SharedPreferences.getInstance();
      for (var item in kegiatan) {
        final storedStatus =
            prefs.getString('status_${item.id}_${item.kategori}');
        if (storedStatus != null) {
          item = item.copyWith(status: storedStatus);
        }
      }
      setState(() {
        _allKegiatan = kegiatan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderPengajuanPimpinan(),
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _buildSelectedView(),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabItem(0, 'Semua'),
            _buildTabItem(1, 'Sertifikasi'),
            _buildTabItem(2, 'Pelatihan'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategoryIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _selectedCategoryIndex == index
                ? const Color(0xFF0E1F43)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedCategoryIndex == index ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    List<KegiatanModel> filteredList;
    switch (_selectedCategoryIndex) {
      case 1:
        filteredList = _allKegiatan
            .where((info) => info.kategori == 'Sertifikasi')
            .toList();
        break;
      case 2:
        filteredList =
            _allKegiatan.where((info) => info.kategori == 'Pelatihan').toList();
        break;
      default:
        filteredList = _allKegiatan;
    }

    return ListView.builder(
      itemCount: filteredList.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return _buildInfoItem(filteredList[index]);
      },
    );
  }

  Widget _buildInfoItem(KegiatanModel kegiatan) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRekomendasiPage(
              id: kegiatan.id,
              kategori: kegiatan.kategori,
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
              kegiatan.judul,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              kegiatan.kategori,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tempat : ${kegiatan.tempat}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tanggal : ${kegiatan.tanggal}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Level : ${kegiatan.level}',
              style: const TextStyle(fontSize: 12),
            ),
            if (kegiatan.tanggalKonfirmasi != null)
              Text(
                'Tanggal Konfirmasi : ${kegiatan.tanggalKonfirmasi}',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
