import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_list_model.dart';
import 'package:pbl_sem5/pages/dosen/rekomendasi/detail_rekomendasi_dosen_page.dart';
import 'package:pbl_sem5/services/dosen/api_rekomendasi_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/rekomendasi/header_rekomendasi_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class HalamanRekomendasiDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanRekomendasiDosen({super.key, this.selectedIndex = 1});

  @override
  _HalamanRekomendasiDosenState createState() =>
      _HalamanRekomendasiDosenState();
}

class _HalamanRekomendasiDosenState extends State<HalamanRekomendasiDosen> {
  final List<String> _categories = ['Semua', 'Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;
  final ApiRekomendasiDosen _apiService = ApiRekomendasiDosen();
  List<RekomendasiItem> _allRekomendasi = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRekomendasi();
  }

  Future<void> _loadRekomendasi() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      List<RekomendasiItem> rekomendasi = [];
      if (_selectedCategoryIndex == 0) {
        final response = await _apiService.getAllRekomendasi();
        rekomendasi = response.data;
      } else if (_selectedCategoryIndex == 1) {
        final response = await _apiService.getRekomendasiSertifikasi();
        rekomendasi = response.data;
      } else if (_selectedCategoryIndex == 2) {
        final response = await _apiService.getRekomendasiPelatihan();
        rekomendasi = response.data;
      }

      setState(() {
        _allRekomendasi = rekomendasi;
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
        child: HeaderRekomendasiDosen(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildCategorySelector(),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _buildSelectedView(),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: List.generate(
            _categories.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });
                  _loadRekomendasi();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedCategoryIndex == index
                        ? const Color(0xFF0E1F43)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    _categories[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedCategoryIndex == index
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    if (_allRekomendasi.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Tidak ada rekomendasi'),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allRekomendasi.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        return _buildRekomendasiItem(_allRekomendasi[index]);
      },
    );
  }

  Widget _buildRekomendasiItem(RekomendasiItem rekomendasi) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetailRekomendasiDosen(
              id: rekomendasi.id,
              tipe: rekomendasi.tipe.toLowerCase(),
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
              rekomendasi.judul,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              rekomendasi.tipe,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tempat : ${rekomendasi.tempat}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tanggal : ${rekomendasi.tanggal}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Level : ${rekomendasi.level}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
