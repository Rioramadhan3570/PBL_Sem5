import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true; // Status untuk menyembunyikan password
  final TextEditingController _usernameController =
      TextEditingController(); // Kontroler untuk username
  final TextEditingController _passwordController =
      TextEditingController(); // Kontroler untuk password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/Login.png'), // Sesuaikan dengan lokasi gambar Anda
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Konten di atas gambar dengan posisi yang bisa diubah
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Label untuk Masukkan Akun Anda
                  const Text(
                    'Masukkan Akun Anda',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Username
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2), // Border putih
                    ),
                    child: TextField(
                      controller:
                          _usernameController, // Menghubungkan kontroler
                      style: const TextStyle(
                          color: Colors
                              .white), // Mengubah warna teks input menjadi putih
                      decoration: InputDecoration(
                        hintText: 'Username', // Contoh nama pengguna
                        hintStyle: const TextStyle(
                            color: Colors.white54), // Warna teks placeholder
                        prefixIcon: const Icon(
                          Icons.person,
                          color:
                              Colors.white, // Mengubah warna ikon menjadi putih
                        ),
                        border: InputBorder.none, // Menghapus border default
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10), // Padding dalam
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Input Password
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          width: 2), // Border putih
                    ),
                    child: TextField(
                      controller:
                          _passwordController, // Menghubungkan kontroler
                      style: const TextStyle(
                          color: Colors
                              .white), // Mengubah warna teks input menjadi putih
                      obscureText:
                          _obscureText, // Menyembunyikan password jika _obscureText true
                      decoration: InputDecoration(
                        hintText: 'Password', // Placeholder untuk password
                        hintStyle: const TextStyle(
                            color: Colors.white54), // Warna teks placeholder
                        prefixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText =
                                  !_obscureText; // Toggle status obscureText
                            });
                          },
                        ),
                        border: InputBorder.none, // Menghapus border default
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10), // Padding dalam
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Login
                  SizedBox(
                    width: 350, // Lebar tombol
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        String username = _usernameController
                            .text; // Ambil username dari kontroler
                        String password = _passwordController
                            .text; // Ambil password dari kontroler

                        // Logika untuk pengalihan berdasarkan username
                        // Map untuk memetakan username ke rute
                        final userRoutes = {
                          'axel': '/utama_dosen',
                          'dimas': '/utama_pimpinan',
                          'rizky': '/utama_tendik',
                        };

                        // Memeriksa apakah username ada di dalam Map
                        if (userRoutes.containsKey(username)) {
                          Navigator.pushNamed(
                              context,
                              userRoutes[
                                  username]!); // Menavigasi ke halaman yang sesuai
                        } else {
                          // Tampilkan pesan error jika username tidak cocok
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Username tidak terdaftar')),
                          );
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Jarak di bawah tombol

                  // Tautan untuk pendaftaran
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrasi');
                    },
                    child: const Text(
                      'Belum Memiliki Akun? Register',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
