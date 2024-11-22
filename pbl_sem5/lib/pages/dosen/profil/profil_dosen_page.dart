// screens/profil_dosen.dart
import 'package:flutter/material.dart';
import 'package:pbl_sem5/dosen/edit_profil_dosen.dart';
import 'package:pbl_sem5/dosen/surat_tugas_dosen.dart';
import 'package:pbl_sem5/models/dosen/profil/profil_response.dart';
import 'package:pbl_sem5/pages/dosen/profil/postingan_disukai_dosen_page.dart';
import 'package:pbl_sem5/services/api_profil.dart';
import 'package:pbl_sem5/widgets/dosen/profil/header_profil.dart';
import 'package:pbl_sem5/widgets/navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilDosen extends StatefulWidget {
  final int selectedIndex;
  
  const ProfilDosen({super.key, this.selectedIndex = 4});

  @override
  State<ProfilDosen> createState() => _ProfilDosenState();
}

class _ProfilDosenState extends State<ProfilDosen> {
  late ApiService _apiService;
  ProfileResponse? _profileData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApiService();
  }

  Future<void> _initializeApiService() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _apiService = ApiService(token: token);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      
      final response = await _apiService.getProfile();
      
      if (!mounted) return;
      
      setState(() {
        _profileData = response;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      // Show error dialog
      _showErrorDialog(e.toString());
    }
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
              _loadProfile(); // Retry loading profile
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ProfileHeader(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildProfileContent(),
      bottomNavigationBar: Navbar(selectedIndex: widget.selectedIndex),
    );
  }

  Widget _buildProfileContent() {
    final data = _profileData?.data;
    if (data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No profile data available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadProfile,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    final avatarUrl = data.dosen.avatar != null 
        ? '${ApiService.baseUrl}/storage/avatars/${data.dosen.avatar}'
        : 'https://via.placeholder.com/150';

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (exception, stackTrace) {
                  debugPrint('Error loading avatar: $exception');
                },
                child: data.dosen.avatar == null
                    ? const Icon(Icons.person, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              data.user.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.dosen.nip} | ${data.user.level}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilDosen(),
                        ),
                      );
                      if (result == true) {
                        _loadProfile();
                      }
                    },
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  ProfileMenuItem(
                    icon: Icons.favorite,
                    title: 'Postingan yang Disukai',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PostinganDisukaiDosen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, color: Colors.grey),
                  ProfileMenuItem(
                    icon: Icons.message,
                    title: 'Surat Tugas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuratTugasDosen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.chevron_right, size: 24),
          ],
        ),
      ),
    );
  }
}