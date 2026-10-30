import 'dart:ui'; // untuk efek blur (ImageFilter)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'notifikasi_admin.dart'; // halaman notifikasi

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
      home: const RiwayatPesanPage(),
    );
  }
}

// =====================================================================
//  HALAMAN DAFTAR PESAN (tampilan admin)
// =====================================================================
class RiwayatPesanPage extends StatefulWidget {
  const RiwayatPesanPage({super.key});

  @override
  State<RiwayatPesanPage> createState() => _RiwayatPesanPageState();
}

class _RiwayatPesanPageState extends State<RiwayatPesanPage> {
  int _selectedIndex = 3; // 3 adalah PESAN

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

  // Data contoh -> ganti dengan data dari server / Firebase
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

  // ==================== BOTTOM BAR (FRONT END SAJA) ====================
  // Belum terhubung ke halaman lain, hanya mengganti tab aktif secara visual
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
    });
    debugPrint('Menu ${_navLabels[index]} ditekan (belum terhubung)');
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
            style: GoogleFonts.spaceMono(fontSize: 12, color: Colors.white),
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
                  const SizedBox(height: 70),
                  ..._chatList.map((chat) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildChatItem(chat),
                      )),
                ],
              ),
            ),
          ),

          // Tombol Notifikasi -> buka halaman notifikasi_admin.dart
          Positioned(
            right: 20,
            bottom: 20,
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

  // ==================== HEADER (LOGO) ====================
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

  // ==================== ITEM DAFTAR CHAT ====================
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
                        style: GoogleFonts.spaceMono(
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
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        return isSelected ? Icons.chat_bubble : Icons.chat_bubble_outline;
      case 4:
        return Icons.person_outline;
      default:
        return Icons.dashboard_outlined;
    }
  }
}

// =====================================================================
//  HALAMAN CHAT (tampilan admin)
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

  // Data contoh -> ganti dengan data dari server / Firebase
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

  // ==================== HEADER CHAT ====================
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
                  style: GoogleFonts.spaceMono(
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

  // ==================== BUBBLE PESAN ====================
  // Admin = kanan (navy), pengguna = kiri (putih)
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

  // ==================== INPUT PESAN ====================
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
                child: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}