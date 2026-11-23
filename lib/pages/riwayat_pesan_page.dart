import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/chat_service.dart';
import '../widgets/app_bottom_bar.dart';
import 'chat_page.dart';

class RiwayatPesanPage extends StatefulWidget {
  const RiwayatPesanPage({super.key});

  @override
  State<RiwayatPesanPage> createState() => _RiwayatPesanPageState();
}

class _RiwayatPesanPageState extends State<RiwayatPesanPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  final _service = ChatService();
  late final Stream<List<RingkasanChat>> _stream =
      _service.streamRiwayatChat();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // logo
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
                        color: _ink)),
              ),
            ),
            const SizedBox(height: 18),

            // daftar percakapan dari Firestore
            Expanded(
              child: StreamBuilder<List<RingkasanChat>>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text('Gagal memuat pesan\n${snap.error}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: Colors.red.shade700)),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final daftar = snap.data!;
                  if (daftar.isEmpty) {
                    return Center(
                      child: Text('Belum ada pesan',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.grey.shade600)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(44, 0, 44, 24),
                    itemCount: daftar.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, i) =>
                        _kartu(context, daftar[i]),
                  );
                },
              ),
            ),
            const AppBottomBar(currentIndex: 3),
          ],
        ),
      ),
    );
  }

  Widget _kartu(BuildContext context, RingkasanChat p) {
    return Material(
      color: _navy,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPage(
                chatId: p.chatId,
                namaLawan: p.namaLawan,
                namaBarang: p.namaBarang,
              ),
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
                          child: Text(p.namaLawan,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        Text(p.statusLabel,
                            style: GoogleFonts.inter(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: p.sudahDibaca
                                    ? Colors.white70
                                    : Colors.amber.shade200)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(p.pesanTerakhir,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: Colors.white70)),
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
