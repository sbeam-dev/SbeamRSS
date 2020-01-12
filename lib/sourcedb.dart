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
        join(await getDatabasesPath(), 'database.db'),
        onCreate: (db, version) {
          db.execute(
            "CREATE TABLE source(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, url TEXT)",
          );
          db.execute(
            "CREATE TABLE feed(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, gettime INTEGER, sourceid INTEGER, readstate INTEGER)",
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

  static Future<void> addSourceToDB(String name, String address) async{
    Database database;
    openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    await database.insert(
      'source',
      {'name': name, 'url':address},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteSourceDB(int delId) async{
    Database database;
    openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    await database.delete(
      'source',
      where: 'id = ?',
      whereArgs: [delId],
    );
  }
}