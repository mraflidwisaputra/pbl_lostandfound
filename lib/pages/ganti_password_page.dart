import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/wave_background.dart';
import 'profil_page.dart';
import 'sukses_page.dart';

class GantiPasswordPage extends StatefulWidget {
  const GantiPasswordPage({super.key});

  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);

  final _baruC = TextEditingController();
  final _konfC = TextEditingController();
  bool _sembunyi1 = true;
  bool _sembunyi2 = true;

  @override
  void dispose() {
    _baruC.dispose();
    _konfC.dispose();
    super.dispose();
  }

  void _konfirmasi() {
    final baru = _baruC.text;
    String? error;
    if (baru.length < 6) {
      error = 'Password minimal 6 karakter';
    } else if (baru != _konfC.text) {
      error = 'Konfirmasi password tidak sama';
    }
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    // TODO: kirim password baru ke server
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuksesPage(
          pesan: 'PASSWORD ANDA BERHASIL DIUBAH !',
          tujuan: (_) => const ProfilPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(32, 40, 32, 44),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                            color: _navy.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text('GANTI PASSWORD',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: _ink)),
                        ),
                        const SizedBox(height: 30),
                        _label('Masukkan Password Baru'),
                        _field(_baruC, _sembunyi1,
                            () => setState(() => _sembunyi1 = !_sembunyi1)),
                        const SizedBox(height: 12),
                        _label('Konfirmasi Password baru'),
                        _field(_konfC, _sembunyi2,
                            () => setState(() => _sembunyi2 = !_sembunyi2)),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: _konfirmasi,
                            icon: const Icon(Icons.send_outlined, size: 16),
                            label: Text('Konfirmasi',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: _ink),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(t,
            style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w500, color: _ink)),
      );

  Widget _field(TextEditingController c, bool sembunyi, VoidCallback toggle) {
    return TextField(
      controller: c,
      obscureText: sembunyi,
      style: GoogleFonts.inter(fontSize: 13),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFDCE9F8),
        hintText: 'Masukkan Password...',
        hintStyle: GoogleFonts.inter(
            fontSize: 12, color: const Color(0xFF8F9BD6)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(
              sembunyi
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: _ink),
          onPressed: toggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _navy),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _navy, width: 1.5),
        ),
      ),
    );
  }
}