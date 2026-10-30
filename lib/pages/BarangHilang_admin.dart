import 'dart:ui'; // untuk efek blur (ImageFilter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laporan dan Riwayat',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const LaporanRiwayatPage(),
    );
  }
}

class LaporanRiwayatPage extends StatefulWidget {
  const LaporanRiwayatPage({super.key});

  @override
  State<LaporanRiwayatPage> createState() => _LaporanRiwayatPageState();
}

class _LaporanRiwayatPageState extends State<LaporanRiwayatPage> {
  int _selectedIndex = 2; // 2 adalah LAPORAN
  String _selectedTab = 'MENUNGGU';

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

  final List<String> _tabs = [
    'MENUNGGU',
    'DISETUJUI',
    'DITOLAK',
    'SELESAI',
  ];

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
                  const SizedBox(height: 20),
                  _buildTabs(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildReportCard(),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi
          Positioned(
            right: 20,
            bottom: 100,
            child: GestureDetector(
              onTap: () => debugPrint('Notifikasi diklik'),
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

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _navy,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.search,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          'Laporan Dan Riwayat',
          style: GoogleFonts.spaceMono(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _darkNavy,
            letterSpacing: 0.5,
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
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
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
      height: 50,
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
          hintText: 'Cari Nama Barang...',
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: _mediumNavy.withOpacity(0.6),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: _navy,
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildReportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Dompet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dompet Kulit Hitam',
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailItem(
                  icon: Icons.access_time,
                  text: '2 Jam Yang Lalu',
                ),
                const SizedBox(height: 4),
                _buildDetailItem(
                  icon: Icons.person_outline,
                  text: 'Barang Pribadi',
                ),
                const SizedBox(height: 4),
                _buildDetailItem(
                  icon: Icons.location_on_outlined,
                  text: 'Parkiran Gedung Utama',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: _mediumNavy,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: _mediumNavy,
            fontWeight: FontWeight.w500,
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
                  children: List.generate(_navLabels.length, (index) {
                    return _buildNavItem(index);
                  }),
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
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== NAV ITEM ====================
  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final IconData icon = _getNavIcon(index, isSelected);

    return GestureDetector(
      onTap: () {
        if (index != _selectedIndex) {
          setState(() {
            _selectedIndex = index;
          });
          debugPrint('Navigasi ke: ${_navLabels[index]}');
        }
      },
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
            Icon(
              icon,
              size: 20,
              color: _navy,
            ),
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