import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/dosen/notifikasi/notifikasi_model.dart';
import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
import 'package:pbl_sem5/pages/dosen/rekomendasi/detail_rekomendasi_dosen_page.dart';
import 'package:pbl_sem5/pages/dosen/riwayat/detail_riwayat_page.dart';
import 'package:pbl_sem5/services/dosen/api_notifikasi_dosen.dart';
import 'package:pbl_sem5/services/dosen/api_riwayat_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';
import 'package:pbl_sem5/widgets/dosen/notifikasi/header_notifikasi_dosen.dart';

class NotifikasiDosen extends StatefulWidget {
  const NotifikasiDosen({super.key});

  @override
  _NotifikasiDosenState createState() => _NotifikasiDosenState();
}

class _NotifikasiDosenState extends State<NotifikasiDosen> {
  final ApiNotifikasiDosen _apiNotifikasiDosen = ApiNotifikasiDosen();
  final ApiRiwayatDosen _apiRiwayatDosen = ApiRiwayatDosen(); // Tambahkan ini
  List<NotifikasiModel> _notifikasi = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchNotifikasi();
  }

  Future<void> _fetchNotifikasi() async {
    try {
      setState(() => _isLoading = true);
      final notifikasi = await _apiNotifikasiDosen.getNotifikasi();
      setState(() {
        _notifikasi = notifikasi;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _navigateToDetail(NotifikasiModel notifikasi) async {
    if (notifikasi.url.contains('rekomendasi')) {
      final uri = Uri.parse(notifikasi.url);
      final id = uri.pathSegments.last;
      final type = uri.queryParameters['tipe'] ?? 'sertifikasi';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanDetailRekomendasiDosen(
            id: id,
            tipe: type,
          ),
        ),
      );
    } else if (notifikasi.url.contains('riwayat')) {
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

        // Ambil semua riwayat dan cari yang sesuai dengan notifikasi
        final List<RiwayatModel> allRiwayat = await _apiRiwayatDosen.getRiwayat();
        final RiwayatModel matchingRiwayat = allRiwayat.firstWhere(
          (riwayat) => riwayat.judul.toLowerCase() == notifikasi.judul.toLowerCase(),
          orElse: () => throw Exception('Riwayat tidak ditemukan'),
        );
        
        // Tutup dialog loading
        Navigator.pop(context);

        if (matchingRiwayat != null && mounted) {
          // Navigate ke halaman detail riwayat
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRiwayat(
                riwayat: matchingRiwayat,
              ),
            ),
          );
        }
      } catch (e) {
        // Tutup loading dialog jika masih terbuka
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memuat detail riwayat: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: const HeaderNotifikasiDosen(),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotifikasi,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _notifikasi.isEmpty
                  ? const Center(
                      child: Text('Tidak ada notifikasi'),
                    )
                  : ListView.builder(
                      itemCount: _notifikasi.length,
                      itemBuilder: (context, index) {
                        final notifikasi = _notifikasi[index];
                        return InkWell(
                          // Changed from GestureDetector to InkWell for better feedback
                          onTap: () => _navigateToDetail(notifikasi),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x4DFDE1B9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifikasi.pesan,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: notifikasi.pesan.contains(
                                              'Anda Direkomendasikan!')
                                          ? const Color(0xFFF1511B)
                                          : notifikasi.pesan.contains(
                                                  'Selamat, Bukti Telah Tervalidasi!')
                                              ? Colors.green
                                              : notifikasi.pesan.contains(
                                                      'Silahkan Lihat Surat Tugas Anda!')
                                                  ? Colors.blue
                                                  : Colors.red,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notifikasi.judul,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notifikasi.vendor,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      notifikasi.tanggal,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 6),
    );
  }
}
