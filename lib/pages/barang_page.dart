import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../widgets/app_bottom_bar.dart';
import 'chat_page.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _bg = Color(0xFFEFF6FD);

  bool _temuan = true; // false = Hilang, true = Temuan
  String _query = '';

  // data contoh -> ganti dengan data dari API/database
  final List<ItemBarang> _dataTemuan = const [
    ItemBarang(
        nama: 'Iphone 16 Pro Max',
        waktu: '2 Jam Yang Lalu',
        kategori: 'Ponsel',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: 'Ditemukan iPhone casing ungu di dekat parkiran.',
        gambar: 'assets/images/iphone.png'),
    ItemBarang(
        nama: 'Dompet Kulit Hitam',
        waktu: '3 Jam Yang Lalu',
        kategori: 'Dompet',
        lokasi: 'Kantin Gedung Utama',
        deskripsi: 'Dompet kulit hitam berisi beberapa kartu.',
        gambar: 'assets/images/dompet.png'),
    ItemBarang(
        nama: 'Kartu Debit BCA',
        waktu: '4 Jam Yang Lalu',
        kategori: 'Kartu',
        lokasi: 'Perpustakaan',
        deskripsi: 'Kartu debit BCA berwarna biru.',
        gambar: 'assets/images/kartu.png'),
    ItemBarang(
        nama: 'Kunci Motor Remote',
        waktu: '5 Jam Yang Lalu',
        kategori: 'Kunci',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: 'Kunci motor dengan remote dan gantungan.',
        gambar: 'assets/images/kunci.png'),
    ItemBarang(
        nama: 'Jam Tangan Seiko',
        waktu: '6 Jam Yang Lalu',
        kategori: 'Aksesoris',
        lokasi: 'Tangga Gedung Utama',
        deskripsi: 'Jam tangan Seiko dial hijau tosca.',
        gambar: 'assets/images/jam.png'),
  ];

  final List<ItemBarang> _dataHilang = const [
    ItemBarang(
        nama: 'Tumbler Biru',
        waktu: '1 Jam Yang Lalu',
        kategori: 'Lainnya',
        lokasi: 'Lab Komputer',
        deskripsi: 'Tumbler biru tertinggal di meja lab.',
        gambar: 'assets/images/tumbler.png',
        pemosting: 'Mahasiswa'),
  ];

  List<ItemBarang> get _filtered {
    final src = _temuan ? _dataTemuan : _dataHilang;
    if (_query.trim().isEmpty) return src;
    return src
        .where((e) => e.nama.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void _showDetail(ItemBarang item) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (_, __, ___) => _DetailDialog(item: item),
      transitionBuilder: (_, anim, __, child) => FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // logo kiri atas
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset('assets/images/logo.png',
                        height: 60,
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(height: 60)),
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
                        _toggle('HILANG', !_temuan, () {
                          setState(() => _temuan = false);
                        }),
                        _toggle('TEMUAN', _temuan, () {
                          setState(() => _temuan = true);
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon:
                          const Icon(Icons.search, color: Color(0xFF0F2A47)),
                      hintText: _temuan
                          ? 'Cari Barang Temuan...'
                          : 'Cari Barang Hilang...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: Colors.grey.shade600),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: _navy.withOpacity(0.6)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _navy, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: _navy.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // daftar barang
                Expanded(
                  child: list.isEmpty
                      ? Center(
                          child: Text('Barang tidak ditemukan',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.grey.shade600)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(36, 8, 36, 24),
                          itemCount: list.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) => _itemTile(list[i]),
                        ),
                ),
                AppBottomBar(currentIndex: 1),
              ],
            ),

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
            style: GoogleFonts.spaceMono(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF0F2A47),
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
        onTap: () => _showDetail(item),
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
                child: Image.asset(
                  item.gambar,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_outlined)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nama,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F2A47))),
                    const SizedBox(height: 4),
                    _meta(Icons.timer_outlined, item.waktu),
                    _meta(Icons.grid_view_rounded, item.kategori),
                    _meta(Icons.location_on_outlined, item.lokasi),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, size: 20),
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
                style: GoogleFonts.inter(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}

/// Popup detail barang dengan latar blur.
class _DetailDialog extends StatelessWidget {
  final ItemBarang item;
  const _DetailDialog({required this.item});

  static const _navy = Color(0xFF0B4F7C);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // latar blur, ketuk untuk menutup
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.white.withOpacity(0.15)),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // gambar + tombol X
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(6)),
                    child: Stack(
                      children: [
                        Image.asset(
                          item.gambar,
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              height: 220,
                              color: Colors.grey.shade400,
                              child: const Center(
                                  child: Icon(Icons.image_outlined, size: 48))),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                  color: Colors.black87, shape: BoxShape.circle),
                              child: const Icon(Icons.close,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // isi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE9F8),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(6)),
                      border: Border.all(color: const Color(0xFF8F9BD6)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.nama,
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F2A47))),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: _navy),
                            const SizedBox(width: 4),
                            Text(item.lokasi,
                                style: GoogleFonts.inter(
                                    fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(item.deskripsi,
                            style: GoogleFonts.inter(
                                fontSize: 12, color: const Color(0xFF0F2A47))),
                        const SizedBox(height: 22),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _navy),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Icon(Icons.person,
                                      size: 18, color: Colors.white),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Diposting Oleh',
                                        style: GoogleFonts.inter(fontSize: 9)),
                                    Text(item.pemosting,
                                        style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                                const SizedBox(width: 24),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChatPage(
                                    namaLawan: item.pemosting,
                                    namaBarang: item.nama,
                                    barang: item,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline,
                                size: 14),
                            label: Text('KIRIM PESAN',
                                style: GoogleFonts.spaceMono(
                                    fontSize: 11, fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _navy,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}