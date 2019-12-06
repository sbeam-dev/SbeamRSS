import 'package:flutter/material.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


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
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: Container(
      color: Colors.white,
      child: ListTile(
        title: Text('Title of RSSSource'),
        subtitle: Text('http://sourceurl/'),
      ),
    ),
    actions: <Widget>[
      IconSlideAction(
        caption: 'Edit',
        color: Colors.grey,
        icon: Icons.edit,
        onTap: (){

        },
      ),
    ],
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: (){

        },
      ),
    ],
  );;
}

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