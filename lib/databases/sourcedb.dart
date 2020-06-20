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
            "CREATE TABLE feed(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, getTime INTEGER, sourceID INTEGER, readState INTEGER)",
          );
          db.execute(
            "CREATE TABLE fav(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, getTime INTEGER)",
          );
        },
        version: 1,
      );
    }
    await openDB();
    List<Map> fetchedDB;
    fetchRaw () async {
      fetchedDB = await database.query(
        'source',
      );
    }
    await fetchRaw();
    return Future.value(List.generate(fetchedDB.length, (i) {
      return RssSource(
        id: fetchedDB[i]['id'],
        name: fetchedDB[i]['name'],
        url: fetchedDB[i]['url'],
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

  static Future<void> editSourceDB(int id, String name, String url) async{
    Database database;
    openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    await database.update(
      'source',
      {
        'name': name,
        'url': url
      },
      where: "id = $id",
      conflictAlgorithm: ConflictAlgorithm.abort
    );
  }
}