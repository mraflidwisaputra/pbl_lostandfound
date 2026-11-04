import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import 'login_page.dart';

/// Halaman awal untuk pengunjung yang belum login.
/// Barang yang ditemukan bisa dilihat, tetapi aksi klaim meminta login.
class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  // data contoh (tampilan saja) -> nanti diganti data dari database
  static const _semua = [
    ItemBarang(
        nama: 'Iphone 16 Pro Max',
        waktu: '2 Jam Yang Lalu',
        kategori: 'Ponsel',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: '',
        gambar: 'assets/images/iphone.png'),
    ItemBarang(
        nama: 'Dompet Kulit Hitam',
        waktu: '2 Jam Yang Lalu',
        kategori: 'Dompet',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: '',
        gambar: 'assets/images/dompet.png'),
    ItemBarang(
        nama: 'Kartu Debit BCA',
        waktu: '2 Jam Yang Lalu',
        kategori: 'Kartu',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: '',
        gambar: 'assets/images/kartu.png'),
    ItemBarang(
        nama: 'Kunci Motor Remote',
        waktu: '2 Jam Yang Lalu',
        kategori: 'Kunci',
        lokasi: 'Parkiran Gojah Mada',
        deskripsi: '',
        gambar: 'assets/images/kunci.png'),
  ];

  final _searchC = TextEditingController();
  String _query = '';
  String? _tipe; // null = semua

  static const _chips = [
    ('Dompet', Icons.account_balance_wallet_outlined),
    ('Ponsel', Icons.smartphone),
    ('Kunci', Icons.vpn_key_outlined),
    ('Kartu', Icons.credit_card),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  List<ItemBarang> _saring(List<ItemBarang> src) {
    final q = _query.toLowerCase().trim();
    return src.where((e) {
      final cocokNama = q.isEmpty || e.nama.toLowerCase().contains(q);
      final cocokTipe = _tipe == null || e.kategori == _tipe;
      return cocokNama && cocokTipe;
    }).toList();
  }

  void _keLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _butuhLogin() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        margin: const EdgeInsets.fromLTRB(26, 0, 26, 16),
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 22),
            Container(
              width: 52,
              height: 52,
              decoration:
                  const BoxDecoration(color: _navy, shape: BoxShape.circle),
              child: const Icon(Icons.lock, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 14),
            Text('Login Diperlukan',
                style: GoogleFonts.poppins(
                    fontSize: 21, fontWeight: FontWeight.w700, color: _ink)),
            const SizedBox(height: 8),
            Text(
                'Untuk mengajukan klaim barang,\nsilahkan login terlebih dahulu',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13, height: 1.35, color: _ink)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 38,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _keLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Login Sekarang',
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _ink,
                  side: const BorderSide(color: _navy),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('BATAL',
                    style: GoogleFonts.poppins(
                        fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _saring(_semua);
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _atas()),
            if (list.isEmpty)
              _pesan('Barang tidak ditemukan')
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(26, 8, 26, 32),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 218,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _kartu(list[i]),
                    childCount: list.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _pesan(String t, {bool error = false}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 0),
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
      padding: const EdgeInsets.fromLTRB(26, 24, 26, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('POLIBATAM\nLOST & FOUND',
                    style: GoogleFonts.poppins(
                        fontSize: 26,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: _ink)),
              ),
              Image.asset('assets/images/logo.png',
                  height: 62,
                  errorBuilder: (_, __, ___) =>
                      const SizedBox(height: 62, width: 62)),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                  fontSize: 14, height: 1.35, color: const Color(0xFF2C4F7C)),
              children: const [
                TextSpan(
                    text:
                        'Temukan Atau Laporkan barang hilang dan temuan di lingkungan '),
                TextSpan(
                    text: 'Polibatam!',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // kolom cari
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 22, right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: _navy.withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchC,
                    onChanged: (v) => setState(() => _query = v),
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Cari Barang...',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                      color: _navy, shape: BoxShape.circle),
                  child: const Icon(Icons.search,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // pencarian cepat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _chips.map((c) {
              final aktif = _tipe == c.$1;
              return GestureDetector(
                onTap: () => setState(() => _tipe = aktif ? null : c.$1),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
                  decoration: BoxDecoration(
                    color: aktif ? _navy : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: _navy),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(c.$2,
                          size: 17, color: aktif ? Colors.white : _navy),
                      const SizedBox(width: 6),
                      Text(c.$1,
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: aktif ? Colors.white : _ink)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _kartu(ItemBarang b) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _butuhLogin,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _navy.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 96,
                  width: double.infinity,
                  child: Image.asset(b.gambar,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade300)),
                ),
              ),
              const SizedBox(height: 8),
              Text(b.nama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _ink)),
              const SizedBox(height: 3),
              _meta(Icons.timer_outlined, b.waktu),
              const SizedBox(height: 2),
              _meta(Icons.location_on_outlined, b.lokasi),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 24,
                child: ElevatedButton(
                  onPressed: _butuhLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Detail',
                      style: GoogleFonts.poppins(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _meta(IconData icon, String t) {
    return Row(
      children: [
        Icon(icon, size: 11, color: _navy),
        const SizedBox(width: 4),
        Expanded(
          child: Text(t,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 9.5)),
        ),
      ],
    );
  }
}