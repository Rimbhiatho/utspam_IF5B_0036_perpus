import 'package:flutter/material.dart';
import '../data/model/infobuku.dart';
import '../detail_buku.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Manual pembagian kategori berdasarkan judul buku
    final List<InfoBuku> fiksi = [
      daftarBuku[1], // Bulan
      daftarBuku[2], // Bumi
      daftarBuku.firstWhere((b) => b.title == 'Matahari'),
      daftarBuku.firstWhere((b) => b.title == 'Nebula'),
      daftarBuku.firstWhere((b) => b.title == 'Bintang'),
      daftarBuku.firstWhere((b) => b.title == 'Si Putih'),
    ];

    final List<InfoBuku> nonFiksi = [
      daftarBuku.firstWhere((b) => b.title == 'IPA'),
      daftarBuku.firstWhere((b) => b.title == 'Matematika'),
      daftarBuku.firstWhere((b) => b.title == 'Seni Budaya'),
      daftarBuku.firstWhere((b) => b.title == 'Bahasa Indonesia'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar banner utama
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/Buku.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),

          // Judul kategori Fiksi
          const Text(
            'Fiksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 254, 236, 195),
            ),
          ),
          const SizedBox(height: 12),

          // List horizontal buku fiksi
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: fiksi.map((buku) => BookThumbnail(buku: buku)).toList(),
            ),
          ),
          const SizedBox(height: 30),

          // Judul kategori Non Fiksi
          const Text(
            'Non Fiksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 254, 236, 195),
            ),
          ),
          const SizedBox(height: 12),

          // List horizontal buku non-fiksi
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: nonFiksi
                  .map((buku) => BookThumbnail(buku: buku))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk menampilkan thumbnail buku
class BookThumbnail extends StatelessWidget {
  final InfoBuku buku;

  const BookThumbnail({super.key, required this.buku});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Navigasi ke halaman detail buku saat thumbnail ditekan
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailBukuPage(buku: buku)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(buku.imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
