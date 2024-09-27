import 'package:flutter/material.dart';
import 'dosen/profil.dart'; // Sesuaikan dengan nama project

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile UI',
      home: ProfileScreen(), // Memanggil ProfileScreen dari profile.dart
    );
  }
}
