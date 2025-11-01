import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/session.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('focus_breath.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        duration INTEGER NOT NULL,
        breathingProtocol TEXT,
        completedAt TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertSession(Session session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<Session>> getAllSessions() async {
    final db = await database;
    final result = await db.query(
      'sessions',
      orderBy: 'completedAt DESC',
    );
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<List<Session>> getSessionsByType(String type) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'completedAt DESC',
    );
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<List<Session>> getSessionsByDate(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final result = await db.query(
      'sessions',
      where: 'completedAt >= ? AND completedAt < ?',
      whereArgs: [
        startOfDay.toIso8601String(),
        endOfDay.toIso8601String(),
      ],
      orderBy: 'completedAt DESC',
    );
    return result.map((map) => Session.fromMap(map)).toList();
  }

  Future<int> deleteSession(int id) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
