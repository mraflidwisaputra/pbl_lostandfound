import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_barang.dart';
import 'auth_service.dart';

/// Koleksi Firestore: klaim/{barangId}_{uidPengaju}
///  barangId, barangNama, barangFoto, pemilikBarangUid,
///  pengajuUid, pengajuNama, ciri, kapanHilang, lokasiHilang,
///  buktiBase64 (list), status, dibuat
///  status: "menunggu" -> "diproses" -> "selesai" / "dibatalkan"  (diubah admin)
class KlaimSaya {
  final String id;
  final String barangId;
  final String barangNama;
  final String foto;
  final String ciri;
  final String lokasi;
  final String status;
  final DateTime? kapan;
  final DateTime? dibuat;
  final List<String> bukti;
  const KlaimSaya({
    required this.id,
    required this.barangId,
    required this.barangNama,
    required this.foto,
    required this.ciri,
    required this.lokasi,
    required this.status,
    required this.kapan,
    required this.dibuat,
    required this.bukti,
  });
}

class KlaimService {
  final _col = FirebaseFirestore.instance.collection('klaim');

  Future<void> ajukan({
    required ItemBarang barang,
    required String ciri,
    required DateTime kapan,
    required String lokasi,
    required List<Uint8List> bukti,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Anda belum login');
    if (barang.id.isEmpty) throw Exception('Data barang tidak valid');
    if (barang.pemilikUid == user.uid) {
      throw Exception('Anda tidak dapat mengklaim laporan Anda sendiri');
    }

    // satu klaim per pengguna untuk satu barang
    final ref = _col.doc('${barang.id}_${user.uid}');
    final ada = await ref.get();
    if (ada.exists) {
      throw Exception('Anda sudah mengajukan klaim untuk barang ini');
    }

    final fotoBarang = barang.gambar.startsWith('assets/') ? '' : barang.gambar;
    final buktiB64 = bukti.map(base64Encode).toList();
    final total = fotoBarang.length + buktiB64.fold<int>(0, (a, e) => a + e.length);
    if (total > 850 * 1024) {
      // batas dokumen Firestore = 1 MB
      throw Exception('Total ukuran foto terlalu besar, kurangi jumlah foto bukti');
    }

    await ref.set({
      'barangId': barang.id,
      'barangNama': barang.nama,
      'barangFoto': fotoBarang,
      'pemilikBarangUid': barang.pemilikUid,
      'pengajuUid': user.uid,
      'pengajuNama': await AuthService().namaPengguna(),
      'ciri': ciri,
      'kapanHilang': Timestamp.fromDate(kapan),
      'lokasiHilang': lokasi,
      'buktiBase64': buktiB64,
      'status': 'menunggu',
      'dibuat': FieldValue.serverTimestamp(),
    });
  }

  /// Klaim yang saya ajukan (untuk tab KLAIM di Riwayat).
  Stream<List<KlaimSaya>> streamSaya() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _col.where('pengajuUid', isEqualTo: uid).snapshots().map((snap) {
      final now = DateTime.now();
      final docs = snap.docs.toList()
        ..sort((a, b) {
          final ta = (a.data()['dibuat'] as Timestamp?)?.toDate() ?? now;
          final tb = (b.data()['dibuat'] as Timestamp?)?.toDate() ?? now;
          return tb.compareTo(ta);
        });
      return docs.map((d) {
        final m = d.data();
        return KlaimSaya(
          id: d.id,
          barangId: m['barangId'] ?? '',
          barangNama: m['barangNama'] ?? '-',
          foto: m['barangFoto'] ?? '',
          ciri: m['ciri'] ?? '',
          lokasi: m['lokasiHilang'] ?? '-',
          status: (m['status'] ?? 'menunggu').toString(),
          kapan: (m['kapanHilang'] as Timestamp?)?.toDate(),
          dibuat: (m['dibuat'] as Timestamp?)?.toDate(),
          bukti: List<String>.from(m['buktiBase64'] ?? const []),
        );
      }).toList();
    });
  }
}