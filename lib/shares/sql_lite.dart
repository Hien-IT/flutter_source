// ignore_for_file: unnecessary_await_in_return

import 'package:sqflite/sqflite.dart';

class Sqllite {
  static String tableRandomMulti = 'randomMulti';
  static String columnIdMulti = '_id';
  static String columnCreateAtMulti = 'createdAt';
  static String columnRandomMulti = 'list';

  static String tableRandomOne = 'randomOne';

  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = '${databasesPath}demo.db';
    final rs = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableRandomMulti ( 
            $columnIdMulti integer primary key autoincrement, 
            $columnCreateAtMulti datetime,
            $columnRandomMulti text not null)
          ''');

        await db.execute('''
          create table $tableRandomOne ( 
            $columnIdMulti integer primary key autoincrement, 
            $columnCreateAtMulti datetime,
            $columnRandomMulti text not null)
          ''');
      },
    );

    return rs;
  }

  static Future<int> insert(
    Map<String, dynamic> row,
    String table,
  ) async {
    final db = await database;
    final rs = await db.insert(table, row);

    return rs;
  }

  static Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await database;
    final rs = await db.query(table, limit: 200, orderBy: 'createdAt DESC');
    return rs;
  }

  static Future<int?> queryRowCount(String table) async {
    final db = await database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $table'),
    );
  }

  static Future<int> update(Map<String, dynamic> row, String table) async {
    final db = await database;
    final id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> delete(int id, String table) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
