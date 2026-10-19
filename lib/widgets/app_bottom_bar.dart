import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pages/home_page.dart';
import '../pages/barang_page.dart';
import '../pages/riwayat_laporan_page.dart';
import '../pages/riwayat_pesan_page.dart';
import '../pages/profil_page.dart';
import '../pages/notifikasi_page.dart';
import 'upload_dialog.dart';

/// Bottom bar bersama (sudah termasuk tombol lonceng notifikasi di atasnya).
/// index: 0 Cari, 1 Barang, 2 Riwayat Laporan, 3 Pesan, 4 Profil
class AppBottomBar extends StatelessWidget {
  final int currentIndex;
  const AppBottomBar({super.key, required this.currentIndex});

  static const _navy = Color(0xFF0B4F7C);

  void _go(BuildContext context, int i) {
    if (i == currentIndex) return;
    Widget? page;
    switch (i) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const BarangPage();
        break;
      case 2:
        page = const RiwayatLaporanPage();
        break;
      case 3:
        page = const RiwayatPesanPage();
        break;
      case 4:
        page = const ProfilPage();
        break;
    }
    if (page == null) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) => page!,
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: _lonceng(context),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: _navy.withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _item(context, 0, Icons.search, 'CARI'),
                      _item(context, 1, Icons.receipt_long_outlined, 'BARANG'),
                      _item(context, 2, Icons.assignment_outlined,
                          'RIWAYAT\nLAPORAN'),
                      _item(context, 3, Icons.chat_bubble_outline, 'PESAN'),
                      _item(context, 4, Icons.person_outline, 'PROFIL'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => showUploadDialog(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _navy,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _lonceng(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NotifikasiPage()),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _navy.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
            child: const Icon(Icons.notifications_none, color: _navy),
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                  color: Colors.red, shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, int i, IconData icon, String label) {
    final selected = currentIndex == i;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _go(context, i),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC9D3F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: _navy),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceMono(
                  fontSize: 8,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: _navy),
            ),
          ],
        ),
      ),
    );
  }
}