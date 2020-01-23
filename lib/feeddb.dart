import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'sourcedb.dart';
import 'package:http/http.dart' as Http;
import 'package:webfeed/webfeed.dart' as WebFeed;
import 'dart:core';

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
    List<Map> fetchedDB;
    fetchRaw () async {
      fetchedDB = await database.rawQuery(
          'SELECT * FROM feed ORDER BY id DESC LIMIT 10'
      );
    }
    await fetchRaw();
    return Future.value(List.generate(fetchedDB.length, (i) {
      return FeedEntry(
        id: fetchedDB[i]['id'],
        title: fetchedDB[i]['title'],
        link: fetchedDB[i]['link'],
        description: fetchedDB[i]['description'],
        author: fetchedDB[i]['author'],
        getTime: fetchedDB[i]['getTime'],
        sourceID: fetchedDB[i]['sourceID'],
        readState: fetchedDB[i]['readState'],
      );
    }));
  }

  static Future<List<FeedEntry>> queryMore(int lastLoadedID) async{
    Database database;
    Future openDB () async{
      database = await openDatabase(
        join(await getDatabasesPath(), 'database.db'),
        version: 1,
      );
    }
    await openDB();
    List<Map> newlyFetched;
    fetchMore() async {
      newlyFetched = await database.rawQuery(
        'SELECT * FROM feed WHERE id < ? ORDER BY id DESC LIMIT 1', [lastLoadedID]
      );
    }
    await fetchMore();
    return Future.value(List.generate(newlyFetched.length, (i) {
      return FeedEntry(
        id: newlyFetched[i]['id'],
        title: newlyFetched[i]['title'],
        link: newlyFetched[i]['link'],
        description: newlyFetched[i]['description'],
        author: newlyFetched[i]['author'],
        getTime: newlyFetched[i]['getTime'],
        sourceID: newlyFetched[i]['sourceID'],
        readState: newlyFetched[i]['readState'],
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

    //check if the link exists in db
    List<Map> sameLinkEntry = await database.query(
        'feed',
        where: 'link == "${entry.link}"'
    );
    if(sameLinkEntry.isNotEmpty){
//      print("${entry.link} duplicated.");
      return;
    }

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
      bool successFlag = true;
      Http.Response response = await Http.get(source.url).catchError((error){successFlag = false;});
      if(!successFlag) continue;
      WebFeed.RssFeed feed = new WebFeed.RssFeed.parse(response.body);
      for (final item in feed.items){
        String fullText = "";
        fullText = fullText + item.description + (item.content == null? "" : item.content.value);
        FeedEntry entry = new FeedEntry(
          id: null,
          title: item.title,
          link: item.link,
          description: fullText,
          author: item.author == null ? "Unknown Author" : item.author,
          getTime: new DateTime.now().millisecondsSinceEpoch ~/ 1000,
          sourceID: source.id,
          readState: 0
        );
//        print("link: ${item.link}");
//        print("des: $fullText");
//        print("author: ${item.author}");
//        print("getTime: ${item.title}");
//        print("------------------------------------");
        await FeedDBOperations.addFeedToDB(entry);
      }
    }
  }

  static Future<void> updateReadToDB(FeedEntry entry, int value) async {
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
      {'id': entry.id, 'title': entry.title, 'link': entry.link, 'description': entry.description, 'author': entry.author,
        'getTime': entry.getTime, 'sourceID': entry.sourceID, 'readState': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}