// lib/screens/notifikasi/notifikasi_pimpinan.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_notifikasi/notifikasi_response.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_notifikasi_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/notifikasi/header_notifikasi_pimpinan.dart';

class NotifikasiPimpinan extends StatefulWidget {
  const NotifikasiPimpinan({super.key});

  @override
  State<NotifikasiPimpinan> createState() => _NotifikasiPimpinanState();
}

class _NotifikasiPimpinanState extends State<NotifikasiPimpinan> {
  final ApiNotifikasiPimpinan _apiService = ApiNotifikasiPimpinan();
  bool _isLoading = true;
  String? _error;
  NotifikasiResponse? _notifikasiData;

  @override
  void initState() {
    super.initState();
    _loadNotifikasiData();
  }

  Future<void> _loadNotifikasiData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final data = await _apiService.getNotifications();
      
      setState(() {
        _notifikasiData = data;
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

    if (_notifikasiData == null || _notifikasiData!.data.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Tidak ada notifikasi')),
        bottomNavigationBar: Navbar(selectedIndex: 6),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: HeaderNotifikasiPimpinan(
          showBackButton: true,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifikasiData,
        child: Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: ListView.builder(
            itemCount: _notifikasiData!.data.length,
            itemBuilder: (context, index) {
              final notification = _notifikasiData!.data[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailRekomendasiPage(
                        id: notification.id,
                        kategori: notification.kategori,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x4DFDE1B9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF1511B),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.vendor,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            notification.tanggalPengajuan,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 6),
    );
  }
}