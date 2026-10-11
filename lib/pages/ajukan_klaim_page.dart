import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'klaim_status_page.dart';

class AjukanKlaimPage extends StatefulWidget {
  final String namaBarang;
  final String lokasiDitemukan;
  final String tanggalDitemukan;
  final String gambar;

  const AjukanKlaimPage({
    super.key,
    required this.namaBarang,
    this.lokasiDitemukan = '-',
    this.tanggalDitemukan = '-',
    this.gambar = '',
  });

  @override
  State<AjukanKlaimPage> createState() => _AjukanKlaimPageState();
}

class _AjukanKlaimPageState extends State<AjukanKlaimPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  final _ciriC = TextEditingController();
  final _lokasiC = TextEditingController();
  final _picker = ImagePicker();
  final List<Uint8List?> _bukti = [null, null, null];
  DateTime _tanggal = DateTime.now();

  String _format(DateTime d) => '${d.day} ${_bulan[d.month - 1]} ${d.year}';

  @override
  void dispose() {
    _ciriC.dispose();
    _lokasiC.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto(int index) async {
    final x = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    if (!mounted) return;
    setState(() => _bukti[index] = bytes);
  }

  Future<void> _pilihTanggal() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _tanggal = d);
  }

  void _kirim() {
    if (_ciriC.text.trim().isEmpty || _lokasiC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Isi ciri-ciri barang dan lokasi kehilangan')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KlaimStatusPage(
          // TODO: ganti dengan proses kirim data klaim ke server/database
          proses: Future.delayed(const Duration(seconds: 2)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28, color: _ink),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 4),
                  Text('Ajukan Klaim',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: _ink)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
                child: Column(
                  children: [
                    _kartuBarang(),
                    const SizedBox(height: 8),
                    _kartuInfo(),
                    const SizedBox(height: 12),
                    _kartuBukti(),
                    const SizedBox(height: 10),
                    _kartuKehilangan(),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.maybePop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _ink,
                              backgroundColor: Colors.white,
                              side: const BorderSide(color: _ink),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: Text('BATAL',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _kirim,
                            icon: const Icon(Icons.send_outlined, size: 18),
                            label: Text('Ajukan Klaim',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _kartu => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: _navy.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      );

  Widget _kartuBarang() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: _kartu,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: widget.gambar.isEmpty
                ? _placeholder(60)
                : Image.asset(widget.gambar,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(60)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.namaBarang,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
                const SizedBox(height: 6),
                _meta(Icons.location_on_outlined,
                    'Ditemukan Di ${widget.lokasiDitemukan}'),
                const SizedBox(height: 4),
                _meta(Icons.event_available_outlined, widget.tanggalDitemukan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(double s) => Container(
      width: s,
      height: s,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image_outlined));

  Widget _meta(IconData icon, String t) => Row(
        children: [
          Icon(icon, size: 12, color: _navy),
          const SizedBox(width: 4),
          Expanded(
              child: Text(t,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(fontSize: 10))),
        ],
      );

  Widget _judul(String t) => Text(t,
      style: GoogleFonts.poppins(
          fontSize: 13, fontWeight: FontWeight.w700, color: _ink));

  Widget _kartuInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _kartu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judul('Informasi Klaim'),
          const SizedBox(height: 6),
          Text('Jelaskan ciri-ciri khusus yang hanya diketahui anda.',
              style: GoogleFonts.inter(fontSize: 11, color: _ink)),
          const SizedBox(height: 10),
          TextField(
            controller: _ciriC,
            maxLines: 5,
            style: GoogleFonts.inter(fontSize: 12),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 8, right: 4, bottom: 70),
                child: Icon(Icons.edit_note, size: 18, color: _navy),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              hintText:
                  'Contoh: ada goresan kecil di samping, warna dial hijau, dan ada stiker kecil di belakang...',
              hintStyle: GoogleFonts.inter(
                  fontSize: 11, color: Colors.grey.shade500),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _navy),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kartuBukti() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _kartu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judul('Bukti Kepemilikan'),
          const SizedBox(height: 4),
          Text('Upload foto, identitas, atau bukti kepemilikan (opsional)',
              style: GoogleFonts.inter(fontSize: 10, color: _ink)),
          const SizedBox(height: 14),
          Row(
            children: List.generate(3, (i) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 10 : 0),
                  child: AspectRatio(aspectRatio: 1, child: _slotBukti(i)),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _slotBukti(int i) {
    final data = _bukti[i];
    if (data != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(data, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => setState(() => _bukti[i] = null),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    color: Colors.black87, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: () => _pilihFoto(i),
      child: CustomPaint(
        painter: _DashedRRectPainter(_navy),
        child: const Center(child: Icon(Icons.add, size: 32, color: _navy)),
      ),
    );
  }

  Widget _kartuKehilangan() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _kartu,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _judul('Kapan dan dimana  anda kehilangan?'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Icon(Icons.calendar_month_outlined,
                    size: 28, color: _navy),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    InkWell(
                      onTap: _pilihTanggal,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: _kotakInput,
                        child: Text(_format(_tanggal),
                            style: GoogleFonts.inter(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _lokasiC,
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Lokasi kehilangan',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 12, color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: _navy),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration get _kotakInput => BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
      );
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  _DashedRRectPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(8)));
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + 4), paint);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}