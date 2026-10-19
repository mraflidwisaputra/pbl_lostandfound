import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/lapor_barang_page.dart';

/// Dialog "Upload Barang Hilang" (pilih kamera / galeri),
/// lalu membuka form laporan dengan foto yang dipilih.
Future<void> showUploadDialog(BuildContext context) async {
  final ImageSource? source = await showGeneralDialog<ImageSource>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Tutup',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, __, ___) => const _UploadDialog(),
    transitionBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
  );
  if (source == null || !context.mounted) return;

  final x = await ImagePicker().pickImage(source: source, imageQuality: 80);
  if (x == null || !context.mounted) return;
  final bytes = await x.readAsBytes();
  if (!context.mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => LaporBarangPage(foto: bytes)),
  );
}

class _UploadDialog extends StatelessWidget {
  const _UploadDialog();

  static const _navy = Color(0xFF0B4F7C);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 290,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
              decoration: BoxDecoration(
                color: _navy,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Upload Barang Hilang',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close,
                              size: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _pilihan(context, Icons.photo_camera_outlined,
                          ImageSource.camera),
                      const SizedBox(width: 28),
                      _pilihan(context, Icons.image_outlined,
                          ImageSource.gallery),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text('Pilih Salah Satu',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pilihan(BuildContext context, IconData icon, ImageSource src) {
    return Material(
      color: const Color(0xFFF7FAFE),
      borderRadius: BorderRadius.circular(8),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => Navigator.pop(context, src),
        child: SizedBox(
          width: 96,
          height: 66,
          child: Icon(icon, size: 34, color: _navy),
        ),
      ),
    );
  }
}