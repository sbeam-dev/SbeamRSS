import 'package:flutter/material.dart';
import 'dart:async';

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


Future<RssSource> _querySourceDatabase(int id) async {
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'source_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE source(id INTEGER PRIMARY KEY, name TEXT, url TEXT)",
      );
    },
    version: 1,
  );

}


// ----------build list of source---------
class SourceListTile extends StatefulWidget {
  @override
  _SourceListTileState createState() => _SourceListTileState();
}

class _SourceListTileState extends State<SourceListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ListTile(
          title: Text("Title of RSS source"),
          subtitle: Text("http://url/"),
          trailing: Icon(Icons.more_vert),
        ),
        onTap: (){
          showModalBottomSheet(context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              builder: (BuildContext context){
                return SourceBottomSheet();
            }
          );
        },
      ),
    );
  }
}

class SourceBottomSheet extends StatefulWidget {
  @override
  _SourceBottomSheet createState() => _SourceBottomSheet();
}

class _SourceBottomSheet extends State<SourceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: <Widget>[
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Edit Name"),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.link),
          title: Text("Edit URL"),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text("Delete this source", style: TextStyle(color: Colors.red),),
          onTap: (){

          },
        )
      ],
    );
  }
}

Widget _buildSubItem(int index){
//  if (_querySourceDatabase(index) == null) {
//    return null;
//  }
//  RssSource _fetchedsource;
//  setfetched() async{
//    _fetchedsource = await _querySourceDatabase(index);
//  }
//  setfetched();
  if (index > 5) {
    return null;
  }
  return SourceListTile();
}


// ---------------Page--------------
class SubsPage extends StatefulWidget {
  SubsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SubsPageState createState() => _SubsPageState();
}

class _SubsPageState extends State<SubsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text("Subscriptions"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){

              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return _buildSubItem(index);
            },
          ),
        ),
      ],
    );
  }
}