import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'riwayat_laporan_page.dart';
import 'sukses_page.dart';

class LaporBarangPage extends StatefulWidget {
  final Uint8List foto;
  const LaporBarangPage({super.key, required this.foto});

  @override
  State<LaporBarangPage> createState() => _LaporBarangPageState();
}

class _LaporBarangPageState extends State<LaporBarangPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  static const _tipeList = [
    ('Kunci', Icons.vpn_key_outlined),
    ('Kartu', Icons.credit_card),
    ('Dompet', Icons.account_balance_wallet_outlined),
    ('Ponsel', Icons.smartphone),
    ('Lainnya', Icons.category_outlined),
  ];

  final _namaC = TextEditingController();
  final _lokasiC = TextEditingController();
  final _detailC = TextEditingController();
  String _kategori = 'Hilang'; // Hilang / Temuan
  String? _tipe;
  DateTime? _waktu;

  bool get _hilang => _kategori == 'Hilang';

  @override
  void dispose() {
    _namaC.dispose();
    _lokasiC.dispose();
    _detailC.dispose();
    super.dispose();
  }

  String _fmt(DateTime d) {
    final jam = d.hour.toString().padLeft(2, '0');
    final mnt = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${_bulan[d.month - 1]} ${d.year}, $jam:$mnt';
  }

  Future<void> _pilihWaktu() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _waktu ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (!mounted) return;
    setState(() =>
        _waktu = DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0));
  }

  void _kirim() {
    if (_namaC.text.trim().isEmpty ||
        _tipe == null ||
        _lokasiC.text.trim().isEmpty ||
        _waktu == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Lengkapi nama, tipe, lokasi, dan waktu terlebih dahulu')),
      );
      return;
    }
    // TODO: kirim data laporan (+ foto widget.foto) ke server/database
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SuksesPage(
          pesan: 'LAPORAN BERHASIL DITAMBAHKAN!',
          tujuan: (_) => const RiwayatLaporanPage(),
        ),
      ),
    );
  }

  InputDecoration _dekor(String hint) => InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle:
            GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _navy.withOpacity(0.6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _navy, width: 1.5),
        ),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 12),
        child: Text(t,
            style: GoogleFonts.poppins(
                fontSize: 12, fontWeight: FontWeight.w600, color: _ink)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: _ink),
        title: Text('Laporkan Barang',
            style: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.w600, color: _ink)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 4, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.memory(widget.foto,
                    width: double.infinity, height: 235, fit: BoxFit.cover),
              ),
              const SizedBox(height: 20),
              _label('Nama Barang'),
              TextField(
                controller: _namaC,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: _dekor('Masukkan Nama Barang...'),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Kategori'),
                        DropdownButtonFormField<String>(
                          value: _kategori,
                          isExpanded: true,
                          decoration: _dekor(''),
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: _ink),
                          items: const ['Hilang', 'Temuan']
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _kategori = v ?? 'Hilang'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Tipe Barang'),
                        DropdownButtonFormField<String>(
                          value: _tipe,
                          isExpanded: true,
                          decoration: _dekor(''),
                          hint: Text('Pilih Tipe',
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: _ink)),
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: _ink),
                          items: _tipeList
                              .map((e) => DropdownMenuItem(
                                    value: e.$1,
                                    child: Row(
                                      children: [
                                        Icon(e.$2, size: 18, color: _navy),
                                        const SizedBox(width: 8),
                                        Text(e.$1),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _tipe = v),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _label(_hilang ? 'Lokasi Barang Hilang' : 'Lokasi Barang Temuan'),
              TextField(
                controller: _lokasiC,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: _dekor('Masukkan Nama Lokasi...'),
              ),
              _label(_hilang ? 'Waktu Kehilangan' : 'Waktu Penemuan'),
              InkWell(
                onTap: _pilihWaktu,
                borderRadius: BorderRadius.circular(8),
                child: InputDecorator(
                  decoration: _dekor(''),
                  child: Text(
                    _waktu == null ? 'Pilih tanggal dan jam...' : _fmt(_waktu!),
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _waktu == null
                            ? Colors.grey.shade500
                            : Colors.black87),
                  ),
                ),
              ),
              _label('Detail Barang'),
              TextField(
                controller: _detailC,
                maxLines: 7,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: _dekor('Warna, Merek, Fitur Unik...'),
              ),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.maybePop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _ink,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: _navy),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                      ),
                      child: Text('BATAL',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _kirim,
                      icon: const Icon(Icons.send_outlined, size: 18),
                      label: Text('Kirim Laporan',
                          style: GoogleFonts.poppins(
                              fontSize: 14, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}