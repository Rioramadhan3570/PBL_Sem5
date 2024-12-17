import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbl_sem5/pages/dosen/profil/edit_profil_dosenpass.dart';
import 'package:pbl_sem5/services/dosen/api_profil_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/edit_profil/header_edit_profil_dosen.dart';
import 'package:pbl_sem5/widgets/dosen/navbar.dart';

class EditProfilDosen extends StatefulWidget {
  const EditProfilDosen({super.key});

  @override
  State<EditProfilDosen> createState() => _EditProfilDosenState();
}

class _EditProfilDosenState extends State<EditProfilDosen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final ApiService _apiService = ApiService();
  File? _selectedImage;
  bool _isLoading = true;
  bool _isLoadingLists = false;
  final bool _isSaving = false;
  String? _errorMessage;
  String? _currentAvatarUrl;

  List<String> _selectedKeahlian = [];
  List<String> _selectedMataKuliah = [];
  List<Map<String, dynamic>> _availableKeahlian = [];
  List<Map<String, dynamic>> _availableMataKuliah = [];
  List<String> _selectedKeahlianIds = [];
  List<String> _selectedMatkulIds = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      setState(() {
        _isLoading = true;
        _isLoadingLists = true;
        _errorMessage = null;
      });

      // Load profile data and available lists concurrently
      await Future.wait([
        _loadProfile(),
        _loadAvailableLists(),
      ]);

      setState(() {
        _isLoading = false;
        _isLoadingLists = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isLoadingLists = false;
      });
      _showErrorDialog(_errorMessage!);
    }
  }

  Future<void> _loadProfile() async {
    try {
      setState(() => _isLoading = true);
      final profile = await _apiService.getProfile();

      if (profile.data != null) {
        final dosen = profile.data!.dosen;
        setState(() {
          _nameController.text = profile.data!.user.nama;
          _usernameController.text = profile.data!.user.username;
          _idController.text = dosen.nip;
          _phoneController.text = dosen.telepon;
          _prodiController.text = dosen.prodi;
          _selectedKeahlian = profile.data!.dosen.keahlian;
          _selectedMataKuliah = profile.data!.dosen.mataKuliah;
          _selectedKeahlianIds = profile.data!.dosen.keahlianIds;
          _selectedMatkulIds = profile.data!.dosen.mataKuliahIds;
          _currentAvatarUrl = dosen.avatar;
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

  Future<void> _loadAvailableLists() async {
    try {
      final keahlian = await _apiService.getAvailableKeahlian();
      final mataKuliah = await _apiService.getAvailableMataKuliah();

      setState(() {
        _availableKeahlian = keahlian;
        _availableMataKuliah = mataKuliah;
      });
    } catch (e) {
      throw Exception('Error loading available lists: ${e.toString()}');
    }
  }

  Future<void> _showAddKeahlianDialog() async {
    try {
      setState(() => _isLoadingLists = true);
      final availableKeahlian = await _apiService.getAvailableKeahlian();
      setState(() => _isLoadingLists = false);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pilih Keahlian'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StatefulBuilder(
              builder: (context, setState) => ListView.builder(
                shrinkWrap: true,
                itemCount: availableKeahlian.length,
                itemBuilder: (context, index) {
                  final keahlian = availableKeahlian[index];
                  final isSelected =
                      _selectedKeahlianIds.contains(keahlian['id'].toString());

                  return CheckboxListTile(
                    title: Text(keahlian['nama']),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedKeahlianIds.add(keahlian['id'].toString());
                          _selectedKeahlian.add(keahlian['nama']);
                        } else {
                          _selectedKeahlianIds
                              .remove(keahlian['id'].toString());
                          _selectedKeahlian.remove(keahlian['nama']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh main view
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoadingLists = false);
      _showErrorMessage('Gagal memuat daftar keahlian: $e');
    }
  }

  Future<void> _showAddMataKuliahDialog() async {
    try {
      setState(() => _isLoadingLists = true);
      final availableMatkul = await _apiService.getAvailableMataKuliah();
      setState(() => _isLoadingLists = false);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pilih Mata Kuliah'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: StatefulBuilder(
              builder: (context, setState) => ListView.builder(
                shrinkWrap: true,
                itemCount: availableMatkul.length,
                itemBuilder: (context, index) {
                  final matkul = availableMatkul[index];
                  final isSelected =
                      _selectedMatkulIds.contains(matkul['id'].toString());

                  return CheckboxListTile(
                    title: Text(matkul['nama']),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedMatkulIds.add(matkul['id'].toString());
                          _selectedMataKuliah.add(matkul['nama']);
                        } else {
                          _selectedMatkulIds.remove(matkul['id'].toString());
                          _selectedMataKuliah.remove(matkul['nama']);
                        }
                      });
                    },
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {}); // Refresh main view
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() => _isLoadingLists = false);
      _showErrorMessage('Gagal memuat daftar mata kuliah: $e');
    }
  }

  Widget _buildKeahlianSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('Keahlian'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _isLoadingLists ? null : _showAddKeahlianDialog,
              ),
            ),
            if (_selectedKeahlian.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _selectedKeahlian
                      .map((keahlian) => Chip(
                            label: Text(keahlian),
                            onDeleted: () {
                              setState(() {
                                final index =
                                    _selectedKeahlian.indexOf(keahlian);
                                _selectedKeahlian.removeAt(index);
                                _selectedKeahlianIds.removeAt(index);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMataKuliahSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Mata Kuliah'),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _isLoadingLists ? null : _showAddMataKuliahDialog,
              ),
            ),
            if (_selectedMataKuliah.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _selectedMataKuliah
                      .map((matkul) => Chip(
                            label: Text(matkul),
                            onDeleted: () {
                              setState(() {
                                final index =
                                    _selectedMataKuliah.indexOf(matkul);
                                _selectedMataKuliah.removeAt(index);
                                _selectedMatkulIds.removeAt(index);
                              });
                            },
                          ))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
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
    if (_prodiController.text.isEmpty) {
      _showErrorMessage('Program Studi tidak boleh kosong');
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
        builder: (context) => ProfilePreviewScreenDosen(
          username: _usernameController.text,
          profileData: {
              'nama': _nameController.text,
              'nip': _idController.text,
              'prodi': _prodiController.text,
              'telepon': _phoneController.text,
              'keahlian': _selectedKeahlian,
              'mataKuliah': _selectedMataKuliah,
              'keahlianIds': _selectedKeahlianIds,
              'matkulIds': _selectedMatkulIds,
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
        child: HeaderEditProfilDosen(
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
      bottomNavigationBar: const Navbar(selectedIndex: 4),
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
            title: Text('Dosen'),
          ),
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
          icon: Icons.school,
          controller: _prodiController,
          label: 'Program Studi',
        ),
        _buildInputField(
          icon: Icons.phone,
          controller: _phoneController,
          label: 'Nomor Telepon',
          keyboardType: TextInputType.phone,
        ),
        _buildKeahlianSection(),
        _buildMataKuliahSection(),
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
    _prodiController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
