// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:pbl_sem5/widgets/dosen/riwayat/header_riwayat_dosen.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
// import 'package:pbl_sem5/services/api_config.dart';
// import 'package:pbl_sem5/services/dosen/api_riwayat_dosen.dart';
// import 'package:pbl_sem5/widgets/dosen/navbar.dart';

// class DetailRiwayat extends StatefulWidget {
//   final RiwayatModel riwayat;

//   const DetailRiwayat({
//     super.key,
//     required this.riwayat,
//   });

//   @override
//   _DetailRiwayatState createState() => _DetailRiwayatState();
// }

// class _DetailRiwayatState extends State<DetailRiwayat> {
//   final ApiRiwayatDosen _apiRiwayatDosen = ApiRiwayatDosen();
//   File? _selectedFile;
//   DateTime? _selectedDate;
//   bool isLoading = false;
//   String? _selectedFileName;

//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf'],
//         withData: true, // Tambahkan ini untuk mendapatkan data bytes
//       );

//       if (result != null) {
//         // Cek apakah file berasal dari Google Drive (tidak memiliki path)
//         if (result.files.single.path == null &&
//             result.files.single.bytes != null) {
//           // Buat file temporary untuk menyimpan bytes
//           final tempDir = await Directory.systemTemp.createTemp();
//           final tempFile = File('${tempDir.path}/${result.files.single.name}');
//           await tempFile.writeAsBytes(result.files.single.bytes!);

//           setState(() {
//             _selectedFile = tempFile;
//             _selectedFileName = result.files.single.name;
//           });
//         } else if (result.files.single.path != null) {
//           // File dari penyimpanan lokal
//           setState(() {
//             _selectedFile = File(result.files.single.path!);
//             _selectedFileName = result.files.single.name;
//           });
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking file: $e')),
//       );
//     }
//   }

//   Widget _buildPdfPreview() {
//     if (_selectedFile != null) {
//       return FutureBuilder<bool>(
//         future: _selectedFile!.exists(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData && snapshot.data == true) {
//             return Container(
//               height: 300,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               child: SfPdfViewer.file(_selectedFile!),
//             );
//           }
//           return const Text('File tidak dapat diakses atau tidak valid');
//         },
//       );
//     }
//     return const SizedBox();
//   }

//   Widget _buildPdfViewer(String? bukti) {
//     if (bukti == null) {
//       return const Text('Tidak ada bukti yang tersedia');
//     }

//     print(
//         'Loading PDF from: $bukti'); // bukti sudah berupa URL lengkap dari backend
//     print('URL Bukti: $bukti');

//     return FutureBuilder<File>(
//       future: DefaultCacheManager().getSingleFile(bukti),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return SizedBox(
//             height: 500,
//             child: SfPdfViewer.file(
//               snapshot.data!,
//               canShowPaginationDialog: true,
//             ),
//           );
//         } else if (snapshot.hasError) {
//           print('Error loading PDF: ${snapshot.error}');
//           return SizedBox(
//             height: 500,
//             child: SfPdfViewer.network(
//               bukti,
//               headers: const {
//                 'Accept': 'application/pdf',
//                 'Access-Control-Allow-Origin': '*'
//               },
//               canShowPaginationDialog: true,
//               onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
//                 print('Failed to load PDF: ${details.error}');
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Gagal memuat PDF: ${details.error}')),
//                 );
//               },
//             ),
//           );
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() => _selectedDate = picked);
//     }
//   }

//   Future<void> _uploadBukti() async {
//     if (_selectedFile == null || _selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pilih file PDF dan tanggal kadaluwarsa')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     try {
//       // Pastikan file masih ada dan bisa diakses
//       if (!await _selectedFile!.exists()) {
//         throw Exception('File tidak ditemukan atau tidak bisa diakses');
//       }
//       final response = await _apiRiwayatDosen.uploadBukti(
//         id: widget.riwayat.id.toString(),
//         tipe: widget.riwayat.kategori.toLowerCase(),
//         jenis:
//             widget.riwayat.pendanaan == 'Internal' ? 'rekomendasi' : 'mandiri',
//         bukti: _selectedFile!,
//         tanggalKadaluwarsa: _selectedDate!,
//       );

//       Navigator.pop(context); // Tutup bottom sheet

