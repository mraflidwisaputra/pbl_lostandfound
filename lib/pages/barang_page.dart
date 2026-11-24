import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../services/barang_service.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/detail_barang_dialog.dart';
import '../widgets/foto_barang.dart';

class BarangPage extends StatefulWidget {
  /// Filter tipe awal (mis. dari tombol kategori di Beranda). null = Semua.
  final String? tipeAwal;
  const BarangPage({super.key, this.tipeAwal});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);
  static const _filterList = ['Semua', 'Dompet', 'Ponsel', 'Kunci', 'Kartu'];

  final _service = BarangService();
  // dibuat sekali agar tidak membaca ulang Firestore setiap ketikan
  late final _streamTemuan = _service.streamBarang('Temuan');
  late final _streamHilang = _service.streamBarang('Hilang');

  bool _temuan = true; // false = Hilang, true = Temuan
  String _query = '';
  late String? _tipe = widget.tipeAwal; // null = Semua

  List<ItemBarang> _saring(List<ItemBarang> src) {
    final q = _query.toLowerCase().trim();
    return src.where((e) {
      final cocokNama = q.isEmpty || e.nama.toLowerCase().contains(q);
      final cocokTipe = _tipe == null || e.kategori == _tipe;
      return cocokNama && cocokTipe;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // logo kiri atas
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/logo.png',
                    height: 60,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 60)),
              ),
            ),
            const SizedBox(height: 16),

            // toggle Hilang / Temuan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Container(
                height: 44,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _navy.withOpacity(0.6)),
                ),
                child: Row(
                  children: [
                    _toggle('HILANG', !_temuan,
                        () => setState(() => _temuan = false)),
                    _toggle('TEMUAN', _temuan,
                        () => setState(() => _temuan = true)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // cari + filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.sourceSans3(fontSize: 14),
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search, color: _ink),
                        hintText: _temuan
                            ? 'Cari Barang Temuan...'
                            : 'Cari Barang Hilang...',
                        hintStyle: GoogleFonts.sourceSans3(
                            fontSize: 14, color: Colors.grey.shade600),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: _navy.withOpacity(0.6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: _navy, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _filter(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: _navy.withOpacity(0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),

            // daftar barang (data langsung dari Firestore)
            Expanded(
              child: StreamBuilder<List<ItemBarang>>(
                stream: _temuan ? _streamTemuan : _streamHilang,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Gagal memuat data.\n${snap.error}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: Colors.red.shade700)),
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final list = _saring(snap.data!);
                  if (list.isEmpty) {
                    return Center(
                      child: Text('Barang tidak ditemukan',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey.shade600)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(36, 8, 36, 24),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _itemTile(list[i]),
                  );
                },
              ),
            ),
            const AppBottomBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _filter() {
    final aktif = _tipe != null;
    return PopupMenuButton<String>(
      onSelected: (v) => setState(() => _tipe = v == 'Semua' ? null : v),
      color: const Color(0xFFF7FAFE),
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _navy.withOpacity(0.6)),
      ),
      itemBuilder: (_) => _filterList
          .map((e) => PopupMenuItem<String>(
                value: e,
                height: 32,
                child: Center(
                  child: Text(e,
                      style: GoogleFonts.sourceSans3(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _ink)),
                ),
              ))
          .toList(),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: aktif ? const Color(0xFFC9D3F5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _navy.withOpacity(0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_outlined, size: 17, color: _ink),
            const SizedBox(width: 4),
            Text(_tipe ?? 'Filter',
                style: GoogleFonts.sourceSans3(
                    fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
          ],
        ),
      ),
    );
  }

  Widget _toggle(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _navy : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            style: GoogleFonts.sourceSans3(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: selected ? Colors.white : _ink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemTile(ItemBarang item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showDetailBarang(context, item),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FotoBarang(item.gambar,
                    width: 62,
                    height: 62,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 62,
                        height: 62,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_outlined))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _ink)),
                    const SizedBox(height: 4),
                    _meta(Icons.timer_outlined, item.waktu),
                    _meta(Icons.grid_view_rounded, item.kategori),
                    _meta(Icons.location_on_outlined, item.lokasi),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20, color: _ink),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 11, color: _navy),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceSans3(fontSize: 10, color: _ink)),
          ),
        ],
      ),
    );
  }
}