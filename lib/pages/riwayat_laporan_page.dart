import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/barang_service.dart';
import '../services/klaim_service.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/detail_barang_dialog.dart';
import '../widgets/foto_barang.dart';

/// Riwayat Laporan dan Klaim milik pengguna (data dari Firestore).
class RiwayatLaporanPage extends StatefulWidget {
  /// true = langsung membuka tab KLAIM (mis. setelah mengajukan klaim)
  final bool tabKlaim;
  const RiwayatLaporanPage({super.key, this.tabKlaim = false});

  @override
  State<RiwayatLaporanPage> createState() => _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);
  static const _hijau = Color(0xFF5CF05C);
  static const _kuning = Color(0xFFFFD84D);
  static const _biru = Color(0xFF9CC9FF);
  static const _merah = Color(0xFFFF5C5C);
  static const _bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  // dibuat sekali agar tidak membaca ulang Firestore tiap ketikan
  late final Stream<List<LaporanSaya>> _streamLaporan =
      BarangService().streamSaya();
  late final Stream<List<KlaimSaya>> _streamKlaim = KlaimService().streamSaya();

  final _searchC = TextEditingController();
  late bool _klaim = widget.tabKlaim; // false = LAPORAN, true = KLAIM
  String _query = '';
  String? _filterLaporan; // null = Semua, "belum", "selesai"
  String? _filterKlaim; // null = Semua, "menunggu", "diproses", "selesai", "dibatalkan"

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  String _tgl(DateTime? d) =>
      d == null ? '-' : '${d.day} ${_bulan[d.month - 1]} ${d.year}';

  bool _cocok(List<String> bidang) {
    final q = _query.toLowerCase().trim();
    return q.isEmpty || bidang.any((e) => e.toLowerCase().contains(q));
  }

  void _gantiTab(bool klaim) {
    setState(() {
      _klaim = klaim;
      _query = '';
      _searchC.clear();
    });
  }

  // ---------- label & warna status ----------
  (String, Color) _badgeLaporan(LaporanSaya l) {
    if (l.status == 'selesai') return ('Selesai', _hijau);
    return (l.item.jenis == 'Temuan' ? 'Belum Diambil' : 'Belum Ditemukan', _kuning);
  }

  (String, Color) _badgeKlaim(String s) {
    switch (s) {
      case 'diproses':
        return ('Diproses', _biru);
      case 'selesai':
        return ('Selesai', _hijau);
      case 'dibatalkan':
        return ('Dibatalkan', _merah);
      default:
        return ('Menunggu Verif', _kuning);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 20),
            _toggle(),
            const SizedBox(height: 18),
            _pencarian(),
            if (_klaim) ...[
              const SizedBox(height: 12),
              _chips(),
            ],
            const SizedBox(height: 12),
            Expanded(child: _klaim ? _daftarKlaim() : _daftarLaporan()),
            const AppBottomBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/logo.png',
              height: 58,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 58, width: 58)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riwayat Laporan Dan Klaim',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 24, fontWeight: FontWeight.w800, color: _ink)),
                Text(
                    'Lihat semua riwayat laporan dan klaim yang pernah anda buat dan ajukan.',
                    style: GoogleFonts.sourceSans3(fontSize: 13, color: _ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggle() {
    Widget item(String label, bool aktif, VoidCallback onTap) => Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aktif ? _navy : Colors.transparent,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Text(label,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: aktif ? Colors.white : _ink)),
            ),
          ),
        );

    return Padding(
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
            item('LAPORAN', !_klaim, () => _gantiTab(false)),
            item('KLAIM', _klaim, () => _gantiTab(true)),
          ],
        ),
      ),
    );
  }

  Widget _pencarian() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _navy.withOpacity(0.6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchC,
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.sourceSans3(fontSize: 13),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Cari berdasarkan nama barang, lokasi, tanggal...',
                        hintStyle: GoogleFonts.sourceSans3(
                            fontSize: 12.5, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                        color: _navy, borderRadius: BorderRadius.circular(17)),
                    child: const Icon(Icons.search, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          if (!_klaim) ...[
            const SizedBox(width: 8),
            _filterLaporanBtn(),
          ],
        ],
      ),
    );
  }

  Widget _filterLaporanBtn() {
    const opsi = [
      ('Semua', null),
      ('Belum Ditemukan', 'belum'),
      ('Selesai', 'selesai'),
    ];
    final aktif = _filterLaporan != null;
    return PopupMenuButton<String?>(
      onSelected: (v) => setState(() => _filterLaporan = v),
      color: const Color(0xFFF7FAFE),
      offset: const Offset(0, 46),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: _navy.withOpacity(0.6)),
      ),
      itemBuilder: (_) => opsi
          .map((o) => PopupMenuItem<String?>(
                value: o.$2,
                height: 32,
                child: Center(
                  child: Text(o.$1,
                      style: GoogleFonts.sourceSans3(
                          fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
                ),
              ))
          .toList(),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: aktif ? const Color(0xFFC9D3F5) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _navy.withOpacity(0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.filter_alt_outlined, size: 17, color: _ink),
            const SizedBox(width: 4),
            Text('Filter',
                style: GoogleFonts.sourceSans3(
                    fontSize: 13, fontWeight: FontWeight.w800, color: _ink)),
          ],
        ),
      ),
    );
  }

  Widget _chips() {
    const items = <(String, IconData, String?)>[
      ('Semua', Icons.view_headline, null),
      ('Menunggu\nVerifikasi', Icons.schedule, 'menunggu'),
      ('Diproses', Icons.mode_comment_outlined, 'diproses'),
      ('Selesai', Icons.check_circle_outline, 'selesai'),
      ('Dibatalkan', Icons.stop_circle_outlined, 'dibatalkan'),
    ];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (label, ikon, st) = items[i];
          final aktif = _filterKlaim == st;
          return GestureDetector(
            onTap: () => setState(() => _filterKlaim = st),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: aktif ? _navy : Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: _navy.withOpacity(0.6)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(ikon, size: 14, color: aktif ? Colors.white : _ink),
                  const SizedBox(width: 4),
                  Text(label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.sourceSans3(
                          fontSize: label.contains('\n') ? 9.5 : 11.5,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          color: aktif ? Colors.white : _ink)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- daftar ----------
  Widget _daftarLaporan() {
    return StreamBuilder<List<LaporanSaya>>(
      stream: _streamLaporan,
      builder: (context, snap) {
        if (snap.hasError) return _error(snap.error);
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final list = snap.data!.where((l) {
          if (_filterLaporan == 'selesai' && l.status != 'selesai') return false;
          if (_filterLaporan == 'belum' && l.status == 'selesai') return false;
          return _cocok([l.item.nama, l.item.lokasi, l.item.deskripsi, _tgl(l.tanggal)]);
        }).toList();
        if (list.isEmpty) return _kosong('Belum ada laporan');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final l = list[i];
            final b = _badgeLaporan(l);
            return _kartu(
              gambar: l.item.gambar,
              nama: l.item.nama,
              tanggal: _tgl(l.tanggal),
              lokasi: l.item.lokasi,
              deskripsi: l.item.deskripsi.isEmpty ? '-' : l.item.deskripsi,
              label: b.$1,
              warna: b.$2,
              onDetail: () => showDetailBarang(context, l.item),
            );
          },
        );
      },
    );
  }

  Widget _daftarKlaim() {
    return StreamBuilder<List<KlaimSaya>>(
      stream: _streamKlaim,
      builder: (context, snap) {
        if (snap.hasError) return _error(snap.error);
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final list = snap.data!.where((k) {
          if (_filterKlaim != null && k.status != _filterKlaim) return false;
          return _cocok([k.barangNama, k.lokasi, k.ciri, _tgl(k.kapan)]);
        }).toList();
        if (list.isEmpty) return _kosong('Belum ada klaim');
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final k = list[i];
            final b = _badgeKlaim(k.status);
            return _kartu(
              gambar: k.foto,
              nama: k.barangNama,
              tanggal: _tgl(k.kapan),
              lokasi: k.lokasi,
              deskripsi: k.ciri.isEmpty ? '-' : k.ciri,
              label: b.$1,
              warna: b.$2,
              onDetail: () => _detailKlaim(k),
            );
          },
        );
      },
    );
  }

  Widget _kosong(String t) => Center(
        child: Text(t,
            style: GoogleFonts.sourceSans3(
                fontSize: 15, color: Colors.grey.shade600)),
      );

  Widget _error(Object? e) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Gagal memuat data.\n$e',
              textAlign: TextAlign.center,
              style: GoogleFonts.sourceSans3(
                  fontSize: 13, color: Colors.red.shade700)),
        ),
      );

  // ---------- kartu ----------
  Widget _kartu({
    required String gambar,
    required String nama,
    required String tanggal,
    required String lokasi,
    required String deskripsi,
    required String label,
    required Color warna,
    required VoidCallback onDetail,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FotoBarang(gambar,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 76,
                        height: 76,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_outlined))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 84),
                      child: Text(nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.sourceSans3(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: _ink)),
                    ),
                    const SizedBox(height: 4),
                    _meta(Icons.event_busy_outlined, tanggal),
                    _meta(Icons.location_on_outlined, lokasi),
                    _meta(Icons.description_outlined, deskripsi),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 24,
                        child: OutlinedButton(
                          onPressed: onDetail,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink,
                            backgroundColor: const Color(0xFFDCE9F8),
                            side: BorderSide(color: _navy.withOpacity(0.6)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Lihat Detail',
                              style: GoogleFonts.sourceSans3(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: warna, borderRadius: BorderRadius.circular(3)),
              child: Text(label,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 10, fontWeight: FontWeight.w600, color: _ink)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String t) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Icon(icon, size: 12, color: _navy),
          const SizedBox(width: 4),
          Expanded(
            child: Text(t,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.sourceSans3(fontSize: 11, color: _ink)),
          ),
        ],
      ),
    );
  }

  // ---------- detail klaim ----------
  void _detailKlaim(KlaimSaya k) {
    final b = _badgeKlaim(k.status);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: const Color(0xFFF7FAFE),
        insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(k.barangNama,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _ink)),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: b.$2, borderRadius: BorderRadius.circular(3)),
                    child: Text(b.$1,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _baris('Tanggal kehilangan', _tgl(k.kapan)),
              _baris('Lokasi kehilangan', k.lokasi),
              _baris('Ciri-ciri barang', k.ciri.isEmpty ? '-' : k.ciri),
              _baris('Diajukan pada', _tgl(k.dibuat)),
              if (k.bukti.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Bukti kepemilikan',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 12, fontWeight: FontWeight.w800, color: _ink)),
                const SizedBox(height: 6),
                Row(
                  children: k.bukti
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FotoBarang(e,
                                  width: 70, height: 70, fit: BoxFit.cover),
                            ),
                          ))
                      .toList(),
                ),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('Tutup',
                      style: GoogleFonts.sourceSans3(
                          fontWeight: FontWeight.w800, color: _navy)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baris(String label, String isi) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.sourceSans3(
                    fontSize: 12, fontWeight: FontWeight.w800, color: _ink)),
            Text(isi,
                style: GoogleFonts.sourceSans3(fontSize: 14, color: _ink)),
          ],
        ),
      );
}