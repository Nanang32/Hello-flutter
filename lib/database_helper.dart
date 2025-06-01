import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dest.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'destwisata.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE destination (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desc TEXT,
        locate TEXT,
        photo TEXT
      )
    ''');
  }

  Future<int> insertDest(Dest dest) async {
    Database db = await instance.db;
    return await db.insert('destination', dest.toMap());
  }

  Future<List<Map<String, dynamic>>> queryAllDests() async {
    Database db = await instance.db;
    return await db.query('destination');
  }

  Future<int> updateDest(Dest dest) async {
    Database db = await instance.db;
    return await db.update(
      'destination',
      dest.toMap(),
      where: 'id = ?',
      whereArgs: [dest.id],
    );
  }

  Future<int> deleteDest(int id) async {
    Database db = await instance.db;
    return await db.delete('destination', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> initializeDests() async {
    List<Dest> destsToAdd = [
      Dest(
        title: 'lorem',
        desc: 'lorem ipsum sadasd',
        locate: 'lorem',
        photo: 'lorem',
      ),
    ];

    for (Dest dest in destsToAdd) {
      await insertDest(dest);
    }
  }
}
