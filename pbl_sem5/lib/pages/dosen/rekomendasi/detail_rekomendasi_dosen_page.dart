import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pbl_sem5/models/dosen/rekomendasi/rekomendasi_detail_model.dart';
import 'package:pbl_sem5/services/dosen/api_rekomendasi_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/rekomendasi/header_rekomendasi_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';
import 'package:url_launcher/url_launcher.dart';

class HalamanDetailRekomendasiDosen extends StatefulWidget {
  final String id;
  final String tipe;
  final int selectedIndex;

  const HalamanDetailRekomendasiDosen({
    super.key,
    required this.id,
    required this.tipe,
    this.selectedIndex = 1,
  });

  @override
  _HalamanDetailRekomendasiDosenState createState() =>
      _HalamanDetailRekomendasiDosenState();
}

class _HalamanDetailRekomendasiDosenState
    extends State<HalamanDetailRekomendasiDosen> {
  final ApiRekomendasiDosen _apiService = ApiRekomendasiDosen();
  bool _isLoading = true;
  String? _error;
  RekomendasiDetail? _detail;

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
          await _apiService.getDetailRekomendasi(widget.id, widget.tipe);
      setState(() {
        _detail = response.data;
        _isLoading = false;
      });

      print('Loading detail for ID: ${widget.id}, Type: ${widget.tipe}');
      print('API Response: ${response.toString()}');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadSuratTugas() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final response =
          await _apiService.downloadSuratTugas(widget.id, widget.tipe);

      // Close loading indicator
      Navigator.pop(context);

      if (response.status && response.data != null) {
        // Save and open file
        final tempDir = await getApplicationDocumentsDirectory();
        final file = File('${tempDir.path}/surat_tugas.pdf');
        await file.writeAsBytes(response.data!.fileBytes);
        await OpenFile.open(file.path);
      } else {
        // Show error message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading indicator if still showing
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Show error message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat mengunduh surat tugas'),
          backgroundColor: Colors.red,
        ),
      );
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
        child: HeaderRekomendasiDosen(
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
                  _detail!.jenis, // Menampilkan jenis rekomendasi
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF737985),
                  ),
                ),
                const Divider(color: Colors.black54),
                const SizedBox(height: 16),
                if (_detail!.jenis == 'Sertifikasi')
                  _buildSertifikasiDetail(_detail!)
                else
                  _buildPelatihanDetail(_detail!),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }

  Widget _buildSertifikasiDetail(RekomendasiDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Pelaksanaan', [
          _buildDetailItem('Tempat', detail.tempat),
          _buildDetailItem('Tanggal', detail.tanggal),
          _buildDetailItem('Waktu', detail.waktu),
        ]),
        _buildSection('Biaya', [
          Text(
            detail.biaya,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Vendor', [
          Text(
            detail.vendor,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Jenis Sertifikasi', [
          Text(
            detail.jenisSertifikasi!,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Jenis Kompetensi', [
          Text(
            detail.jenisKompetensi,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Level', [
          Text(
            detail.level,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Bidang Minat', [
          Text(
            detail.bidangMinat.join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Mata Kuliah', [
          Text(
            detail.mataKuliah.join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Kuota Peserta', [
          Row(
            children: [
              Text(
                '${detail.kuota} Orang',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _showPesertaPopUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF99D1C),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Peserta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ]),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed:
                    detail.suratTugas != null ? _downloadSuratTugas : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: detail.suratTugas != null
                      ? const Color(0xFF0E1F43)
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Unduh Surat Tugas',
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
                onPressed: () {
                  launch(detail.vendorWeb);
                },
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
          ],
        ),
      ],
    );
  }

  Widget _buildPelatihanDetail(RekomendasiDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Pelaksanaan', [
          _buildDetailItem('Tempat', detail.tempat),
          _buildDetailItem('Tanggal', detail.tanggal),
          _buildDetailItem('Waktu', detail.waktu),
        ]),
        _buildSection('Biaya', [
          Text(
            detail.biaya,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Vendor', [
          Text(
            detail.vendor,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Jenis Kompetensi', [
          Text(
            detail.jenisKompetensi,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Level', [
          Text(
            detail.level,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Bidang Minat', [
          Text(
            detail.bidangMinat.join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Mata Kuliah', [
          Text(
            detail.mataKuliah.join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Kuota Peserta', [
          Row(
            children: [
              Text(
                '${detail.kuota} Orang',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  _showPesertaPopUp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF99D1C),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Lihat Peserta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ]),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed:
                    detail.suratTugas != null ? _downloadSuratTugas : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E1F43),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Unduh Surat Tugas',
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
                onPressed: () {
                  launch(detail.vendorWeb);
                },
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
          ],
        ),
      ],
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

  void _showPesertaPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peserta'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < _detail!.peserta.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${i + 1}. ${_detail!.peserta[i]}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
