import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Login email + password. Jika [sebagaiAdmin] true, akun harus
  /// punya field role = "admin" di dokumen users/{uid}.
  Future<void> login({
    required String email,
    required String password,
    required bool sebagaiAdmin,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password);
    final doc = await _db.collection('users').doc(cred.user!.uid).get();
    final role = doc.data()?['role'] ?? 'mahasiswa';
    if (sebagaiAdmin && role != 'admin') {
      await _auth.signOut();
      throw Exception('Akun ini bukan akun Admin');
    }
  }

  Future<void> logout() => _auth.signOut();

  /// Peran akun dari users/{uid}.role  (mis. "admin", "mahasiswa", "dosen", "staff").
  /// Jika dokumen/field belum ada, dianggap civitas akademik biasa.
  Future<String> peran() async {
    final u = _auth.currentUser;
    if (u == null) return 'tamu';
    final doc = await _db.collection('users').doc(u.uid).get();
    return (doc.data()?['role'] ?? 'mahasiswa').toString().toLowerCase().trim();
  }

  /// Data profil dari koleksi users (nama, nim, email, jurusan, prodi, status).
  Future<Map<String, dynamic>?> profilSaatIni() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    final doc = await _db.collection('users').doc(u.uid).get();
    return doc.data();
  }

  Future<void> gantiPassword(String passwordBaru) async {
    await _auth.currentUser!.updatePassword(passwordBaru);
  }

  /// Nama untuk sapaan di Beranda: users/{uid}.nama -> displayName -> email.
  Future<String> namaPengguna() async {
    final u = _auth.currentUser;
    if (u == null) return 'Pengguna';
    try {
      final doc = await _db.collection('users').doc(u.uid).get();
      final nama = doc.data()?['nama'];
      if (nama is String && nama.trim().isNotEmpty) return nama.trim();
    } catch (_) {}
    if ((u.displayName ?? '').isNotEmpty) return u.displayName!;
    return (u.email ?? 'Pengguna').split('@').first;
  }

  /// Ubah error Firebase menjadi pesan Bahasa Indonesia.
  static String pesanError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
        case 'invalid-email':
          return 'Email atau password salah';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan, coba lagi nanti';
        case 'network-request-failed':
          return 'Tidak ada koneksi internet';
        case 'requires-recent-login':
          return 'Demi keamanan, silakan login ulang lalu coba lagi';
        case 'weak-password':
          return 'Password terlalu lemah';
        default:
          return 'Terjadi kesalahan (${e.code})';
      }
    }
    return e.toString().replaceFirst('Exception: ', '');
  }
}