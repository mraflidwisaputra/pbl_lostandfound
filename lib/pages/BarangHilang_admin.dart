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
      title: 'Barang Hilang',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const BarangHilangPage(),
    );
  }
}

class BarangHilangPage extends StatefulWidget {
  const BarangHilangPage({super.key});

  @override
  State<BarangHilangPage> createState() => _BarangHilangPageState();
}

class _BarangHilangPageState extends State<BarangHilangPage> {
  int _selectedIndex = 1;
  bool _isHilang = true;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _barangList = [
    {
      'nama': 'Kartu BCA',
      'waktu': '2 Jam Yang Lalu',
      'kategori': 'Kartu',
      'lokasi': 'Parkiran Gedung Utama',
      'deskripsi': 'Kartu ATM BCA berwarna biru dengan gambar harimau',
      'pelapor': 'Sadie',
      'image': 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400',
    },
    {
      'nama': 'Dompet Kulit',
      'waktu': '5 Jam Yang Lalu',
      'kategori': 'Dompet',
      'lokasi': 'Kantin Gedung B',
      'deskripsi': 'Dompet kulit coklat merk XYZ',
      'pelapor': 'John',
      'image': 'https://images.unsplash.com/photo-1627123424574-724758594e93?w=400',
    },
    {
      'nama': 'iPhone 16 Pro',
      'waktu': '1 Hari Yang Lalu',
      'kategori': 'Elektronik',
      'lokasi': 'Ruang Kelas 301',
      'deskripsi': 'iPhone 16 Pro warna hitam dengan casing bening',
      'pelapor': 'Kathryn',
      'image': 'https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=400',
    },
    {
      'nama': 'Kunci Motor',
      'waktu': '3 Hari Yang Lalu',
      'kategori': 'Kunci',
      'lokasi': 'Parkiran Motor Lantai 2',
      'deskripsi': 'Kunci motor Honda dengan gantungan kunci beruang',
      'pelapor': 'Laki',
      'image': 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
    {
      'nama': 'Jam Tangan Seiko',
      'waktu': '1 Minggu Yang Lalu',
      'kategori': 'Aksesoris',
      'lokasi': 'Tangga Gedung Utama',
      'deskripsi': 'Jam tangan Seiko warna silver dengan strap hitam',
      'pelapor': 'Sadie',
      'image': 'https://images.unsplash.com/photo-1523170335258-f5ed11844a49?w=400',
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 24),
                  _buildTabs(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 28),
                  ..._barangList.map((barang) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _showBarangDetail(barang),
                          child: _buildBarangCard(barang),
                        ),
                      )),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

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

  // ==================== POPUP DETAIL BARANG ====================
  void _showBarangDetail(Map<String, String> barang) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gambar Barang dengan tombol close
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        barang['image']!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: _selectedBg,
                            child: const Icon(Icons.image, color: _navy, size: 50),
                          );
                        },
                      ),
                    ),
                    // Tombol Close (X)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Konten Detail
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Barang
                      Text(
                        barang['nama']!,
                        style: GoogleFonts.spaceMono(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _darkNavy,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Lokasi
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: _navy, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            barang['lokasi']!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: _mediumNavy,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Deskripsi
                      Text(
                        barang['deskripsi'] ?? 'Deskripsi Atau Detail Barang',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _mediumNavy,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Card Pelapor
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
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
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: _selectedBg,
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/women/65.jpg',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Reporting Oleh',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  barang['pelapor']!,
                                  style: GoogleFonts.spaceMono(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _darkNavy,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Tombol Kirim Pesan
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Navigasi ke halaman chat
                          },
                          icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20),
                          label: Text(
                            'KIRIM PESAN',
                            style: GoogleFonts.spaceMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _navy,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==================== TABS ====================
  Widget _buildTabs() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _navy.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isHilang = true),
              child: Container(
                decoration: BoxDecoration(
                  color: _isHilang ? _navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'HILANG',
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _isHilang ? Colors.white : _navy,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isHilang = false),
              child: Container(
                decoration: BoxDecoration(
                  color: !_isHilang ? _navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    'TEMUAN',
                    style: GoogleFonts.spaceMono(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: !_isHilang ? Colors.white : _navy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
          Icon(Icons.search, color: _navy, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: _isHilang ? 'Cari Barang Hilang...' : 'Cari Barang Temuan...',
                hintStyle: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================== BARANG CARD ====================
  Widget _buildBarangCard(Map<String, String> barang) {
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
            child: Image.network(
              barang['image']!,
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
                  barang['nama']!,
                  style: GoogleFonts.spaceMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, barang['waktu']!),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.category_outlined, barang['kategori']!),
                const SizedBox(height: 6),
                _buildInfoRow(Icons.location_on_outlined, barang['lokasi']!),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _navy, size: 24),
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
          GestureDetector(
            onTap: () {},
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

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
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