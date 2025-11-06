import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:calculator/model/calculation_history.dart';

class DatabaseHelper {
  static const _databaseName = "Calculator.db";
  static const _databaseVersion = 1;
  static const table = 'history';
  
  static const columnId = 'id';
  static const columnExpression = 'expression';
  static const columnResult = 'result';
  static const columnTimestamp = 'timestamp';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnExpression TEXT NOT NULL,
        $columnResult TEXT NOT NULL,
        $columnTimestamp INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insert(CalculationHistory history) async {
    Database db = await instance.database;
    return await db.insert(table, history.toMap());
  }

  Future<List<CalculationHistory>> getAllHistory() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      orderBy: '$columnTimestamp DESC'
    );

    return List.generate(maps.length, (i) {
      return CalculationHistory.fromMap(maps[i]);
    });
  }
  
  Future<int> clearHistory() async {
    Database db = await instance.database;
    return await db.delete(table);
  }
}