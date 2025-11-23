import 'package:flutter/material.dart';
import '../edit_peminjaman.dart';
import '../data/repository/loan_repository.dart';
import '../data/auth/auth_service.dart';
import '../data/db/database_helper.dart';
import '../data/repository/user_repository.dart';
import '../data/model/peminjaman.dart';
import '../data/model/infobuku.dart';

class PeminjamanTab extends StatefulWidget {
  const PeminjamanTab({super.key});

  @override
  State<PeminjamanTab> createState() => _PeminjamanTabState();
}

class _PeminjamanTabState extends State<PeminjamanTab> {
  // Repository untuk mengambil data peminjaman
  final _loanRepo = LoanRepository();

  // List peminjaman dan map buku yang dipinjam
  List<PeminjamanModel> _loans = [];
  Map<int, InfoBuku> _books = {};

  // Nama user yang sedang login
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadLoans(); // Memuat data peminjaman saat widget dibuat
  }

  // Fungsi untuk mengambil data peminjaman dari database
  Future<void> _loadLoans() async {
    final userId = AuthService.instance.currentUserId;

    // Jika user belum login, kosongkan data
    if (userId == null) {
      setState(() {
        _loans = [];
        _books = {};
      });
      return;
    }

    // Ambil data peminjaman berdasarkan userId
    final loans = await _loanRepo.getLoansByUser(userId);

    // Ambil data user dan database
    final user = await UserRepository().getUserById(userId);
    final db = await DatabaseHelper.instance.database;

    // Ambil data buku berdasarkan bookId dari setiap peminjaman
    final Map<int, InfoBuku> booksMap = {};
    for (final loan in loans) {
      final rows = await db.rawQuery(
        'SELECT * FROM books WHERE id = ? LIMIT 1',
        [loan.bookId],
      );
      if (rows.isNotEmpty) {
        final m = Map<String, dynamic>.from(rows.first);
        m['tersedia'] = (m['tersedia'] == 1); // Konversi ke boolean
        booksMap[loan.bookId] = InfoBuku.fromMap(m);
      }
    }

    // Tentukan nama yang akan ditampilkan
    final displayName = (user != null && user.username.isNotEmpty)
        ? user.username
        : (user?.name ?? '-');

    // Simpan data ke state
    setState(() {
      _loans = loans;
      _books = booksMap;
      _userName = displayName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loans.isEmpty
            // Jika tidak ada data peminjaman
            ? const Center(
                child: Text(
                  'Belum ada riwayat peminjaman',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            // Jika ada data peminjaman
            : ListView.builder(
                itemCount: _loans.length,
                itemBuilder: (context, index) {
                  final loan = _loans[index];
                  final buku = _books[loan.bookId];
                  final nama = _userName ?? '-';

                  // Hitung lama peminjaman dalam hari
                  final lama =
                      ((loan.dueDate - loan.borrowDate) ~/ (24 * 3600 * 1000));

                  // Konversi tanggal pinjam ke format DateTime
                  final tanggal = DateTime.fromMillisecondsSinceEpoch(
                    loan.borrowDate,
                  );

                  final biaya = loan.biaya;

                  return Card(
                    color: const Color.fromARGB(255, 91, 94, 102),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      // Gambar buku
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: buku != null
                            ? Image.asset(
                                buku.imagePath,
                                width: 50,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : const SizedBox(width: 50, height: 70),
                      ),
                      // Judul buku
                      title: Text(
                        buku?.title ?? 'Unknown',
                        style: const TextStyle(color: Colors.white),
                      ),
                      // Detail peminjaman
                      subtitle: Text(
                        'Nama: $nama\nLama: $lama hari\nMulai: ${tanggal.day}-${tanggal.month}-${tanggal.year}\nBiaya: Rp $biaya',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      // Tombol edit peminjaman
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () async {
                          final loanId = loan.id;
                          if (loanId != null) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditPeminjamanPage(loanId: loanId),
                              ),
                            );
                            await _loadLoans(); // Refresh data setelah edit
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
