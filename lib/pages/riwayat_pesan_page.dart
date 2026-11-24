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

  // dibuat sekali agar tidak berlangganan ulang tiap rebuild
  late final Stream<List<RingkasanChat>> _stream =
      ChatService().streamDaftar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/images/logo.png',
                    height: 60,
                    errorBuilder: (_, __, ___) => const SizedBox(height: 60)),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Riwayat Pesan',
                    style: GoogleFonts.sourceSans3(
                        fontSize: 28, fontWeight: FontWeight.w800, color: _ink)),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: StreamBuilder<List<RingkasanChat>>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text('Gagal memuat pesan.\n${snap.error}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSans3(
                                fontSize: 13, color: Colors.red.shade700)),
                      ),
                    );
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final daftar = snap.data!;
                  if (daftar.isEmpty) {
                    return Center(
                      child: Text('Belum ada pesan',
                          style: GoogleFonts.sourceSans3(
                              fontSize: 15, color: Colors.grey.shade600)),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(44, 0, 44, 24),
                    itemCount: daftar.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _kartu(daftar[i]),
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

  Widget _kartu(RingkasanChat c) {
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
                chatId: c.chatId,
                lawanUid: c.lawanUid,
                lawanNama: c.lawanNama,
                barangId: c.barangId,
                namaBarang: c.barangNama,
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
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFFD9D9D9),
                child: Icon(Icons.person, size: 38, color: Colors.white),
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
                          child: Text(c.lawanNama,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.sourceSans3(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ),
                        Text(c.status,
                            style: GoogleFonts.sourceSans3(
                                fontSize: 10, color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(c.pesanTerakhir,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.sourceSans3(
                            fontSize: 14,
                            fontWeight:
                                c.belumDibaca ? FontWeight.w800 : FontWeight.w400,
                            color: Colors.white)),
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