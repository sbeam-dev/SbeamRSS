import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RssSource {
  final int id;
  final String name;
  final String url;
  RssSource({this.id, this.name, this.url});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }
}


class SourceDBOperations{
  static Future<List<RssSource>> querySourceDatabase() async{
    Database database;
    Future openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'source_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE source(id INTEGER PRIMARY KEY, name TEXT, url TEXT)",
          );
        },
        version: 1,
      );
    }
    await openDB();
    List<Map> fetcheddb;
    fetchRaw () async {
      fetcheddb = await database.query(
        'source',
      );
    }
    await fetchRaw();
    return Future.value(List.generate(fetcheddb.length, (i) {
      return RssSource(
        id: fetcheddb[i]['id'],
        name: fetcheddb[i]['name'],
        url: fetcheddb[i]['url'],
      );
    }));
  }

  static Future<void> addSourceToDB(RssSource newsource) async{
    Database database;
    openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'source_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE source(id INTEGER PRIMARY KEY, name TEXT, url TEXT)",
          );
        },
        version: 1,
      );
    }
    await openDB();
    await database.insert(
      'source',
      newsource.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteSourceDB(int delId) async{
    Database database;
    openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'source_database.db'),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE source(id INTEGER PRIMARY KEY, name TEXT, url TEXT)",
          );
        },
        version: 1,
      );
    }
    await openDB();
    await database.delete(
      'source',
      where: 'id = ?',
      whereArgs: [delId],
    );
    await database.rawUpdate("UPDATE source SET id = id-1 WHERE id > ?", [delId]);
  }
}