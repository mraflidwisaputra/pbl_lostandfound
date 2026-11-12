import 'dart:ui'; // untuk efek blur (ImageFilter)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'notifikasi_admin.dart';
import 'dashboard_admin.dart';
import 'BarangHilang_admin.dart';
import 'LaporanRiwayat_admin.dart';
import 'Profil_admin.dart';
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
      title: 'Pesan Admin',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const RiwayatPesanAdminPage(),
    );
  }
}

// =====================================================================
//  HALAMAN DAFTAR PESAN (tampilan admin)
// =====================================================================
class RiwayatPesanAdminPage extends StatefulWidget {
  const RiwayatPesanAdminPage({super.key});

  @override
  State<RiwayatPesanAdminPage> createState() => _RiwayatPesanAdminPageState();
}

class _RiwayatPesanAdminPageState extends State<RiwayatPesanAdminPage> {
  int _selectedIndex = 3; // 3 adalah PESAN

  // 1. TAMBAHKAN GLOBAL KEY UNTUK MENDAPATKAN POSISI TOMBOL PLUS
  final GlobalKey _fabKey = GlobalKey();

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  final List<String> _navLabels = [
    'DASHBOARD',
    'BARANG',
    'LAPORAN',
    'PESAN',
    'PROFIL',
  ];

  final List<Map<String, String>> _chatList = [
    {
      'nama': 'Loki',
      'pesan': 'Baik min',
      'waktu': 'Kemarin',
      'avatar': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'nama': 'Kathryn',
      'pesan': 'Di Gedung Utama Pak',
      'waktu': '11.50',
      'avatar': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'nama': 'Sadie',
      'pesan': 'Baik Bapak👍',
      'waktu': 'Sekarang',
      'avatar': 'https://randomuser.me/api/portraits/women/65.jpg',
    },
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
        return;
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

  // 3. UI POPUP AKSI CEPAT
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
      // Lonceng notifikasi: otomatis berada tepat di atas bar menu & tombol plus
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 4),
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
                  const SizedBox(height: 70),
                  ..._chatList.map(
                    (chat) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildChatItem(chat),
                    ),
                  ),
                ],
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
                child: const Icon(Icons.search, color: _navy, size: 28),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem(Map<String, String> chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatAdminPage(
              namaLawan: chat['nama']!,
              avatarUrl: chat['avatar']!,
              namaBarang: 'Pengguna',
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _navy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _navy.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(chat['avatar']!),
              backgroundColor: _selectedBg,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chat['nama']!,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        chat['waktu']!,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat['pesan']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.white),
                  ),
                ],
              ),
            ),
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
              onTap:
                  _showQuickActionDialog, // <--- GANTI DENGAN FUNGSI POPUP BARU
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
            Icon(_getNavIcon(index, isSelected), size: 20, color: _navy),
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
        return isSelected ? Icons.chat_bubble : Icons.chat_bubble_outline;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

// =====================================================================
//  HALAMAN CHAT (tampilan admin) - TIDAK DIUBAH
// =====================================================================
class _Pesan {
  final String teks;
  final bool dariAdmin;
  _Pesan(this.teks, this.dariAdmin);
}

class ChatAdminPage extends StatefulWidget {
  final String namaLawan;
  final String avatarUrl;
  final String namaBarang;

  const ChatAdminPage({
    super.key,
    required this.namaLawan,
    required this.avatarUrl,
    this.namaBarang = 'Pengguna',
  });

  @override
  State<ChatAdminPage> createState() => _ChatAdminPageState();
}

class _ChatAdminPageState extends State<ChatAdminPage> {
  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  final TextEditingController _inputC = TextEditingController();
  final ScrollController _scrollC = ScrollController();

  final List<_Pesan> _pesan = [
    _Pesan('Selamat siang, ada yang bisa kami bantu?', true),
    _Pesan('Saya kehilangan dompet hitam di gedung utama', false),
    _Pesan('Baik, kami cek dulu ya', true),
    _Pesan('Di Gedung Utama Pak', false),
    _Pesan('Baik min', false),
  ];

  @override
  void dispose() {
    _inputC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  void _kirim() {
    final teks = _inputC.text.trim();
    if (teks.isEmpty) return;
    setState(() => _pesan.add(_Pesan(teks, true)));
    _inputC.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollC.hasClients) {
        _scrollC.animateTo(
          _scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                controller: _scrollC,
                padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                children: _pesan.map(_buildBubble).toList(),
              ),
            ),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _darkNavy),
            onPressed: () => Navigator.maybePop(context),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.avatarUrl),
            backgroundColor: _selectedBg,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.namaLawan,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                  ),
                ),
                Text(
                  widget.namaBarang,
                  style: GoogleFonts.inter(fontSize: 11, color: _darkNavy),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.outlined_flag, color: _navy),
            tooltip: 'Laporkan',
            onPressed: () {
              // TODO: laporkan percakapan
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(_Pesan p) {
    final admin = p.dariAdmin;
    return Align(
      alignment: admin ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.68,
        ),
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: admin ? _navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(admin ? 22 : 4),
            bottomRight: Radius.circular(admin ? 4 : 22),
          ),
          border: admin ? null : Border.all(color: _navy.withOpacity(0.3)),
        ),
        child: Text(
          p.teks,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: admin ? Colors.white : _navy,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        height: 46,
        padding: const EdgeInsets.only(left: 6, right: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _navy.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 20, color: _navy),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: () {
                // TODO: lampirkan foto / file
              },
            ),
            Expanded(
              child: TextField(
                controller: _inputC,
                onSubmitted: (_) => _kirim(),
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Masukkan Pesan...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _kirim,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: _navy,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}