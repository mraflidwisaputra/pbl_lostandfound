import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/item_barang.dart';
import 'auth_service.dart';

/// Koleksi Firestore: barang/{id}
///  nama, kategori ("Hilang"/"Temuan"), tipe, lokasi, detail,
///  waktu (Timestamp), dibuat (Timestamp), fotoBase64, status,
///  pemilikUid, pemilikNama
class BarangService {
  final _col = FirebaseFirestore.instance.collection('barang');

  Future<void> tambah({
    required String nama,
    required String kategori,
    required String tipe,
    required String lokasi,
    required DateTime waktu,
    required String detail,
    required Uint8List foto,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Anda belum login');
    // batas dokumen Firestore = 1 MB, sisakan ruang untuk field lain
    if (foto.lengthInBytes > 700 * 1024) {
      throw Exception('Ukuran foto terlalu besar, pilih foto lain');
    }
    await _col.add({
      'nama': nama,
      'kategori': kategori,
      'tipe': tipe,
      'lokasi': lokasi,
      'detail': detail,
      'waktu': Timestamp.fromDate(waktu),
      'dibuat': FieldValue.serverTimestamp(),
      'fotoBase64': base64Encode(foto),
      'status': 'menunggu',
      'pemilikUid': user.uid,
      'pemilikNama': await AuthService().namaPengguna(),
    });
  }

  /// Daftar barang realtime (otomatis ter-update saat ada data baru).
  Stream<List<ItemBarang>> streamBarang(String kategori) {
    return _col.where('kategori', isEqualTo: kategori).snapshots().map((snap) {
      final docs = snap.docs.toList()
        ..sort((a, b) {
          final ta = (a.data()['waktu'] as Timestamp?)?.toDate() ?? DateTime(2000);
          final tb = (b.data()['waktu'] as Timestamp?)?.toDate() ?? DateTime(2000);
          return tb.compareTo(ta); // terbaru di atas
        });
      return docs.map(_dariDoc).toList();
    });
  }

  /// Laporan terbaru (Hilang + Temuan) untuk Beranda.
  Stream<List<ItemBarang>> streamTerbaru({int batas = 4}) {
    return _col
        .orderBy('dibuat', descending: true)
        .limit(batas)
        .snapshots()
        .map((snap) => snap.docs.map(_dariDoc).toList());
  }

  /// Laporan milik saya (untuk halaman Riwayat Laporan).
  Stream<List<LaporanSaya>> streamSaya() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _col.where('pemilikUid', isEqualTo: uid).snapshots().map((snap) {
      final now = DateTime.now();
      final docs = snap.docs.toList()
        ..sort((a, b) {
          final ta = (a.data()['dibuat'] as Timestamp?)?.toDate() ?? now;
          final tb = (b.data()['dibuat'] as Timestamp?)?.toDate() ?? now;
          return tb.compareTo(ta); // terbaru di atas
        });
      return docs
          .map((d) => LaporanSaya(
                item: _dariDoc(d),
                status: (d.data()['status'] ?? 'menunggu').toString(),
                tanggal: (d.data()['waktu'] as Timestamp?)?.toDate(),
              ))
          .toList();
    });
  }

  /// Ambil satu barang berdasarkan id (dipakai halaman Chat untuk form klaim).
  Future<ItemBarang?> ambil(String id) async {
    final d = await _col.doc(id).get();
    if (!d.exists) return null;
    return _dariDoc(d);
  }

  ItemBarang _dariDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? <String, dynamic>{};
    final waktu = (m['waktu'] as Timestamp?)?.toDate() ?? DateTime.now();
    return ItemBarang(
      id: d.id,
      pemilikUid: m['pemilikUid'] ?? '',
      jenis: m['kategori'] ?? '',
      tanggal: waktu,
      nama: m['nama'] ?? '-',
      waktu: _lalu(waktu),
      kategori: m['tipe'] ?? '-',
      lokasi: m['lokasi'] ?? '-',
      deskripsi: m['detail'] ?? '',
      gambar: m['fotoBase64'] ?? '',
      pemosting: m['pemilikNama'] ?? 'Pengguna',
    );
  }

  static String _lalu(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'Baru saja';
    if (d.inMinutes < 60) return '${d.inMinutes} Menit Yang Lalu';
    if (d.inHours < 24) return '${d.inHours} Jam Yang Lalu';
    return '${d.inDays} Hari Yang Lalu';
  }
}

/// Satu laporan milik pengguna beserta statusnya
/// ("menunggu" / "selesai") untuk halaman Riwayat.
class LaporanSaya {
  final ItemBarang item;
  final String status;
  final DateTime? tanggal;
  const LaporanSaya(
      {required this.item, required this.status, required this.tanggal});
}