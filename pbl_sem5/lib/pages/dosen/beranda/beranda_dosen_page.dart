import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/models/dosen/beranda/beranda_model.dart';
import 'package:pbl_sem5/pages/dosen/rekomendasi/detail_rekomendasi_dosen_page.dart';
import 'package:pbl_sem5/pages/running_figure.dart';
import 'package:pbl_sem5/services/api_login.dart';
import 'package:pbl_sem5/services/dosen/api_beranda_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class HalamanUtamaDosen extends StatefulWidget {
  final int selectedIndex;
  const HalamanUtamaDosen({super.key, this.selectedIndex = 0});

  @override
  State<HalamanUtamaDosen> createState() => _HalamanUtamaDosenState();
}

class _HalamanUtamaDosenState extends State<HalamanUtamaDosen> {
  final ApiBerandaDosen _apiService = ApiBerandaDosen();
  final LoginService _loginService = LoginService();
  bool _isLoading = true;
  String? _error;
  BerandaData? _berandaData;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _apiService.getDashboard();
      setState(() {
        _berandaData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      final result = await _loginService.logout();

      if (result['success']) {
        // Pastikan navigasi ke halaman login
        if (mounted) {
          // Hapus semua route dan navigasi ke login
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login_user', // Ganti dengan route login page Anda
            (Route<dynamic> route) => false,
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Gagal logout'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    if (_berandaData == null) {
      return const Scaffold(
        body: Center(child: Text('Data tidak tersedia')),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 
                        kBottomNavigationBarHeight,
            ),
            child: Column(
              children: [
                _buildHeader(),
                _buildStatsSection(),
                _buildRecentInfoSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 0),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xffffebf11), Color(0xffff1511b), Color(0xFFF36619)],
          stops: [0.70, 1.0, 1.0],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: _berandaData?.userInfo.avatar != null
                      ? Image.network(_berandaData!.userInfo.avatar!).image
                      : null,
                  child: _berandaData?.userInfo.avatar == null
                      ? const Icon(Icons.person, size: 25, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_berandaData?.userInfo.nama} | ${_berandaData?.userInfo.role}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _berandaData?.userInfo.nip ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notifikasi_dosen');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () =>
                      showCustomLogoutDialog(context, _handleLogout),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 50),
            child: Column(
              children: [
                Text(
                  'Hallo, ${_berandaData?.userInfo.nama.split(' ')[0]}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID')
                      .format(DateTime.now()),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 25, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Sertifikasi',
              _berandaData?.totalSertifikasi.toString() ?? '0',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Total Pelatihan',
              _berandaData?.totalPelatihan.toString() ?? '0',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFFBBC09),
            Color(0xFFFDD015),
          ],
          stops: [0.0, 0.56],
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
          child: Text(
            'Rekomendasi Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _berandaData?.latestRekomendasi.length ?? 0,
          itemBuilder: (context, index) {
            final item = _berandaData?.latestRekomendasi[index];
            return InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HalamanDetailRekomendasiDosen(
                    id: item?.id ?? '',
                    tipe: item?.tipe ?? '',
                  ),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: const Color(0x66FDE1B9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item?.judul ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item?.tipe == 'Sertifikasi'
                            ? Colors.blue.withOpacity(0.2)
                            : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item?.tipe ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: item?.tipe == 'Sertifikasi'
                              ? Colors.blue
                              : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
