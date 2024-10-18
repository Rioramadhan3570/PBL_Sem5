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
    // Here you would typically make an API call to update the server
    Future.delayed(const Duration(seconds: 1), () {
      widget.onNavigateBack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderDetailInformasi(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: const Color(0xFFFFF5E6),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.informasi.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.informasi.kategori,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isLoved ? Icons.favorite : Icons.favorite_border,
                            color: isLoved ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isLoved = !isLoved;
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    _buildInfoSection('Pelaksanaan', [
                      _buildInfoItem('Tempat', widget.informasi.tempat),
                      _buildInfoItem('Tanggal', widget.informasi.tanggal),
                      _buildInfoItem('Waktu', widget.informasi.waktu),
                    ]),
                    _buildInfoSection('Biaya', [
                      _buildInfoItem('', widget.informasi.biaya),
                    ]),
                    _buildInfoSection('Vendor', [
                      _buildInfoItem('', widget.informasi.vendor),
                    ]),
                    _buildInfoSection('Jenis', [
                      _buildInfoItem('', widget.informasi.jenis),
                    ]),
                    _buildInfoSection('Tag Bidang Minat', [
                      _buildInfoItem(
                          '', widget.informasi.tagBidangMinat.join(', ')),
                    ]),
                    _buildInfoSection('Tag Mata Kuliah', [
                      _buildInfoItem(
                          '', widget.informasi.tagMataKuliah.join(', ')),
                    ]),
                    _buildInfoSection('Kuota Peserta', [
                      _buildInfoItem('', widget.informasi.kuotaPeserta),
                    ]),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0E1F43),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Selengkapnya',
                                style: TextStyle(color: Colors.white)),
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
                            ),
                            child: Text(
                              isSubmitted ? 'Diajukan' : 'Ajukan',
                              style: TextStyle(
                                color:
                                    isSubmitted ? Colors.black54 : Colors.white,
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
        ],
      ),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 80,
              child: Text(
                '$label:',
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
