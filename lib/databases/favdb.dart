import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'feeddb.dart';
import 'dart:core';

class FavEntry {
  final int id;
  final String title;
  final String link;
  final String description;
  final String author;
  final int getTime;  //sqlite format, seconds after 1970-01-01
  FavEntry({this.id, this.title, this.link, this.description, this.author, this.getTime});

  FeedEntry toFeedEntry() {
    return FeedEntry(
      id: this.id,
      title: this.title,
      link: this.link,
      description: this.description,
      author: this.author,
      getTime: this.getTime,
      sourceID: null,
      readState: 0
    );
  }
}

class FavDBOperations{
  static Future<List<FavEntry>> queryEntries() async{
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
      database.execute('CREATE TABLE IF NOT EXISTS fav(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, getTime INTEGER)');
      fetchedDB = await database.rawQuery(
          'SELECT * FROM fav ORDER BY id DESC'
      );
    }
    await fetchRaw();
    return Future.value(List.generate(fetchedDB.length, (i) {
      return FavEntry(
        id: fetchedDB[i]['id'],
        title: fetchedDB[i]['title'],
        link: fetchedDB[i]['link'],
        description: fetchedDB[i]['description'],
        author: fetchedDB[i]['author'],
        getTime: fetchedDB[i]['getTime'],
      );
    }));
  }

  static Future<int> addFeedToDB(FeedEntry entry) async{
    Database database;
    Future openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    database.execute('CREATE TABLE IF NOT EXISTS fav(id INTEGER PRIMARY KEY, title TEXT, link TEXT, description TEXT, author TEXT, getTime INTEGER)');
    //check if the link exists in db
    List<Map> sameLinkEntry = await database.query(
        'fav',
        where: 'link = ?',
        whereArgs: [entry.link]
    );
    if(sameLinkEntry.isNotEmpty){
//      print("${entry.link} duplicated.");
      return 1;
    }

    await database.insert(
      'fav',
      {'title': entry.title, 'link': entry.link, 'description': entry.description, 'author': entry.author,
        'getTime': entry.getTime,},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return 0;
  }

  static Future<void> deleteFeedToDB(String link) async{
    Database database;
    Future openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    await database.delete('fav', where: 'link = ?', whereArgs: [link]);
  }
}