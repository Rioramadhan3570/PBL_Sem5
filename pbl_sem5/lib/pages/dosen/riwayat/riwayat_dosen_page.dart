import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
import 'package:pbl_sem5/pages/dosen/riwayat/detail_riwayat_page.dart';
import 'package:pbl_sem5/services/dosen/api_riwayat_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';
import 'package:pbl_sem5/widgets/dosen/riwayat/header_riwayat_dosen.dart';

class RiwayatDosen extends StatefulWidget {
  const RiwayatDosen({super.key});

  @override
  _RiwayatDosenState createState() => _RiwayatDosenState();
}

class _RiwayatDosenState extends State<RiwayatDosen> {
  bool _isMandiriActive = true;
  String _statusFilter = 'Semua';
  List<RiwayatModel> riwayatList = [];
  bool isLoading = false;
  final ApiRiwayatDosen _apiRiwayatDosen = ApiRiwayatDosen();

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    setState(() => isLoading = true);
    try {
      final data = await _apiRiwayatDosen.getRiwayat();
      setState(() => riwayatList = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<RiwayatModel> get filteredRiwayat {
    return riwayatList.where((riwayat) {
      // Filter berdasarkan tipe (Mandiri/Rekomendasi)
      bool matchesType = _isMandiriActive
          ? riwayat.pendanaan == 'Eksternal'
          : riwayat.pendanaan == 'Internal';

      // Filter berdasarkan status
      bool matchesStatus = _statusFilter == 'Semua' ||
          riwayat.statusBukti == _getStatusApiValue(_statusFilter);

      return matchesType && matchesStatus;
    }).toList();
  }

  String _getStatusApiValue(String displayStatus) {
    switch (displayStatus) {
      case 'Proses':
        return 'pending';
      case 'Disetujui':
        return 'approved';
      case 'Ditolak':
        return 'rejected';
      default:
        return '';
    }
  }

  String _getDisplayStatus(String? apiStatus, bool isBuktiUploaded) {
    if (!isBuktiUploaded) {
      return 'Belum Upload';
    }
    switch (apiStatus) {
      case 'pending':
        return 'Proses';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Belum Upload';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isMandiriActive = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isMandiriActive
                              ? const Color(0xFF0E1F43)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Mandiri',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                _isMandiriActive ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isMandiriActive = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isMandiriActive
                              ? const Color(0xFF0E1F43)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          'Rekomendasi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                !_isMandiriActive ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(25),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                'Semua',
                'Proses',
                'Disetujui',
                'Ditolak',
              ]
                  .map((status) => PopupMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onSelected: (value) => setState(() => _statusFilter = value),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderRiwayatDosen(),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRiwayat,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategorySelector(),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredRiwayat.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada data riwayat',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredRiwayat.length,
                          itemBuilder: (context, index) {
                            final riwayat = filteredRiwayat[index];
                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailRiwayat(riwayat: riwayat),
                                ),
                              ).then((_) => _fetchRiwayat()),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.orange[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      riwayat.judul,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      riwayat.kategori,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                        onPressed: null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: _getStatusColor(
                                              riwayat.statusBukti),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        child: Text(_getDisplayStatus(
                                            riwayat.statusBukti,
                                            riwayat.isBuktiUploaded)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }
}
