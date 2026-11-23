import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../services/auth_service.dart';
import '../services/barang_service.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/detail_barang_dialog.dart';
import '../widgets/foto_barang.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _biru = Color(0xFF2C4F7C);
  static const _bg = Color(0xFFEFF6FD);

  // dibuat sekali agar tidak membaca ulang Firestore setiap rebuild
  late final Future<String> _nama = AuthService().namaPengguna();
  late final Stream<List<ItemBarang>> _stream =
      BarangService().streamTerbaru(batas: 12);

  static const _kategori = [
    ('Dompet', Icons.account_balance_wallet_outlined),
    ('Ponsel', Icons.smartphone),
    ('Kunci', Icons.vpn_key_outlined),
    ('Kartu', Icons.credit_card),
  ];

  String? _tipe; // kategori terpilih, null = semua

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ItemBarang>>(
                stream: _stream,
                builder: (context, snap) {
                  final semua = snap.data ?? const <ItemBarang>[];
                  // tanpa filter: 4 terbaru; dengan filter: yang cocok kategori
                  final list = _tipe == null
                      ? semua.take(4).toList()
                      : semua.where((e) => e.kategori == _tipe).take(6).toList();
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: _atas()),
                      if (snap.hasError)
                        _pesan('Gagal memuat data.\n${snap.error}',
                            error: true)
                      else if (!snap.hasData)
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(top: 32),
                            child:
                                Center(child: CircularProgressIndicator()),
                          ),
                        )
                      else if (list.isEmpty)
                        _pesan(_tipe == null
                            ? 'Belum ada laporan'
                            : 'Belum ada laporan $_tipe')
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(56, 0, 56, 24),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 18,
                              mainAxisExtent: 170,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (_, i) => _kartu(list[i]),
                              childCount: list.length,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const AppBottomBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _pesan(String t, {bool error = false}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Text(t,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 13,
                color: error ? Colors.red.shade700 : Colors.grey.shade600)),
      ),
    );
  }

  Widget _atas() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
      child: Column(
        children: [
          Image.asset('assets/images/logo.png',
              height: 118,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(height: 118, width: 118)),
          const SizedBox(height: 22),
          Text('SELAMAT DATANG',
              style: GoogleFonts.sourceSans3(
                  fontSize: 26, fontWeight: FontWeight.w800, color: _ink)),
          FutureBuilder<String>(
            future: _nama,
            builder: (_, s) {
              final n = (s.data ?? '').toUpperCase();
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(n.isEmpty ? ' ' : '$n!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: _biru)),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.waving_hand_rounded,
                      size: 22, color: _biru),
                ],
              );
            },
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text('Cari barang Anda Yang hilang Disini',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _biru)),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.sentiment_satisfied_alt_outlined,
                  size: 18, color: _biru),
            ],
          ),
          const SizedBox(height: 34),
          Text('TELUSURI KATEGORI',
              style: GoogleFonts.sourceSans3(
                  fontSize: 17, fontWeight: FontWeight.w800, color: _ink)),
          const SizedBox(height: 16),
          Row(
            children: _kategori.map((c) {
              final aktif = _tipe == c.$1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () => setState(() => _tipe = aktif ? null : c.$1),
                    borderRadius: BorderRadius.circular(10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color: aktif ? _navy : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _navy),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(c.$2,
                                size: 15,
                                color: aktif ? Colors.white : _navy),
                            const SizedBox(width: 4),
                            Text(c.$1,
                                style: GoogleFonts.sourceSans3(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: aktif ? Colors.white : _ink)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 34),
          Text('BARU-BARU INI DILAPORKAN',
              style: GoogleFonts.sourceSans3(
                  fontSize: 17, fontWeight: FontWeight.w800, color: _ink)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _kartu(ItemBarang b) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => showDetailBarang(context, b),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _navy.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 84,
                  width: double.infinity,
                  child: FotoBarang(b.gambar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 8),
              Text(b.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.sourceSans3(
                      fontSize: 13, fontWeight: FontWeight.w800, color: _ink)),
              const SizedBox(height: 4),
              _meta(Icons.timer_outlined, b.waktu),
              const SizedBox(height: 3),
              _meta(Icons.location_on_outlined, b.lokasi),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String t) {
    return Row(
      children: [
        Icon(icon, size: 12, color: _navy),
        const SizedBox(width: 4),
        Expanded(
          child: Text(t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.sourceSans3(fontSize: 10, color: _biru)),
        ),
      ],
    );
  }
}