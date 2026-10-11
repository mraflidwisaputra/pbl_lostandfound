class ItemBarang {
  final String nama;
  final String waktu;
  final String kategori;
  final String lokasi;
  final String deskripsi;
  final String gambar;
  final String pemosting;

  const ItemBarang({
    required this.nama,
    required this.waktu,
    required this.kategori,
    required this.lokasi,
    required this.deskripsi,
    required this.gambar,
    this.pemosting = 'Admin',
  });
}