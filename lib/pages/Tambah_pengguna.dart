import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tambah Pengguna',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const TambahPenggunaPage(),
    );
  }
}

// =====================================================================
//  HALAMAN TAMBAH PENGGUNA
// =====================================================================
class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _mediumNavy = Color(0xFF2C4F7C);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedPeran = '';
  String _selectedKategori = '';
  String _selectedJurusan = 'Teknik Informatika';
  String _selectedProdi = 'D-3 Teknik Informatika';

  final List<String> _peranOptions = ['Divitas Akademik', 'Admin'];
  final List<String> _kategoriOptions = ['Mahasiswa', 'Dosen', 'Staff Kampus'];
  final List<String> _jurusanOptions = [
    'Teknik Informatika',
    'Teknik Mesin',
    'Teknik Elektro',
    'Akuntansi'
  ];
  final List<String> _prodiOptions = [
    'D-3 Teknik Informatika',
    'S1 Teknik Informatika',
    'D4 Teknik Informatika'
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFormCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: _darkNavy,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Tambah Pengguna',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: _darkNavy,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // User Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            _buildLabel('Nama Lengkap'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _namaController,
              hint: 'Masukkan Nama Lengkap...',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('NIM/NIP/NIK'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nimController,
              hint: 'Contoh: 3312501106',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM/NIP/NIK harus diisi';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildLabel('Email'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'nama@polibatam.ac.id',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email harus diisi';
                }
                if (!value.contains('@')) {
                  return 'Email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            _buildLabel('Peran'),
            const SizedBox(height: 8),
            _buildButtonGroup(
              options: _peranOptions,
              selected: _selectedPeran,
              onTap: (value) => setState(() => _selectedPeran = value),
            ),
            const SizedBox(height: 16),

            _buildLabel('Kategori Divitas'),
            const SizedBox(height: 8),
            _buildButtonGroup(
              options: _kategoriOptions,
              selected: _selectedKategori,
              onTap: (value) => setState(() => _selectedKategori = value),
            ),
            const SizedBox(height: 16),

            _buildLabel('Jurusan'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedJurusan,
              items: _jurusanOptions,
              onChanged: (value) => setState(() => _selectedJurusan = value!),
            ),
            const SizedBox(height: 16),

            _buildLabel('Program Studi'),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedProdi,
              items: _prodiOptions,
              onChanged: (value) => setState(() => _selectedProdi = value!),
            ),
            const SizedBox(height: 16),

            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _passwordController,
              hint: 'Minimal 8 Karakter',
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password harus diisi';
                }
                if (value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: _buildButton(
                    text: 'BATAL',
                    color: Colors.white,
                    textColor: _navy,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildButton(
                    text: 'SIMPAN',
                    color: Colors.white,
                    textColor: _navy,
                    onTap: _handleSimpan,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.spaceMono(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: GoogleFonts.inter(fontSize: 13, color: _darkNavy),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500),
        ),
      ),
    );
  }

  Widget _buildButtonGroup({
    required List<String> options,
    required String selected,
    required Function(String) onTap,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selected == option;
        return GestureDetector(
          onTap: () => onTap(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? _navy : Colors.white.withOpacity(0.4),
                width: 1.5,
              ),
            ),
            child: Text(
              option,
              style: GoogleFonts.spaceMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? _navy : Colors.white,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(fontSize: 13, color: _darkNavy),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: _navy, size: 20),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  // ==================== HANDLE SIMPAN ====================
  void _handleSimpan() {
    if (_formKey.currentState!.validate()) {
      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: _navy),
        ),
      );

      // Simulasi proses simpan (1 detik)
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Tutup loading

        // Navigasi ke halaman sukses (replace agar tidak bisa kembali ke form)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuccessTambahPenggunaPage()),
        );
      });
    }
  }
}

// =====================================================================
//  HALAMAN SUKSES - PENGGUNA BERHASIL DITAMBAHKAN
// =====================================================================
class SuccessTambahPenggunaPage extends StatelessWidget {
  const SuccessTambahPenggunaPage({super.key});

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _lightBlue = Color(0xFFD6E5F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Dekorasi gelombang atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _lightBlue.withOpacity(0.6),
                    _lightBlue.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: TopWavePainter(),
              ),
            ),
          ),

          // Konten tengah
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon centang dalam lingkaran navy
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: _navy,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Teks sukses
                  Text(
                    'PENGGUNA BERHASIL DITAMBAHKAN !',
                    style: GoogleFonts.spaceMono(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _darkNavy,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // Tombol kembali ke halaman kelola pengguna
                  GestureDetector(
                    onTap: () {
                      // Kembali ke halaman sebelumnya (Kelola Pengguna)
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                        color: _navy,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _navy.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Kembali',
                            style: GoogleFonts.spaceMono(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dekorasi gelombang bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    _lightBlue.withOpacity(0.8),
                    _lightBlue.withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
              child: CustomPaint(
                painter: BottomWavePainter(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter untuk gelombang atas
class TopWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFD6E5F7).withOpacity(0.4)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.5,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter untuk gelombang bawah
class BottomWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFFD6E5F7).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.4,
      size.width * 0.5,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.6,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}