import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBhelper {
  static Future<Database> open(String dbPath) async {
    final db =
        await openDatabase(dbPath, onCreate: (Database dbs, int version) async {
      return dbs.execute('CREATE TABLE meda (uid TEXT,name TEXT,time TEXT)');
    }, version: 1);
    // await insert(db);
    return db;
  }

  static Future<void> insert(String uid, String med, String time) async {
    final dbPath = await startDatabase();

    final db = await open(dbPath);

    await db.insert(
        'meda', {'uid': '$uid', 'name': '$med', 'time': '$time'}).then((value) {
      print('added');
    });
  }

  static Future<String> startDatabase() async {
    var db = await getDatabasesPath();
    String dbPath = path.join(db, 'fresh.db');

    return dbPath;
  }

  static Future<void> query() async {
    final dbPath = await startDatabase();
    final db = await open(dbPath);

    final list = await db.rawQuery('SELECT * from meda');
    list.forEach((element) {
      print(element['name'] + "uid=" + element['uid']);

      // return {'uid': element['$uid'], 'img': (element['$img'])};
    });
  }

  static Future<void> delete(String id) async {
    // Get a reference to the database.
    final dbPath = await startDatabase();
    final db = await open(dbPath);

    await db.delete(
      'meda',
      // Use a `where` clause to delete a specific dog.
      where: "uid =?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: ['$id'],
    ).then((value) => print('deleted '));
  }
}
