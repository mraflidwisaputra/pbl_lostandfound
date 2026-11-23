class ItemBarang {
  final String id;         // dokumen Firestore
  final String pemilikUid; // uid pemilik/poster
  final String nama;
  final String waktu;
  final String kategori;   // "Hilang" / "Temuan"
  final String tipe;       // sub-kategori: Dompet, Ponsel, dst.
  final String lokasi;
  final String deskripsi;
  final String gambar;     // base64 atau kosong
  final String pemosting;

  const ItemBarang({
    this.id = '',
    this.pemilikUid = '',
    required this.nama,
    required this.waktu,
    required this.kategori,
    this.tipe = '',
    required this.lokasi,
    required this.deskripsi,
    required this.gambar,
    this.pemosting = 'Admin',
  });
}