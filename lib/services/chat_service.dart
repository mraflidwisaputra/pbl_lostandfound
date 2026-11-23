import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Model pesan dalam satu percakapan
class PesanChat {
  final String id;
  final String teks;
  final String pengirimUid;
  final String pengirimNama;
  final DateTime waktu;
  final bool dibaca;

  const PesanChat({
    required this.id,
    required this.teks,
    required this.pengirimUid,
    required this.pengirimNama,
    required this.waktu,
    required this.dibaca,
  });

  bool get dariSaya => pengirimUid == FirebaseAuth.instance.currentUser?.uid;
}

/// Model ringkasan percakapan untuk Riwayat Pesan
class RingkasanChat {
  final String chatId;
  final String namaLawan;
  final String namaBarang;
  final String barangId;
  final String pesanTerakhir;
  final DateTime waktuTerakhir;
  final bool sudahDibaca;
  final String pengirimTerakhirUid;

  const RingkasanChat({
    required this.chatId,
    required this.namaLawan,
    required this.namaBarang,
    required this.barangId,
    required this.pesanTerakhir,
    required this.waktuTerakhir,
    required this.sudahDibaca,
    required this.pengirimTerakhirUid,
  });

  String get statusLabel {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final d = DateTime.now().difference(waktuTerakhir);
    if (pengirimTerakhirUid != uid) {
      // pesan dari lawan
      return sudahDibaca ? _lalu(d) : 'Belum Dibaca';
    } else {
      return sudahDibaca ? 'Dibaca ${_lalu(d)}' : 'Terkirim';
    }
  }

  static String _lalu(Duration d) {
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} Menit Yang lalu';
    if (d.inHours < 24) return '${d.inHours} Jam Yang lalu';
    return '${d.inDays} Hari Yang lalu';
  }
}

/// Layanan chat berbasis Firestore.
///
/// Struktur Firestore:
///   chats/{chatId}
///     - userIds: [uid1, uid2]
///     - namaUsers: {uid1: "Nama1", uid2: "Nama2"}
///     - barangId: String
///     - namaBarang: String
///     - pesanTerakhir: String
///     - waktuTerakhir: Timestamp
///     - dibaca: {uid1: true, uid2: false}
///     - pengirimTerakhirUid: String
///
///   chats/{chatId}/pesan/{pesanId}
///     - teks: String
///     - pengirimUid: String
///     - pengirimNama: String
///     - waktu: Timestamp
///     - dibaca: bool
class ChatService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  User? get _user => _auth.currentUser;

  /// Buat atau ambil chatId antara user saat ini dan admin untuk barang tertentu.
  Future<String> buatAtauAmbilChat({
    required String barangId,
    required String namaBarang,
    required String adminUid,
    required String adminNama,
  }) async {
    final uid = _user?.uid;
    if (uid == null) throw Exception('Belum login');
    final namaSaya = _user?.displayName ?? _user?.email ?? 'Pengguna';

    // Cari chat yang sudah ada
    final existing = await _db
        .collection('chats')
        .where('userIds', arrayContains: uid)
        .where('barangId', isEqualTo: barangId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return existing.docs.first.id;

    // Buat baru
    final ref = await _db.collection('chats').add({
      'userIds': [uid, adminUid],
      'namaUsers': {uid: namaSaya, adminUid: adminNama},
      'barangId': barangId,
      'namaBarang': namaBarang,
      'pesanTerakhir': '',
      'waktuTerakhir': FieldValue.serverTimestamp(),
      'dibaca': {uid: true, adminUid: true},
      'pengirimTerakhirUid': uid,
    });
    return ref.id;
  }

  /// Kirim pesan ke percakapan [chatId].
  Future<void> kirimPesan(String chatId, String teks) async {
    final uid = _user?.uid;
    if (uid == null) throw Exception('Belum login');
    final nama = _user?.displayName ?? _user?.email ?? 'Pengguna';

    final batch = _db.batch();

    final pesanRef = _db.collection('chats').doc(chatId).collection('pesan').doc();
    batch.set(pesanRef, {
      'teks': teks,
      'pengirimUid': uid,
      'pengirimNama': nama,
      'waktu': FieldValue.serverTimestamp(),
      'dibaca': false,
    });

    // Update ringkasan chat - tandai belum dibaca untuk lawan
    final chatRef = _db.collection('chats').doc(chatId);
    // Ambil data lawan dulu
    final chatSnap = await chatRef.get();
    final userIds = List<String>.from(chatSnap.data()?['userIds'] ?? []);
    final Map<String, dynamic> dibacaMap = {};
    for (final id in userIds) {
      dibacaMap['dibaca.$id'] = id == uid;
    }

    batch.update(chatRef, {
      'pesanTerakhir': teks,
      'waktuTerakhir': FieldValue.serverTimestamp(),
      'pengirimTerakhirUid': uid,
      ...dibacaMap,
    });

    await batch.commit();
  }

  /// Stream pesan dalam percakapan [chatId], urut waktu.
  Stream<List<PesanChat>> streamPesan(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('pesan')
        .orderBy('waktu', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final m = d.data();
              return PesanChat(
                id: d.id,
                teks: m['teks'] ?? '',
                pengirimUid: m['pengirimUid'] ?? '',
                pengirimNama: m['pengirimNama'] ?? '',
                waktu: (m['waktu'] as Timestamp?)?.toDate() ?? DateTime.now(),
                dibaca: m['dibaca'] ?? false,
              );
            }).toList());
  }

  /// Stream daftar percakapan user saat ini.
  Stream<List<RingkasanChat>> streamRiwayatChat() {
    final uid = _user?.uid;
    if (uid == null) return const Stream.empty();
    return _db
        .collection('chats')
        .where('userIds', arrayContains: uid)
        .orderBy('waktuTerakhir', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) {
              final m = d.data();
              final namaUsers =
                  Map<String, dynamic>.from(m['namaUsers'] ?? {});
              final userIds =
                  List<String>.from(m['userIds'] ?? []);
              final lawanUid = userIds.firstWhere(
                (id) => id != uid,
                orElse: () => '',
              );
              final namaLawan = namaUsers[lawanUid] ?? 'Pengguna';
              final dibaca =
                  Map<String, dynamic>.from(m['dibaca'] ?? {});
              return RingkasanChat(
                chatId: d.id,
                namaLawan: namaLawan,
                namaBarang: m['namaBarang'] ?? '',
                barangId: m['barangId'] ?? '',
                pesanTerakhir: m['pesanTerakhir'] ?? '',
                waktuTerakhir:
                    (m['waktuTerakhir'] as Timestamp?)?.toDate() ?? DateTime.now(),
                sudahDibaca: dibaca[uid] == true,
                pengirimTerakhirUid: m['pengirimTerakhirUid'] ?? '',
              );
            }).toList());
  }

  /// Tandai semua pesan di [chatId] sebagai sudah dibaca oleh user saat ini.
  Future<void> tandaiDibaca(String chatId) async {
    final uid = _user?.uid;
    if (uid == null) return;
    await _db.collection('chats').doc(chatId).update({'dibaca.$uid': true});
  }
}
