import 'package:flutter/material.dart';
import 'header_detail_informasi.dart';
import 'navbar.dart';

class InformasiDetail {
  final String title;
  final String tempat;
  final String tanggal;
  final String waktu;
  final String biaya;
  final String vendor;
  final String jenis;
  final List<String> tagBidangMinat;
  final List<String> tagMataKuliah;
  final String kuotaPeserta;
  final String kategori;

  InformasiDetail({
    required this.title,
    required this.tempat,
    required this.tanggal,
    required this.waktu,
    required this.biaya,
    required this.vendor,
    required this.jenis,
    required this.tagBidangMinat,
    required this.tagMataKuliah,
    required this.kuotaPeserta,
    required this.kategori,
  });
}

class HalamanDetailInformasiDosen extends StatefulWidget {
  final InformasiDetail informasi;
  final int selectedIndex;
  final Function onNavigateBack;

  const HalamanDetailInformasiDosen({
    Key? key,
    required this.informasi,
    required this.onNavigateBack,
    this.selectedIndex = 1,
  }) : super(key: key);

  @override
  _HalamanDetailInformasiDosenState createState() =>
      _HalamanDetailInformasiDosenState();
}

class _HalamanDetailInformasiDosenState
    extends State<HalamanDetailInformasiDosen> {
  bool isLoved = false;
  bool isSubmitted = false;

  void _handleSubmit() {
    setState(() {
      isSubmitted = true;
    });
    // Removed the automatic navigation
  }

  @override
  Widget build(BuildContext context) {
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.informasi.title,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0E1F43),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.informasi.kategori,
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
                          onPressed: () {
                            setState(() {
                              isLoved = !isLoved;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.black54),
                    const SizedBox(height: 16),
                    _buildSection('Pelaksanaan', [
                      _buildDetailItem('Tempat', widget.informasi.tempat),
                      _buildDetailItem('Tanggal', widget.informasi.tanggal),
                      _buildDetailItem('Waktu', widget.informasi.waktu),
                    ]),
                    _buildSection('Biaya', [
                      Text(
                        widget.informasi.biaya,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Vendor', [
                      Text(
                        widget.informasi.vendor,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Jenis', [
                      Text(
                        widget.informasi.jenis,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Tag Bidang Minat', [
                      Text(
                        widget.informasi.tagBidangMinat.join(', '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Tag Mata Kuliah', [
                      Text(
                        widget.informasi.tagMataKuliah.join(', '),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ]),
                    _buildSection('Kuota Peserta', [
                      Text(
                        widget.informasi.kuotaPeserta,
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
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitted ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubmitted
                                  ? Colors.grey
                                  : const Color(0xFFF99D1C),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              isSubmitted ? 'Diajukan' : 'Ajukan',
                              style: TextStyle(
                                color: isSubmitted ? Colors.black54 : Colors.white,
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