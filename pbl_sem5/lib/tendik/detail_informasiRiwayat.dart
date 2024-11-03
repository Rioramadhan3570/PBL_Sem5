import 'package:flutter/material.dart';
import 'header_riwayat.dart';
import 'navbar.dart';

class DetailInformasi extends StatefulWidget {
  final String title;
  final String subtitle;

  const DetailInformasi({
    Key? key,
    required this.title,
    required this.subtitle, }) : super(key: key);

  @override
  _DetailInformasiState createState() => _DetailInformasiState();
}

class _DetailInformasiState extends State<DetailInformasi> {
  bool isUploaded = false; // Status upload sertifikat

  // Fungsi untuk menampilkan bottom sheet upload sertifikat
  void showUploadBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Upload Sertif',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Center(
                  child: Icon(Icons.cloud_upload, size: 50, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              const Text('sertif.jpg'), // Placeholder untuk nama file
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tanggal Kadaluwarsa',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aksi penyimpanan dan update status
                  setState(() {
                    isUploaded = true; // Update status menjadi uploaded
                  });
                  Navigator.of(context).pop(); // Tutup bottom sheet
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const HeaderRiwayat(),
      ),
      body: SingleChildScrollView( // Tambahkan SingleChildScrollView di sini
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
                        child: Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
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
                    widget.subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Text(
                    'Pelaksanaan',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Tempat: Gedung AH, Politeknik Negeri Malang\n'
                    'Tanggal: 12 Januari 2025\n'
                    'Waktu: 08.00 WIB - selesai\n'
                    'Pendanaan: Internal\n'
                    'Biaya: Rp. 5.000.000',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bukti Upload Sertifikasi',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isUploaded) // Kondisi jika sertifikat sudah di-upload
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            color: const Color.fromARGB(255, 255, 255, 255), // Tempat preview dokumen
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                            child: const Text(
                              'Aktif Sampai 12-09-2026',
                              style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Tindakan untuk tombol "Selengkapnya"
                          },
                          child: const Text('Selengkapnya'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showUploadBottomSheet(context); // Panggil bottom sheet upload
                          },
                          child: const Text('Upload Sertif'),
                        ),
                      ],
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
