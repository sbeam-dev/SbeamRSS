import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavPage extends StatefulWidget {
  FavPage({Key key}) : super(key: key);
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites", style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text("Upcoming feature, still under construction."),
            )
          ],
        ),
      ),
    );
  }
}