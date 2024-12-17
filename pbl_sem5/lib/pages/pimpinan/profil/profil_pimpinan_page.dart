import 'package:flutter/material.dart';
import 'package:pbl_sem5/models/profil/profil_response.dart';
import 'package:pbl_sem5/pages/pimpinan/profil/edit_profil_pimpinan_page.dart';
import 'package:pbl_sem5/pages/pimpinan/suratTugas/surat_tugas_pimpinan.dart';
import 'package:pbl_sem5/pages/pimpinan/riwayat/riwayat_pimpinan_page.dart';
import 'package:pbl_sem5/services/pimpinan/api_profil_pimpinan.dart';
import 'package:pbl_sem5/widgets/pimpinan/navbar.dart';
import 'package:pbl_sem5/widgets/pimpinan/profil/header_profil_pimpinan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPimpinan extends StatefulWidget {
  final int selectedIndex;
  const ProfilPimpinan({super.key, this.selectedIndex = 4});

  @override
  State<ProfilPimpinan> createState() => _ProfilPimpinanState();
}

class _ProfilPimpinanState extends State<ProfilPimpinan> {
  late ApiProfilPimpinan _apiService;
  ProfileResponse? _profileData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApiService();
  }

  Future<void> _initializeApiService() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token not found. Please login again.');
      }

      _apiService = ApiProfilPimpinan(token: token);
      await _loadProfile();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
        _showErrorDialog(e.toString());
      }
    }
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

      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _loadProfile();
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
        child: HeaderProfilPimpinan(),
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
      bottomNavigationBar: const Navbar(selectedIndex: 3),
    );
  }

  Widget _buildProfileContent() {
    final data = _profileData?.data;
    if (data == null) {
      return const Center(child: Text('No profile data available'));
    }
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
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
                image: data.pimpinan.avatar != null
                    ? DecorationImage(
                        image: NetworkImage(data.pimpinan.avatar!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: data.pimpinan.avatar == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              data.user.nama,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${data.pimpinan.nip} | ${data.user.level.nama}',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
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
                          builder: (context) => const EditProfilPimpinan(),
                        ),
                      );
                      if (result == true) {
                        _loadProfile();
                      }
                    },
                  ),
                  const Divider(
                      height: 1),
                  ProfileMenuItem(
                    icon: Icons.history,
                    title: 'Riwayat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HalamanRiwayatPimpinan()),
                      );
                    },
                  ),
                  const Divider(height: 1), // Tambahkan pembatas
                  ProfileMenuItem(
                    icon: Icons.message, // atau Icons.assignment
                    title: 'Surat Tugas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SuratTugasPage(),
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
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
