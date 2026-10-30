import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notifikasi',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEFF6FD),
        useMaterial3: true,
      ),
      home: const NotifikasiPage(),
    );
  }
}

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  static const Color _navy = Color(0xFF0B4F7C);
  static const Color _bg = Color(0xFFEFF6FD);
  static const Color _darkNavy = Color(0xFF0F2A47);
  static const Color _mediumNavy = Color(0xFF2C4F7C);

  // Data notifikasi (icon null = lingkaran polos)
  static const List<Map<String, Object?>> _notifikasiList = [
    {
      'judul': 'Barang yang mirip dengan laporan anda ditemukan!',
      'isi': 'Dompet Kitam sudah berada di pos pamdal',
      'waktu': '3 Menit Yang lalu',
      'icon': null,
    },
    {
      'judul': 'Laporan Kehilangan Barang Anda Sudah Diterima',
      'isi': 'Menunggu Proses Verifikasi',
      'waktu': '15 Menit Yang lalu',
      'icon': null,
    },
    {
      'judul': 'Klaim Anda Disetujui',
      'isi': 'Silahkan Ambil Barang Di Pos Pamdal',
      'waktu': '6 Menit Yang lalu',
      'icon': Icons.check_circle_outline,
    },
    {
      'judul': 'Pesan Baru Dari Admin',
      'isi': 'Kami menemukan barang yang sesuai dengan laporan anda',
      'waktu': '2 Jam Yang Lalu',
      'icon': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: _notifikasiList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final item = _notifikasiList[index];
                  return _buildNotifCard(
                    judul: item['judul'] as String,
                    isi: item['isi'] as String,
                    waktu: item['waktu'] as String,
                    icon: item['icon'] as IconData?,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== HEADER ====================
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back, color: _darkNavy, size: 26),
          ),
          const SizedBox(width: 12),
          Text(
            'Notifikasi',
            style: GoogleFonts.spaceMono(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _darkNavy,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== KARTU NOTIFIKASI ====================
  Widget _buildNotifCard({
    required String judul,
    required String isi,
    required String waktu,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _navy.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lingkaran ikon
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _navy,
              shape: BoxShape.circle,
            ),
            child: icon != null
                ? Icon(icon, color: Colors.white, size: 20)
                : null,
          ),
          const SizedBox(width: 14),

          // Teks notifikasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: GoogleFonts.spaceMono(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _darkNavy,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isi,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: _mediumNavy,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  waktu,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _mediumNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}