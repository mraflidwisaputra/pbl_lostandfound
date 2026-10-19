import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/app_bottom_bar.dart';
import 'ganti_password_page.dart';
import 'login_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  // data contoh -> ganti dengan data pengguna yang sedang login
  static const _nama = 'Stark';
  static const _nim = '3312501106';
  static const _email = 'Stark@polibatam.ac.id';
  static const _jurusan = 'Teknik Informatika';
  static const _prodi = 'D-3 Teknik Informatika';
  static const _status = 'Aktif';

  Uint8List? _foto;

  Future<void> _ubahFoto() async {
    final x = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    final b = await x.readAsBytes();
    if (!mounted) return;
    setState(() => _foto = b);
    // TODO: unggah foto profil ke server
  }

  Future<void> _logout() async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Anda perlu login lagi untuk memakai aplikasi.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Keluar')),
        ],
      ),
    );
    if (ya != true || !mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage: _foto != null
                                ? MemoryImage(_foto!) as ImageProvider
                                : const AssetImage('assets/images/profil.png'),
                            onBackgroundImageError: (_, __) {},
                            child: _foto == null
                                ? const Icon(Icons.person,
                                    size: 56, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(_nama,
                              style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: _ink)),
                          Text(_nim,
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: _ink)),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 26,
                            child: OutlinedButton(
                              onPressed: _ubahFoto,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _ink,
                                backgroundColor: Colors.white,
                                side: BorderSide(
                                    color: _navy.withOpacity(0.5)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text('Ubah Foto Profil',
                                  style: GoogleFonts.poppins(fontSize: 11)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: _navy.withOpacity(0.45),
                        boxShadow: [
                          BoxShadow(
                              color: _navy.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Data Diri Mahasiswa',
                        style: GoogleFonts.poppins(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _ink)),
                    const SizedBox(height: 14),
                    _baris('Email', _email),
                    _baris('Jurusan', _jurusan),
                    _baris('Prodi', _prodi),
                    _baris('Status', _status),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          _menu(
                              icon: Icons.lock_outline,
                              label: 'Ganti Password',
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const GantiPasswordPage()),
                                  )),
                          Divider(height: 1, color: Colors.grey.shade200),
                          _menu(
                              icon: Icons.logout,
                              label: 'Logout',
                              onTap: _logout),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomBar(currentIndex: 4),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 68,
            child: Text(label,
                style: GoogleFonts.poppins(fontSize: 12, color: _ink)),
          ),
          Text(': ', style: GoogleFonts.poppins(fontSize: 12, color: _ink)),
          Expanded(
            child: Text(nilai,
                style: GoogleFonts.poppins(fontSize: 12, color: _ink)),
          ),
        ],
      ),
    );
  }

  Widget _menu(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: _ink),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(fontSize: 12, color: _ink)),
            ),
            const Icon(Icons.chevron_right, size: 20, color: _ink),
          ],
        ),
      ),
    );
  }
}