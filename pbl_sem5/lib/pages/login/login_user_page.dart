import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/login/user_model.dart';
import 'package:pbl_sem5/pages/login/error_dialog.dart';
import 'package:pbl_sem5/pages/login/login_base_mixim.dart';
import 'package:pbl_sem5/services/api_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LoginValidationMixin {
  bool _obscureText = true;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginService _apiService = LoginService();
  String? _selectedRole;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // List untuk mengumpulkan semua pesan error validasi awal
    List<String> errors = [];

    // Validasi username
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      errors.add("Username");
    }

    // Validasi password
    final password = _passwordController.text;
    if (password.isEmpty) {
      errors.add("Password");
    }

    // Validasi role
    if (_selectedRole == null) {
      errors.add("Role");
    }

    // Jika ada error validasi awal, tampilkan semuanya dalam satu popup
    if (errors.isNotEmpty) {
      String errorMessage = '';
      if (errors.length == 1) {
        errorMessage = '${errors[0]} harus diisi terlebih dahulu';
      } else if (errors.length == 2) {
        errorMessage = '${errors.join(" dan ")} harus diisi terlebih dahulu';
      } else {
        errorMessage =
            '${errors.take(errors.length - 1).join(", ")} dan ${errors.last} harus diisi terlebih dahulu';
      }
      ErrorDialog.show(context, errorMessage);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result =
          await _apiService.login(username, password, _selectedRole!);

      if (!mounted) return;

      if (result['success']) {
        UserModel user = result['data'];
        String userRole = user.level.kode.toLowerCase();

        if (_selectedRole == 'dosen' && userRole == 'dos') {
          Navigator.pushReplacementNamed(context, '/utama_dosen');
        } else if (_selectedRole == 'pimpinan' && userRole == 'pmp') {
          Navigator.pushReplacementNamed(context, '/utama_pimpinan');
        } else {
          ErrorDialog.show(
              context,
              _selectedRole == 'dosen'
                  ? 'Anda tidak memiliki akses sebagai Dosen'
                  : 'Anda tidak memiliki akses sebagai Pimpinan');
        }
      } else {
        // Handle specific error responses
        String errorMessage = '';
        if (result['message'].toString().contains('404')) {
          errorMessage = 'Username yang anda masukkan salah';
        } else if (result['message'].toString().contains('401')) {
          errorMessage = 'Username atau Password yang anda masukkan salah';
        } else if (result['message'].toString().contains('Server')) {
          errorMessage = 'Terjadi kesalahan pada server';
        } else {
          errorMessage = result['message'] ?? 'Gagal melakukan login';
        }
        ErrorDialog.show(context, errorMessage);
      }
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('SocketException')) {
        errorMessage = 'Koneksi internet bermasalah';
      } else if (e.toString().contains('404')) {
        errorMessage = 'Username yang anda masukkan salah';
      } else if (e.toString().contains('401')) {
        errorMessage = 'Password yang anda masukkan salah';
      } else {
        errorMessage = 'Terjadi kesalahan saat login';
      }
      ErrorDialog.show(context, errorMessage);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    const double borderRadius = 20.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/Login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16.0 : 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: screenSize.height * 0.35),
                      Text(
                        'Masukkan Akun Anda',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 20,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.04),

                      // Role Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    setState(() => _selectedRole = 'pimpinan');
                                  },
                            child: Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    color: _selectedRole == 'pimpinan'
                                        ? const Color(0xFFC13541)
                                        : Colors.transparent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pimpinan',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _isLoading
                                ? null
                                : () {
                                    setState(() => _selectedRole = 'dosen');
                                  },
                            child: Column(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    color: _selectedRole == 'dosen'
                                        ? const Color(
                                            0xFFC13541) // Menggunakan kode warna #c13541
                                        : Colors.transparent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Dosen',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      // Username Field
                      Container(
                        height: isSmallScreen ? 50 : 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: TextFormField(
                          controller: _usernameController,
                          enabled: !_isLoading,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Username',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            prefixIcon: const Icon(Icons.person_outline,
                                color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 10 : 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      // Password Field
                      Container(
                        height: isSmallScreen ? 50 : 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(borderRadius),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          enabled: !_isLoading,
                          obscureText: _obscureText,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: isSmallScreen ? 14 : 16,
                            ),
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.white,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () => setState(
                                      () => _obscureText = !_obscureText),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 10 : 12,
                              horizontal: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.05),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 50 : 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? SizedBox(
                                  height: isSmallScreen ? 20 : 24,
                                  width: isSmallScreen ? 20 : 24,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 14 : 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
