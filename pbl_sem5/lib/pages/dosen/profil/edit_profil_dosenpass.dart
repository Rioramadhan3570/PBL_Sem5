import 'package:flutter/material.dart';
import 'package:pbl_sem5/services/dosen/api_profil_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/edit_profil/header_edit_profil_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class ProfilePreviewScreenDosen extends StatefulWidget {
  final String username;
  final Map<String, dynamic> profileData;
  final VoidCallback? onProfileUpdated;

  const ProfilePreviewScreenDosen({
    super.key,
    required this.username,
    required this.profileData,
    this.onProfileUpdated,
  });

  @override
  State<ProfilePreviewScreenDosen> createState() =>
      _ProfilePreviewScreenDosenState();
}

class _ProfilePreviewScreenDosenState extends State<ProfilePreviewScreenDosen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final bool _isLoading = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username;
  }

  Future<void> _updateProfileAndCredentials() async {
    if (!_validateInputs()) return;
    try {
      setState(() => _isSaving = true);

      await _apiService.updateProfile(
        nama: widget.profileData['nama'],
        nip: widget.profileData['nip'],
        prodi: widget.profileData['prodi'],
        telepon: widget.profileData['telepon'],
        username: _usernameController.text,
        keahlianIds: List<String>.from(widget.profileData['keahlianIds'] ?? []),
        matkulIds: List<String>.from(widget.profileData['matkulIds'] ?? []),
        avatar: widget.profileData['avatar'],
      );

      if (_newPasswordController.text.isNotEmpty) {
        await _apiService.updateUserCredentials(
          username: _usernameController.text,
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
      } else if (_usernameController.text != widget.username) {
        await _apiService.updateUserCredentials(
          username: _usernameController.text,
        );
      }

      setState(() => _isSaving = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui profil: $e')),
      );
    }
  }

  bool _validateInputs() {
    if (_usernameController.text.isEmpty) {
      _showErrorMessage('Username tidak boleh kosong');
      return false;
    }

    if (_newPasswordController.text.isNotEmpty) {
      if (_currentPasswordController.text.isEmpty) {
        _showErrorMessage(
            'Password lama harus diisi jika ingin mengubah password');
        return false;
      }

      if (_newPasswordController.text.length < 6) {
        _showErrorMessage('Password baru harus minimal 6 karakter');
        return false;
      }

      if (_newPasswordController.text != _confirmPasswordController.text) {
        _showErrorMessage('Password baru dan konfirmasi tidak sama');
        return false;
      }
    }

    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: HeaderEditProfilDosen(
          showBackButton: true,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField(
                  icon: Icons.person,
                  controller: _usernameController,
                  label: 'Username',
                ),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                  icon: Icons.lock,
                  controller: _currentPasswordController,
                  label: 'Password Lama',
                  obscureText: _obscureCurrentPassword,
                  onToggleVisibility: () {
                    setState(() =>
                        _obscureCurrentPassword = !_obscureCurrentPassword);
                  },
                ),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                  icon: Icons.lock,
                  controller: _newPasswordController,
                  label: 'Password Baru',
                  obscureText: _obscureNewPassword,
                  onToggleVisibility: () {
                    setState(() => _obscureNewPassword = !_obscureNewPassword);
                  },
                ),
                const SizedBox(height: 16.0),
                _buildPasswordField(
                  icon: Icons.lock,
                  controller: _confirmPasswordController,
                  label: 'Konfirmasi Password Baru',
                  obscureText: _obscureConfirmPassword,
                  onToggleVisibility: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ],
            ),
          ),
          _buildBottomButton(),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 4),
    );
  }

  Widget _buildBottomButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _isSaving ? null : _updateProfileAndCredentials,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A237E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: label,
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onToggleVisibility,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
