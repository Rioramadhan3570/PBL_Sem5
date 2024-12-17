import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/detail_riwayat_response.dart';
import 'package:pbl_sem5/pages/pimpinan/riwayat/riwayat_peserta_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_riwayat_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/riwayat/header_riwayat_pimpinan.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRiwayatPimpinanPage extends StatefulWidget {
  final String id;
  final String kategori;

  const DetailRiwayatPimpinanPage({
    super.key,
    required this.id,
    required this.kategori,
  });

  @override
  _DetailRiwayatPimpinanPageState createState() =>
      _DetailRiwayatPimpinanPageState();
}

class _DetailRiwayatPimpinanPageState extends State<DetailRiwayatPimpinanPage> {
  final ApiRiwayatPimpinan _apiService = ApiRiwayatPimpinan();
  bool _isLoading = true;
  String? _error;
  DetailRiwayatData? _detail;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final response =
          await _apiService.getDetailRiwayat(widget.id, widget.kategori);
      setState(() {
        _detail = response.data;
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
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
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
        child: HeaderRiwayatPimpinan(
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
                  _buildDetailItem('Tanggal', _detail!.tanggal),
                  _buildDetailItem('Waktu', _detail!.waktu),
                ]),
                _buildSection('Biaya', [
                  Text(_detail!.biaya, style: const TextStyle(fontSize: 14)),
                ]),
                _buildSection('Vendor', [
                  Text(_detail!.vendor, style: const TextStyle(fontSize: 14)),
                ]),
                if (_detail!.kategori == 'Sertifikasi' &&
                    _detail!.jenisSertifikasi != null)
                  _buildSection('Jenis Sertifikasi', [
                    Text(_detail!.jenisSertifikasi!,
                        style: const TextStyle(fontSize: 14)),
                  ]),
                _buildSection('Jenis Kompetensi', [
                  Text(_detail!.jenisKompetensi,
                      style: const TextStyle(fontSize: 14)),
                ]),
                _buildSection('Level', [
                  Text(_detail!.level, style: const TextStyle(fontSize: 14)),
                ]),
                _buildSection('Tag Bidang Minat', [
                  Text(_detail!.bidangMinat.join(', '),
                      style: const TextStyle(fontSize: 14)),
                ]),
                _buildSection('Tag Mata Kuliah', [
                  Text(_detail!.mataKuliah.join(', '),
                      style: const TextStyle(fontSize: 14)),
                ]),
                _buildSection('Kuota Peserta', [
                  Text('${_detail!.kuota} Orang',
                      style: const TextStyle(fontSize: 14)),
                ]),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _detail!.vendorWeb != null
                            ? () => _launchURL(_detail!.vendorWeb!)
                            : null, // Disable tombol jika vendorWeb null
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0E1F43),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Selengkapnya',
                          style: TextStyle(
                            color: _detail!.vendorWeb != null
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RiwayatPesertaPage(
                                id: widget.id,
                                kategori: widget.kategori,
                                title: _detail!.judul,
                              ),
                            ),
                          );
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
      bottomNavigationBar: const Navbar(selectedIndex: 3),
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
