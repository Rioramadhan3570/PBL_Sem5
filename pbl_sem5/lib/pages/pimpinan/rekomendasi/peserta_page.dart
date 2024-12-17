// lib/pages/pimpinan/rekomendasi/peserta_page.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/calon_peserta_model.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_rekomendasi/peserta_model.dart';
import 'package:pbl_sem5/services/pimpinan/api_rerkomendasi_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/pengajuan/header_pengajuan_pimpinan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PesertaPage extends StatefulWidget {
  final String id;
  final String kategori;
  final String title;

  const PesertaPage({
    super.key,
    required this.id,
    required this.kategori,
    required this.title,
  });

  @override
  _PesertaPageState createState() => _PesertaPageState();
}

class _PesertaPageState extends State<PesertaPage> {
  final ApiRekomendasiPimpinan _apiService = ApiRekomendasiPimpinan();
  List<PesertaModel> _peserta = [];
  bool _isLoading = true;
  String? _error;
  Set<String> _selectedPeserta = {}; // Untuk menyimpan ID peserta yang dipilih
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load both status and peserta concurrently
      final results = await Future.wait([
        _apiService.getStatus(widget.id, widget.kategori),
        _apiService.getPeserta(widget.id, widget.kategori),
      ]);

      if (!mounted) return;

      setState(() {
        _status = results[0] as String;
        _peserta = results[1] as List<PesertaModel>;
        _selectedPeserta = Set.from(_peserta.map((p) => p.id));
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

// ... previous imports and code remains same ...

  Future<void> _showAddPesertaDialog() async {
    if (_status != 'pending') return;

    try {
      final calonPeserta = await _apiService.getCalonPesertaWithHistory(
          widget.id, widget.kategori);
      final detail =
          await _apiService.getDetailKegiatan(widget.id, widget.kategori);
      if (!mounted) return;

      final int kuota = detail.kuota;

      await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pilih Peserta',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  'Kuota: ${_selectedPeserta.length}/$kuota',
                  style: TextStyle(
                    fontSize: 14,
                    color: _selectedPeserta.length >= kuota
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: calonPeserta.length,
                      itemBuilder: (context, index) {
                        final calon = calonPeserta[index];
                        final isSelected = _selectedPeserta.contains(calon.id);
                        final bool isCheckboxEnabled =
                            isSelected || _selectedPeserta.length < kuota;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: CheckboxListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        calon.nama,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              !isCheckboxEnabled && !isSelected
                                                  ? Colors.grey
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.info_outline,
                                          size: 20),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () =>
                                          _showHistoryDialog(context, calon),
                                    ),
                                  ],
                                ),
                                if (calon.matchingPoints > 0) ...[
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Skor: ${calon.matchingPoints}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            value: isSelected,
                            onChanged: isCheckboxEnabled
                                ? (bool? value) {
                                    setDialogState(() {
                                      if (value == true) {
                                        _selectedPeserta.add(calon.id);
                                      } else {
                                        _selectedPeserta.remove(calon.id);
                                      }
                                    });
                                  }
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  if (_selectedPeserta.length > kuota) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Jumlah peserta melebihi kuota ($kuota)')),
                    );
                    return;
                  }

                  try {
                    await _apiService.updatePeserta(
                      widget.id,
                      widget.kategori,
                      _selectedPeserta.toList(),
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    await _loadInitialData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Peserta berhasil diperbarui')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _showHistoryDialog(BuildContext context, CalonPesertaModel calon) {
    final List<Map<String, String>> allHistory = [
      ...calon.history.sertifikasi.map((item) => {
            'judul': item.judul,
            'kategori': 'Sertifikasi',
            'tanggal': item.tanggal,
          }),
      ...calon.history.pelatihan.map((item) => {
            'judul': item.judul,
            'kategori': 'Pelatihan',
            'tanggal': item.tanggal,
          }),
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.history, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Riwayat ${calon.nama}',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height *
              0.5, // Set height to 50% of screen height
          child: ListView(
            children: [
              if (allHistory.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Tidak ada riwayat kegiatan',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              else
                ...allHistory
                    .map((item) => Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['judul'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: item['kategori'] == 'Sertifikasi'
                                            ? Colors.blue.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        item['kategori'] ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              item['kategori'] == 'Sertifikasi'
                                                  ? Colors.blue[800]
                                                  : Colors.green[800],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      item['tanggal'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ))
                    ,
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _getStatus() async {
    try {
      final status = await _apiService.getStatus(widget.id, widget.kategori);
      setState(() {
        _status = status;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _showConfirmationDialog(String action) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Konfirmasi ${action == 'approved' ? 'Setuju' : 'Tolak'}'),
          content: Text(
              'Apakah Anda yakin ingin ${action == 'approved' ? 'menyetujui' : 'menolak'} pengajuan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _updateStatus(action);
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await _apiService.updateStatus(widget.id, widget.kategori, newStatus);

      if (!mounted) return;

      // Store status locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'status_${widget.id}_${widget.kategori}', newStatus);

      setState(() {
        _status = newStatus;
      });

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(newStatus == 'approved' ? 'Disetujui' : 'Ditolak'),
            content: Text(
                'Pengajuan telah berhasil ${newStatus == 'approved' ? 'disetujui' : 'ditolak'}.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigator.pop(context, newStatus); // Return to previous screen with status
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isActionable = _status == 'pending';

    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          Navigator.pop(context, _status);
        }
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: HeaderPengajuanPimpinan(
            showBackButton: true,
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!))
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0E1F43),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.kategori,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF737985),
                              ),
                            ),
                            const Divider(color: Colors.black54),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Peserta',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0E1F43),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: isActionable
                                        ? const Color(0xFFFFB703)
                                        : Colors.grey,
                                  ),
                                  onPressed: isActionable
                                      ? _showAddPesertaDialog
                                      : null,
                                ),
                              ],
                            ),
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _peserta.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(_peserta[index].nama),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    tileColor: Colors.grey[100],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    disabledBackgroundColor: Colors.grey,
                                  ),
                                  onPressed: isActionable
                                      ? () =>
                                          _showConfirmationDialog('approved')
                                      : null,
                                  child: const Text('Setuju'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
        bottomNavigationBar: const Navbar(selectedIndex: 2),
      ),
    );
  }
}
