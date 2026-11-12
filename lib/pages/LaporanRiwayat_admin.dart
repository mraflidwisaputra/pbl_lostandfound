import 'dart:ui'; // untuk efek blur (ImageFilter)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Import halaman-halaman lain yang terhubung di folder pages
import 'dashboard_admin.dart';
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
      title: 'Laporan Dan Riwayat',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const LaporanPage(),
    );
  }
}

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  int _selectedIndex = 2; // LAPORAN tab aktif
  int _activeTab = 0; // 0=MENUNGGU, 1=DISETUJUI, 2=DITOLAK, 3=SELESAI
  final TextEditingController _searchController = TextEditingController();

  // 1. TAMBAHKAN GLOBAL KEY UNTUK MENDAPATKAN POSISI TOMBOL PLUS
  final GlobalKey _fabKey = GlobalKey();

  final List<String> _tabLabels = [
    'MENUNGGU',
    'DISETUJUI',
    'DITOLAK',
    'SELESAI',
  ];
  final List<String> _navLabels = [
    'DASHBOARD',
    'BARANG',
    'LAPORAN',
    'PESAN',
    'PROFIL',
  ];

  // Data contoh laporan
  final List<Map<String, String>> _laporanList = [
    {
      'nama': 'Jam Tangan',
      'waktu': '2 Jam Yang Lalu',
      'kategori': 'Aksesoris',
      'lokasi': 'Parkiran Gedung Utama',
      'image': 'assets/images/jam.png',
    },
    {
      'nama': 'Dompet',
      'waktu': '5 Jam Yang Lalu',
      'kategori': 'Dompet & Dokumen',
      'lokasi': 'Kantin Gedung B',
      'image': 'assets/images/dompet.png',
    },
    {
      'nama': 'Kunci',
      'waktu': '1 Hari Yang Lalu',
      'kategori': 'Kunci',
      'lokasi': 'Ruang Kelas 301',
      'image': 'assets/images/kunci.png',
    },
    {
      'nama': 'HP',
      'waktu': '2 Hari Yang Lalu',
      'kategori': 'Elektronik',
      'lokasi': 'Perpustakaan',
      'image': 'assets/images/iphone.png',
    },
  ];

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _mediumNavy = Color(0xFF2C4F7C);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ==================== NAVIGASI BOTTOM BAR ====================
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
        return; // Sudah di halaman Laporan
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

  // ==================== 2. FUNGSI POPUP DENGAN OVERLAY (MUNCUL DI ATAS TOMBOL) ====================
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

  // ==================== 3. UI POPUP ====================
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

  // ==================== BUILD ====================
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
                  _buildTabFilter(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 28),
                  ..._laporanList.map(
                    (laporan) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildLaporanCard(laporan),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi
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

  // ==================== HEADER ====================
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
                child: const Icon(Icons.search, color: _navy, size: 28),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            'Laporan Dan Riwayat',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _darkNavy,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== TAB FILTER ====================
  Widget _buildTabFilter() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _navy.withOpacity(0.4)),
      ),
      child: Row(
        children: List.generate(_tabLabels.length, (index) {
          final isActive = _activeTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isActive ? _navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    _tabLabels[index],
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : _navy,
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

  // ==================== SEARCH BAR ====================
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _navy.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: _navy, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Nama Barang...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== LAPORAN CARD ====================
  Widget _buildLaporanCard(Map<String, String> laporan) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              laporan['image']!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: _selectedBg,
                  child: const Icon(Icons.image, color: _navy),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  laporan['nama']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, laporan['waktu']!),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.category_outlined, laporan['kategori']!),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.location_on_outlined, laporan['lokasi']!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: _navy),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 11, color: _mediumNavy),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ==================== BOTTOM SECTION ====================
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
                  children: [
                    _buildNavItem(0, Icons.dashboard_outlined, 'DASHBOARD'),
                    _buildNavItem(1, Icons.copy_outlined, 'BARANG'),
                    _buildNavItem(2, Icons.description_outlined, 'LAPORAN'),
                    _buildNavItem(3, Icons.chat_bubble_outline, 'PESAN'),
                    _buildNavItem(4, Icons.person_outline, 'PROFIL'),
                  ],
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

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
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
              label,
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
}