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
      title: 'Form Laporan Barang',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const FormLaporanBarangPage(),
    );
  }
}

// ==================== SUCCESS SCREEN ====================
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _lightBlue = Color(0xFFD6E5F7);
  static const Color _darkNavy = Color(0xFF0F2A47);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // Background decorative waves
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
                painter: WavePainter(),
              ),
            ),
          ),
          
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success circle with checkmark
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
                
                // Success text
                Text(
                  'LAPORAN BERHASIL DITAMBAHKAN!',
                  style: GoogleFonts.spaceMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Navigate back button
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to dashboard or home
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/dashboard',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    'Kembali ke Dashboard',
                    style: GoogleFonts.spaceMono(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom decorative waves
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

// Custom painter for top wave decoration
class WavePainter extends CustomPainter {
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

// Custom painter for bottom wave decoration
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

// ==================== FORM PAGE ====================
class FormLaporanBarangPage extends StatefulWidget {
  const FormLaporanBarangPage({super.key});

  @override
  State<FormLaporanBarangPage> createState() => _FormLaporanBarangPageState();
}

class _FormLaporanBarangPageState extends State<FormLaporanBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _waktuController = TextEditingController();
  final _detailController = TextEditingController();
  
  String? _selectedKategori;
  String? _selectedTipe;
  
  final List<String> _kategoriOptions = ['Temuan', 'Hilang'];
  final List<String> _tipeOptions = ['Kunci', 'Kartu', 'Dompet'];

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _mediumNavy = Color(0xFF2C4F7C);
  static const Color _selectedBg = Color(0xFFC9D3F5);

  @override
  void dispose() {
    _namaController.dispose();
    _lokasiController.dispose();
    _waktuController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: _navy,
          ),
        ),
      );

      // Simulate API call or data processing
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context); // Hide loading
        // Navigate to success screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Image
                _buildHeaderImage(),
                const SizedBox(height: 24),

                // Nama Barang
                _buildLabel('Nama Barang'),
                const SizedBox(height: 8),
                _buildTextField(_namaController, 'Masukkan Nama Barang...'),
                const SizedBox(height: 20),

                // Kategori dan Tipe Barang (Row)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Kategori'),
                          const SizedBox(height: 8),
                          _buildDropdown(
                            _selectedKategori,
                            _kategoriOptions,
                            'Pilih Kategori',
                            (value) => setState(() => _selectedKategori = value),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Tipe Barang'),
                          const SizedBox(height: 8),
                          _buildDropdownWithIcons(
                            _selectedTipe,
                            _tipeOptions,
                            'Pilih Tipe',
                            (value) => setState(() => _selectedTipe = value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Lokasi Barang Ditemukan
                _buildLabel('Lokasi Barang Ditemukan'),
                const SizedBox(height: 8),
                _buildTextField(_lokasiController, 'Masukkan Nama Lokasi...'),
                const SizedBox(height: 20),

                // Waktu Ditemukan
                _buildLabel('Waktu Ditemukan'),
                const SizedBox(height: 8),
                _buildTextField(_waktuController, 'Masukkan Waktu...'),
                const SizedBox(height: 20),

                // Detail Barang
                _buildLabel('Detail Barang'),
                const SizedBox(height: 8),
                _buildTextArea(_detailController, 'Warna, Merek, Fitur Unik...'),
                const SizedBox(height: 40),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildCancelButton(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: _buildSubmitButton(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _navy.withOpacity(0.4)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          'https://images.unsplash.com/photo-1558002038-1055907df827?w=800&h=400&fit=crop',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: _selectedBg,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.key, size: 64, color: _navy.withOpacity(0.6)),
                  const SizedBox(height: 8),
                  Text(
                    'Foto Barang',
                    style: GoogleFonts.inter(
                      color: _mediumNavy,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceMono(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: _darkNavy,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTextArea(TextEditingController controller, String hint) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey.shade500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, String hint, Function(String?) onChanged) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _navy,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: _navy,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownWithIcons(String? value, List<String> items, String hint, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Row(
          children: [
            Icon(Icons.list, size: 18, color: _navy),
            const SizedBox(width: 8),
            Text(
              hint,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        items: [
          DropdownMenuItem<String>(
            value: null,
            enabled: false,
            child: Row(
              children: [
                Icon(Icons.key, size: 18, color: _navy),
                const SizedBox(width: 8),
                Text(
                  'Kunci',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Kunci',
            child: Row(
              children: [
                Icon(Icons.key, size: 18, color: _navy),
                const SizedBox(width: 8),
                Text(
                  'Kunci',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Kartu',
            child: Row(
              children: [
                Icon(Icons.credit_card, size: 18, color: _navy),
                const SizedBox(width: 8),
                Text(
                  'Kartu',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'Dompet',
            child: Row(
              children: [
                Icon(Icons.wallet, size: 18, color: _navy),
                const SizedBox(width: 8),
                Text(
                  'Dompet',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _navy,
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: onChanged,
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: _navy,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _navy.withOpacity(0.6)),
      ),
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'BATAL',
          style: GoogleFonts.spaceMono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _navy,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 48,
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
      child: TextButton(
        onPressed: _submitForm,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.send,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              'Kirim Laporan',
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}