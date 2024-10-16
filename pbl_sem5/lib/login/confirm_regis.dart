import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ConfirmRegis(),
    );
  }
}

class ConfirmRegis extends StatefulWidget {
  @override
  _ConfirmRegisState createState() => _ConfirmRegisState();
}

class _ConfirmRegisState extends State<ConfirmRegis> {
  // Variabel untuk mengontrol visibilitas password dan konfirmasi password
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Akun Baru Anda'),
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
            // Input untuk Username dengan gaya khusus
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Username', // Placeholder tidak bergerak
                hintStyle: TextStyle(color: Colors.grey), // Gaya placeholder
                filled: false, // Tidak ada latar belakang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Membuat border lebih bulat
                  borderSide: BorderSide(),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 20),
            // Input untuk Password dengan gaya khusus
            TextFormField(
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Password', // Placeholder tidak bergerak
                hintStyle: TextStyle(color: Colors.grey), // Gaya placeholder
                filled: false, // Tidak ada latar belakang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Membuat border lebih bulat
                  borderSide: BorderSide(),
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                   
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            // Input untuk Konfirmasi Password dengan gaya khusus
            TextFormField(
              obscureText: !_isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Konfirmasi Password', // Placeholder tidak bergerak
                hintStyle: TextStyle(color: Colors.grey), // Gaya placeholder
                filled: false, // Tidak ada latar belakang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0), // Membuat border lebih bulat
                  borderSide: BorderSide(),
                ),
                prefixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    
                  ),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            // Tombol untuk Submit atau Lanjut
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
