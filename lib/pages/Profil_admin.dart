import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dashboard_admin.dart';
import 'BarangHilang_admin.dart';
import 'LaporanRiwayat_admin.dart';
import 'ChatPage_admin.dart';
import 'kelolapengguna_admin.dart';
import 'notifikasi_admin.dart';
import 'ganti_password_page.dart';
import 'login_page.dart';

// Titik masuk agar file ini bisa dijalankan langsung:
// flutter run -t lib/pages/Profil_admin.dart
void main() {
  runApp(const ProfilAdminApp());
}

class ProfilAdminApp extends StatelessWidget {
  const ProfilAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Profil Admin',
      home: ProfilAdminPage(),
    );
  }
}

class ProfilAdminPage extends StatefulWidget {
  const ProfilAdminPage({super.key});

  @override
  State<ProfilAdminPage> createState() => _ProfilAdminPageState();
}

class _ProfilAdminPageState extends State<ProfilAdminPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);
  static const _selectedBg = Color(0xFFC9D3F5);

  int _selectedIndex = 4; // 4 = PROFIL

  // GlobalKey untuk posisi tombol plus (popup aksi cepat)
  final GlobalKey _fabKey = GlobalKey();

  // data contoh -> ganti dengan data admin yang sedang login
  static const _nama = 'Admin Stark';
  static const _nip = '198501012010011001';
  static const _email = 'admin@polibatam.ac.id';
  static const _jabatan = 'Administrator Sistem';
  static const _unit = 'Jurusan Teknik Informatika';
  static const _status = 'Aktif';

  Uint8List? _foto;

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
      bottomNavigationBar: _buildBottomSection(),
      body: Stack(
        children: [
          SafeArea(
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
                              Text(_nip,
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
                        Text('Data Diri Admin',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: _ink)),
                        const SizedBox(height: 14),
                        _baris('Email', _email),
                        _baris('Jabatan', _jabatan),
                        _baris('Unit', _unit),
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
              ],
            ),
          ),

          // Tombol Notifikasi Mengambang (tepat di atas tombol plus)
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