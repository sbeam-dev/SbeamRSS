import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_app1/sourcedb.dart';

class FeedEntry {
  final int id;
  final String title;
  final String link;
  final String description;
  final String author;
  final int getTime;  //sqlite format, seconds after 1970-01-01
  final int sourceID;
  final int readState; //haven't read 0 read 1
  FeedEntry({this.id, this.title, this.link, this.description, this.author, this.getTime, this.sourceID, this.readState});
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
            "CREATE TABLE feed(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, getTime INTEGER, sourceID INTEGER, readState INTEGER)",
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
        getTime: fetcheddb[i]['getTime'],
        sourceID: fetcheddb[i]['sourceID'],
        readState: fetcheddb[i]['readState'],
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
      'getTime': entry.getTime, 'sourceID': entry.sourceID, 'readState': entry.readState},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> refreshToDB() async{
    List<RssSource> sourceList;
    sourceList = await SourceDBOperations.querySourceDatabase();
    for (final source in sourceList){
      //pull rss from web and add
    }
  }
}