import 'package:flutter/material.dart';
import 'header_registrasi.dart'; // Import Header

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Registrasi(),
    );
  }
}

class Registrasi extends StatefulWidget {
  @override
  _RegistrasiState createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  // List of roles
  final List<String> roles = ['Dosen', 'Tendik', 'Pimpinan'];

  // List of positions for "Pimpinan" role
  final List<String> positions = [
    'Kepala Jurusan',
    'Sekertaris Jurusan',
    'Kepala Prodi',
    'Wakil Direktur 2',
  ];

  // Variables to hold selected role, selected position, and text fields
  String? selectedRole;
  String? selectedPosition;
  TextEditingController nameController = TextEditingController();
  TextEditingController nipController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Image.asset(
                'images/jti.png', // Sesuaikan dengan lokasi gambar Anda
                height: 100,
              ),
            ),
            SizedBox(height: 20),
            // Dropdown untuk memilih role
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.work_outline), // Ikon user berkemeja
                hintText: 'Pilih Role',
              ),
              value: selectedRole,
              items: roles.map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedRole = newValue;
                  selectedPosition = null; // Reset posisi saat role berubah
                });
              },
            ),
            SizedBox(height: 20),
            // Jika role adalah "Pimpinan", tampilkan dropdown untuk memilih posisi
            if (selectedRole == 'Pimpinan')
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  hintText: 'Pilih Posisi',
                ),
                value: selectedPosition,
                items: positions.map((String position) {
                  return DropdownMenuItem<String>(
                    value: position,
                    child: Text(position),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedPosition = newValue;
                  });
                },
              ),
            SizedBox(height: 20),
            // Input untuk nama
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            // Input untuk NIP
            TextFormField(
              controller: nipController,
              decoration: InputDecoration(
                hintText: 'Masukkan NIP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            SizedBox(height: 30),
            // Tombol Lanjut
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/confirmregis');
                print('Role: $selectedRole');
                if (selectedRole == 'Pimpinan') {
                  print('Posisi: $selectedPosition');
                }
                print('Nama: ${nameController.text}');
                print('NIP: ${nipController.text}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Lanjut'),
            ),
          ],
        ),
      ),
    );
  }
}
