import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHelper with ChangeNotifier {
  static const tableName = 'user';
  sql.Database? db;

  DBHelper() {
    // this will run when provider is instantiate the first time
    init();
  }

  void init() async {
    final dbPath = await sql.getDatabasesPath();
    db = await sql.openDatabase(
      path.join(dbPath, 'userDB.db'),
      onCreate: (db, version) {
        final stmt = '''CREATE TABLE IF NOT EXISTS $tableName (
            id TEXT PRIMARY KEY,
            username TEXT
        )'''
            .trim()
            .replaceAll(RegExp(r'[\s]{2,}'), ' ');
        return db.execute(stmt);
      },
      version: 1,
    );
    // the init funciton is async so it won't block the main thread
    // notify provider that depends on it when done
    notifyListeners();
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    await db!
        .insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  Future delete(String table) async {
    await db!.delete(table, where: 'id = ?', whereArgs: [1]);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    return await db!.query(
      table,
    );
  }
}