import 'package:flutter/material.dart';
import '../data/model/infobuku.dart';
import '../detail_buku.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Controller untuk input pencarian
  final TextEditingController _searchController = TextEditingController();

  // List hasil pencarian
  List<InfoBuku> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchResults = daftarBuku; // Default tampilkan semua buku
  }

  @override
  void dispose() {
    _searchController.dispose(); // Bersihkan controller saat widget dihancurkan
    super.dispose();
  }

  // Fungsi untuk melakukan pencarian berdasarkan judul, penulis, atau genre
  void _performSearch(String query) {
    setState(() {
      _searchResults = daftarBuku
          .where(
            (buku) =>
                buku.title.toLowerCase().contains(query.toLowerCase()) ||
                buku.author.toLowerCase().contains(query.toLowerCase()) ||
                buku.genre.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cari Buku')),
      backgroundColor: const Color.fromARGB(255, 232, 203, 177),
      body: Column(
        children: [
          // Input pencarian
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Cari judul, penulis, atau genre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Tampilkan hasil pencarian
          Expanded(
            child: _searchResults.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Mulai mencari'
                          : 'Tidak ada hasil ditemukan',
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final buku = _searchResults[index];

                      return ListTile(
                        // Gambar sampul buku
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            buku.imagePath,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Judul dan penulis
                        title: Text(buku.title),
                        subtitle: Text(buku.author),

                        // Navigasi ke halaman detail buku
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailBukuPage(buku: buku),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
