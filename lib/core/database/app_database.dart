import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'tables.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  static Future<Database>
  _initDatabase() async {
    final dbPath =
    await getDatabasesPath();

    final path = join(
      dbPath,
      'expense_manager.db',
    );

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(
      Database db,
      int version,
      ) async {
    await db.execute('''
      CREATE TABLE ${DbTables.categories}(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        is_synced INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DbTables.transactions}(
        id TEXT PRIMARY KEY,
        amount REAL NOT NULL,
        note TEXT,
        type TEXT NOT NULL,
        category_id TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        is_synced INTEGER NOT NULL,
        is_deleted INTEGER NOT NULL,

        FOREIGN KEY(category_id)
        REFERENCES ${DbTables.categories}(id)
      )
    ''');
  }
}