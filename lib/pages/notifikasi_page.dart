import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class _Notif {
  final IconData ikon;
  final String judul;
  final String isi;
  final String waktu;
  const _Notif(this.ikon, this.judul, this.isi, this.waktu);
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  // data contoh -> ganti dengan data dari server
  static const _daftar = [
    _Notif(Icons.search, 'Barang yang mirip dengan laporan anda ditemukan!',
        'Dompet hitam sudah berada di pos pamdal', '3 Menit Yang lalu'),
    _Notif(Icons.assignment_outlined,
        'Laporan Kehilangan Barang Anda Sudah Diterima',
        'Menunggu Proses Verifikasi', '15 Menit Yang lalu'),
    _Notif(Icons.verified_outlined, 'Klaim Anda Disetujui',
        'Silahkan Ambil Barang Di Pos Pamdal', '5 Menit Yang lalu'),
    _Notif(Icons.chat_bubble_outline, 'Pesan Baru Dari Admin',
        'Kami menemukan barang yang sesuai dengan laporan anda',
        '2 Jam Yang Lalu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28, color: _ink),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(width: 4),
                  Text('Notifikasi',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: _ink)),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: _daftar.isEmpty
                  ? Center(
                      child: Text('Belum ada notifikasi',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey.shade600)))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(50, 0, 50, 24),
                      itemCount: _daftar.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _kartu(_daftar[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kartu(_Notif n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _navy.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration:
                const BoxDecoration(color: _navy, shape: BoxShape.circle),
            child: Icon(n.ikon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.judul,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: _ink)),
                const SizedBox(height: 4),
                Text(n.isi,
                    style: GoogleFonts.inter(fontSize: 11, color: _ink)),
                const SizedBox(height: 4),
                Text(n.waktu,
                    style: GoogleFonts.inter(fontSize: 11, color: _ink)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}