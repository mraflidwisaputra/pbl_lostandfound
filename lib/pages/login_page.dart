import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'dashboard_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/wave_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _navy = Color(0xFF0B4F7C);
  static const _bg = Color(0xFFEFF6FD);
  static const _fieldBg = Color(0xFFDCE9F8);

  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  // null = belum memilih. Pilihan: Mahasiswa, Staff Kampus, Dosen, Admin
  String? _jenisUser;
  static const _jenisList = ['Mahasiswa', 'Staff Kampus', 'Dosen', 'Admin'];
  bool _obscure = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_jenisUser == null) {
      setState(() => _errorMessage = 'Silahkan pilih jenis user terlebih dahulu');
      return;
    }
    if (_emailC.text.trim().isEmpty || _passC.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Email dan password tidak boleh kosong');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailC.text.trim(),
        password: _passC.text.trim(),
      );
      if (!mounted) return;
      // Admin -> Dashboard Admin; Mahasiswa / Staff Kampus / Dosen -> Beranda
      if (_jenisUser == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardAdminPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ' + e.code + ' - ' + (e.message ?? ''));
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'Akun tidak ditemukan di Firebase';
          break;
        case 'wrong-password':
          msg = 'Password salah';
          break;
        case 'invalid-credential':
          msg = 'Email atau password salah';
          break;
        case 'invalid-email':
          msg = 'Format email tidak valid';
          break;
        case 'user-disabled':
          msg = 'Akun telah dinonaktifkan';
          break;
        case 'network-request-failed':
          msg = 'Koneksi internet bermasalah';
          break;
        default:
          msg = 'Login gagal: ' + (e.message ?? e.code);
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      debugPrint('Login general error: ' + e.toString());
      setState(() => _errorMessage = 'Gagal login: ' + e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // latar gelombang biru muda
          const Positioned.fill(
            child: WaveBackground(child: SizedBox.shrink()),
          ),

          // kartu login
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _navy.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', height: 100),
                    const SizedBox(height: 16),
                    Text(
                      'Polibatam Lost & Found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F2A47),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Barang Hilang? Polibatam Lost & Found Solusinya',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(fontSize: 11, color: _navy),
                    ),
                    const SizedBox(height: 28),

                    // pilih jenis user
                    _dropdownUser(),
                    const SizedBox(height: 20),

                    _field(
                      controller: _emailC,
                      hint: 'Masukkan Email Anda',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      controller: _passC,
                      hint: 'Masukkan Password',
                      icon: Icons.lock_outline,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFF0F2A47),
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Tampilkan pesan error jika ada
                    if (_errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ] else
                      const SizedBox(height: 6),

                    SizedBox(
                      width: 100,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Login',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
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

  Widget _dropdownUser() {
    const ink = Color(0xFF0F2A47);
    final gaya = GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w600, color: ink);
    return Center(
      child: Container(
        width: 190,
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFE),
          border: Border.all(color: _navy),
          borderRadius: BorderRadius.circular(6),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _jenisUser,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: ink),
            dropdownColor: const Color(0xFFF7FAFE),
            borderRadius: BorderRadius.circular(6),
            style: gaya,
            hint: Text('Silahkan Pilih User', style: gaya),
            items: [
              DropdownMenuItem<String>(
                  value: null, child: Text('Pilih Jenis User', style: gaya)),
              ..._jenisList.map((e) => DropdownMenuItem<String>(
                  value: e, child: Text(e, style: gaya))),
            ],
            onChanged: (v) => setState(() {
              _jenisUser = v;
              _errorMessage = null;
            }),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: _fieldBg,
        isDense: true,
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xB3102A43),
        ),
        prefixIcon: Icon(icon, color: const Color(0xFF0F2A47)),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _navy),
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