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
      title: 'Dashboard Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

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
          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 28),
                  _buildAktivitasSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi Bell (floating di atas bottom nav)
          Positioned(
            right: 20,
            bottom: 110,
            child: GestureDetector(
              onTap: () {},
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
                    // Badge merah dengan border putih
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE74C3C),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation + Tombol Plus (sejajar horizontal)
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

  // ==================== HEADER (DIMODIFIKASI: EMOJI DIGANTI ICON) ====================
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
              // PERUBAHAN DI SINI: Mengganti Text dengan Row berisi Text + Icon
              Row(
                children: [
                  const Text(
                    'ADMIN!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C4F7C),
                    ),
                  ),
                  const SizedBox(width: 8), // Jarak antara teks dan icon
                  const Icon(
                    Icons.waving_hand, // Icon tangan melambaikan (pengganti emoji)
                    color: Color(0xFF2C4F7C),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==================== STATS GRID ====================
  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard(icon: Icons.description_outlined, number: '12', label: 'Laporan\nKehilangan'),
        _buildStatCard(icon: Icons.copy_outlined, number: '12', label: 'Barang\nTemuan'),
        _buildStatCard(icon: Icons.chat_bubble_outline, number: '6', label: 'Menunggu\nVerifikasi'),
        _buildStatCard(icon: Icons.inventory_2_outlined, number: '4', label: 'Klaim\nDiproses'),
      ],
    );
  }

  Widget _buildStatCard({required IconData icon, required String number, required String label}) {
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
                  style: GoogleFonts.spaceMono(
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

  // ==================== AKTIVITAS SECTION ====================
  Widget _buildAktivitasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AKTIVITAS TERBARU',
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
        const SizedBox(height: 12),
        _buildActivityItem(
          avatarUrl: 'https://randomuser.me/api/portraits/women/65.jpg',
          title: 'Sadie Membuat Laporan Kehilangan',
          subtitle: '7 Menit Lalu',
        ),
      ],
    );
  }

  Widget _buildActivityItem({required String avatarUrl, required String title, required String subtitle}) {
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
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: _mediumNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BOTTOM SECTION (Nav Bar + Tombol Plus) ====================
  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bottom Navigation Bar
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

          // Tombol Plus (+) di sebelah kanan, sejajar dengan bottom nav
          GestureDetector(
            onTap: () {
              debugPrint('Tombol Tambah ditekan');
            },
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
    );
  }

  // ==================== NAV ITEM ====================
  Widget _buildNavItem(int index) {
    final isSelected = _selectedIndex == index;
    final IconData icon = _getNavIcon(index, isSelected);

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
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