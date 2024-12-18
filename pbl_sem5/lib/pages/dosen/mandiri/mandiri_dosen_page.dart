// pages/dosen/mandiri/mandiri_dosen_page.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/models/dosen/mandiri/pelatihan_mandiri.dart';
import 'package:pbl_sem5/models/dosen/mandiri/sertifikasi_mandiri.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/detail_mandiri_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/pelatihan_form.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/sertifikasi_form.dart';
import 'package:pbl_sem5/services/dosen/api_mandiri_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/mandiri/header_mandiri_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';
import 'package:intl/intl.dart';

class HalamanMandiriDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanMandiriDosen({super.key, this.selectedIndex = 1});

  @override
  _HalamanMandiriDosenState createState() => _HalamanMandiriDosenState();
}

class _HalamanMandiriDosenState extends State<HalamanMandiriDosen> {
  final List<String> _categories = ['Sertifikasi', 'Pelatihan'];
  int _selectedCategoryIndex = 0;
  final ApiMandiriDosen _apiService = ApiMandiriDosen();
  List<SertifikasiMandiri> _sertifikasi = [];
  List<PelatihanMandiri> _pelatihan = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _apiService.getMandiriData();
      setState(() {
        _sertifikasi = (data['sertifikasi'] as List).cast<SertifikasiMandiri>();
        _pelatihan = (data['pelatihan'] as List).cast<PelatihanMandiri>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (e.toString().contains('Unauthenticated')) {
        // Redirect ke halaman login
        Navigator.of(context).pushReplacementNamed('/login_user');

        // Optional: Tampilkan snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
          ),
        );
      }
    }
  }

  // Tambahkan method untuk proses delete
  Future<void> _deleteItem(String id, String kategori) async {
    try {
      await _apiService.deleteMandiri(id, kategori);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$kategori berhasil dihapus')),
      );

      // Refresh data setelah delete
      _loadData();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus $kategori: $e')),
      );
    }
  }

  void _showAddKegiatanDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sertifikasi'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SertifikasiForm()),
                  ).then((_) => _loadData());
                },
              ),
              ListTile(
                title: const Text('Pelatihan'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PelatihanForm()),
                  ).then((_) => _loadData());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderMandiriDosen(),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildCategorySelector(),
            ),
            SliverFillRemaining(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(child: Text(_error!))
                      : _buildSelectedView(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddKegiatanDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }

  Widget _buildCategorySelector() {
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
          children: List.generate(_categories.length, (index) {
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
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSelectedView() {
    final items = _selectedCategoryIndex == 0 ? _sertifikasi : _pelatihan;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tidak ada data mandiri ${_categories[_selectedCategoryIndex]}',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF737985),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: items.length,
      padding: const EdgeInsets.only(top: 8),
      itemBuilder: (context, index) {
        final item = items[index];
        if (_selectedCategoryIndex == 0) {
          final sertifikasi = item as SertifikasiMandiri;
          return _buildKegiatanItem(
            id: sertifikasi.sertifikasiMandiriId,
            nama: sertifikasi.sertifikasiNama,
            tempat: sertifikasi.sertifikasiTempat,
            tanggal:
                DateFormat('dd/MM/yyyy').format(sertifikasi.sertifikasiStart),
            kategori: 'Sertifikasi',
            level: sertifikasi.sertifikasiLevel,
          );
        } else {
          final pelatihan = item as PelatihanMandiri;
          return _buildKegiatanItem(
            id: pelatihan.pelatihanMandiriId,
            nama: pelatihan.pelatihanNama,
            tempat: pelatihan.pelatihanTempat,
            tanggal: DateFormat('dd/MM/yyyy').format(pelatihan.pelatihanStart),
            kategori: 'Pelatihan',
            level: pelatihan.pelatihanLevel,
          );
        }
      },
    );
  }

  void _navigateToEdit(String id, String kategori) async {
    final apiMandiriDosen = ApiMandiriDosen();
    try {
      final detailData = await apiMandiriDosen.getDetail(id, kategori);

      if (!mounted) return;

      if (kategori == 'Sertifikasi') {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SertifikasiForm(
              isEdit: true,
              id: id,
              initialData: detailData,
            ),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PelatihanForm(
              isEdit: true,
              id: id,
              initialData: detailData,
            ),
          ),
        );
      }

      // Refresh data setelah edit
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    }
  }

  // Tambahkan method untuk konfirmasi delete
  void _showDeleteConfirmation(String id, String kategori) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah anda yakin ingin menghapus $kategori ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _deleteItem(id, kategori);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKegiatanItem({
    required String id,
    required String nama,
    required String tempat,
    required String tanggal,
    required String kategori,
    required String level,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HalamanDetailMandiriDosen(
              id: id,
              kategori: kategori,
            ),
          ),
        ).then((_) => _loadData());
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        // Prevent the GestureDetector onTap from triggering
                        _navigateToEdit(id, kategori);
                      },
                      color: Colors.blue,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        // Prevent the GestureDetector onTap from triggering
                        _showDeleteConfirmation(id, kategori);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            Text(
              kategori,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              'Tempat : $tempat',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tanggal : ${DateFormat('d MMMM y', 'id').format(DateFormat('dd/MM/yyyy').parse(tanggal))}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Level : $level',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}