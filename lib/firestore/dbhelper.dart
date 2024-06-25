import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'babyname.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE names (
        id INTEGER PRIMARY KEY,
        name TEXT,
        meaning TEXT,
        liked_name INTEGER,
        rejected_name INTEGER
      )
    ''');
  }

  Future<Map<String, dynamic>> getNameById(int id) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'names',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {'name': 'No name', 'meaning': 'No meaning'};
    }
  }

  Future<List<Map<String, dynamic>>> getDataByLikedName(
      String likedName) async {
    final db = await database;
    return await db.query(
      'names',
      where: 'liked_name = ?',
      whereArgs: [likedName],
    );
  }

  Future<void> updateLikedName(int id, int liked) async {
    final db = await database;
    await db.update(
      'names',
      {'liked_name': liked},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateRejectedName(int id, int rejected) async {
    final db = await database;
    await db.update(
      'names',
      {'rejected_name': rejected},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
