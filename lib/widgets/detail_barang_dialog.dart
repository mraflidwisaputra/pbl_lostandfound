import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../pages/chat_page.dart';
import 'foto_barang.dart';

/// Membuka popup detail barang (latar blur). Dipakai di Beranda & Daftar Barang.
void showDetailBarang(BuildContext context, ItemBarang item) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => DetailBarangDialog(item: item),
    transitionBuilder: (_, anim, __, child) => FadeTransition(
      opacity: anim,
      child: ScaleTransition(
        scale: Tween(begin: 0.95, end: 1.0)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ),
  );
}

/// Popup detail barang dengan latar blur.
class DetailBarangDialog extends StatelessWidget {
  final ItemBarang item;
  const DetailBarangDialog({required this.item});

  static const _navy = Color(0xFF0B4F7C);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // latar blur, ketuk untuk menutup
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.white.withOpacity(0.15)),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // gambar + tombol X
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                    child: Stack(
                      children: [
                        FotoBarang(item.gambar,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              color: Colors.grey.shade400,
                              child: const Center(
                                  child: Icon(Icons.image_outlined, size: 48))),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: Colors.black87, shape: BoxShape.circle),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // isi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9F8),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(6)),
                      border: Border.all(color: const Color(0xFF8F9BD6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nama,
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F2A47))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: _navy),
                            const SizedBox(width: 4),
                            Text(item.lokasi,
                                style: GoogleFonts.inter(
                                    fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(item.deskripsi,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: const Color(0xFF0F2A47))),
                        const SizedBox(height: 22),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _navy),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Icon(Icons.person,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Diposting Oleh',
                                        style: GoogleFonts.inter(fontSize: 9)),
                                    Text(item.pemosting,
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final nav = Navigator.of(context);
                              nav.pop();
                              nav.push(
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    namaLawan: item.pemosting,
                                    namaBarang: item.nama,
                                    barang: item,
                                    // chatId null → akan dibuat baru oleh ChatPage
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline,
                                size: 14),
                            label: Text('KIRIM PESAN',
                                style: GoogleFonts.spaceMono(
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
        ),
      ],
    );
  }
}