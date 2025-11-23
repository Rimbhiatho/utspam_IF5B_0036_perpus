import 'package:flutter/material.dart';
import '../data/model/infobuku.dart';
import 'form_peminjaman.dart';
import 'data/auth/auth_service.dart';
import 'data/repository/bookmark_repository.dart';
import 'data/repository/book_repository.dart';
import 'data/db/database_helper.dart';

class DetailBukuPage extends StatefulWidget {
  final InfoBuku buku;

  const DetailBukuPage({super.key, required this.buku});

  @override
  State<DetailBukuPage> createState() => _DetailBukuPageState();
}

class _DetailBukuPageState extends State<DetailBukuPage> {
  // Status bookmark buku
  bool isBookmarked = false;

  // Repository untuk bookmark
  final _bookmarkRepo = BookmarkRepository();

  @override
  void initState() {
    super.initState();
    _initBookmark(); // Cek apakah buku sudah di-bookmark
  }

  // Fungsi untuk mengecek status bookmark dari database
  Future<void> _initBookmark() async {
    final userId = AuthService.instance.currentUserId;
    if (userId == null) {
      setState(() => isBookmarked = false);
      return;
    }

    final db = await DatabaseHelper.instance.database;
    final rows = await db.rawQuery(
      'SELECT id FROM books WHERE title = ? LIMIT 1',
      [widget.buku.title],
    );

    if (rows.isEmpty) {
      setState(() => isBookmarked = false);
      return;
    }

    final bookId = rows.first['id'] as int;
    final bookmarked = await _bookmarkRepo.isBookmarked(userId, bookId);
    setState(() => isBookmarked = bookmarked);
  }

  @override
  Widget build(BuildContext context) {
    final buku = widget.buku;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deskripsi Buku'),
        backgroundColor: const Color.fromARGB(255, 232, 203, 177),
      ),
      backgroundColor: const Color.fromARGB(255, 232, 203, 177),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar sampul buku
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                buku.imagePath,
                height: 175,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Judul buku
            Text(
              buku.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Penulis dan biaya pinjam
            Text(
              'Penulis: ${buku.author}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Biaya Pinjam: Rp ${buku.biaya}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),

            // Status ketersediaan buku
            Text(
              buku.tersedia ? 'Status: Tersedia' : 'Status: Tidak Tersedia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: buku.tersedia
                    ? const Color.fromARGB(255, 0, 0, 0)
                    : const Color.fromARGB(255, 240, 43, 29),
              ),
            ),
            const SizedBox(height: 20),

            // Genre dan sinopsis
            const Text(
              "Genre",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(buku.genre, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 16),
            Text(
              buku.synopsis,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 30),

            // Tombol Bookmark dan Pinjam Buku
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ✅ Tombol Bookmark
                ElevatedButton.icon(
                  onPressed: () async {
                    final userId = AuthService.instance.currentUserId;
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan login terlebih dahulu'),
                        ),
                      );
                      return;
                    }

                    setState(() => isBookmarked = !isBookmarked);

                    if (isBookmarked) {
                      // Tambahkan ke bookmark
                      final bookRepo = BookRepository();
                      final insertedId = await bookRepo.insertBook(widget.buku);
                      await _bookmarkRepo.addBookmark(userId, insertedId);
                    } else {
                      // Hapus dari bookmark
                      final db = await DatabaseHelper.instance.database;
                      final rows = await db.rawQuery(
                        'SELECT id FROM books WHERE title = ? LIMIT 1',
                        [widget.buku.title],
                      );
                      if (rows.isNotEmpty) {
                        final bookId = rows.first['id'] as int;
                        await _bookmarkRepo.removeBookmark(userId, bookId);
                      }
                    }

                    // Tampilkan notifikasi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isBookmarked
                              ? 'Ditambahkan ke bookmark'
                              : 'Dihapus dari bookmark',
                        ),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.all(50.0),
                      ),
                    );
                  },
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: Colors.white,
                  ),
                  label: Text(
                    isBookmarked ? 'Bookmarked' : 'Bookmark',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 236, 195),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isBookmarked
                        ? const Color.fromARGB(255, 51, 58, 68)
                        : const Color.fromARGB(255, 91, 94, 102),
                  ),
                ),

                // ✅ Tombol Pinjam Buku
                ElevatedButton.icon(
                  onPressed: buku.tersedia
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormPeminjamanPage(buku: buku),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(
                    Icons.library_books,
                    color: Color.fromARGB(255, 232, 203, 177),
                  ),
                  label: const Text(
                    "Pinjam Buku",
                    style: TextStyle(color: Color.fromARGB(255, 232, 203, 177)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 91, 94, 102),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
