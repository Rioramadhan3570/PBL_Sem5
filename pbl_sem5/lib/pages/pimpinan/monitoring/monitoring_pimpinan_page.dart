// // lib/screens/monitoring/monitoring_pimpinan.dart
// import 'package:flutter/material.dart';
// import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/monitorng_model.dart';
// import 'package:pbl_sem5/pages/pimpinan/monitoring/detail_monitoring_pimpinan_page.dart';
// import 'package:pbl_sem5/services/pimpinan/api_monitoring.dart';
// import 'package:pbl_sem5/widgets/pimpinan/monitoring/header_monitoring_pimpinan.dart';
// import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';

// class MonitoringPimpinan extends StatefulWidget {
//   const MonitoringPimpinan({super.key});

//   @override
//   State<MonitoringPimpinan> createState() => _MonitoringPimpinanState();
// }

// class _MonitoringPimpinanState extends State<MonitoringPimpinan> {
//   final ApiMonitoring _apiMonitoring = ApiMonitoring();
//   List<MonitoringModel> monitoringList = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMonitoringData();
//   }

//   Future<void> _fetchMonitoringData() async {
//     try {
//       setState(() {
//         isLoading = true;
//         error = null;
//       });

//       final response = await _apiMonitoring.getMonitoring();
      
//       setState(() {
//         monitoringList = response.data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error ?? 'Terjadi kesalahan')),
//       );
//     }
//   }

//   void _showNoDataDialog(String nama, String jenis) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Informasi',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Text('$nama belum memiliki $jenis'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _navigateToDetail(String nama, String jenis, String userId) async {
//     try {
//       await _apiMonitoring.getDetailMonitoring(userId, jenis);
      
