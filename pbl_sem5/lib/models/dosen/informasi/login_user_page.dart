// lib/pages/login/login_user_page.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/dosen/user_model.dart';
import 'package:pbl_sem5/pages/login/login_base_mixim.dart';
import 'package:pbl_sem5/services/api_service.dart';

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
  final ApiService _apiService = ApiService();
  String _selectedRole = 'dosen';

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final username = _usernameController.text;
    final password = _passwordController.text;

    String? validationMessage = validateLogin(username, password);
    if (validationMessage != null) {
      showErrorMessage(context, validationMessage);
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await _apiService.login(username, password, _selectedRole);

      if (result['success']) {
        UserModel user = result['data'];
        String userRole = user.level.kode.toLowerCase();

        if (_selectedRole == 'dosen' && userRole == 'dos') {
          Navigator.pushReplacementNamed(context, '/utama_dosen');
        } else if (_selectedRole == 'pimpinan' && userRole == 'pmp') {
          Navigator.pushReplacementNamed(context, '/utama_pimpinan');
        } else {
          showErrorMessage(context, "Anda tidak memiliki akses untuk login sebagai ${_selectedRole}");
        }
      } else {
        showErrorMessage(context, result['message']);
      }
    } catch (e) {
      showErrorMessage(context, "Terjadi kesalahan saat login");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 180), // Adjusted spacing based on the image
                    const Text(
                      'Masukkan Akun Anda',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Role Selector
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRole,
                          dropdownColor: Colors.black87,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'dosen',
                              child: Text('Dosen',
                                style: TextStyle(color: Colors.white)
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'pimpinan',
                              child: Text('Pimpinan',
                                style: TextStyle(color: Colors.white)
                              ),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() => _selectedRole = newValue);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Username Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(Icons.person_outline, color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () => setState(() => _obscureText = !_obscureText),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
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
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}