import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FeedEntry {
  final int id;
  final String title;
  final String link;
  final String description;
  final String author;
  final int gettime;  //sqlite format, seconds after 1970-01-01
  final int sourceid;
  final int readstate; //haven't read 0 read 1
  FeedEntry({this.id, this.title, this.link, this.description, this.author, this.gettime, this.sourceid, this.readstate});
}

class FeedDBOperations{
  static Future<List<FeedEntry>> queryTenEntries() async{
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
      fetcheddb = await database.rawQuery(
          'SELECT * from feed ORDER BY id DESC LIMIT 10'
      );
    }
    await fetchRaw();
    return Future.value(List.generate(fetcheddb.length, (i) {
      return FeedEntry(
        id: fetcheddb[i]['id'],
        title: fetcheddb[i]['title'],
        link: fetcheddb[i]['url'],
        description: fetcheddb[i]['description'],
        author: fetcheddb[i]['author'],
        gettime: fetcheddb[i]['gettime'],
        sourceid: fetcheddb[i]['sourceid'],
        readstate: fetcheddb[i]['readstate'],
      );
    }));
  }
  static Future<void> addFeedToDB(FeedEntry entry) async{
    Database database;
    Future openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    await database.insert(
      'feed',
      {'title': entry.title, 'link': entry.link, 'description': entry.description, 'author': entry.author,
      'gettime': entry.gettime, 'sourceid': entry.sourceid, 'readstate': entry.readstate},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}