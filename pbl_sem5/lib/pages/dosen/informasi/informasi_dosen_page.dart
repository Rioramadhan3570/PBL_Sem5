// lib/pages/dosen/informasi_dosen_page.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/pages/dosen/informasi/detail_informasi__dosen_page.dart';
import 'package:pbl_sem5/services/api_informasi.dart';
import 'package:pbl_sem5/widgets/dosen/informasi/header_informasi.dart';
import 'package:pbl_sem5/widgets/navbar.dart';
import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
import 'package:intl/intl.dart';

class HalamanInformasiDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanInformasiDosen({super.key, this.selectedIndex = 1});

  @override
  _HalamanInformasiDosenState createState() => _HalamanInformasiDosenState();
}

class _HalamanInformasiDosenState extends State<HalamanInformasiDosen> {
  final InformasiService _apiService = InformasiService();
  final List<String> _categories = ['Semua', 'Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;
  List<dynamic> _informasiList = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadInformasi();
  }

  Future<void> _loadInformasi() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final type = _selectedCategoryIndex == 0
          ? 'all'
          : _selectedCategoryIndex == 1
              ? 'sertifikasi'
              : 'pelatihan';

      print('Loading informasi for type: $type');
      final informasi = await _apiService.getInformasi(type: type);

      setState(() {
        _informasiList = informasi;
        _isLoading = false;
      });

      print('Loaded ${informasi.length} items');
    } catch (e) {
      print('Error in _loadInformasi: $e');
      setState(() {
        _error = 'Gagal memuat data. Silakan coba lagi.';
        _isLoading = false;
      });
    }
  }

  Widget _buildInformasiList() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInformasi,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_informasiList.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada informasi tersedia',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadInformasi,
      child: ListView.builder(
        itemCount: _informasiList.length,
        padding: const EdgeInsets.only(top: 8),
        itemBuilder: (context, index) {
          final item = _informasiList[index];
          return _buildInfoItem(item);
        },
      ),
    );
  }

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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildInformasiList(),
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
                setState(() => _selectedCategoryIndex = index);
                _loadInformasi();
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

  Widget _buildInfoItem(dynamic informasi) {
    final bool isSertifikasi = informasi is Sertifikasi;
    final String title = informasi.nama;
    final String tempat = informasi.tempat;
    final String level = informasi.level;
    // Mengambil tanggal mulai saja
    final DateTime? startDate =
        isSertifikasi ? informasi.sertifikasiStart : informasi.pelatihanStart;

    // Format tanggal dengan benar menggunakan intl
    String formattedDate = startDate != null
        ? DateFormat('dd MMMM yyyy', 'id_ID').format(startDate)
        : 'Tanggal belum ditentukan';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetailInformasiDosen(
              informasi: informasi,
              onNavigateBack: () {
                Navigator.pop(context);
                _loadInformasi();
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
            // Nama
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Kategori
            Text(
              isSertifikasi ? 'Sertifikasi' : 'Pelatihan',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            // Tempat
            Text(
              'Tempat: $tempat',
              style: const TextStyle(fontSize: 12),
            ),
            // Tanggal
            Text(
              'Tanggal: $formattedDate',
              style: const TextStyle(fontSize: 12),
            ),
            // Waktu
              Text(
                'Level: $level',
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }
}
