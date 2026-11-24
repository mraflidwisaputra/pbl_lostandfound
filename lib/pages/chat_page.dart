import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../services/auth_service.dart';
import '../services/barang_service.dart';
import '../services/chat_service.dart';
import 'ajukan_klaim_page.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  final String lawanUid;
  final String lawanNama;
  final String barangId;
  final String namaBarang;
  final ItemBarang? barang; // opsional; jika null dimuat dari Firestore

  const ChatPage({
    super.key,
    required this.chatId,
    required this.lawanUid,
    required this.lawanNama,
    required this.barangId,
    required this.namaBarang,
    this.barang,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _ink = Color(0xFF0F2A47);
  static const _bg = Color(0xFFEFF6FD);

  final _service = ChatService();
  late final Stream<List<PesanChat>> _stream =
      _service.streamPesan(widget.chatId);
  final _inputC = TextEditingController();
  final _scrollC = ScrollController();
  final String _uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  String _namaSaya = 'Pengguna';
  ItemBarang? _barang;
  String? _terakhirDitandai;
  int _jumlah = 0;

  @override
  void initState() {
    super.initState();
    _barang = widget.barang;
    AuthService().namaPengguna().then((n) => _namaSaya = n);
    if (_barang == null && widget.barangId.isNotEmpty) {
      BarangService().ambil(widget.barangId).then((b) {
        if (mounted) setState(() => _barang = b);
      });
    }
    _service.tandaiDibaca(widget.chatId);
  }

  @override
  void dispose() {
    _inputC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  // klaim hanya untuk barang Temuan milik orang lain
  bool get _bolehKlaim =>
      _barang != null && _barang!.jenis == 'Temuan' && _barang!.pemilikUid != _uid;

  Future<void> _kirim() async {
    final teks = _inputC.text.trim();
    if (teks.isEmpty) return;
    _inputC.clear();
    try {
      await _service.kirim(
        chatId: widget.chatId,
        lawanUid: widget.lawanUid,
        lawanNama: widget.lawanNama,
        barangId: widget.barangId,
        barangNama: widget.namaBarang,
        namaSaya: _namaSaya,
        teks: teks,
      );
    } catch (e) {
      if (!mounted) return;
      _inputC.text = teks;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesan gagal terkirim, coba lagi')),
      );
    }
  }

  void _ajukanKlaim() {
    final b = _barang;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AjukanKlaimPage(
          namaBarang: widget.namaBarang,
          lokasiDitemukan: b?.lokasi ?? '-',
          tanggalDitemukan: b?.waktu ?? '-',
          gambar: b?.gambar ?? '',
        ),
      ),
    );
  }

  void _kelolaPesanBaru(List<PesanChat> pesan) {
    // gulir ke pesan terbaru
    if (pesan.length != _jumlah) {
      _jumlah = pesan.length;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollC.hasClients) {
          _scrollC.animateTo(_scrollC.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut);
        }
      });
    }
    // tandai dibaca jika pesan terakhir dari lawan
    if (pesan.isNotEmpty &&
        !pesan.last.dariSaya &&
        pesan.last.id != _terakhirDitandai) {
      _terakhirDitandai = pesan.last.id;
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _service.tandaiDibaca(widget.chatId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: StreamBuilder<List<PesanChat>>(
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
                  final pesan = snap.data!;
                  _kelolaPesanBaru(pesan);
                  return ListView(
                    controller: _scrollC,
                    padding: const EdgeInsets.fromLTRB(14, 24, 14, 12),
                    children: [
                      if (pesan.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 40, bottom: 40),
                          child: Center(
                            child: Text(
                                'Belum ada pesan.\nMulai percakapan dengan ${widget.lawanNama}.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSans3(
                                    fontSize: 14,
                                    color: Colors.grey.shade600)),
                          ),
                        ),
                      ...pesan.map(_bubble),
                      if (_bolehKlaim) ...[
                        const SizedBox(height: 24),
                        _klaimCard(),
                      ],
                    ],
                  );
                },
              ),
            ),
            _inputBar(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: const Color(0xFFF7FAFE),
      padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.lawanNama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.sourceSans3(
                        fontSize: 16, fontWeight: FontWeight.w800, color: _ink)),
                Text(widget.namaBarang,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.sourceSans3(fontSize: 12, color: _ink)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.outlined_flag),
            tooltip: 'Laporkan',
            onPressed: () {
              // TODO: laporkan percakapan
            },
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _bubble(PesanChat p) {
    final saya = p.dariSaya;
    return Align(
      alignment: saya ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.68),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: saya ? _navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(saya ? 20 : 4),
            bottomRight: Radius.circular(saya ? 4 : 20),
          ),
        ),
        child: Text(
          p.teks,
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: saya ? Colors.white : _navy,
          ),
        ),
      ),
    );
  }

  Widget _klaimCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE9F8),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _navy.withOpacity(0.6)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                    color: Color(0xFF365B85), shape: BoxShape.circle),
                child: const Icon(Icons.fact_check_outlined,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merasa ini barang anda?',
                        style: GoogleFonts.sourceSans3(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _ink)),
                    Text('Ajukan Klaim untuk Memverifikasi kepemilikan barang',
                        style: GoogleFonts.sourceSans3(
                            fontSize: 10, color: _ink)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton.icon(
              onPressed: _ajukanKlaim,
              icon: const Icon(Icons.published_with_changes_outlined, size: 16),
              label: Text('Ajukan Klaim',
                  style: GoogleFonts.sourceSans3(
                      fontSize: 13, fontWeight: FontWeight.w800)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        height: 42,
        padding: const EdgeInsets.only(left: 6, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: _navy.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: () {
                // TODO: lampirkan foto / file
              },
            ),
            Expanded(
              child: TextField(
                controller: _inputC,
                onSubmitted: (_) => _kirim(),
                style: GoogleFonts.sourceSans3(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Masukkan Pesan...',
                  hintStyle: GoogleFonts.sourceSans3(
                      fontSize: 14, color: Colors.grey.shade700),
                ),
              ),
            ),
            GestureDetector(
              onTap: _kirim,
              child: Container(
                width: 32,
                height: 32,
                decoration:
                    const BoxDecoration(color: _navy, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}