import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_bottom_bar.dart';
import 'chat_page.dart';

class _RingkasanPesan {
  final String nama;
  final String pesanTerakhir;
  final String status; // contoh: "Dibaca 2 Menit Yang lalu" / "Terkirim"
  final String namaBarang;
  const _RingkasanPesan({
    required this.nama,
    required this.pesanTerakhir,
    required this.status,
    required this.namaBarang,
  });
}

class RiwayatPesanPage extends StatelessWidget {
  const RiwayatPesanPage({super.key});

  static const _navy = Color(0xFF0B4F7C);
  static const _bg = Color(0xFFEFF6FD);

  // data contoh -> ganti dengan data dari API/database
  static const _daftar = [
    _RingkasanPesan(
        nama: 'Admin',
        pesanTerakhir: 'Baik min',
        status: 'Dibaca 2 Menit Yang lalu',
        namaBarang: 'Jam Tangan Seiko'),
    _RingkasanPesan(
        nama: 'Admin',
        pesanTerakhir: 'Di Gedung Utama Pak',
        status: 'Dibaca 5 Menit Yang lalu',
        namaBarang: 'Kunci Motor Remote'),
    _RingkasanPesan(
        nama: 'Admin',
        pesanTerakhir: 'Siap pak',
        status: 'Terkirim',
        namaBarang: 'Iphone 16 Pro Max'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
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
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 44),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Riwayat Pesan',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F2A47))),
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: _daftar.isEmpty
                      ? Center(
                          child: Text('Belum ada pesan',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: Colors.grey.shade600)),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(44, 0, 44, 24),
                          itemCount: _daftar.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, i) =>
                              _kartu(context, _daftar[i]),
                        ),
                ),
                const AppBottomBar(currentIndex: 3),
              ],
            ),

            // tombol notifikasi
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
                      border: Border.all(color: _navy.withOpacity(0.5)),
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

  Widget _kartu(BuildContext context, _RingkasanPesan p) {
    return Material(
      color: _navy,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ChatPage(namaLawan: p.nama, namaBarang: p.namaBarang),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: const Color(0xFFD9D9D9),
                child: const Icon(Icons.person, size: 38, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(p.nama,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        Text(p.status,
                            style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(p.pesanTerakhir,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}