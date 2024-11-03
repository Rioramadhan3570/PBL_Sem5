import 'package:flutter/material.dart';
import 'header_pengajuan.dart';
import 'navbar.dart';
import 'sertifikasi_form.dart';
import 'pelatihan_form.dart';
import 'detail_pengajuan_tendik.dart';

class PengajuanTendik extends StatefulWidget {
  const PengajuanTendik({Key? key}) : super(key: key);

  @override
  State<PengajuanTendik> createState() => _PengajuanTendikState();
}

class _PengajuanTendikState extends State<PengajuanTendik> {
  // Constants
  static const List<String> _statusList = ["All", "Proses", "Disetujui", "Ditolak"];

  // State variables
  String _selectedTab = "Rekomen";
  String _selectedStatus = "All";
  String _status = "Proses";

  // Bottom sheet for adding new items
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return _buildBottomSheetContent();
      },
    );
  }

  // Build bottom sheet content
  Widget _buildBottomSheetContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomSheetItem(
            'Sertifikasi', 
            () => _navigateToForm(const SertifikasiForm())
          ),
          const Divider(height: 1),
          _buildBottomSheetItem(
            'Pelatihan', 
            () => _navigateToForm(const PelatihanForm())
          ),
        ],
      ),
    );
  }

  // Helper method for bottom sheet list items
  ListTile _buildBottomSheetItem(String title, VoidCallback onTapAction) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        onTapAction();
      },
    );
  }

  // Navigate to specific form
  void _navigateToForm(Widget form) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => form),
    );
  }

  // Navigate to detail page with sample data
  void _navigateToDetail() {
    final detail = DetailPengajuanTendik(
      title: 'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
      tempat: 'Jakarta',
      tanggal: '20 November 2024',
      waktu: '09:00 - 16:00',
      biaya: 'Rp 2.000.000',
      vendor: 'Microsoft',
      jenis: 'Sertifikasi',
      tagBidangMinat: ['Web Development', 'Programming'],
      tagMataKuliah: ['Pemrograman Web', 'Desain Web'],
      kuotaPeserta: '100 Peserta',
      kategori: 'Teknologi Informasi',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HalamanDetailInformasi(
          informasi: detail,
          onNavigateBack: () {
            // Implement callback here if needed
          },
        ),
      ),
    );
  }

  // Build tab selection widget
  Widget _buildTabSelector(String label, String tabValue) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = tabValue;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: _selectedTab == tabValue
                ? const Color(0xFF0E1F43)
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _selectedTab == tabValue ? Colors.white : Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // Status color based on current status
  Color _getStatusColor() {
    switch (_status) {
      case "Proses":
        return const Color(0xFFF99D1C);
      case "Disetujui":
        return Colors.green;
      case "Ditolak":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Add button widget
  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: _showFilterBottomSheet,
      backgroundColor: Colors.orange,
      child: const Icon(Icons.add, color: Colors.white, size: 32),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = _statusList.contains(_selectedStatus) 
        ? _selectedStatus 
        : _statusList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderPengajuan(),
      ),
      body: Column(
        children: [
          // Top control bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Tab selectors
                _buildTabSelector('Rekomen', 'Rekomen'),
                const SizedBox(width: 8),
                _buildTabSelector('Mandiri', 'Mandiri'),
                const SizedBox(width: 8),

                // Status dropdown filter
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedStatus,
                      icon: const Icon(Icons.filter_list),
                      menuMaxHeight: 300,
                      items: _statusList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null && _statusList.contains(newValue)) {
                          setState(() {
                            _selectedStatus = newValue;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // List view of items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 1,
              itemBuilder: (context, index) {
                // Filter logic for status
                if (_selectedStatus != "All" && _status != _selectedStatus) {
                  return const SizedBox.shrink();
                }
                
                return GestureDetector(
                  onTap: _navigateToDetail, // Navigate to detail on card tap
                  child: Card(
                    color: const Color(0xFFFFF5E6),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Microsoft Technology Associate (MTA) - Web Development Fundamentals',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddButton(),
      bottomNavigationBar: Navbar(selectedIndex: 2),
    );
  }
}
