import 'package:flutter/material.dart';
class Utamacontoh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman utama dosen
                Navigator.pushNamed(context, '/utama_dosen');
              },
              child: Text('Login sebagai Dosen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Arahkan ke halaman utama pimpinan
                Navigator.pushNamed(context, '/utama_pimpinan');
              },
              child: Text('Login sebagai Pimpinan'),
            ),
          ],
        ),
      ),
    );
  }
}