import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wave_background.dart';

/// Halaman centang "berhasil". Otomatis pindah ke [tujuan] setelah [durasi].
class SuksesPage extends StatefulWidget {
  final String pesan;
  final WidgetBuilder tujuan;
  final Duration durasi;

  const SuksesPage({
    super.key,
    required this.pesan,
    required this.tujuan,
    this.durasi = const Duration(milliseconds: 2200),
  });

  @override
  State<SuksesPage> createState() => _SuksesPageState();
}

class _SuksesPageState extends State<SuksesPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.durasi, () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: widget.tujuan),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: WaveBackground(
          child: Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.6, end: 1),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutBack,
              builder: (_, v, child) =>
                  Transform.scale(scale: v, child: child),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 175,
                    height: 175,
                    decoration: const BoxDecoration(
                        color: Color(0xFF0B4F7C), shape: BoxShape.circle),
                    child: const Icon(Icons.check_rounded,
                        size: 90, color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(widget.pesan,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F2A47))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}