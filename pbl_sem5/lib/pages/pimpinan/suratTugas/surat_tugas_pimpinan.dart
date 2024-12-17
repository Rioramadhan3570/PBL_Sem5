import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_suratTugas/kegiatan_model.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_surat_tugas_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/surat_tugas/header_surat_tugas_pimpinan.dart';

class SuratTugasPage extends StatefulWidget {
  const SuratTugasPage({super.key});

  @override
  State<SuratTugasPage> createState() => _SuratTugasPageState();
}

class _SuratTugasPageState extends State<SuratTugasPage> {
  final ApiSuratTugasPimpinan _apiService = ApiSuratTugasPimpinan();
  List<KegiatanModel>? kegiatanList;
  bool isLoading = false;
  String? errorMessage;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _fetchKegiatanList();
  }

  List<KegiatanModel> get _filteredKegiatan {
    if (kegiatanList == null) return [];
    String filterKategori = _selectedTab == 0 ? 'Sertifikasi' : 'Pelatihan';
    return kegiatanList!
        .where((item) => item.kategori.toLowerCase() == filterKategori.toLowerCase())
        .toList();
  }

  Future<void> _fetchKegiatanList() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _apiService.getKegiatanList();
      setState(() {
        kegiatanList = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _downloadSuratTugas(int id, String kategori) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final filePath = await _apiService.downloadSuratTugas(id, kategori);

      if (!mounted) return;
      Navigator.pop(context);

      final file = File(filePath);
      if (await file.exists()) {
        await OpenFile.open(file.path);
      } else {
        throw Exception('File not found');
      }
    } catch (e) {
      if (!mounted) return;
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat mengunduh surat tugas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetail(int id, String kategori) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailRekomendasiPage(
          id: id.toString(),
          kategori: kategori,
          selectedIndex: 3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderSuratTugasPimpinan(showBackButton: true),
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(child: _buildContent()),
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
                onTap: () => setState(() => _selectedTab = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 0
                        ? const Color(0xFF0E1F43)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Sertifikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTab == 0 ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTab = 1),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _selectedTab == 1
                        ? const Color(0xFF0E1F43)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Pelatihan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedTab == 1 ? Colors.white : Colors.black,
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

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchKegiatanList,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final filteredList = _filteredKegiatan;
    if (filteredList.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada surat tugas ${_selectedTab == 0 ? "Sertifikasi" : "Pelatihan"}',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchKegiatanList,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return _buildSuratTugasCard(filteredList[index]);
        },
      ),
    );
  }

  Widget _buildSuratTugasCard(KegiatanModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFDE1B9).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E1F43),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.kategori,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737985),
                  ),
                ),
                Text(
                  'Tanggal Mulai: ${item.tanggalMulai}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737985),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _navigateToDetail(
                      item.id,
                      item.kategori,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E1F43),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Detail',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _downloadSuratTugas(
                      item.id,
                      item.kategori,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF99D1C),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Download',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}