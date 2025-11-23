import 'package:flutter/material.dart';
import 'data/repository/loan_repository.dart';
import 'data/repository/book_repository.dart';
import 'data/repository/user_repository.dart';
import 'data/db/database_helper.dart';
import 'data/model/peminjaman.dart';
import 'data/model/infobuku.dart';
import 'data/model/riwayat.dart';
import 'widgets/book_image_header.dart';
import 'widgets/lama_pinjam_field.dart';
import 'widgets/date_picker_row.dart';

class EditPeminjamanPage extends StatefulWidget {
  final int loanId;
  const EditPeminjamanPage({super.key, required this.loanId});

  @override
  State<EditPeminjamanPage> createState() => _EditPeminjamanPageState();
}

class _EditPeminjamanPageState extends State<EditPeminjamanPage> {
  final _loanRepo = LoanRepository();
  final _bookRepo = BookRepository();
  PeminjamanModel? _loan;
  InfoBuku? _buku;
  String? _userName;
  late TextEditingController _lamaPinjamController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _lamaPinjamController = TextEditingController(text: '1');
    _loadData();
  }

  @override
  void dispose() {
    _lamaPinjamController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final loan = await _loanRepo.getLoanById(widget.loanId);
    if (loan == null) {
      if (mounted) Navigator.pop(context);
      return;
    }

    final db = await DatabaseHelper.instance.database;
    final rows = await db.rawQuery('SELECT * FROM books WHERE id = ? LIMIT 1', [
      loan.bookId,
    ]);
    InfoBuku? buku;
    if (rows.isNotEmpty) {
      final m = Map<String, dynamic>.from(rows.first);
      m['tersedia'] = (m['tersedia'] == 1);
      buku = InfoBuku.fromMap(m);
    }

    final user = await UserRepository().getUserById(loan.userId);

    final borrowDate = DateTime.fromMillisecondsSinceEpoch(loan.borrowDate);
    final dueDate = DateTime.fromMillisecondsSinceEpoch(loan.dueDate);
    final lama = dueDate.difference(borrowDate).inDays;

    if (mounted) {
      setState(() {
        _loan = loan;
        _buku = buku;
        _userName = (user != null && user.username.isNotEmpty)
            ? user.username
            : (user?.name ?? '-');
        _selectedDate = borrowDate;
        _lamaPinjamController.text = lama.toString();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) setState(() => _selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final buku = _buku;
    final int lamaPinjam = int.tryParse(_lamaPinjamController.text) ?? 0;
    final int totalBiaya = (buku?.biaya ?? 0) * lamaPinjam;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Peminjaman'),
        backgroundColor: const Color.fromARGB(255, 232, 203, 177),
      ),
      backgroundColor: const Color.fromARGB(255, 51, 58, 68),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loan == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    if (buku != null) BookImageHeader(buku: buku, height: 150),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Judul: ${buku?.title ?? '-'}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Username: ${_userName ?? '-'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          LamaPinjamField(
                            controller: _lamaPinjamController,
                            onChanged: (_) => setState(() {}),
                          ),
                          DatePickerRow(
                            selectedDate: _selectedDate,
                            onSelect: () => _selectDate(context),
                          ),
                          Text(
                            'Tanggal Mulai: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 10),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.cancel),
                          label: const Text('Batal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              232,
                              203,
                              177,
                            ),
                            foregroundColor: Colors.black,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final newBorrow =
                                _selectedDate.millisecondsSinceEpoch;
                            final newDue = _selectedDate
                                .add(Duration(days: lamaPinjam))
                                .millisecondsSinceEpoch;
                            final updated = PeminjamanModel(
                              id: _loan!.id,
                              userId: _loan!.userId,
                              bookId: _loan!.bookId,
                              borrowDate: newBorrow,
                              dueDate: newDue,
                              returnDate: _loan!.returnDate,
                              status: _loan!.status,
                              biaya: totalBiaya,
                            );
                            await _loanRepo.updateLoan(updated);
                            final user = await UserRepository().getUserById(
                              _loan!.userId,
                            );
                            final riwayat = RiwayatModel(
                              userId: _loan!.userId,
                              bookId: _loan!.bookId,
                              action: 'edit',
                              note: user?.username,
                            );
                            await DatabaseHelper.instance.insert(
                              'riwayat',
                              riwayat.toMap(),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Peminjaman "${buku?.title ?? ''}" diperbarui',
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () async {
                            if (_loan == null) return;
                            await _loanRepo.deleteLoan(_loan!.id!);
                            await _bookRepo.updateAvailability(
                              _loan!.bookId,
                              true,
                            );
                            final user = await UserRepository().getUserById(
                              _loan!.userId,
                            );
                            final riwayat = RiwayatModel(
                              userId: _loan!.userId,
                              bookId: _loan!.bookId,
                              action: 'delete',
                              note: user?.username,
                            );
                            await DatabaseHelper.instance.insert(
                              'riwayat',
                              riwayat.toMap(),
                            );
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Peminjaman "${buku?.title ?? ''}" dihapus',
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
