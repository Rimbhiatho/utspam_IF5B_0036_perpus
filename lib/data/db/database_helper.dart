import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/infobuku.dart';

class DatabaseHelper {
  // Singleton instance agar hanya ada satu koneksi database
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // Getter untuk mendapatkan database, jika belum ada maka dibuat baru
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('perpus.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  // Membuat tabel-tabel utama aplikasi
  Future _createDB(Database db, int version) async {
    // Tabel users: menyimpan data pengguna

    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      username TEXT,
      nik TEXT,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      phone TEXT,
      address TEXT,
      createdAt INTEGER
    )
    ''');
    // Tabel loans: menyimpan data peminjaman buku
    await db.execute('''
    CREATE TABLE books (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      author TEXT,
      genre TEXT,
      synopsis TEXT,
      imagePath TEXT,
      biaya INTEGER,
      tersedia INTEGER
    )
    ''');

    // Tabel riwayat: mencatat aktivitas user terhadap buku
    await db.execute('''
    CREATE TABLE loans (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      bookId INTEGER NOT NULL,
      borrowDate INTEGER NOT NULL,
      dueDate INTEGER NOT NULL,
      returnDate INTEGER,
      status TEXT,
      biaya INTEGER,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (bookId) REFERENCES books(id)
    )
    ''');

    // Tabel bookmarks: menyimpan buku favorit user
    await db.execute('''
    CREATE TABLE riwayat (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      bookId INTEGER NOT NULL,
      action TEXT NOT NULL,
      timestamp INTEGER NOT NULL,
      note TEXT,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (bookId) REFERENCES books(id)
    )
    ''');

    // Upgrade database jika versi berubah
    await db.execute('''
    CREATE TABLE bookmarks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId INTEGER NOT NULL,
      bookId INTEGER NOT NULL,
      createdAt INTEGER,
      FOREIGN KEY (userId) REFERENCES users(id),
      FOREIGN KEY (bookId) REFERENCES books(id)
    )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS bookmarks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        bookId INTEGER NOT NULL,
        createdAt INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id),
        FOREIGN KEY (bookId) REFERENCES books(id)
      )
      ''');
    }
    if (oldVersion < 3) {
      try {
        await db.execute('ALTER TABLE users ADD COLUMN username TEXT');
      } catch (e) {
        // ignore if column already exists or other errors during alter
      }
    }
    if (oldVersion < 4) {
      try {
        await db.execute('ALTER TABLE users ADD COLUMN nik TEXT');
      } catch (e) {
        // ignore if column already exists or other errors during alter
      }
    }
  }

  // Seed data awal buku jika tabel books masih kosong
  Future<void> seedInitialData(List<InfoBuku> daftarBuku) async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM books'),
    );
    if (count == 0) {
      for (final b in daftarBuku) {
        final map = b.toMap();
        map['tersedia'] = (map['tersedia'] == true) ? 1 : 0;
        await db.insert('books', map);
      }
    }
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.insert(table, values);
  }

  // Fungsi CRUD umum
  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final db = await instance.database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table,
    String where,
    List<dynamic> whereArgs,
  ) async {
    final db = await instance.database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await instance.database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  // Menutup koneksi database
  Future close() async {
    final db = _database;
    if (db != null) await db.close();
    _database = null;
  }
}
