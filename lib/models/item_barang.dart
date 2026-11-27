class ItemBarang {
  final String nama;
  final String waktu;
  final String kategori; // tipe barang: Kunci, Kartu, Dompet, ...
  final String lokasi;
  final String deskripsi;
  final String gambar; // path asset ATAU teks base64 dari Firestore
  final String pemosting;

  // terisi saat data berasal dari Firestore
  final String id;
  final String pemilikUid;
  final String jenis; // "Hilang" / "Temuan"
  final DateTime? tanggal; // waktu kehilangan / penemuan

  const ItemBarang({
    required this.nama,
    required this.waktu,
    required this.kategori,
    required this.lokasi,
    required this.deskripsi,
    required this.gambar,
    this.pemosting = 'Admin',
    this.id = '',
    this.pemilikUid = '',
    this.jenis = '',
    this.tanggal,
  });

  /// Alias: sebagian halaman memakai nama `tipe` (isinya sama dengan `kategori`).
  String get tipe => kategori;
}