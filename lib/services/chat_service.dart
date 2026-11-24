import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Struktur Firestore:
///  chats/{chatId}
///    peserta [uidA, uidB], namaPeserta {uid: nama}, barangId, barangNama,
///    pesanTerakhir, waktuTerakhir, pengirimTerakhir, dibacaPada {uid: waktu}
///  chats/{chatId}/pesan/{id}
///    teks, pengirimUid, waktu
class PesanChat {
  final String id;
  final String teks;
  final bool dariSaya;
  const PesanChat(
      {required this.id, required this.teks, required this.dariSaya});
}

class RingkasanChat {
  final String chatId;
  final String lawanUid;
  final String lawanNama;
  final String barangId;
  final String barangNama;
  final String pesanTerakhir;
  final String status; // "Terkirim" / "Dibaca 2 Menit Yang lalu" / "5 Menit Yang lalu"
  final bool belumDibaca;
  final DateTime? waktu;
  const RingkasanChat({
    required this.chatId,
    required this.lawanUid,
    required this.lawanNama,
    required this.barangId,
    required this.barangNama,
    required this.pesanTerakhir,
    required this.status,
    required this.belumDibaca,
    required this.waktu,
  });
}

class ChatService {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  /// Id percakapan tetap untuk pasangan (barang + dua pengguna).
  static String idChat(String barangId, String uidA, String uidB) {
    final u = [uidA, uidB]..sort();
    return '${barangId}_${u[0]}_${u[1]}';
  }

  Stream<List<PesanChat>> streamPesan(String chatId) {
    final uid = _uid;
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('pesan')
        .orderBy('waktu')
        .snapshots()
        .map((s) => s.docs.map((d) {
              final m = d.data();
              return PesanChat(
                id: d.id,
                teks: m['teks'] ?? '',
                dariSaya: m['pengirimUid'] == uid,
              );
            }).toList());
  }

  Future<void> kirim({
    required String chatId,
    required String lawanUid,
    required String lawanNama,
    required String barangId,
    required String barangNama,
    required String namaSaya,
    required String teks,
  }) async {
    final uid = _uid;
    final chatRef = _db.collection('chats').doc(chatId);
    final batch = _db.batch();
    // dokumen percakapan dibuat saat pesan pertama dikirim
    batch.set(
        chatRef,
        {
          'peserta': [uid, lawanUid],
          'namaPeserta': {uid: namaSaya, lawanUid: lawanNama},
          'barangId': barangId,
          'barangNama': barangNama,
          'pesanTerakhir': teks,
          'waktuTerakhir': FieldValue.serverTimestamp(),
          'pengirimTerakhir': uid,
          'dibacaPada': {uid: FieldValue.serverTimestamp()},
        },
        SetOptions(merge: true));
    batch.set(chatRef.collection('pesan').doc(), {
      'teks': teks,
      'pengirimUid': uid,
      'waktu': FieldValue.serverTimestamp(),
    });
    await batch.commit();
  }

  /// Tandai percakapan sudah dibaca oleh saya (dipanggil saat chat dibuka).
  Future<void> tandaiDibaca(String chatId) async {
    try {
      await _db
          .collection('chats')
          .doc(chatId)
          .update({'dibacaPada.$_uid': FieldValue.serverTimestamp()});
    } catch (_) {
      // percakapan belum ada (belum ada pesan) -> abaikan
    }
  }

  Stream<List<RingkasanChat>> streamDaftar() {
    final uid = _uid;
    return _db
        .collection('chats')
        .where('peserta', arrayContains: uid)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map((d) => _ringkas(d, uid)).toList();
      final now = DateTime.now();
      list.sort((a, b) => (b.waktu ?? now).compareTo(a.waktu ?? now));
      return list;
    });
  }

  RingkasanChat _ringkas(
      QueryDocumentSnapshot<Map<String, dynamic>> d, String uid) {
    final m = d.data();
    final peserta = List<String>.from(m['peserta'] ?? const []);
    final lawanUid = peserta.firstWhere((e) => e != uid, orElse: () => '');
    final nama =
        ((m['namaPeserta'] as Map?)?[lawanUid] as String?) ?? 'Pengguna';
    final waktu = (m['waktuTerakhir'] as Timestamp?)?.toDate();
    final dibaca = (m['dibacaPada'] as Map?) ?? const {};
    final bacaLawan = (dibaca[lawanUid] as Timestamp?)?.toDate();
    final bacaSaya = (dibaca[uid] as Timestamp?)?.toDate();
    final dariSaya = m['pengirimTerakhir'] == uid;

    String status;
    var belum = false;
    if (dariSaya) {
      final terbaca =
          bacaLawan != null && (waktu == null || !bacaLawan.isBefore(waktu));
      status = terbaca ? 'Dibaca ${_lalu(bacaLawan)}' : 'Terkirim';
    } else {
      status = _lalu(waktu);
      belum = bacaSaya == null || (waktu != null && bacaSaya.isBefore(waktu));
    }

    return RingkasanChat(
      chatId: d.id,
      lawanUid: lawanUid,
      lawanNama: nama,
      barangId: m['barangId'] ?? '',
      barangNama: m['barangNama'] ?? '',
      pesanTerakhir: m['pesanTerakhir'] ?? '',
      status: status,
      belumDibaca: belum,
      waktu: waktu,
    );
  }

  static String _lalu(DateTime? t) {
    if (t == null) return 'Baru saja';
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} Menit Yang lalu';
    if (d.inHours < 24) return '${d.inHours} Jam Yang lalu';
    return '${d.inDays} Hari Yang lalu';
  }
}