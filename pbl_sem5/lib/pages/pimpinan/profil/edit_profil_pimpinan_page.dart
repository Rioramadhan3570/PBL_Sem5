import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl_sem5/models/profil/pimpinan_model.dart';
import 'package:pbl_sem5/pages/pimpinan/profil/edit_profil_pimpinanpasss.dart';
import 'package:pbl_sem5/services/pimpinan/api_profil_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/edit_profil/header_edit_profil_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';

class EditProfilPimpinan extends StatefulWidget {
  const EditProfilPimpinan({super.key});

  @override
  State<EditProfilPimpinan> createState() => _EditProfilPimpinanState();
}

class _EditProfilPimpinanState extends State<EditProfilPimpinan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _posisiController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final ApiProfilPimpinan _apiService = ApiProfilPimpinan();
  File? _selectedImage;
  bool _isLoading = true;
  final bool _isSaving = false;
  String? _errorMessage;
  String? _currentAvatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _isLoading = true);
      final profile = await _apiService.getProfile();

      if (profile.data != null) {
        final pimpinan = profile.data!.role as PimpinanModel;
        setState(() {
          _nameController.text = profile.data!.user.nama;
          _usernameController.text = profile.data!.user.username;
          _idController.text = pimpinan.nip;
          _phoneController.text = pimpinan.telepon;
          _posisiController.text = pimpinan.posisi;
          _currentAvatarUrl = pimpinan.avatar;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Atur Posisi Foto',
              toolbarColor: const Color(0xFF1A237E),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: false,
            ),
          ],
        );

        if (croppedFile != null) {
          setState(() {
            _selectedImage = File(croppedFile.path);
            _currentAvatarUrl = null; 
          });
        }
      }
    } catch (e) {
      _showErrorMessage('Error picking image: $e');
    }
  }

  bool _validateFields() {
    if (_nameController.text.isEmpty) {
      _showErrorMessage('Nama tidak boleh kosong');
      return false;
    }
    if (_idController.text.isEmpty) {
      _showErrorMessage('NIP tidak boleh kosong');
      return false;
    }
    if (_posisiController.text.isEmpty) {
      _showErrorMessage('Posisi tidak boleh kosong');
      return false;
    }
    if (_phoneController.text.isEmpty) {
      _showErrorMessage('Nomor Telepon tidak boleh kosong');
      return false;
    }
    if (!RegExp(r'^\d{10,13}$').hasMatch(_phoneController.text)) {
      _showErrorMessage('Format nomor telepon tidak valid (10-13 digit)');
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadProfile();
            },
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToPreview() async {
    if (!_validateFields()) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePreviewScreenPimpinan(
          username: _usernameController.text,
          profileData: {
            'nama': _nameController.text,
            'nip': _idController.text,
            'posisi': _posisiController.text,
            'telepon': _phoneController.text,
            'avatar': _selectedImage,
            'current_avatar': _currentAvatarUrl,
          },
          onProfileUpdated: () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          },
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: HeaderEditProfilPimpinan(
          showBackButton: true,
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileImage(),
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Profil Anda dan Tambahkan\nFoto Profil (Opsional)',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildInputFields(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(
                color: Colors.grey[300]!,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    )
                  : _currentAvatarUrl != null && _currentAvatarUrl!.isNotEmpty
                      ? Image.network(
                          _currentAvatarUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                size: 50, color: Colors.grey);
                          },
                        )
                      : const Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const ListTile(
            leading: Icon(Icons.badge),
            title: Text('Pimpinan'),
          ),
        ),
        _buildInputField(
          icon: Icons.work,
          controller: _posisiController,
          label: 'Posisi',
        ),
        _buildInputField(
          icon: Icons.person,
          controller: _nameController,
          label: 'Nama Lengkap',
        ),
        _buildInputField(
          icon: Icons.assignment_ind,
          controller: _idController,
          label: 'NIP',
          keyboardType: TextInputType.number,
        ),
        _buildInputField(
          icon: Icons.phone,
          controller: _phoneController,
          label: 'Nomor Telepon',
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
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
              onPressed: _isLoading ? null : _navigateToPreview,
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
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Lanjut',
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

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _posisiController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