//       setState(() {
//         widget.riwayat.statusBukti = 'pending';
//         widget.riwayat.isBuktiUploaded = true;
//         // Jangan set widget.riwayat.bukti jika responsenya boolean
//         if (response.bukti is! bool) {
//           widget.riwayat.bukti = response.bukti;
//         }
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Berhasil upload bukti')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error uploading bukti: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> _reuploadBukti() async {
//     if (_selectedFile == null || _selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pilih file PDF dan tanggal kadaluwarsa')),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     try {
//       // Pastikan file masih ada dan bisa diakses
//       if (!await _selectedFile!.exists()) {
//         throw Exception('File tidak ditemukan atau tidak bisa diakses');
//       }

//       final response = await _apiRiwayatDosen.reuploadBukti(
//         id: widget.riwayat.id.toString(),
//         tipe: widget.riwayat.kategori.toLowerCase(),
//         jenis:
//             widget.riwayat.pendanaan == 'Internal' ? 'rekomendasi' : 'mandiri',
//         bukti: _selectedFile!,
//         tanggalKadaluwarsa: _selectedDate!,
//       );

//       Navigator.pop(context);

//       // Update local state
//       setState(() {
//         widget.riwayat.statusBukti = response.statusBukti ?? 'pending';
//         // Jangan set widget.riwayat.bukti jika responsenya boolean
//         if (response.bukti is! bool) {
//           widget.riwayat.bukti = response.bukti;
//         }
//         widget.riwayat.tanggalKadaluwarsa = response.tanggalKadaluwarsa;
//         widget.riwayat.komentar = response.komentar;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Berhasil reupload bukti')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error reuploading bukti: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   void _showUploadBottomSheet() {
//     if (widget.riwayat.statusBukti == 'approved') {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Bukti sudah disetujui dan tidak dapat diedit')),
//       );
//       return;
//     }

