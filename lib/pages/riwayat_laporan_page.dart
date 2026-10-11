import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bottom_bar.dart';

enum StatusLaporan { menunggu, diproses, selesai, dibatalkan }

extension StatusLaporanX on StatusLaporan {
  String get label {
    switch (this) {
      case StatusLaporan.menunggu:
        return 'Menunggu Verif';
      case StatusLaporan.diproses:
        return 'Diproses';
      case StatusLaporan.selesai:
        return 'Selesai';
      case StatusLaporan.dibatalkan:
        return 'Dibatalkan';
    }
  }

  Color get warna {
    switch (this) {
      case StatusLaporan.menunggu:
        return const Color(0xFFFFD84D);
      case StatusLaporan.diproses:
        return const Color(0xFF9CC9FF);
      case StatusLaporan.selesai:
        return const Color(0xFF5CF05C);
      case StatusLaporan.dibatalkan:
        return const Color(0xFFFF5C5C);
    }
  }
}

class _Laporan {
  final String nama;
  final String tanggal;
  final String lokasi;
  final String deskripsi;
  final String gambar;
  final StatusLaporan status;
  const _Laporan(this.nama, this.tanggal, this.lokasi, this.deskripsi,
      this.gambar, this.status);
}

class RiwayatLaporanPage extends StatefulWidget {
  const RiwayatLaporanPage({super.key});

  @override
  State<RiwayatLaporanPage> createState() => _RiwayatLaporanPageState();
}

class _RiwayatLaporanPageState extends State<RiwayatLaporanPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  // data contoh -> ganti dengan data dari API/database
  static const _semua = [
    _Laporan('Iphone 16 Pro Max', '10 Oktober 2026', 'Parkiran Gojah Mada',
        'iPhone casing ungu', 'assets/images/iphone.png', StatusLaporan.selesai),
    _Laporan('Dompet Kulit Hitam', '9 Oktober 2026', 'Kantin Gedung Utama',
        'Dompet berisi kartu', 'assets/images/dompet.png', StatusLaporan.selesai),
    _Laporan('Kartu Debit BCA', '8 Oktober 2026', 'Perpustakaan',
        'Kartu debit biru', 'assets/images/kartu.png', StatusLaporan.menunggu),
    _Laporan('Kunci Motor Remote', '7 Oktober 2026', 'Parkiran Gojah Mada',
        'Kunci dengan remote', 'assets/images/kunci.png', StatusLaporan.dibatalkan),
  ];

  StatusLaporan? _filter; // null = Semua
  String _query = '';

  List<_Laporan> get _tampil {
    return _semua.where((l) {
      final cocokStatus = _filter == null || l.status == _filter;
      final q = _query.toLowerCase().trim();
      final cocokCari = q.isEmpty ||
          l.nama.toLowerCase().contains(q) ||
          l.lokasi.toLowerCase().contains(q) ||
          l.tanggal.toLowerCase().contains(q) ||
          l.deskripsi.toLowerCase().contains(q);
      return cocokStatus && cocokCari;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final list = _tampil;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _header(),
                const SizedBox(height: 18),
                _pencarian(),
                const SizedBox(height: 14),
                _chips(),
                const SizedBox(height: 14),
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text('Laporan tidak ditemukan',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.grey.shade600)))
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => _kartu(list[i]),
                        ),
                ),
                const AppBottomBar(currentIndex: 2),
              ],
            ),
            Positioned(
              right: 18,
              bottom: 92,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2)),
                      ],
                    ),
                    child: const Icon(Icons.notifications_none, color: _navy),
                  ),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
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
              errorBuilder: (_, __, ___) => const SizedBox(height: 58, width: 58)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riwayat Laporan',
                    style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.w700, color: _ink)),
                Text('Lihat semua laporan kehilangan yang pernah anda buat.',
                    style: GoogleFonts.inter(fontSize: 11, color: _ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pencarian() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _navy.withOpacity(0.6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.inter(fontSize: 12),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        hintText: 'Cari berdasarkan nama barang, lokasi, tanggal, hari...',
                        hintStyle: GoogleFonts.inter(
                            fontSize: 11, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                        color: _navy, shape: BoxShape.circle),
                    child: const Icon(Icons.search,
                        size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                // TODO: buka filter tambahan (rentang tanggal, dll)
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: _ink,
                backgroundColor: Colors.white,
                side: BorderSide(color: _navy.withOpacity(0.6)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Filter',
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chips() {
    final items = <(String, StatusLaporan?)>[
      ('Semua', null),
      ('Menunggu\nVerifikasi', StatusLaporan.menunggu),
      ('Diproses', StatusLaporan.diproses),
      ('Selesai', StatusLaporan.selesai),
      ('Dibatalkan', StatusLaporan.dibatalkan),
    ];
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (label, st) = items[i];
          final aktif = _filter == st;
          return GestureDetector(
            onTap: () => setState(() => _filter = st),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: aktif ? _navy : Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: _navy.withOpacity(0.6)),
              ),
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      fontSize: label.contains('\n') ? 9 : 11,
                      height: 1.1,
                      color: aktif ? Colors.white : _ink)),
            ),
          );
        },
      ),
    );
  }

  Widget _kartu(_Laporan l) {
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
                child: Image.asset(l.gambar,
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
                      padding: const EdgeInsets.only(right: 80),
                      child: Text(l.nama,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _ink)),
                    ),
                    const SizedBox(height: 4),
                    _meta(Icons.event_busy_outlined, l.tanggal),
                    _meta(Icons.location_on_outlined, l.lokasi),
                    _meta(Icons.description_outlined, l.deskripsi),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 24,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: buka halaman detail laporan
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _ink,
                            backgroundColor: const Color(0xFFDCE9F8),
                            side: BorderSide(color: _navy.withOpacity(0.6)),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Lihat Detail',
                              style: GoogleFonts.poppins(fontSize: 10)),
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
                color: l.status.warna,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(l.status.label,
                  style: GoogleFonts.poppins(fontSize: 9, color: _ink)),
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
                style: GoogleFonts.inter(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}