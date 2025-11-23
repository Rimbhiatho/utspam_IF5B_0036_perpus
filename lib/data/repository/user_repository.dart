import '../db/database_helper.dart';
import '../model/user.dart';

class UserRepository {
  final dbHelper = DatabaseHelper.instance;

  Future<UserModel> createUser(UserModel user) async {
    final id = await dbHelper.insert('users', user.toMap());
    return UserModel(
      id: id,
      name: user.name,
      username: user.username,
      email: user.email,
      password: user.password,
      phone: user.phone,
      address: user.address,
      createdAt: user.createdAt,
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final rows = await dbHelper.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<UserModel?> getUserByIdentifier(String identifier) async {
    final rows = await dbHelper.query(
      'users',
      where: 'email = ? OR nik = ?',
      whereArgs: [identifier, identifier],
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<UserModel?> getUserById(int id) async {
    final rows = await dbHelper.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  Future<List<UserModel>> getAllUsers() async {
    final rows = await dbHelper.queryAll('users');
    return rows.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> updateUser(UserModel user) async {
    final values = user.toMap()..remove('id');
    return await dbHelper.update('users', values, 'id = ?', [user.id]);
  }

  Future<int> deleteUser(int id) async {
    return await dbHelper.delete('users', 'id = ?', [id]);
  }
}
