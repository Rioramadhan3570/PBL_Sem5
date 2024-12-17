import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_riwayat/peserta_riwayat_response.dart';
import 'package:pbl_sem5/services/pimpinan/api_riwayat_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/riwayat/header_riwayat_pimpinan.dart';

class RiwayatPesertaPage extends StatefulWidget {
  final String id;
  final String kategori;
  final String title;

  const RiwayatPesertaPage({
    super.key,
    required this.id,
    required this.kategori,
    required this.title,
  });

  @override
  _RiwayatPesertaPageState createState() => _RiwayatPesertaPageState();
}

class _RiwayatPesertaPageState extends State<RiwayatPesertaPage> {
  final ApiRiwayatPimpinan _apiService = ApiRiwayatPimpinan();
  bool _isLoading = true;
  String? _error;
  PesertaRiwayatData? _pesertaData;

  @override
  void initState() {
    super.initState();
    _loadPesertaData();
  }

  Future<void> _loadPesertaData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final response = await _apiService.getPesertaRiwayat(widget.id, widget.kategori);
      
      setState(() {
        _pesertaData = response.data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderRiwayatPimpinan(
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
                          const Text(
                            'Peserta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E1F43),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _pesertaData?.peserta.length ?? 0,
                                itemBuilder: (context, index) {
                                  final peserta = _pesertaData!.peserta[index];
                                  return ListTile(
                                    title: Text(peserta.nama),
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
                        ],
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }
}