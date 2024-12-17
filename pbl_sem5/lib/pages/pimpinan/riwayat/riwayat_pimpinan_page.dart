import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/riwayat_response.dart';
import 'package:pbl_sem5/pages/pimpinan/riwayat/detail_riwayat_pimpinan_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_riwayat_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/riwayat/header_riwayat_pimpinan.dart';

class HalamanRiwayatPimpinan extends StatefulWidget {
  const HalamanRiwayatPimpinan({super.key});

  @override
  State<HalamanRiwayatPimpinan> createState() => _HalamanRiwayatPimpinanState();
}

class _HalamanRiwayatPimpinanState extends State<HalamanRiwayatPimpinan> {
  final List<String> _categories = ['Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;
  final ApiRiwayatPimpinan _apiService = ApiRiwayatPimpinan();
  List<RiwayatData> _allRiwayat = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRiwayat();
  }

  Future<void> _loadRiwayat() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final response = await _apiService.getRiwayatList();
      setState(() {
        _allRiwayat = response.data;
        _isLoading = false;
      });
      debugPrint('Loaded ${_allRiwayat.length} riwayat items');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      debugPrint('Error loading riwayat: $_error');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderRiwayatPimpinan(
          showBackButton: true,
        ),
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                ? Center(child: Text(_error!))
                : _allRiwayat.isEmpty 
                  ? const Center(child: Text('Tidak ada data riwayat'))
                  : _buildSelectedView(),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
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
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == 0
                        ? const Color(0xFF0E1F43)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Sertifikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedCategoryIndex == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedCategoryIndex = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == 1
                        ? const Color(0xFF0E1F43)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Pelatihan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedCategoryIndex == 1 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    final selectedCategory = _categories[_selectedCategoryIndex];
    final filteredList = _allRiwayat
        .where((riwayat) => riwayat.kategori == selectedCategory)
        .toList();

    return RefreshIndicator(
      onRefresh: _loadRiwayat,
      child: filteredList.isEmpty
          ? Center(child: Text('Tidak ada data ${selectedCategory.toLowerCase()}'))
          : ListView.builder(
              itemCount: filteredList.length,
              padding: const EdgeInsets.only(top: 8),
              itemBuilder: (context, index) {
                return _buildRiwayatItem(filteredList[index]);
              },
            ),
    );
  }

  Widget _buildRiwayatItem(RiwayatData riwayat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailRiwayatPimpinanPage(
              id: riwayat.id,
              kategori: riwayat.kategori,
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
              riwayat.judul,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              riwayat.kategori,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tanggal Konfirmasi : ${riwayat.tanggalKonfirmasi}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}