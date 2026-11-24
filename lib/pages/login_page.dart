import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/wave_background.dart';
import 'dashboard_admin.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _fieldBg = Color(0xFFDCE9F8);
  static const _fieldBorder = Color(0xFF8FA6E3);

  final _emailC = TextEditingController();
  final _passC = TextEditingController();
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

      // Peran dibaca otomatis dari database (users/{uid}.role),
      // bukan dipilih manual -> menghindari salah pilih.
      final peran = await AuthService().peran();
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => peran == 'admin'
              ? const DashboardAdminPage() // admin
              : const HomeScreen(), // mahasiswa / staff / dosen
        ),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message ?? ''}');
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'Akun tidak ditemukan';
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
        case 'too-many-requests':
          msg = 'Terlalu banyak percobaan, coba lagi nanti';
          break;
        case 'network-request-failed':
          msg = 'Koneksi internet bermasalah';
          break;
        default:
          msg = 'Login gagal: ${e.message ?? e.code}';
      }
      setState(() => _errorMessage = msg);
    } catch (e) {
      // mis. gagal membaca peran dari database -> batalkan login
      debugPrint('Login general error: $e');
      await FirebaseAuth.instance.signOut();
      setState(() => _errorMessage = 'Gagal login: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FD),
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
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 64),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFCFF),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _navy.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png',
                        height: 100,
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(height: 100)),
                    const SizedBox(height: 16),
                    Text(
                      'Polibatam Lost & Found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSans3(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Barang Hilang? Polibatam Lost & Found Solusinya',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _navy,
                      ),
                    ),
                    const SizedBox(height: 34),

                    _field(
                      controller: _emailC,
                      hint: 'Masukkan Email Anda',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
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
                          color: _ink,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      onSubmit: _login,
                    ),
                    const SizedBox(height: 14),

                    // pesan error
                    if (_errorMessage != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceSans3(
                            fontSize: 12.5,
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.w600,
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
                                style: GoogleFonts.sourceSans3(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
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

  Widget _field({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    VoidCallback? onSubmit,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      onSubmitted: onSubmit == null ? null : (_) => onSubmit(),
      style: GoogleFonts.sourceSans3(fontSize: 14, color: _ink),
      decoration: InputDecoration(
        filled: true,
        fillColor: _fieldBg,
        isDense: true,
        hintText: hint,
        hintStyle: GoogleFonts.sourceSans3(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xB3102A43), // 70% terlihat
        ),
        prefixIcon: Icon(icon, color: _ink),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _fieldBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _fieldBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: _navy, width: 1.5),
        ),
      ),
    );
  }
}