import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'dashboard_admin.dart';
import 'LaporanRiwayat_admin.dart';
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
      title: 'Barang Hilang',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const BarangHilangAdminPage(),
    );
  }
}

class BarangHilangAdminPage extends StatefulWidget {
  const BarangHilangAdminPage({super.key});

  @override
  State<BarangHilangAdminPage> createState() => _BarangHilangAdminPageState();
}

class _BarangHilangAdminPageState extends State<BarangHilangAdminPage> {
  int _selectedIndex = 1;
  String _selectedTab = 'HILANG';

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

  final List<String> _tabs = ['HILANG', 'TEMUAN'];

  final List<Map<String, String>> _barangList = [
    {
      'nama': 'Jam Tangan',
      'waktu': '2 Jam Yang Lalu',
      'kategori': 'Aksesoris',
      'lokasi': 'Parkiran Gedung Utama',
      'image': 'assets/images/jam.png',
      'deskripsi': 'Jam tangan hitam dengan tali kulit, hilang setelah jam kuliah selesai.',
      'diposting': 'Sadie',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'nama': 'Dompet',
      'waktu': '5 Jam Yang Lalu',
      'kategori': 'Dompet & Dokumen',
      'lokasi': 'Kantin Gedung B',
      'image': 'assets/images/dompet.png',
      'deskripsi': 'Dompet hitam berisi KTP dan beberapa kartu, hilang sekitar jam makan siang.',
      'diposting': 'Sadie',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'nama': 'Kunci',
      'waktu': '1 Hari Yang Lalu',
      'kategori': 'Kunci',
      'lokasi': 'Ruang Kelas 301',
      'image': 'assets/images/kunci.png',
      'deskripsi': 'Kunci motor dengan gantungan remote, hilang setelah perkuliahan selesai.',
      'diposting': 'Sadie',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'nama': 'HP',
      'waktu': '2 Hari Yang Lalu',
      'kategori': 'Elektronik',
      'lokasi': 'Perpustakaan',
      'image': 'assets/images/iphone.png',
      'deskripsi': 'Ponsel dengan casing hitam, hilang saat berada di dalam ruangan.',
      'diposting': 'Sadie',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
  ];

  // 2. FUNGSI POPUP DENGAN OVERLAY (MUNCUL DI ATAS TOMBOL)
  void _showQuickActionDialog() {
    final RenderBox renderBox =
        _fabKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    const double popupWidth = 260.0;
    const double popupHeight = 150.0;

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
            ),
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
            _buildQuickActionButton(
              icon: Icons.add_business_outlined,
              title: 'Tambah Barang Temuan',
              onTap: () {
                onClose();
                _showUploadBarangTemuanDialog();
              },
            ),
            const SizedBox(height: 10),
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
                  _buildTabs(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  ..._barangList.map(
                    (barang) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GestureDetector(
                        onTap: () => _showDetailBarangDialog(barang),
                        child: _buildReportCard(barang),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 12,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotifikasiPage()),
              ),
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
                child: const Icon(Icons.search, color: _navy, size: 32),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
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
        children: List.generate(_tabs.length, (index) {
          final isSelected = _selectedTab == _tabs[index];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = _tabs[index];
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? _navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Center(
                  child: Text(
                    _tabs[index],
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : _navy,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari Barang Hilang...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: _mediumNavy.withOpacity(0.6),
          ),
          prefixIcon: const Icon(Icons.search, color: _navy, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // POPUP DETAIL BARANG (muncul saat katalog barang ditekan)
  void _showDetailBarangDialog(Map<String, String> barang) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.1),
      builder: (dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Foto barang + tombol X
                  Container(
                    height: 240,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _navy.withOpacity(0.4)),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          barang['image']!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: _selectedBg,
                            child: const Icon(Icons.image,
                                color: _navy, size: 48),
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.of(dialogContext).pop(),
                            child: Container(
                              width: 26,
                              height: 26,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _darkNavy.withOpacity(0.85),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                'X',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Detail barang
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEBFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _navy.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barang['nama']!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: _darkNavy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: _navy),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                barang['lokasi']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _darkNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          barang['deskripsi']!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _mediumNavy,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Diposting oleh
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _navy, width: 1.2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: _selectedBg,
                                  backgroundImage:
                                      NetworkImage(barang['avatar']!),
                                  onBackgroundImageError: (_, __) {},
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Diposting Oleh',
                                      style: GoogleFonts.inter(
                                        fontSize: 9,
                                        color: _mediumNavy,
                                      ),
                                    ),
                                    Text(
                                      barang['diposting']!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: _darkNavy,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Tombol kirim pesan
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatAdminPage(
                                    namaLawan: barang['diposting']!,
                                    avatarUrl: barang['avatar']!,
                                    namaBarang: barang['nama']!,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 10),
                              decoration: BoxDecoration(
                                color: _navy,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.chat_bubble_outline,
                                      size: 16, color: Colors.white),
                                  const SizedBox(width: 4),
                                  Text(
                                    'KIRIM PESAN',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildReportCard(Map<String, String> barang) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _navy.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              barang['image']!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFF8B4513),
                child: const Icon(Icons.image, color: Colors.white, size: 32),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  barang['nama']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailItem(
                  icon: Icons.access_time,
                  text: barang['waktu']!,
                ),
                const SizedBox(height: 4),
                _buildDetailItem(
                  icon: Icons.category_outlined,
                  text: barang['kategori']!,
                ),
                const SizedBox(height: 4),
                _buildDetailItem(
                  icon: Icons.location_on_outlined,
                  text: barang['lokasi']!,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _navy, size: 20),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _mediumNavy),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: _mediumNavy,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
                  children: List.generate(_navLabels.length, (index) {
                    return _buildNavItem(index);
                  }),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 4. PASANG GLOBAL KEY DI TOMBOL PLUS
            GestureDetector(
              key: _fabKey, // <--- INI KUNCINYA AGAR POSISI DIKETAHUI
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
        return;
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
        return isSelected ? Icons.description : Icons.description_outlined;
      case 3:
        return Icons.chat_bubble_outline;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.dashboard_outlined;
    }
  }
}