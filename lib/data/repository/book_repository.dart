import '../db/database_helper.dart';
import '../model/infobuku.dart';

class BookRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertBook(InfoBuku book) async {
    final map = book.toMap();
    map['tersedia'] = (map['tersedia'] == true) ? 1 : 0;
    return await dbHelper.insert('books', map);
  }

  Future<List<InfoBuku>> getAllBooks() async {
    final rows = await dbHelper.queryAll('books');
    return rows.map((r) {
      final map = Map<String, dynamic>.from(r);
      map['tersedia'] = (map['tersedia'] == 1);
      return InfoBuku.fromMap(map);
    }).toList();
  }

  Future<int> updateAvailability(int bookId, bool available) async {
    return await dbHelper.update(
      'books',
      {'tersedia': available ? 1 : 0},
      'id = ?',
      [bookId],
    );
  }

  Future<int> deleteBook(int id) async {
    return await dbHelper.delete('books', 'id = ?', [id]);
  }
}
