import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/beranda_responses.dart';
import 'package:pbl_sem5/pages/running_figure.dart';
import 'package:pbl_sem5/services/api_login.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/services/pimpinan/api_beranda_pimpinan.dart';
import 'package:pbl_sem5/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart';

class HalamanUtamaPimpinan extends StatefulWidget {
  final int selectedIndex;
  const HalamanUtamaPimpinan({super.key, this.selectedIndex = 0});

  @override
  _HalamanUtamaPimpinanState createState() => _HalamanUtamaPimpinanState();
}

class _HalamanUtamaPimpinanState extends State<HalamanUtamaPimpinan> {
  final ApiBerandaPimpinan _apiService = ApiBerandaPimpinan();
  final LoginService _loginService = LoginService(); // Instance login service
  bool _isLoading = true;
  String? _error;
  BerandaResponse? _berandaData;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _loadBerandaData();
  }

  Future<void> _loadBerandaData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final data = await _apiService.getBerandaData();

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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text(_error!)),
      );
    }

    if (_berandaData == null) {
      return const Scaffold(
        body: Center(child: Text('Data tidak tersedia')),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadBerandaData,
        child: Column(
          children: [
            _buildHeader(),
            _buildStatsSection(),
            Expanded(
              child: _buildRecentInfoSection(),
            ),
          ],
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
                  backgroundImage: _berandaData!.profile.avatar != null
                      ? NetworkImage(_berandaData!.profile.avatar!)
                      : null,
                      child: _berandaData!.profile.avatar == null
                      ? const Icon(Icons.person, size: 25, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_berandaData!.profile.nama.split(',')[0]} | ${_berandaData!.profile.role}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _berandaData!.profile.nip ?? '-',
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
                    Navigator.pushNamed(context, '/notifikasi_pimpinan');
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
                  'Hallo, ${_berandaData!.profile.nama.split(' ')[0]}!',
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
              'Pengajuan Sertifikasi',
              _berandaData!.statistics.totalSertifikasi.toString(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pengajuan Pelatihan',
              _berandaData!.statistics.totalPelatihan.toString(),
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Pengajuan Terbaru',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _berandaData!.latestRekomendasi.isEmpty
              ? const Center(
                  child: Text(
                    'Tidak ada data pengajuan terbaru',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _berandaData!.latestRekomendasi.length,
                  itemBuilder: (context, index) {
                    final rekomendasi = _berandaData!.latestRekomendasi[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRekomendasiPage(
                              id: rekomendasi.id,
                              kategori: rekomendasi.kategori,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0x66FDE1B9),
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                rekomendasi.judul,
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
                                color: rekomendasi.kategori == 'Sertifikasi'
                                    ? Colors.blue.withOpacity(0.2)
                                    : Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                rekomendasi.kategori,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: rekomendasi.kategori == 'Sertifikasi'
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
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:pbl_sem5/models/pimpinan/pimpinan_beranda/beranda_responses.dart';
// import 'package:pbl_sem5/pages/running_figure.dart';
// import 'package:pbl_sem5/services/api_login.dart';
// import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
// import 'package:pbl_sem5/services/pimpinan/api_beranda_pimpinan.dart';
// import 'package:pbl_sem5/pages/pimpinan/rekomendasi/detail_rekomendasi_page.dart';

// class HalamanUtamaPimpinan extends StatefulWidget {
//   final int selectedIndex;
//   const HalamanUtamaPimpinan({super.key, this.selectedIndex = 0});

//   @override
//   _HalamanUtamaPimpinanState createState() => _HalamanUtamaPimpinanState();
// }

// class _HalamanUtamaPimpinanState extends State<HalamanUtamaPimpinan> {
//   final ApiBerandaPimpinan _apiService = ApiBerandaPimpinan();
//   final LoginService _loginService = LoginService(); // Instance login service
//   bool _isLoading = true;
//   String? _error;
//   BerandaResponse? _berandaData;

//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('id_ID', null);
//     _loadBerandaData();
//   }

//   Future<void> _loadBerandaData() async {
//     try {
//       setState(() {
//         _isLoading = true;
//         _error = null;
//       });

//       final data = await _apiService.getBerandaData();

//       setState(() {
//         _berandaData = data;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _handleLogout() async {
//     try {
//       final result = await _loginService.logout();

//       if (result['success']) {
//         // Pastikan navigasi ke halaman login
//         if (mounted) {
//           // Hapus semua route dan navigasi ke login
//           Navigator.of(context).pushNamedAndRemoveUntil(
//             '/login_user', // Ganti dengan route login page Anda
//             (Route<dynamic> route) => false,
//           );
//         }
//       } else {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(result['message'] ?? 'Gagal logout'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Terjadi kesalahan saat logout'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           return RefreshIndicator(
//             onRefresh: _loadBerandaData,
//             child: SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: _buildContent(),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: const Navbar(selectedIndex: 0),
//     );
//   }

//   Widget _buildContent() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_error != null) {
//       return Center(child: Text(_error!));
//     }

//     if (_berandaData == null) {
//       return const Center(child: Text('Data tidak tersedia'));
//     }

//     return Column(
//       children: [
//         _buildHeader(),
//         _buildStatsSection(),
//         Expanded(
//           child: _buildRecentInfoSection(),
//         ),
//       ],
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xffffebf11), Color(0xffff1511b), Color(0xFFF36619)],
//           stops: [0.70, 1.0, 1.0],
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 60, 16, 50),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 25,
//                   backgroundImage: _berandaData!.profile.avatar != null
//                       ? NetworkImage(_berandaData!.profile.avatar!)
//                       : const NetworkImage('https://via.placeholder.com/50'),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${_berandaData!.profile.nama} | ${_berandaData!.profile.role}',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         _berandaData!.profile.nip ?? '-',
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.notifications, color: Colors.white),
//                   onPressed: () {
//                     Navigator.pushNamed(context, '/notifikasi_pimpinan');
//                   },
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.logout, color: Colors.white),
//                   onPressed: () => showCustomLogoutDialog(context, _handleLogout),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'Hallo, ${_berandaData!.profile.nama.split(' ')[0]}!',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
//               style: const TextStyle(fontSize: 14, color: Colors.white),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsSection() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
//       child: Wrap(
//         alignment: WrapAlignment.center,
//         spacing: 16,
//         runSpacing: 16,
//         children: [
//           _buildStatCard(
//             'Pengajuan Sertifikasi',
//             _berandaData!.statistics.totalSertifikasi.toString(),
//           ),
//           _buildStatCard(
//             'Pengajuan Pelatihan',
//             _berandaData!.statistics.totalPelatihan.toString(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, String value) {
//     return Container(
//       width: 175,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//           colors: [
//             Color(0xFFFBBC09),
//             Color(0xFFFDD015),
//           ],
//           stops: [0.0, 0.56],
//         ),
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.3),
//             spreadRadius: 1,
//             blurRadius: 3,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRecentInfoSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
//           child: Text(
//             'Pengajuan Terbaru',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             itemCount: _berandaData!.latestRekomendasi.length,
//             itemBuilder: (context, index) {
//               final rekomendasi = _berandaData!.latestRekomendasi[index];
//               return InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetailRekomendasiPage(
//                         id: rekomendasi.id,
//                         kategori: rekomendasi.kategori,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   margin: const EdgeInsets.only(bottom: 8),
//                   decoration: BoxDecoration(
//                     color: const Color(0x66FDE1B9),
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey.withOpacity(0.2)),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           rekomendasi.judul,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: rekomendasi.kategori == 'Sertifikasi'
//                               ? Colors.blue.withOpacity(0.2)
//                               : Colors.green.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: Text(
//                           rekomendasi.kategori,
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: rekomendasi.kategori == 'Sertifikasi'
//                                 ? Colors.blue
//                                 : Colors.green,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }