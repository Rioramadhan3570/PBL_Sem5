import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/Date%20Formate/date_format_monitoring.dart';
import 'package:pbl_sem5/services/pimpinan/api_monitoring.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/detail_monitoring_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/widgets/pimpinan/monitoring/header_monitoring_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';

class DetailMonitoringPimpinan extends StatefulWidget {
  final String nama;
  final String jenis;
  final String userId;

  const DetailMonitoringPimpinan({
    super.key,
    required this.nama,
    required this.jenis,
    required this.userId,
  });

  @override
  State<DetailMonitoringPimpinan> createState() => _DetailMonitoringPimpinanState();
}

class _DetailMonitoringPimpinanState extends State<DetailMonitoringPimpinan> {
  final ApiMonitoring _apiMonitoring = ApiMonitoring();
  List<DetailMonitoringModel> detailList = [];
  List<DetailMonitoringModel> filteredList = [];
  bool isLoading = true;
  String? error;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _initializeDate();
  }

  Future<void> _initializeDate() async {
    await initializeDateFormatting('id_ID', null);
    _fetchDetailData();
  }

  void _showNoDataDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Informasi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('${widget.nama} belum memiliki ${widget.jenis}'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Kembali ke halaman monitoring
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectYear(BuildContext context) async {
    final DateTime? picked = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Tahun'),
          content: SizedBox(
            width: 300,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(2020),
              lastDate: DateTime(DateTime.now().year + 1),
              selectedDate: DateTime(selectedYear),
              onChanged: (DateTime dateTime) {
                Navigator.pop(context, dateTime);
              },
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedYear = picked.year;
        _filterData();
      });
    }
  }

  void _filterData() {
    filteredList = detailList.where((detail) {
      final DateTime tanggal = DateTime.parse(detail.tanggal);
      return tanggal.year == selectedYear;
    }).toList();
  }

  Future<void> _fetchDetailData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await _apiMonitoring.getDetailMonitoring(widget.userId, widget.jenis);
      
      setState(() {
        detailList = response.data;
        _filterData();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      if (!mounted) return;
      _showNoDataDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderMonitoringPimpinan(
          showBackButton: true,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchDetailData,
        child: Column(
          children: [
            // Filter Container
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _selectYear(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: const Icon(
                        Icons.filter_list,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // List data
            Expanded(
              child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                  ? const SizedBox()
                  : filteredList.isEmpty
                    ? const Center(
                        child: Text('Tidak ada data untuk tahun yang dipilih'),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: filteredList
                            .map((detail) => _buildDetailCard(detail))
                            .toList(),
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }

  Widget _buildDetailCard(DetailMonitoringModel detail) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFFFFF8EA),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail.judul,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              detail.kategori,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Tempat', detail.tempat),
            _buildDetailRow('Tanggal', FormatterUtils.formatDate(detail.tanggal)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const Text(': '),
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