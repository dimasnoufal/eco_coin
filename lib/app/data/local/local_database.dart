import 'package:eco_coin/app/data/models/recycling_item.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static const String _databaseName = "eco_coin.db";
  static const String _tableName = "history_recycling";
  static const int _databaseVersion = 1;

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        categoryName TEXT,
        confidence TEXT,
        image BLOB,
        date TEXT,
        ecoPoints INTEGER DEFAULT 0
      )
      """);
  }

  Future<Database> _initializeDb() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
  }

  Future<int> insertItem(RecyclingItem recyclingItem) async {
    final db = await _initializeDb();

    final data = recyclingItem.toJson();
    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<RecyclingItem>> getAllItems() async {
    final db = await _initializeDb();
    final results = await db.query(_tableName, orderBy: "id");

    return results.map((result) => RecyclingItem.fromJson(result)).toList();
  }

  Future<RecyclingItem> getItemById(int id) async {
    final db = await _initializeDb();
    final results = await db.query(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
      limit: 1,
    );

    return results.map((result) => RecyclingItem.fromJson(result)).first;
  }

  Future<int> removeItem(int id) async {
    final db = await _initializeDb();

    final result = await db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return result;
  }

  Future<void> close() async {
    final db = await _initializeDb();
    db.close();
  }
}
