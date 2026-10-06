import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _navy = Color(0xFF0B4F7C);
  static const _bg = Color(0xFFEFF6FD);

  int _tab = 0; // 0 Cari, 1 Barang, 2 Pesan, 3 Profil
  final _searchC = TextEditingController();

  // data contoh -> nanti ganti dengan data dari API/database
  final _quick = const [
    (Icons.account_balance_wallet_outlined, 'Dompet'),
    (Icons.smartphone, 'Ponsel'),
    (Icons.vpn_key_outlined, 'Kunci'),
    (Icons.credit_card, 'Kartu'),
  ];

  final _recent = const [
    ('Iphone 16 Pro Max', '4 Jam Yang Lalu', 'Parkiran Gedung Utama',
        'assets/images/iphone.png'),
    ('Kunci Motor Remote', '2 Jam Yang Lalu', 'Parkiran Gojah Mada',
        'assets/images/kunci.png'),
    ('Jam Tangan Merek Seiko', '5 Jam Yang Lalu', 'Tangga Gedung Utama',
        'assets/images/jam.png'),
  ];

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  void _search(String q) {
    // TODO: arahkan ke halaman hasil pencarian
    debugPrint('Cari: $q');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 120),
              child: Column(
                children: [
                  Image.asset('assets/images/logo.png', height: 120),
                  const SizedBox(height: 24),
                  Text('SELAMAT DATANG',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F2A47))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('STARK!',
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C4F7C))),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.waving_hand_rounded,
                        size: 22,
                        color: Color(0xFF2C4F7C),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Cari barang Anda Yang hilang Disini',
                          style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2C4F7C))),
                      const SizedBox(width: 6),
                      const Icon(Icons.sentiment_satisfied_alt_outlined,
                          size: 18, color: Color(0xFF2C4F7C)),
                    ],
                  ),
                  const SizedBox(height: 36),

                  // kolom pencarian
                  Container(
                    height: 52,
                    padding: const EdgeInsets.only(left: 20, right: 8),
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
                            onSubmitted: _search,
                            style: GoogleFonts.inter(fontSize: 14),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Cari Barang...',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _search(_searchC.text),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                                color: _navy, shape: BoxShape.circle),
                            child: const Icon(Icons.search,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // pencarian cepat
                  Text('PENCARIAN CEPAT',
                      style: GoogleFonts.spaceMono(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: _quick
                        .map((q) => _quickChip(q.$1, q.$2))
                        .toList(),
                  ),
                  const SizedBox(height: 40),

                  // baru-baru ini dilaporkan
                  Text('BARU-BARU INI DILAPORKAN',
                      style: GoogleFonts.spaceMono(
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Row(
                    children: _recent
                        .map((r) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _itemCard(r.$1, r.$2, r.$3, r.$4),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // tombol notifikasi
            Positioned(
              right: 16,
              bottom: 100,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
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

            // bottom navigation custom
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: _bottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickChip(IconData icon, String label) {
    return InkWell(
      onTap: () => _search(label),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _navy),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: _navy),
            const SizedBox(width: 6),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _itemCard(String title, String time, String place, String image) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      width: 42, height: 42, color: Colors.grey.shade300)),
            ),
          ),
          const SizedBox(height: 10),
          Text(title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.spaceMono(
                  fontSize: 8.5, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          _meta(Icons.timer_outlined, time),
          const SizedBox(height: 4),
          _meta(Icons.location_on_outlined, place),
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: _navy),
        const SizedBox(width: 3),
        Expanded(
          child: Text(text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 6.5)),
        ),
      ],
    );
  }

  Widget _bottomBar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _navy.withOpacity(0.5)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(0, Icons.search, 'CARI'),
              _navItem(1, Icons.receipt_long_outlined, 'BARANG'),
              const SizedBox(width: 56), // ruang untuk tombol +
              _navItem(2, Icons.chat_bubble_outline, 'PESAN'),
              _navItem(3, Icons.person_outline, 'PROFIL'),
            ],
          ),
        ),
        Positioned(
          top: -20,
          child: GestureDetector(
            onTap: () {
              // TODO: buka halaman "Laporkan barang"
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _navy,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final selected = _tab == index;
    return GestureDetector(
      onTap: () => setState(() => _tab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC9D3F5) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: _navy),
            Text(label,
                style: GoogleFonts.spaceMono(
                    fontSize: 9, fontWeight: FontWeight.w700, color: _navy)),
          ],
        ),
      ),
    );
  }
}