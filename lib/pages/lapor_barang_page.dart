import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/barang_service.dart';
import 'home_page.dart';
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
  bool _mengirim = false;

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
    setState(() => _waktu =
        DateTime(d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0));
  }

  void _pesan(String t) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  /// Simpan laporan ke Firestore (koleksi "barang"), lalu tampilkan layar sukses.
  Future<void> _kirim() async {
    if (_mengirim) return;
    if (_namaC.text.trim().isEmpty ||
        _tipe == null ||
        _lokasiC.text.trim().isEmpty ||
        _waktu == null) {
      _pesan('Lengkapi nama, tipe, lokasi, dan waktu terlebih dahulu');
      return;
    }
    setState(() => _mengirim = true);
    try {
      await BarangService().tambah(
        nama: _namaC.text.trim(),
        kategori: _kategori,
        tipe: _tipe!,
        lokasi: _lokasiC.text.trim(),
        waktu: _waktu!,
        detail: _detailC.text.trim(),
        foto: widget.foto,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SuksesPage(
            pesan: 'LAPORAN BERHASIL DITAMBAHKAN!',
            // laporan baru langsung terlihat di "Baru-baru ini dilaporkan"
            tujuan: (_) => const HomeScreen(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _mengirim = false);
      _pesan(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  InputDecoration _dekor(String hint) => InputDecoration(
        isDense: true,
        filled: true,
        fillColor: const Color(0xFFF7FAFE),
        hintText: hint,
        hintStyle: GoogleFonts.sourceSans3(
            fontSize: 13, color: Colors.grey.shade500),
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
            style: GoogleFonts.sourceSans3(
                fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
      );

  TextStyle get _isi => GoogleFonts.sourceSans3(fontSize: 15, color: _ink);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(26, 16, 26, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: _navy.withOpacity(0.6)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Image.memory(widget.foto,
                      width: double.infinity, height: 235, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),

              _label('Nama Barang'),
              TextField(
                controller: _namaC,
                style: GoogleFonts.sourceSans3(fontSize: 14),
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
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          dropdownColor: const Color(0xFFF7FAFE),
                          borderRadius: BorderRadius.circular(8),
                          style: _isi,
                          // tampilan saat tertutup: hanya teks
                          selectedItemBuilder: (_) => ['Hilang', 'Temuan']
                              .map((e) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(e, style: _isi)))
                              .toList(),
                          // tampilan saat terbuka: ada centang pada yang dipilih
                          items: ['Hilang', 'Temuan']
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(e, style: _isi)),
                                        if (e == _kategori)
                                          const Icon(Icons.check,
                                              size: 16, color: _navy),
                                      ],
                                    ),
                                  ))
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
                          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                          dropdownColor: const Color(0xFFF7FAFE),
                          borderRadius: BorderRadius.circular(8),
                          style: _isi,
                          hint: Text('Pilih Tipe', style: _isi),
                          selectedItemBuilder: (_) => _tipeList
                              .map((e) => Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(e.$1, style: _isi)))
                              .toList(),
                          items: _tipeList
                              .map((e) => DropdownMenuItem(
                                    value: e.$1,
                                    child: Row(
                                      children: [
                                        Icon(e.$2, size: 18, color: _navy),
                                        const SizedBox(width: 10),
                                        Text(e.$1, style: _isi),
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
                style: GoogleFonts.sourceSans3(fontSize: 14),
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
                    style: GoogleFonts.sourceSans3(
                        fontSize: 14,
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
                style: GoogleFonts.sourceSans3(fontSize: 14),
                decoration: _dekor('Warna, Merek, Fitur Unik...'),
              ),

              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          _mengirim ? null : () => Navigator.maybePop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _ink,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: _navy),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                      ),
                      child: Text('Batal',
                          style: GoogleFonts.sourceSans3(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _mengirim ? null : _kirim,
                      icon: _mengirim
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send_outlined, size: 18),
                      label: Text(_mengirim ? 'Mengirim...' : 'Kirim Laporan',
                          style: GoogleFonts.sourceSans3(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: _navy.withOpacity(0.7),
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
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