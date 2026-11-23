import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/item_barang.dart';
import '../services/chat_service.dart';
import 'ajukan_klaim_page.dart';

class ChatPage extends StatefulWidget {
  /// [chatId] diisi jika chat sudah ada (dari riwayat pesan).
  /// Jika null, [barang] wajib diisi untuk membuat chat baru.
  final String? chatId;
  final String namaLawan;
  final String namaBarang;
  final ItemBarang? barang;

  const ChatPage({
    super.key,
    this.chatId,
    required this.namaLawan,
    required this.namaBarang,
    this.barang,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  static const _navy = Color(0xFF0B4F7C);
  static const _bg = Color(0xFFEFF6FD);

  final _inputC = TextEditingController();
  final _scrollC = ScrollController();
  final _service = ChatService();

  String? _chatId;
  bool _inisialisasi = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.chatId != null) {
      _chatId = widget.chatId;
      _tandaiDibaca();
    } else {
      _inisialisasiChat();
    }
  }

  Future<void> _inisialisasiChat() async {
    final b = widget.barang;
    if (b == null) return;
    try {
      // Admin UID – gunakan pemilikUid barang jika tersedia,
      // jika tidak ada fallback ke empty (admin harus sudah ada di Firestore)
      final id = await _service.buatAtauAmbilChat(
        barangId: b.id,
        namaBarang: b.nama,
        adminUid: b.pemilikUid.isNotEmpty ? b.pemilikUid : 'admin',
        adminNama: b.pemosting,
      );
      if (mounted) {
        setState(() => _chatId = id);
        _tandaiDibaca();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  void _tandaiDibaca() {
    if (_chatId != null) _service.tandaiDibaca(_chatId!);
  }

  @override
  void dispose() {
    _inputC.dispose();
    _scrollC.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    final teks = _inputC.text.trim();
    if (teks.isEmpty || _chatId == null) return;
    _inputC.clear();
    try {
      await _service.kirimPesan(_chatId!, teks);
      _gulirBawah();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal kirim: $e')),
        );
      }
    }
  }

  void _gulirBawah() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollC.hasClients) {
        _scrollC.animateTo(
          _scrollC.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _ajukanKlaim() {
    final b = widget.barang;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $_error',
                    style: const TextStyle(color: Colors.red)),
              )
            else if (_chatId == null)
              const Expanded(
                  child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: StreamBuilder<List<PesanChat>>(
                  stream: _service.streamPesan(_chatId!),
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Center(
                          child: Text('Gagal memuat pesan: ${snap.error}',
                              style:
                                  const TextStyle(color: Colors.red)));
                    }
                    final pesan = snap.data ?? [];
                    // Auto scroll ke bawah saat ada pesan baru
                    if (snap.hasData) {
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _gulirBawah());
                    }
                    return ListView(
                      controller: _scrollC,
                      padding:
                          const EdgeInsets.fromLTRB(14, 24, 14, 12),
                      children: [
                        ...pesan.map(_bubble),
                        const SizedBox(height: 28),
                        _klaimCard(),
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
                Text(widget.namaLawan,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F2A47))),
                Text(widget.namaBarang,
                    style: GoogleFonts.inter(
                        fontSize: 11, color: const Color(0xFF0F2A47))),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.outlined_flag),
            tooltip: 'Laporkan',
            onPressed: () {},
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
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: saya ? _navy : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(saya ? 22 : 4),
            bottomRight: Radius.circular(saya ? 4 : 22),
          ),
        ),
        child: Text(
          p.teks,
          style: GoogleFonts.inter(
            fontSize: 15,
            color: saya ? Colors.white : _navy,
          ),
        ),
      ),
    );
  }

  Widget _klaimCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                    color: Color(0xFF365B85), shape: BoxShape.circle),
                child: const Icon(Icons.inventory_2_outlined,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Merasa ini barang anda?',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F2A47))),
                    Text(
                        'Ajukan Klaim untuk Memverifikasi kepemilikan barang',
                        style: GoogleFonts.inter(fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton.icon(
              onPressed: _ajukanKlaim,
              icon: const Icon(Icons.verified_outlined, size: 16),
              label: Text('Ajukan Klaim',
                  style: GoogleFonts.poppins(
                      fontSize: 12, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
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
        height: 48,
        padding: const EdgeInsets.only(left: 6, right: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: _navy.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: _inputC,
                onSubmitted: (_) => _kirim(),
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: 'Masukkan Pesan...',
                  hintStyle: GoogleFonts.inter(
                      fontSize: 13, color: Colors.grey.shade500),
                ),
              ),
            ),
            GestureDetector(
              onTap: _kirim,
              child: Container(
                width: 34,
                height: 34,
                decoration:
                    const BoxDecoration(color: _navy, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    size: 17, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
