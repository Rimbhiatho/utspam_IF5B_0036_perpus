import '../db/database_helper.dart';
import '../model/peminjaman.dart';
import '../model/riwayat.dart';
import 'user_repository.dart';

class LoanRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> createLoan(PeminjamanModel loan) async {
    final id = await dbHelper.insert('loans', loan.toMap());
    final user = await UserRepository().getUserById(loan.userId);
    final riwayat = RiwayatModel(
      userId: loan.userId,
      bookId: loan.bookId,
      action: 'borrow',
      note: user?.username,
    );
    await dbHelper.insert('riwayat', riwayat.toMap());
    return id;
  }

  Future<int> returnLoan(int loanId, int returnDateMillis) async {
    final rows = await dbHelper.query(
      'loans',
      where: 'id = ?',
      whereArgs: [loanId],
    );
    if (rows.isEmpty) return 0;
    final loan = PeminjamanModel.fromMap(rows.first);
    await dbHelper.update(
      'loans',
      {'returnDate': returnDateMillis, 'status': 'returned'},
      'id = ?',
      [loanId],
    );
    final user = await UserRepository().getUserById(loan.userId);
    final riwayat = RiwayatModel(
      userId: loan.userId,
      bookId: loan.bookId,
      action: 'return',
      note: user?.username,
    );
    await dbHelper.insert('riwayat', riwayat.toMap());
    return 1;
  }

  Future<List<PeminjamanModel>> getLoansByUser(int userId) async {
    final rows = await dbHelper.query(
      'loans',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'borrowDate DESC',
    );
    return rows.map((r) => PeminjamanModel.fromMap(r)).toList();
  }

  Future<PeminjamanModel?> getLoanById(int id) async {
    final rows = await dbHelper.query(
      'loans',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return PeminjamanModel.fromMap(rows.first);
  }

  Future<int> updateLoan(PeminjamanModel loan) async {
    final values = loan.toMap()..remove('id');
    return await dbHelper.update('loans', values, 'id = ?', [loan.id]);
  }

  Future<int> deleteLoan(int id) async {
    return await dbHelper.delete('loans', 'id = ?', [id]);
  }

  Future<List<RiwayatModel>> getRiwayatByUser(int userId) async {
    final rows = await dbHelper.query(
      'riwayat',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    return rows.map((r) => RiwayatModel.fromMap(r)).toList();
  }
}
