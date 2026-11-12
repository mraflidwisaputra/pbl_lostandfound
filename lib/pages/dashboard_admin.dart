import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'LaporanRiwayat_admin.dart';
import 'BarangHilang_admin.dart';
import 'ChatPage_admin.dart';
import 'Profil_admin.dart';
import 'notifikasi_admin.dart';
import 'kelolapengguna_admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const DashboardAdminPage(),
    );
  }
}

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  int _selectedIndex = 0;

  // 1. TAMBAHKAN GLOBAL KEY UNTUK MENDAPATKAN POSISI TOMBOL PLUS
  final GlobalKey _fabKey = GlobalKey();

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

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Widget targetPage;
    switch (index) {
      case 0:
        return;
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
        targetPage = const ProfilAdminPage();
        break;
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

  // 2. FUNGSI POPUP DENGAN OVERLAY (MUNCUL DI ATAS TOMBOL)
  void _showQuickActionDialog() {
    // Dapatkan posisi dan ukuran tombol (+)
    final RenderBox renderBox =
        _fabKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    // Hitung posisi popup (di tengah horizontal tombol, dan di atasnya dengan jarak 16px)
    const double popupWidth = 260.0;
    const double popupHeight = 150.0; // Perkiraan tinggi popup

    final double leftPosition =
        position.dx + (size.width / 2) - (popupWidth / 2);
    final double topPosition =
        position.dy - popupHeight - 16; // 16px di atas tombol

    final OverlayState overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background transparan untuk mendeteksi tap di luar popup (untuk menutup)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => overlayEntry.remove(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(color: Colors.black.withOpacity(0.1)),
              ),
            ),
          ),
          // Popup itu sendiri
          Positioned(
            left: leftPosition.clamp(
              0.0,
              MediaQuery.of(context).size.width - popupWidth,
            ), // Mencegah keluar layar
            top: topPosition.clamp(0.0, MediaQuery.of(context).size.height),
            width: popupWidth,
            child: _buildQuickActionPopup(() => overlayEntry.remove()),
          ),
        ],
      ),
    );

    overlay.insert(overlayEntry);
  }

  // 3. UI POPUP
  Widget _buildQuickActionPopup(VoidCallback onClose) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aksi Cepat',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text(
                        'X',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tombol 1
            _buildQuickActionButton(
              icon: Icons.add_business_outlined,
              title: 'Tambah Barang Temuan',
              onTap: () {
                onClose();
                _showUploadBarangTemuanDialog();
              },
            ),
            const SizedBox(height: 10),

            // Tombol 2
            _buildQuickActionButton(
              icon: Icons.people_outline,
              title: 'Kelola Pengguna',
              onTap: () {
                onClose();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const KelolaPenggunaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ===== POPUP UPLOAD BARANG TEMUAN (KAMERA / GALERI) =====
  Future<void> _pickBarangImage(ImageSource source) async {
    try {
      final XFile? picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;
      debugPrint('Foto barang temuan dipilih: ${picked.path}');
      // TODO: lanjutkan ke form upload barang temuan dengan picked.path
    } catch (e) {
      debugPrint('Gagal memilih gambar: $e');
    }
  }

  void _showUploadBarangTemuanDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upload Barang Temuan',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'X',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Tombol Kamera & Galeri
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildUploadOptionButton(
                        icon: Icons.camera_alt_outlined,
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          _pickBarangImage(ImageSource.camera);
                        },
                      ),
                      const SizedBox(width: 16),
                      _buildUploadOptionButton(
                        icon: Icons.image_outlined,
                        onTap: () {
                          Navigator.of(dialogContext).pop();
                          _pickBarangImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Text(
                    'Pilih Salah Satu',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadOptionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: _navy, size: 26),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _selectedBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _navy, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      bottomNavigationBar: _buildBottomSection(),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ).copyWith(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 28),
                  _buildAktivitasSection(),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi Mengambang
          Positioned(
            right: 20,
            bottom: 12,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotifikasiPage()),
                );
              },
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
                      child: Icon(
                        Icons.notifications_none,
                        color: _navy,
                        size: 22,
                      ),
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
        ],
      ),
    );
  }

  // ... (Sisa kode _buildHeader, _buildStatsGrid, _buildStatCard, _buildAktivitasSection, _buildActivityItem tetap sama seperti sebelumnya) ...
  Widget _buildHeader() {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/logo.png',
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _selectedBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _navy.withOpacity(0.6)),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: _navy,
                  size: 28,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELAMAT DATANG',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F2A47),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: const [
                  Text(
                    'ADMIN!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C4F7C),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.waving_hand, color: Color(0xFF2C4F7C), size: 24),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(
          icon: Icons.description_outlined,
          number: '12',
          label: 'Laporan\nKehilangan',
        ),
        _buildStatCard(
          icon: Icons.copy_outlined,
          number: '12',
          label: 'Barang\nTemuan',
        ),
        _buildStatCard(
          icon: Icons.chat_bubble_outline,
          number: '6',
          label: 'Menunggu\nVerifikasi',
        ),
        _buildStatCard(
          icon: Icons.inventory_2_outlined,
          number: '4',
          label: 'Klaim\nDiproses',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
  }) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _navy.withOpacity(0.4)),
            ),
            child: Icon(icon, color: _navy, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  number,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _navy,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _mediumNavy,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAktivitasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AKTIVITAS TERBARU',
          style: GoogleFonts.poppins(
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
        _buildActivityItem(
          avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
          title: 'Laki Membuat Laporan Kehilangan',
          subtitle: '5 Menit Lalu',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          avatarUrl: 'https://randomuser.me/api/portraits/women/44.jpg',
          title: 'Kathryn Membuat Laporan Kehilangan',
          subtitle: '15 Menit Lalu',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          avatarUrl: 'https://randomuser.me/api/portraits/men/52.jpg',
          title: 'Klaim untuk "Dompet Hitam" Diajukan',
          subtitle: '5 Menit Lalu',
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required String avatarUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: _selectedBg,
          ),
          const SizedBox(width: 12),
          const Icon(Icons.chevron_right, color: _navy, size: 20),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _darkNavy,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(fontSize: 11, color: _mediumNavy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return SafeArea(
      top: false,
      child: Container(
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
                  children: List.generate(
                    _navLabels.length,
                    (index) => _buildNavItem(index),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 4. PASANG GLOBAL KEY DI TOMBOL PLUS
            GestureDetector(
              key: _fabKey, // <--- INI KUNCINYA
              onTap: _showQuickActionDialog,
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
      ),
    );
  }

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
              style: GoogleFonts.poppins(
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
      case 0:
        return isSelected ? Icons.dashboard : Icons.dashboard_outlined;
      case 1:
        return Icons.copy_outlined;
      case 2:
        return Icons.description_outlined;
      case 3:
        return Icons.chat_bubble_outline;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.dashboard_outlined;
    }
  }
}