import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_admin.dart';
import 'BarangHilang_admin.dart';
import 'LaporanRiwayat_admin.dart';
import 'ChatPage_admin.dart';
import 'notifikasi_admin.dart';
import 'login_page.dart';

// ==========================================
// 1. FUNGSI MAIN (Titik masuk aplikasi)
// Ini wajib ada agar Flutter tahu dari mana harus memulai.
// ==========================================
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const ProfilAdminPage(), // Langsung menampilkan halaman Profil
    );
  }
}

// ==========================================
// 2. HALAMAN PROFIL ADMIN
// ==========================================
class ProfilAdminPage extends StatefulWidget {
  const ProfilAdminPage({super.key});

  @override
  State<ProfilAdminPage> createState() => _ProfilAdminPageState();
}

class _ProfilAdminPageState extends State<ProfilAdminPage> {
  int _selectedIndex = 4; // 4 adalah PROFIL (agar tab bawah menyala di Profil)

  // Definisi Warna Konsisten Sesuai Dashboard Sebelumnya
  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _mediumNavy = Color(0xFF2C4F7C);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  final List<String> _navLabels = [
    'DASHBOARD',
    'BARANG',
    'LAPORAN',
    'PESAN',
    'PROFIL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildProfileSection(),
                  const SizedBox(height: 24),
                  _buildDataDiriSection(),
                  const SizedBox(height: 20),
                  _buildMenuSection(),
                  const SizedBox(height: 100), // Ruang agar tidak tertutup bottom nav
                ],
              ),
            ),
          ),

          // Tombol Notifikasi Mengambang (Sama seperti Dashboard)
          Positioned(
            right: 20,
            bottom: 110,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotifikasiPage())),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _navy.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Center(
                      child: Icon(Icons.notifications_none, color: _navy, size: 22),
                    ),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE74C3C),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomSection(),
          ),
        ],
      ),
    );
  }

  // ==================== PROFILE SECTION ====================
  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _selectedBg,
                shape: BoxShape.circle,
                border: Border.all(color: _navy.withOpacity(0.6), width: 3),
              ),
              child: ClipOval(
                // Menggunakan Image.network agar tidak error jika assets belum ada
                child: Image.network(
                  'https://randomuser.me/api/portraits/men/32.jpg', 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 50, color: _navy);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _navy,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Admin',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: _darkNavy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '081402068787',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _mediumNavy,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => debugPrint('Ubah Foto Profil diklik'),
          child: Text(
            'Ubah Foto Profil',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _navy,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== DATA DIRI SECTION ====================
  Widget _buildDataDiriSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DATA DIRI ADMIN',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _navy,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 3,
            width: 50,
            decoration: BoxDecoration(
              color: _navy,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          _buildDataItem('Nama', 'Rizal'),
          const SizedBox(height: 12),
          _buildDataItem('Email', 'rizal@lostditemukan.id'),
          const SizedBox(height: 12),
          _buildDataItem('Status', 'Aktif'),
        ],
      ),
    );
  }

  Widget _buildDataItem(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _darkNavy,
            ),
          ),
        ),
        const Text(
          ': ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _darkNavy,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: _mediumNavy,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== MENU SECTION ====================
  Widget _buildMenuSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Ganti Password',
            onTap: () => debugPrint('Ganti Password diklik'),
          ),
          Container(height: 1, color: Colors.grey.shade200),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: _showLogoutDialog,
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isLogout ? const Color(0xFFE74C3C).withOpacity(0.1) : _bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isLogout ? const Color(0xFFE74C3C) : _navy,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isLogout ? const Color(0xFFE74C3C) : _darkNavy,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isLogout ? const Color(0xFFE74C3C) : _navy,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== BOTTOM SECTION ====================
  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: _navy.withOpacity(0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_navLabels.length, (index) {
                  return _buildNavItem(index);
                }),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => debugPrint('Tombol Tambah ditekan'),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _navy,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _navy.withOpacity(0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = const DashboardAdminPage();
        break;
      case 1:
        targetPage = const BarangHilangAdminPage();
        break;
      case 2:
        targetPage = const LaporanPage();
        break;
      case 3:
        targetPage = const RiwayatPesanAdminPage();
        break;
      case 4:
        return;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  // ==================== NAV ITEM ====================
  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final IconData icon = _getNavIcon(index, isSelected);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg.withOpacity(0.5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: _navy),
            const SizedBox(height: 2),
            Text(
              _navLabels[index],
              style: GoogleFonts.spaceMono(
                fontSize: 7.5,
                fontWeight: FontWeight.w700,
                color: _navy,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNavIcon(int index, bool isSelected) {
    switch (index) {
      case 0: return isSelected ? Icons.dashboard : Icons.dashboard_outlined;
      case 1: return Icons.copy_outlined;
      case 2: return Icons.description_outlined;
      case 3: return Icons.chat_bubble_outline;
      case 4: return isSelected ? Icons.person : Icons.person_outline;
      default: return Icons.dashboard_outlined;
    }
  }

  // ==================== LOGOUT DIALOG ====================
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text(
            'Konfirmasi Logout',
            style: TextStyle(fontWeight: FontWeight.w700, color: _darkNavy),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(color: _mediumNavy),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(color: _mediumNavy, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                debugPrint('User berhasil logout');
                // Tambahkan logika logout (misal: hapus token, kembali ke login)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}