//       if (!mounted) return;
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailMonitoringPimpinan(
//             nama: nama,
//             jenis: jenis,
//             userId: userId,
//           ),
//         ),
//       );
//       _fetchMonitoringData();
//     } catch (e) {
//       if (!mounted) return;
//       _showNoDataDialog(nama, jenis);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: HeaderMonitoringPimpinan(),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchMonitoringData,
//         child: isLoading 
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(error!),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _fetchMonitoringData,
//                       child: const Text('Coba Lagi'),
//                     ),
//                   ],
//                 ),
//               )
//             : monitoringList.isEmpty
//                 ? const Center(child: Text('Tidak ada data monitoring'))
//                 : Column(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Table(
//                             border: TableBorder(
//                               horizontalInside: BorderSide(color: Colors.grey.shade300),
//                               bottom: BorderSide(color: Colors.grey.shade300),
//                             ),
//                             columnWidths: const {
//                               0: FlexColumnWidth(2),
//                               1: FlexColumnWidth(2),
//                               2: FlexColumnWidth(1),
//                             },
//                             children: [
//                               TableRow(
//                                 decoration: BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(color: Colors.grey.shade300)),
//                                 ),
//                                 children: const [
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text('NAMA',
//                                         style: TextStyle(fontWeight: FontWeight.bold)),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text('JENIS',
//                                         style: TextStyle(fontWeight: FontWeight.bold)),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.symmetric(vertical: 12.0),
//                                     child: Text('AKSI',
//                                         style: TextStyle(fontWeight: FontWeight.bold)),
//                                   ),
//                                 ],
//                               ),
//                               ...monitoringList
//                                   .expand((monitoring) => monitoring.jenis
//                                       .map((jenis) => _buildTableRow(
//                                           context,
//                                           monitoring.nama,
//                                           jenis.kategori,
//                                           monitoring.userId)))
//                                   ,
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//       ),
//       bottomNavigationBar: const Navbar(selectedIndex: 1),
//     );
//   }

//   TableRow _buildTableRow(
//       BuildContext context, String nama, String jenis, String userId) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Text(nama),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Text(jenis),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: ElevatedButton(
//             onPressed: () => _navigateToDetail(nama, jenis, userId),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.grey[300],
//               foregroundColor: Colors.black,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               minimumSize: const Size(50, 25),
//             ),
//             child: const Text('Detail', style: TextStyle(fontSize: 12)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/monitorng_model.dart';
// import 'package:pbl_sem5/pages/pimpinan/monitoring/detail_monitoring_pimpinan_page.dart';
// import 'package:pbl_sem5/services/pimpinan/api_monitoring.dart';
// import 'package:pbl_sem5/widgets/pimpinan/monitoring/header_monitoring_pimpinan.dart';
// import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';

// class MonitoringPimpinan extends StatefulWidget {
//   const MonitoringPimpinan({super.key});

//   @override
//   State<MonitoringPimpinan> createState() => _MonitoringPimpinanState();
// }

// class _MonitoringPimpinanState extends State<MonitoringPimpinan> {
//   final ApiMonitoring _apiMonitoring = ApiMonitoring();
//   List<MonitoringModel> monitoringList = [];
//   bool isLoading = true;
//   String? error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchMonitoringData();
//   }

//   Future<void> _fetchMonitoringData() async {
//     try {
//       setState(() {
//         isLoading = true;
//         error = null;
//       });

//       final response = await _apiMonitoring.getMonitoring();
      
//       setState(() {
//         monitoringList = response.data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         isLoading = false;
//       });
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(error ?? 'Terjadi kesalahan')),
//       );
//     }
//   }

//   void _showNoDataDialog(String nama, String jenis) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Informasi',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           content: Text('$nama belum memiliki $jenis'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _navigateToDetail(String nama, String jenis, String userId) async {
//     try {
//       await _apiMonitoring.getDetailMonitoring(userId, jenis);
      
//       if (!mounted) return;
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DetailMonitoringPimpinan(
//             nama: nama,
//             jenis: jenis,
//             userId: userId,
//           ),
//         ),
//       );
//       _fetchMonitoringData();
//     } catch (e) {
//       if (!mounted) return;
//       _showNoDataDialog(nama, jenis);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: HeaderMonitoringPimpinan(),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _fetchMonitoringData,
//         child: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : error != null
//             ? Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(error!),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _fetchMonitoringData,
//                       child: const Text('Coba Lagi'),
//                     ),
//                   ],
//                 ),
//               )
//             : monitoringList.isEmpty
//                 ? const Center(child: Text('Tidak ada data monitoring'))
//                 : ListView.builder(
//                     itemCount: monitoringList.length,
//                     itemBuilder: (context, index) {
//                       final monitoring = monitoringList[index];
//                       return ExpansionTile(
//                         title: Text(monitoring.nama),
//                         children: monitoring.jenis
//                           .map((jenis) => ListTile(
//                               title: Text(jenis.kategori),
//                               trailing: ElevatedButton(
//                                 onPressed: () => _navigateToDetail(
//                                     monitoring.nama, jenis.kategori, monitoring.userId),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.grey[300],
//                                   foregroundColor: Colors.black,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 16, vertical: 8),
//                                   minimumSize: const Size(50, 25),
//                                 ),
//                                 child: const Text('Detail',
//                                     style: TextStyle(fontSize: 12)),
//                               ),
//                             ))
//                           .toList(),
//                       );
//                     },
//                   ),
//       ),
//       bottomNavigationBar: const Navbar(selectedIndex: 1),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/pimpinan/pimpinan_monitoring/monitorng_model.dart';
import 'package:pbl_sem5/pages/pimpinan/monitoring/detail_monitoring_pimpinan_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_monitoring.dart';
import 'package:pbl_sem5/widgets/pimpinan/monitoring/header_monitoring_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';

class MonitoringPimpinan extends StatefulWidget {
  const MonitoringPimpinan({super.key});

  @override
  State<MonitoringPimpinan> createState() => _MonitoringPimpinanState();
}

class _MonitoringPimpinanState extends State<MonitoringPimpinan> {
  final ApiMonitoring _apiMonitoring = ApiMonitoring();
  List<MonitoringModel> monitoringList = [];
  List<MonitoringModel> filteredMonitoringList = [];
  bool isLoading = true;
  String? error;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMonitoringData();
  }

  Future<void> _fetchMonitoringData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await _apiMonitoring.getMonitoring();
      
      setState(() {
        monitoringList = response.data;
        filteredMonitoringList = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Terjadi kesalahan')),
      );
    }
  }

  void _showNoDataDialog(String nama, String jenis) {
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
          content: Text('$nama belum memiliki $jenis'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToDetail(String nama, String jenis, String userId) async {
    try {
      await _apiMonitoring.getDetailMonitoring(userId, jenis);
      
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailMonitoringPimpinan(
            nama: nama,
            jenis: jenis,
            userId: userId,
          ),
        ),
      );
      _fetchMonitoringData();
    } catch (e) {
      if (!mounted) return;
      _showNoDataDialog(nama, jenis);
    }
  }

  void _filterMonitoringList(String searchText) {
    setState(() {
      filteredMonitoringList = monitoringList.where((monitoring) =>
          monitoring.nama.toLowerCase().contains(searchText.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderMonitoringPimpinan(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama dosen',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _filterMonitoringList(searchController.text);
                  },
                ),
              ),
              onChanged: _filterMonitoringList,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchMonitoringData,
                child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(error!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchMonitoringData,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : filteredMonitoringList.isEmpty
                        ? const Center(child: Text('Tidak ada data monitoring'))
                        : ListView.builder(
                            itemCount: filteredMonitoringList.length,
                            itemBuilder: (context, index) {
                              final monitoring = filteredMonitoringList[index];
                              return ExpansionTile(
                                title: Text(monitoring.nama),
                                children: monitoring.jenis
                                  .map((jenis) => ListTile(
                                      title: Text(jenis.kategori),
                                      trailing: ElevatedButton(
                                        onPressed: () => _navigateToDetail(
                                            monitoring.nama, jenis.kategori, monitoring.userId),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[300],
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          minimumSize: const Size(50, 25),
                                        ),
                                        child: const Text('Detail',
                                            style: TextStyle(fontSize: 12)),
                                      ),
                                    ))
                                  .toList(),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1),
    );
  }
}