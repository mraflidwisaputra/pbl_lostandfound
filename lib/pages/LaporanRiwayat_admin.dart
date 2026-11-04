import 'dart:ui'; // untuk efek blur (ImageFilter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import halaman-halaman lain yang terhubung di folder pages
import 'dashboard_admin.dart';
import 'BarangHilang_admin.dart';
import 'ChatPage_admin.dart';
import 'Profil_admin.dart';
import 'notifikasi_admin.dart';

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

  final List<String> _tabLabels = ['MENUNGGU', 'DISETUJUI', 'DITOLAK', 'SELESAI'];
  final List<String> _navLabels = ['DASHBOARD', 'BARANG', 'LAPORAN', 'PESAN', 'PROFIL'];

  // Data contoh laporan
  final List<Map<String, String>> _laporanList = [
    {
      'nama': 'Nama Barang',
      'waktu': '2 Jam Yang Lalu',
      'kategori': 'Kategori',
      'lokasi': 'Parkiran Gedung Utama',
      'image': 'https://via.placeholder.com/100x100/8B4513/FFFFFF?text=Barang',
    },
    {
      'nama': 'Nama Barang',
      'waktu': '5 Jam Yang Lalu',
      'kategori': 'Kategori',
      'lokasi': 'Kantin Gedung B',
      'image': 'https://via.placeholder.com/100x100/4169E1/FFFFFF?text=Barang',
    },
    {
      'nama': 'Nama Barang',
      'waktu': '1 Hari Yang Lalu',
      'kategori': 'Kategori',
      'lokasi': 'Ruang Kelas 301',
      'image': 'https://via.placeholder.com/100x100/32CD32/FFFFFF?text=Barang',
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

  // ==================== POPUP UPLOAD BARANG TEMUAN ====================
  void _showUploadDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        // BackdropFilter = background di belakang popup menjadi blur
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: _buildUploadDialog(dialogContext),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildUploadDialog(BuildContext dialogContext) {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Judul + tombol X
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upload Barang Temuan',
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Text(
                  'X',
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Dua pilihan: kamera & galeri
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUploadOption(
                icon: Icons.camera_alt_outlined,
                onTap: () {
                  Navigator.pop(dialogContext);
                  debugPrint('Buka kamera');
                  // TODO: ImagePicker().pickImage(source: ImageSource.camera)
                },
              ),
              _buildUploadOption(
                icon: Icons.image_outlined,
                onTap: () {
                  Navigator.pop(dialogContext);
                  debugPrint('Buka galeri');
                  // TODO: ImagePicker().pickImage(source: ImageSource.gallery)
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          Text(
            'Pilih Salah Satu',
            style: GoogleFonts.spaceMono(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 32, color: _navy),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
                  .copyWith(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildTabFilter(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 28),
                  ..._laporanList.map((laporan) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildLaporanCard(laporan),
                      )),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi
          Positioned(
            right: 20,
            bottom: 100,
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
            style: GoogleFonts.spaceMono(
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
                    style: GoogleFonts.spaceMono(
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
            child: Image.network(
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
                  style: GoogleFonts.spaceMono(
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
            style: GoogleFonts.inter(
              fontSize: 11,
              color: _mediumNavy,
            ),
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

            // Tombol Tambah (+) -> memunculkan popup upload
            GestureDetector(
              onTap: _showUploadDialog,
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
}