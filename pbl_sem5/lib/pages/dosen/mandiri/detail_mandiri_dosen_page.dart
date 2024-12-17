//pages/dosen/mandiri/detail_mandiri_dosen_page.dart
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pbl_sem5/models/dosen/mandiri/mandiri_detail_model.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/pelatihan_form.dart';
import 'package:pbl_sem5/pages/dosen/mandiri/sertifikasi_form.dart';
import 'package:pbl_sem5/services/dosen/api_mandiri_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/mandiri/header_mandiri_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class HalamanDetailMandiriDosen extends StatefulWidget {
  final String id;
  final String kategori;

  const HalamanDetailMandiriDosen({
    super.key,
    required this.id,
    required this.kategori,
  });

  @override
  State<HalamanDetailMandiriDosen> createState() =>
      _HalamanDetailMandiriDosenState();
}

class _HalamanDetailMandiriDosenState extends State<HalamanDetailMandiriDosen> {
  final ApiMandiriDosen _apiMandiriDosen = ApiMandiriDosen();
  MandiriDetail? _detailData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id');
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    try {
      setState(() => _isLoading = true);

      final data = await _apiMandiriDosen.getDetail(widget.id, widget.kategori);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text(
              'Apakah anda ingin menghapus ${widget.kategori.toLowerCase()} mandiri?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  Navigator.pop(context); // Close dialog
                  await _apiMandiriDosen.deleteMandiri(
                      widget.id, widget.kategori);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${widget.kategori} berhasil dihapus'),
                      ),
                    );
                    Navigator.pop(context); // Back to list page
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Gagal menghapus ${widget.kategori}: ${e.toString()}'),
                      ),
                    );
                  }
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditForm() {
    if (_detailData == null) return;

    if (widget.kategori.toLowerCase() == 'sertifikasi') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SertifikasiForm(
            isEdit: true,
            id: widget.id,
            initialData: _detailData!,
          ),
        ),
      ).then((_) => _fetchDetail());
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PelatihanForm(
            isEdit: true,
            id: widget.id,
            initialData: _detailData!,
          ),
        ),
      ).then((_) => _fetchDetail());
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

    if (_detailData == null) {
      return const Scaffold(
        body: Center(child: Text('Detail tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderMandiriDosen(showBackButton: true),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _detailData!.judul,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E1F43),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _detailData!.jenis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF737985),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black54),
                const SizedBox(height: 16),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 2),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection('Pelaksanaan', [
          _buildDetailItem('Tempat', _detailData!.tempat),
          _buildDetailItem('Tanggal', _detailData!.tanggal),
          _buildDetailItem('Waktu', _detailData!.waktu),
        ]),
        _buildSection('Biaya', [
          Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(_detailData!.biaya),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Vendor', [
          Text(
            // Mengambil nama vendor saja
            _detailData!.bidangMinat.isNotEmpty ? _detailData!.vendorNama : '',
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        if (widget.kategori.toLowerCase() == 'sertifikasi' &&
            _detailData!.jenisSertifikasi != null)
          _buildSection('Jenis Sertifikasi', [
            Text(
              _detailData!.jenisSertifikasi!,
              style: const TextStyle(fontSize: 14),
            ),
          ]),
        _buildSection('Jenis Kompetensi', [
          Text(
            _detailData!.jenisKompetensi,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Level', [
          Text(
            _detailData!.level,
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Bidang Minat', [
          Text(
            // Hanya menampilkan nama bidang minat
            _detailData!.bidangMinat.map((item) => item['nama']).join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
        _buildSection('Tag Mata Kuliah', [
          Text(
            // Hanya menampilkan nama mata kuliah
            _detailData!.mataKuliah.map((item) => item['nama']).join(', '),
            style: const TextStyle(fontSize: 14),
          ),
        ]),
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
}
