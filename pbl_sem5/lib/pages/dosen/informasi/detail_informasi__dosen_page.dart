// lib/pages/dosen/detail_informasi_dosen_page.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/services/api_disukai.dart';
import 'package:pbl_sem5/widgets/dosen/informasi/header_detail_informasi.dart';
import 'package:pbl_sem5/widgets/navbar.dart';
import 'package:pbl_sem5/models/dosen/informasi/sertifikasi_rekomendasi_model.dart';
import 'package:intl/intl.dart';

class HalamanDetailInformasiDosen extends StatefulWidget {
  final dynamic informasi;
  final int selectedIndex;
  final Function onNavigateBack;

  const HalamanDetailInformasiDosen({
    super.key,
    required this.informasi,
    required this.onNavigateBack,
    this.selectedIndex = 1,
  });

  @override
  _HalamanDetailInformasiDosenState createState() =>
      _HalamanDetailInformasiDosenState();
}

class _HalamanDetailInformasiDosenState
    extends State<HalamanDetailInformasiDosen> {
  final DisukaiService _disukaiService = DisukaiService();
  bool isLoading = false;
  bool isLoved = false;
  String? errorMessage;
  String? disukaiId;
  bool isSubmitted = false;
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    setState(() {
      isLoved = widget.informasi.disukaiId != null;
      disukaiId = widget.informasi.disukaiId;
    });
  }

  Future<void> _toggleLike() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userId = await _disukaiService.getUserId();
      if (userId == null) {
        throw Exception('User not logged in');
      }

      bool success;
      if (isLoved && disukaiId != null) {
        success = await _disukaiService.removeDisukai(disukaiId!);
      } else {
        success = await _disukaiService.addDisukai(
          userId: userId,
          sertifikasiRekomendasiId:
              widget.informasi.type == 'sertifikasi' ? widget.informasi.id : null,
          pelatihanRekomendasiId:
              widget.informasi.type == 'pelatihan' ? widget.informasi.id : null,
          tipe: widget.informasi.type,
        );
      }

      if (success) {
        setState(() {
          isLoved = !isLoved;
          if (!isLoved) {
            disukaiId = null;
          }
        });
        
        // Panggil callback untuk memperbarui tampilan
        if (widget.onNavigateBack != null) {
          widget.onNavigateBack();
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLoved ? 'Berhasil menambahkan ke disukai' : 'Berhasil menghapus dari disukai'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage ?? 'Terjadi kesalahan')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null && endDate == null) {
      return 'Tanggal belum ditentukan';
    }

    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    if (startDate == null || endDate == null) {
      final date = startDate ?? endDate;
      return dateFormat.format(date!);
    }

    // Format kedua tanggal
    final startFormatted = dateFormat.format(startDate);
    final endFormatted = dateFormat.format(endDate);

    // Jika tanggal mulai dan selesai sama
    if (startFormatted == endFormatted) {
      return startFormatted;
    }

    // Jika berbeda, tampilkan keduanya
    return '$startFormatted - $endFormatted';
  }

  void _handleSubmit() {
    setState(() {
      isSubmitted = true;
    });
  }

  Widget _buildPelaksanaanSection() {
    final bool isSertifikasi = widget.informasi is Sertifikasi;

    // Ambil tanggal dari objek informasi
    final startDate = isSertifikasi
        ? widget.informasi.sertifikasiStart
        : widget.informasi.pelatihanStart;
    final endDate = isSertifikasi
        ? widget.informasi.sertifikasiEnd
        : widget.informasi.pelatihanEnd;

    // Ambil waktu pelaksanaan
    final waktu = widget.informasi.waktuPelaksanaan;

    return _buildSection('Pelaksanaan', [
      _buildDetailItem('Tempat', widget.informasi.tempat),
      _buildDetailItem('Tanggal', formatDateRange(startDate, endDate)),
      if (waktu != null && waktu.isNotEmpty) _buildDetailItem('Waktu', waktu),
    ]);
  }

  Widget _buildHeader(bool isSertifikasi) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.informasi.nama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E1F43),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isSertifikasi ? 'Sertifikasi' : 'Pelatihan',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF737985),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(
            isLoved ? Icons.favorite : Icons.favorite_border,
            color: isLoved ? Colors.red : Colors.grey,
            size: 24,
          ),
          onPressed: isLoading ? null : _toggleLike,
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
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

  @override
  Widget build(BuildContext context) {
    final bool isSertifikasi = widget.informasi is Sertifikasi;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderDetailInformasi(),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFDE1B9).withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(isSertifikasi),
                    const Divider(color: Colors.black54),
                    const SizedBox(height: 16),
                    _buildPelaksanaanSection(),
                    _buildSection('Biaya', [
                      Text(
                        currencyFormat.format(widget.informasi.biaya),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Vendor', [
                      Text(
                        widget.informasi.vendor['vendor_nama'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Jenis Kompetensi', [
                      Text(
                        widget.informasi.jenis['jenis_nama']?.toString() ?? '',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    if (isSertifikasi)
                      _buildSection('Jenis Sertifikasi', [
                        Text(
                          widget.informasi.jenisSertifikasi,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ]),
                    _buildSection('Level', [
                      Text(
                        widget.informasi.level,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Bidang Minat', [
                      Text(
                        widget.informasi.bidangMinat
                            .map((e) => e['keahlian_nama'])
                            .join(', '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Mata Kuliah', [
                      Text(
                        widget.informasi.mataKuliah
                            .map((e) => e['keahlian_nama'])
                            .join(', '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Kuota Peserta', [
                      Text(
                        '${widget.informasi.kuota} Orang',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
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
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }
}
