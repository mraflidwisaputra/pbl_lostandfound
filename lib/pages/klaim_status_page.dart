import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wave_background.dart';
import 'home_page.dart';
import 'riwayat_laporan_page.dart';

/// Menampilkan "Mengajukan Klaim..." lalu berubah menjadi "Berhasil".
/// [proses] = pekerjaan yang ditunggu (mis. request ke server).
class KlaimStatusPage extends StatefulWidget {
  final Future<void> proses;
  const KlaimStatusPage({super.key, required this.proses});

  @override
  State<KlaimStatusPage> createState() => _KlaimStatusPageState();
}

class _KlaimStatusPageState extends State<KlaimStatusPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _circle = Color(0xFF1B5E8A);
  static const _ink = Color(0xFF0F2A47);

  bool _selesai = false;
  bool _gagal = false;

  @override
  void initState() {
    super.initState();
    widget.proses.then((_) {
      if (mounted) setState(() => _selesai = true);
    }).catchError((_) {
      if (mounted) setState(() => _gagal = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // cegah kembali saat proses / setelah selesai
      child: Scaffold(
        body: WaveBackground(
          child: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: _gagal
                  ? _gagalView()
                  : (_selesai ? _berhasilView() : _loadingView()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingView() {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                      color: _circle, shape: BoxShape.circle),
                  child: const Icon(Icons.description_outlined,
                      size: 60, color: Colors.white),
                ),
                const Positioned(
                  bottom: 6,
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                        strokeWidth: 3, color: Color(0xFF2E9BFF)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('Mengajukan Klaim...',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700, color: _ink)),
          const SizedBox(height: 10),
          Text('Mohon Tunggu Sebentar,\nKami Sedang Menyimpan Data Klaim Anda',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: _ink)),
        ],
      ),
    );
  }

  Widget _berhasilView() {
    return Center(
      key: const ValueKey('berhasil'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 175,
              height: 175,
              decoration: BoxDecoration(
                color: _circle,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black87, width: 0.8),
              ),
              child: const Icon(Icons.check_rounded,
                  size: 90, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('KLAIM BERHASIL DIAJUKAN',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 19, fontWeight: FontWeight.w700, color: _ink)),
            const SizedBox(height: 18),
            Text(
                'Klaim Anda Berhasil Dikirim\nDan Sedang Menunggu Verifikasi\nOleh Admin.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 14, height: 1.5, color: _ink)),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RiwayatLaporanPage()),
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: Text('Lihat Riwayat Laporan',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
                icon: const Icon(Icons.reply, size: 16),
                label: Text('Kembali Ke Beranda',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  backgroundColor: Colors.white,
                  side: BorderSide(color: _navy.withOpacity(0.6)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gagalView() {
    return Center(
      key: const ValueKey('gagal'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.redAccent),
            const SizedBox(height: 14),
            Text('Klaim gagal dikirim',
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w700, color: _ink)),
            const SizedBox(height: 8),
            Text('Periksa koneksi internet Anda lalu coba lagi.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: _ink)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: _navy, foregroundColor: Colors.white),
              child: const Text('Kembali ke formulir'),
            ),
          ],
        ),
      ),
    );
  }
}