//     if (widget.riwayat.statusBukti != 'rejected' &&
//         widget.riwayat.bukti != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content:
//                 Text('Bukti hanya bisa diupload ulang jika status ditolak')),
//       );
//       return;
//     }

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => StatefulBuilder(
//         builder: (context, setModalState) => Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//             left: 16,
//             right: 16,
//             top: 16,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   'Upload Bukti',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton.icon(
//                   onPressed: () async {
//                     await _pickFile();
//                     setModalState(() {}); // Refresh state setelah file dipilih
//                   },
//                   icon: const Icon(Icons.upload_file),
//                   label: const Text('Pilih File PDF'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 24, vertical: 12),
//                   ),
//                 ),
//                 if (_selectedFileName != null) ...[
//                   const SizedBox(height: 10),
//                   Text('File terpilih: $_selectedFileName'),
//                   _buildPdfPreview(),
//                 ],
//                 if (widget.riwayat.statusBukti != 'rejected') ...[
//                   const SizedBox(height: 20),
//                   ListTile(
//                     title: Text(_selectedDate != null
//                         ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
//                         : 'Pilih Tanggal Kadaluwarsa'),
//                     trailing: const Icon(Icons.calendar_today),
//                     onTap: () async {
//                       await _selectDate(context);
//                       setModalState(
//                           () {}); // Refresh state setelah tanggal dipilih
//                     },
//                   ),
//                 ],
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: isLoading
//                       ? null
//                       : () {
//                           if (widget.riwayat.statusBukti == 'rejected') {
//                             _reuploadBukti();
//                           } else {
//                             _uploadBukti();
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     minimumSize: const Size(double.infinity, 45),
//                   ),
//                   child: isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : Text(
//                           widget.riwayat.statusBukti == 'rejected'
//                               ? 'Upload Ulang'
//                               : 'Simpan',
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   String formatDisplayDate(String? date) {
//     if (date == null) return '';
//     try {
//       final parsedDate = DateTime.parse(date);
//       return DateFormat('d MMMM yyyy').format(parsedDate);
//     } catch (e) {
//       debugPrint('Error formatting date: $e');
//       return date;
//     }
//   }

//   String formatCurrency(String amount) {
//     try {
//       final formatter = NumberFormat.currency(
//         locale: 'id_ID',
//         symbol: 'Rp',
//         decimalDigits: 0,
//       );
//       return formatter.format(double.parse(amount));
//     } catch (e) {
//       return 'Rp$amount';
//     }
//   }

//   Widget _buildStatusBadge() {
//     final bool isExpiredCert = widget.riwayat.isExpired();
//     if (widget.riwayat.statusBukti == 'approved' &&
//         widget.riwayat.tanggalKadaluwarsa != null) {
//       return Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: isExpiredCert ? Colors.red : Colors.green,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           isExpiredCert
//               ? 'Kadaluwarsa'
//               : 'Aktif sampai ${formatDisplayDate(widget.riwayat.tanggalKadaluwarsa)}',
//           style: const TextStyle(color: Colors.white),
//         ),
//       );
//     }
//     return const SizedBox();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: HeaderRiwayatDosen(
//           showBackButton: true,
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.orange[50],
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.only(right: 10),
//                         child: const Icon(
//                           Icons.info,
//                           color: Colors.blue,
//                           size: 30,
//                         ),
//                       ),
//                       Expanded(
//                         child: Text(
//                           widget.riwayat.judul,
//                           style: const TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     widget.riwayat.kategori,
//                     style: const TextStyle(fontSize: 16, color: Colors.black54),
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Pelaksanaan',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'Tempat: ${widget.riwayat.tempat}\n'
//                     'Tanggal: ${widget.riwayat.tanggalMulai}\n'
//                     'Waktu: ${widget.riwayat.waktu} WIB - selesai\n'
//                     'Pendanaan: ${widget.riwayat.pendanaan}\n'
//                     'Biaya: ${formatCurrency(widget.riwayat.biaya)}',
//                     style: const TextStyle(fontSize: 14),
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Bukti Upload',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       // Tampilkan icon edit hanya jika bukti sudah diupload dan status pending
//                       if (widget.riwayat.statusBukti == 'pending' &&
//                           widget.riwayat.isBuktiUploaded ==
//                               true) // Tambahkan kondisi ini
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: _showUploadBottomSheet,
//                           tooltip: 'Edit Bukti',
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   if (widget.riwayat.statusBukti == null ||
//                       widget.riwayat.statusBukti == 'pending')
//                     if (!widget.riwayat.isBuktiUploaded)
//                       ElevatedButton(
//                         onPressed: _showUploadBottomSheet,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.orange,
//                         ),
//                         child: const Text(
//                           'Upload Bukti',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       )
//                     else
//                       const Text(
//                         'Bukti telah diupload, menunggu validasi admin',
//                         style: TextStyle(color: Colors.amber),
//                       )
//                   else if (widget.riwayat.statusBukti == 'rejected')
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Bukti ditolak dengan alasan:',
//                           style: TextStyle(color: Colors.red),
//                         ),
//                         if (widget.riwayat.komentar != null)
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               color: Colors.red[50],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Text(widget.riwayat.komentar!),
//                           ),
//                         ElevatedButton(
//                           onPressed: _showUploadBottomSheet,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.orange,
//                           ),
//                           child: const Text(
//                             'Upload Ulang Bukti',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         ListTile(
//                           title: Text(_selectedDate != null
//                               ? DateFormat('dd MMMM yyyy')
//                                   .format(_selectedDate!)
//                               : 'Pilih Tanggal Kadaluwarsa'),
//                           trailing: const Icon(Icons.calendar_today),
//                           onTap: () async {
//                             await _selectDate(context);
//                           },
//                         ),
//                       ],
//                     )
//                   else if (widget.riwayat.statusBukti == 'approved' &&
//                       widget.riwayat.bukti != null)
//                     Container(
//                       padding: const EdgeInsets.all(16.0),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (widget.riwayat.bukti != null) ...[
//                             Builder(
//                               builder: (context) {
//                                 final pdfUrl = widget.riwayat
//                                     .bukti!; // Langsung gunakan URL dari response API
//                                 print('Loading PDF from: $pdfUrl');

//                                 return FutureBuilder<File>(
//                                   future: DefaultCacheManager()
//                                       .getSingleFile(pdfUrl),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.hasData) {
//                                       return SizedBox(
//                                         height: 500,
//                                         child: SfPdfViewer.file(
//                                           snapshot.data!,
//                                           canShowPaginationDialog: true,
//                                         ),
//                                       );
//                                     } else if (snapshot.hasError) {
//                                       print(
//                                           'Error loading PDF: ${snapshot.error}');

//                                       return SizedBox(
//                                         height: 500,
//                                         child: SfPdfViewer.network(
//                                           pdfUrl,
//                                           canShowPaginationDialog: true,
//                                           onDocumentLoadFailed: (details) {
//                                             print(
//                                                 'Failed to load PDF: ${details.error}');
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                   content: Text(
//                                                       'Gagal memuat PDF: ${details.error}')),
//                                             );
//                                           },
//                                         ),
//                                       );
//                                     }
//                                     return const Center(
//                                         child: CircularProgressIndicator());
//                                   },
//                                 );
//                               },
//                             ),
//                           ] else
//                             const Text('Tidak ada bukti yang tersedia'),
//                           const SizedBox(height: 10),
//                           _buildStatusBadge(),
//                         ],
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const Navbar(selectedIndex: 3),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:pbl_sem5/widgets/dosen/riwayat/header_riwayat_dosen.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pbl_sem5/models/dosen/riwayat/riwayat_model.dart';
import 'package:pbl_sem5/services/dosen/api_riwayat_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class DetailRiwayat extends StatefulWidget {
  final RiwayatModel riwayat;

  const DetailRiwayat({
    super.key,
    required this.riwayat,
  });

  @override
  _DetailRiwayatState createState() => _DetailRiwayatState();
}

class _DetailRiwayatState extends State<DetailRiwayat> {
  final ApiRiwayatDosen _apiRiwayatDosen = ApiRiwayatDosen();
  File? _selectedFile;
  DateTime? _selectedDate;
  bool isLoading = false;
  String? _selectedFileName;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null) {
        if (result.files.single.path == null &&
            result.files.single.bytes != null) {
          final tempDir = await Directory.systemTemp.createTemp();
          final tempFile = File('${tempDir.path}/${result.files.single.name}');
          await tempFile.writeAsBytes(result.files.single.bytes!);

          setState(() {
            _selectedFile = tempFile;
            _selectedFileName = result.files.single.name;
          });
        } else if (result.files.single.path != null) {
          setState(() {
            _selectedFile = File(result.files.single.path!);
            _selectedFileName = result.files.single.name;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  Widget _buildPdfPreview() {
    if (_selectedFile != null) {
      return FutureBuilder<bool>(
        future: _selectedFile!.exists(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            return Container(
              height: 300,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: SfPdfViewer.file(_selectedFile!),
            );
          }
          return const Text('File tidak dapat diakses atau tidak valid');
        },
      );
    }
    return const SizedBox();
  }

  Widget _buildPdfViewer(String? bukti) {
    if (bukti == null) {
      return const Text('Tidak ada bukti yang tersedia');
    }

    print('Loading PDF from: $bukti');
    print('URL Bukti: $bukti');

    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(bukti),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 500,
            child: SfPdfViewer.file(
              snapshot.data!,
              canShowPaginationDialog: true,
            ),
          );
        } else if (snapshot.hasError) {
          print('Error loading PDF: ${snapshot.error}');
          return SizedBox(
            height: 500,
            child: SfPdfViewer.network(
              bukti,
              headers: const {
                'Accept': 'application/pdf',
                'Access-Control-Allow-Origin': '*'
              },
              canShowPaginationDialog: true,
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                print('Failed to load PDF: ${details.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal memuat PDF: ${details.error}')),
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _uploadBukti() async {
    if (_selectedFile == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih file PDF dan tanggal kadaluwarsa')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      if (!await _selectedFile!.exists()) {
        throw Exception('File tidak ditemukan atau tidak bisa diakses');
      }
      final response = await _apiRiwayatDosen.uploadBukti(
        id: widget.riwayat.id.toString(),
        tipe: widget.riwayat.kategori.toLowerCase(),
        jenis:
            widget.riwayat.pendanaan == 'Internal' ? 'rekomendasi' : 'mandiri',
        bukti: _selectedFile!,
        tanggalKadaluwarsa: _selectedDate!,
      );

      Navigator.pop(context);

      setState(() {
        widget.riwayat.statusBukti = 'pending';
        widget.riwayat.isBuktiUploaded = true;
        if (response.bukti is! bool) {
          widget.riwayat.bukti = response.bukti;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil upload bukti')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading bukti: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _reuploadBukti() async {
    if (_selectedFile == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih file PDF dan tanggal kadaluwarsa')),
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      if (!await _selectedFile!.exists()) {
        throw Exception('File tidak ditemukan atau tidak bisa diakses');
      }

      final response = await _apiRiwayatDosen.reuploadBukti(
        id: widget.riwayat.id.toString(),
        tipe: widget.riwayat.kategori.toLowerCase(),
        jenis:
            widget.riwayat.pendanaan == 'Internal' ? 'rekomendasi' : 'mandiri',
        bukti: _selectedFile!,
        tanggalKadaluwarsa: _selectedDate!,
      );

      Navigator.pop(context);

      setState(() {
        widget.riwayat.statusBukti = response.statusBukti ?? 'pending';
        if (response.bukti is! bool) {
          widget.riwayat.bukti = response.bukti;
        }
        widget.riwayat.tanggalKadaluwarsa = response.tanggalKadaluwarsa;
        widget.riwayat.komentar = response.komentar;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil reupload bukti')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reuploading bukti: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showUploadBottomSheet() {
    if (widget.riwayat.statusBukti == 'approved') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bukti sudah disetujui dan tidak dapat diedit')),
      );
      return;
    }

    if (widget.riwayat.statusBukti != 'rejected' &&
        widget.riwayat.bukti != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Bukti hanya bisa diupload ulang jika status ditolak')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload Bukti',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _pickFile();
                    setModalState(() {});
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Pilih File PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
                if (_selectedFileName != null) ...[
                  const SizedBox(height: 10),
                  Text('File terpilih: $_selectedFileName'),
                  _buildPdfPreview(),
                ],
                const SizedBox(height: 20),
                ListTile(
                  title: Text(_selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                      : 'Pilih Tanggal Kadaluwarsa'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    await _selectDate(context);
                    setModalState(() {});
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (widget.riwayat.statusBukti == 'rejected') {
                            _reuploadBukti();
                          } else {
                            _uploadBukti();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.riwayat.statusBukti == 'rejected'
                              ? 'Upload Ulang'
                              : 'Simpan',
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String formatDisplayDate(String? date) {
    if (date == null) return '';
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('d MMMM yyyy').format(parsedDate);
    } catch (e) {
      debugPrint('Error formatting date: $e');
      return date;
    }
  }

  String formatCurrency(String amount) {
    try {
      final formatter = NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
        decimalDigits: 0,
      );
      return formatter.format(double.parse(amount));
    } catch (e) {
      return 'Rp$amount';
    }
  }

  Widget _buildStatusBadge() {
    final bool isExpiredCert = widget.riwayat.isExpired();
    if (widget.riwayat.statusBukti == 'approved' &&
        widget.riwayat.tanggalKadaluwarsa != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isExpiredCert ? Colors.red : Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          isExpiredCert
              ? 'Kadaluwarsa'
              : 'Aktif sampai ${formatDisplayDate(widget.riwayat.tanggalKadaluwarsa)}',
          style: const TextStyle(color: Colors.white),
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderRiwayatDosen(
          showBackButton: true,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.riwayat.judul,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.riwayat.kategori,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  const Text(
                    'Pelaksanaan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tempat: ${widget.riwayat.tempat}\n'
                    'Tanggal: ${widget.riwayat.tanggalMulai}\n'
                    'Waktu: ${widget.riwayat.waktu} WIB - selesai\n'
                    'Pendanaan: ${widget.riwayat.pendanaan}\n'
                    'Biaya: ${formatCurrency(widget.riwayat.biaya)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bukti Upload',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (widget.riwayat.statusBukti == 'pending' &&
                          widget.riwayat.isBuktiUploaded == true)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _showUploadBottomSheet,
                          tooltip: 'Edit Bukti',
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (widget.riwayat.statusBukti == null ||
                      widget.riwayat.statusBukti == 'pending')
                    if (!widget.riwayat.isBuktiUploaded)
                      ElevatedButton(
                        onPressed: _showUploadBottomSheet,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text(
                          'Upload Bukti',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    else
                      const Text(
                        'Bukti telah diupload, menunggu validasi admin',
                        style: TextStyle(color: Colors.amber),
                      )
                  else if (widget.riwayat.statusBukti == 'rejected')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bukti ditolak dengan alasan:',
                          style: TextStyle(color: Colors.red),
                        ),
                        if (widget.riwayat.komentar != null)
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(widget.riwayat.komentar!),
                          ),
                        ElevatedButton(
                          onPressed: _showUploadBottomSheet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text(
                            'Upload Ulang Bukti',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  else if (widget.riwayat.statusBukti == 'approved' &&
                      widget.riwayat.bukti != null)
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.riwayat.bukti != null) ...[
                            Builder(
                              builder: (context) {
                                final pdfUrl = widget.riwayat.bukti!;
                                print('Loading PDF from: $pdfUrl');
                                return FutureBuilder<File>(
                                  future: DefaultCacheManager()
                                      .getSingleFile(pdfUrl),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return SizedBox(
                                        height: 500,
                                        child: SfPdfViewer.file(
                                          snapshot.data!,
                                          canShowPaginationDialog: true,
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      print(
                                          'Error loading PDF: ${snapshot.error}');

                                      return SizedBox(
                                        height: 500,
                                        child: SfPdfViewer.network(
                                          pdfUrl,
                                          canShowPaginationDialog: true,
                                          onDocumentLoadFailed: (details) {
                                            print(
                                                'Failed to load PDF: ${details.error}');
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Gagal memuat PDF: ${details.error}')),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                );
                              },
                            ),
                          ] else
                            const Text('Tidak ada bukti yang tersedia'),
                          const SizedBox(height: 10),
                          _buildStatusBadge(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }
}
