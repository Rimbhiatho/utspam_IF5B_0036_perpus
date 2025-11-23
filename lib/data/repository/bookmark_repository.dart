import '../db/database_helper.dart';
import '../model/infobuku.dart';

class BookmarkRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<int> addBookmark(int userId, int bookId) async {
    final alreadyBookmarked = await isBookmarked(userId, bookId);
    if (alreadyBookmarked) {
      // Return 0 or -1 to indicate no new row inserted
      return 0;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    return await dbHelper.insert('bookmarks', {
      'userId': userId,
      'bookId': bookId,
      'createdAt': now,
    });
  }

  Future<int> removeBookmark(int userId, int bookId) async {
    return await dbHelper.delete('bookmarks', 'userId = ? AND bookId = ?', [
      userId,
      bookId,
    ]);
  }

  Future<bool> isBookmarked(int userId, int bookId) async {
    final db = await dbHelper.database;
    final rows = await db.rawQuery(
      'SELECT 1 FROM bookmarks WHERE userId = ? AND bookId = ? LIMIT 1',
      [userId, bookId],
    );
    return rows.isNotEmpty;
  }

  Future<List<InfoBuku>> getBookmarksByUser(int userId) async {
    final db = await dbHelper.database;
    try {
      await db.rawDelete(
        'DELETE FROM bookmarks WHERE id NOT IN (SELECT MAX(id) FROM bookmarks WHERE userId = ? GROUP BY bookId) AND userId = ?',
        [userId, userId],
      );
    } catch (e) {
      // ignore errors during cleanup
    }
    final rows = await db.rawQuery(
      'SELECT b.* FROM books b JOIN bookmarks bm ON b.id = bm.bookId WHERE bm.userId = ? ORDER BY bm.createdAt DESC',
      [userId],
    );
    return rows.map((r) {
      final map = Map<String, dynamic>.from(r);
      map['tersedia'] = (map['tersedia'] == 1);
      return InfoBuku.fromMap(map);
    }).toList();
  }
}
