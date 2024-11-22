// lib/pages/dosen/postingan_disukai_dosen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbl_sem5/models/dosen/informasi/pelatihan_rekomendasi_model.dart';
import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
import 'package:pbl_sem5/pages/dosen/informasi/detail_informasi__dosen_page.dart';
import 'package:pbl_sem5/services/api_disukai.dart';
import 'package:pbl_sem5/widgets/dosen/profil/header_disukai.dart';
import 'package:pbl_sem5/widgets/navbar.dart';

class PostinganDisukaiDosen extends StatefulWidget {
  final int selectedIndex;
  const PostinganDisukaiDosen({super.key, this.selectedIndex = 1});

  @override
  _PostinganDisukaiDosenState createState() => _PostinganDisukaiDosenState();
}

class _PostinganDisukaiDosenState extends State<PostinganDisukaiDosen> {
  final DisukaiService _disukaiService = DisukaiService();
  List<dynamic> _disukaiItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDisukaiItems();
  }

  Future<void> _fetchDisukaiItems() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final items = await _disukaiService.fetchDisukaiItems();
      
      if (mounted) {
        setState(() {
          _disukaiItems = items.where((item) => 
            (item is Sertifikasi || item is Pelatihan) && 
            item.nama != null && 
            item.nama.isNotEmpty
          ).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });

        if (_errorMessage.toLowerCase().contains('unauthorized') ||
            _errorMessage.toLowerCase().contains('login')) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  Future<void> _removeFromDisukai(dynamic item) async {
    try {
      if (item.disukaiId != null) {
        final success = await _disukaiService.removeDisukai(item.disukaiId.toString());
        if (success) {
          if (mounted) {
            setState(() {
              _disukaiItems.remove(item);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Berhasil menghapus dari disukai'))
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus: ${e.toString()}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderDisukai(),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDisukaiItems,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_errorMessage),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchDisukaiItems,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _disukaiItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              size: 48,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Belum ada item yang disukai',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/informasi_dosen');
                              },
                              child: const Text('Jelajahi Informasi'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _disukaiItems.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final item = _disukaiItems[index];
                          return _buildInfoItem(item);
                        },
                      ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 6),
    );
  }

  Widget _buildInfoItem(dynamic informasi) {
    final bool isSertifikasi = informasi is Sertifikasi;
    final DateTime? startDate = isSertifikasi
        ? informasi.sertifikasiStart
        : informasi.pelatihanStart;

    return Dismissible(
      key: Key(informasi.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => _removeFromDisukai(informasi),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HalamanDetailInformasiDosen(
                  informasi: informasi,
                  onNavigateBack: _fetchDisukaiItems,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSertifikasi
                    ? [const Color(0xFFE3F2FD), Colors.white]
                    : [const Color(0xFFE8F5E9), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        informasi.nama ?? 'Tidak ada judul',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSertifikasi
                            ? Colors.blue.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isSertifikasi ? 'Sertifikasi' : 'Pelatihan',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSertifikasi ? Colors.blue : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        informasi.tempat ?? 'Lokasi tidak tersedia',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(startDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}