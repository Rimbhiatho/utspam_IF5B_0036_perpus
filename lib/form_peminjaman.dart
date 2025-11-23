import 'package:flutter/material.dart';
import '../data/model/infobuku.dart';
import '../homepage.dart';
import 'data/auth/auth_service.dart';
import 'data/repository/loan_repository.dart';
import 'data/repository/book_repository.dart';
import 'data/model/peminjaman.dart';
import 'data/repository/user_repository.dart';
import 'widgets/book_image_header.dart';
import 'widgets/lama_pinjam_field.dart';
import 'widgets/date_picker_row.dart';

class FormPeminjamanPage extends StatefulWidget {
  final InfoBuku buku;
  const FormPeminjamanPage({super.key, required this.buku});

  @override
  State<FormPeminjamanPage> createState() => _FormPeminjamanPageState();
}

class _FormPeminjamanPageState extends State<FormPeminjamanPage> {
  // Tanggal mulai peminjaman
  late DateTime _selectedDate;

  // Controller untuk input lama pinjam
  late TextEditingController _lamaPinjamController;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _lamaPinjamController = TextEditingController(text: '3'); // default 3 hari
    _loadUserName(); // ambil nama user yang login
  }

  String? _userName;

  // Ambil nama user dari AuthService dan UserRepository
  Future<void> _loadUserName() async {
    final id = AuthService.instance.currentUserId;
    if (id == null) return;
    final user = await UserRepository().getUserById(id);
    final displayName = (user != null && user.username.isNotEmpty)
        ? user.username
        : (user?.name ?? '-');
    setState(() => _userName = displayName);
  }

  // Fungsi untuk memilih tanggal mulai pinjam
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final buku = widget.buku;
    final int lamaPinjam = int.tryParse(_lamaPinjamController.text) ?? 0;
    final int totalBiaya = buku.biaya * lamaPinjam;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Peminjaman'),
        backgroundColor: const Color.fromARGB(255, 232, 203, 177),
      ),
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gambar buku di header
            BookImageHeader(buku: buku, height: 150),
            const SizedBox(height: 16),

            // Informasi buku dan peminjam
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Judul: ${buku.title}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nama Peminjam: ${_userName ?? '-'}',
                    style: const TextStyle(color: Colors.white70),
                  ),

                  // Input lama pinjam
                  LamaPinjamField(
                    controller: _lamaPinjamController,
                    onChanged: (_) => setState(() {}),
                  ),

                  // Picker tanggal mulai
                  DatePickerRow(
                    selectedDate: _selectedDate,
                    onSelect: () => _selectDate(context),
                  ),

                  // Tampilkan tanggal mulai
                  Text(
                    'Tanggal Mulai: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                    style: const TextStyle(color: Colors.white70),
                  ),

                  SizedBox(height: 10),

                  // Total biaya pinjam
                  Text(
                    'Total Biaya: Rp $totalBiaya',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tombol simpan peminjaman
            ElevatedButton.icon(
              onPressed: () async {
                final userId = AuthService.instance.currentUserId;
                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Silakan login dahulu')),
                  );
                  return;
                }

                final now = DateTime.now().millisecondsSinceEpoch;
                final due = _selectedDate
                    .add(Duration(days: lamaPinjam))
                    .millisecondsSinceEpoch;

                // Cari bookId berdasarkan judul
                final bookRepo = BookRepository();
                final db = await bookRepo.dbHelper.database;
                final rows = await db.rawQuery(
                  'SELECT id FROM books WHERE title = ? LIMIT 1',
                  [buku.title],
                );

                int bookId;
                if (rows.isEmpty) {
                  bookId = await bookRepo.insertBook(
                    buku,
                  ); // jika belum ada, insert dulu
                } else {
                  bookId = rows.first['id'] as int;
                }

                // Buat objek peminjaman
                final createLoan = PeminjamanModel(
                  userId: userId,
                  bookId: bookId,
                  borrowDate: now,
                  dueDate: due,
                  biaya: totalBiaya,
                );

                // Simpan ke database
                final loanRepo = LoanRepository();
                await loanRepo.createLoan(createLoan);

                // Update status ketersediaan buku
                await bookRepo.updateAvailability(bookId, false);

                // Tampilkan notifikasi
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Peminjaman "${buku.title}" berhasil disimpan',
                    ),
                  ),
                );

                // Navigasi ke homepage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Homepage()),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('pinjam'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
