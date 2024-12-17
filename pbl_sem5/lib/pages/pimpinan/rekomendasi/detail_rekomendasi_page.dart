// lib/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/Date%20Formate/date_format_monitoring.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/detail_kegiatan_model.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/peserta_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_rerkomendasi_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/pengajuan/header_pengajuan_pimpinan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRekomendasiPage extends StatefulWidget {
  final String id;
  final String kategori;
  final int selectedIndex;

  const DetailRekomendasiPage({
    super.key,
    required this.id,
    required this.kategori,
    this.selectedIndex = 1,
  });

  @override
  _DetailRekomendasiPageState createState() => _DetailRekomendasiPageState();
}

class _DetailRekomendasiPageState extends State<DetailRekomendasiPage> {
  final ApiRekomendasiPimpinan _apiService = ApiRekomendasiPimpinan();
  bool _isLoading = true;
  String? _error;
  DetailKegiatanModel? _detail;

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _checkStoredStatus(); // Add this
  }

  Future<void> _checkStoredStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedStatus =
        prefs.getString('status_${widget.id}_${widget.kategori}');
    if (storedStatus != null && _detail != null) {
      setState(() {
        _detail = _detail!.copyWith(status: storedStatus);
      });
    }
  }

  Future<void> _loadDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      // Load detail and status concurrently
      final detail =
          await _apiService.getDetailKegiatan(widget.id, widget.kategori);
      final status = await _apiService.getStatus(widget.id, widget.kategori);
      setState(() {
        _detail = detail.copyWith(status: status);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_detail == null) {
      return const Scaffold(
        body: Center(child: Text('Detail tidak ditemukan')),
      );
    }

    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: HeaderPengajuanPimpinan(
            showBackButton: true,
          ),
        ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE1B9).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _detail!.judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E1F43),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _detail!.kategori,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737985),
                  ),
                ),
                const Divider(color: Colors.black54),
                const SizedBox(height: 16),
                _buildSection('Pelaksanaan', [
                  _buildDetailItem('Tempat', _detail!.tempat),
                  _buildDetailItem(
                      'Tanggal',
                      FormatterUtils.formatDate(
                          _detail!.tanggalMulai, _detail!.tanggalSelesai)),
                  _buildDetailItem(
                      'Waktu', FormatterUtils.formatTime(_detail!.waktu)),
                ]),
                _buildSection('Biaya', [
                  Text(
                    _detail!.biaya,
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                _buildSection('Vendor', [
                  Text(
                    _detail!.vendor,
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                if (_detail!.kategori == 'Sertifikasi' &&
                    _detail!.jenisSertifikasi != null)
                  _buildSection('Jenis Sertifikasi', [
                    Text(
                      _detail!.jenisSertifikasi!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ]),
                _buildSection('Jenis Kompetensi', [
                  Text(
                    _detail!.jenisKompetensi,
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                _buildSection('Level', [
                  Text(
                    _detail!.level,
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                _buildSection('Tag Bidang Minat', [
                  Text(
                    _detail!.bidangMinat.join(', '),
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                _buildSection('Tag Mata Kuliah', [
                  Text(
                    _detail!.mataKuliah.join(', '),
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                _buildSection('Kuota Peserta', [
                  Text(
                    '${_detail!.kuota} Orang',
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _launchURL(_detail!.vendorWeb),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E1F43),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Selengkapnya',
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
                        onPressed: () async {
                          final status = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PesertaPage(
                                id: widget.id,
                                kategori: widget.kategori,
                                title: _detail!.judul,
                              ),
                            ),
                          );
                          if (status != null) {
                            setState(() {
                              _detail = _detail!.copyWith(status: status);
                            });
                            // Store status locally
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                'status_${widget.id}_${widget.kategori}',
                                status);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF99D1C),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Peserta',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }

  Widget _buildSection(String title, List<Widget> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E1F43),
          ),
        ),
        const SizedBox(height: 8),
        ...content,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label : ',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF737985),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF0E1F43),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
