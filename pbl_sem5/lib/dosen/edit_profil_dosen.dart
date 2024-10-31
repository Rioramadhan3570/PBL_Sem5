import 'package:flutter/material.dart';
import 'navbar.dart';
import 'header_edit_profil.dart';
import 'profile_preview_screen.dart';

class EditProfilDosen extends StatefulWidget {
  const EditProfilDosen({Key? key}) : super(key: key);

  @override
  State<EditProfilDosen> createState() => _EditProfilDosenState();
}

class _EditProfilDosenState extends State<EditProfilDosen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedRole = 'Dosen';

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 40),
        child: HeaderEditProfil(),
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.person, size: 40),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Edit Profil Anda dan Tambahkan\nFoto Profil (Opsional)',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    icon: Icons.work,
                    value: _selectedRole,
                    onTap: () {
                      // Show role selection dialog
                    },
                  ),
                  _buildInputField(
                    icon: Icons.person,
                    controller: _nameController,
                    hintText: 'Axel Bagaskoro',
                  ),
                  _buildInputField(
                    icon: Icons.badge,
                    controller: _idController,
                    hintText: '2241650098',
                  ),
                  _buildInputField(
                    icon: Icons.school,
                    value: 'Data Mining',
                    onTap: () {
                      // Show department selection dialog
                    },
                  ),
                  _buildInputField(
                    icon: Icons.book,
                    value: 'Data Mining',
                    onTap: () {
                      // Show course selection dialog
                    },
                  ),
                  _buildInputField(
                    icon: Icons.phone,
                    controller: _phoneController,
                    hintText: '082112344321',
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Lanjut button
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePreviewScreen(
                            name: _nameController.text,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      minimumSize: const Size(120, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Lanjut',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 4),
    );
  }

  Widget _buildInputField({
    required IconData icon,
    TextEditingController? controller,
    String? hintText,
    String? value,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: ListTile(
          leading: Icon(icon),
          title: controller != null
              ? TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                  ),
                )
              : Text(value ?? ''),
          onTap: onTap,
        ),
      ),
    );
  }
}