// lib/screens/surat_tugas/surat_tugas_page.dart
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pbl_sem5/pages/dosen/rekomendasi/detail_rekomendasi_dosen_page.dart';
import 'package:pbl_sem5/services/dosen/api_surat_tugas_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';
import 'package:pbl_sem5/widgets/dosen/surat_tugas/header_surat_tugas_dosen.dart';

class SuratTugasPage extends StatefulWidget {
  const SuratTugasPage({super.key});

  @override
  State<SuratTugasPage> createState() => _SuratTugasPageState();
}

class _SuratTugasPageState extends State<SuratTugasPage> {
  final ApiSuratTugasDosen _apiSuratTugas = ApiSuratTugasDosen();
  List<Map<String, dynamic>> _allSuratTugas = [];
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _loadSuratTugas();
  }

  Future<void> _loadSuratTugas() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final suratTugasList = await _apiSuratTugas.getAllSuratTugas();
      setState(() {
        _allSuratTugas = suratTugasList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredSuratTugas {
    String filterKategori = _selectedTab == 0 ? 'Sertifikasi' : 'Pelatihan';
    return _allSuratTugas
        .where((item) =>
            item['kategori'].toString().toLowerCase() ==
            filterKategori.toLowerCase())
        .toList();
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

      final file = await _apiSuratTugas.downloadSuratTugas(id, kategori);

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (file != null) {
        await OpenFile.open(file.path);
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      if (!mounted) return;
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
        builder: (context) => HalamanDetailRekomendasiDosen(
          id: id.toString(),
          tipe: kategori.toLowerCase(),
          selectedIndex: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderSuratTugasDosen(showBackButton: true),
      ),
      body: Column(
        children: [
          _buildCustomTabBar(),
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 4),
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
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSuratTugas,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    final filteredList = _filteredSuratTugas;
    if (filteredList.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada surat tugas ${_selectedTab == 0 ? "Sertifikasi" : "Pelatihan"}',
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSuratTugas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return _buildSuratTugasCard(filteredList[index]);
        },
      ),
    );
  }

  Widget _buildSuratTugasCard(Map<String, dynamic> item) {
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
                  item['judul'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E1F43),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['kategori'],
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737985),
                  ),
                ),
                Text(
                  'Tanggal Mulai: ${item['tanggal']}',
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
                      item['id'],
                      item['kategori'],
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
                      item['id'],
                      item['kategori'],
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
