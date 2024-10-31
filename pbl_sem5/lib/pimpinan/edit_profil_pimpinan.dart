import 'package:flutter/material.dart';
import 'navbar.dart';
import 'header_edit_profil.dart';
import 'profile_preview_screen.dart';

class EditProfilPimpinan extends StatefulWidget {
  const EditProfilPimpinan({Key? key}) : super(key: key);

  @override
  State<EditProfilPimpinan> createState() => _EditProfilPimpinanState();
}

class _EditProfilPimpinanState extends State<EditProfilPimpinan> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedRole = 'Pimpinan';

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
              padding: const EdgeInsets.only(bottom: 250), // Increased padding for navbar
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
                    hintText: 'Dimas Anggoro',
                  ),
                  _buildInputField(
                    icon: Icons.badge,
                    controller: _idController,
                    hintText: '2241650098',
                  ),
                  _buildInputField(
                    icon: Icons.phone,
                    controller: _phoneController,
                    hintText: '082112344321',
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: SizedBox(height: 20),
                  ),
                ],
              ),
            ),
          ),
          // Lanjut button positioned above navbar
          Positioned(
            left: 0,
            right: 0,
            bottom: 100, // Position above navbar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end, // Align to right
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
                      minimumSize: const Size(120, 45), // Set fixed width for button
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
          // Navbar at bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 8,
              child: Navbar(),
            ),
          ),
        ],
      ),
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