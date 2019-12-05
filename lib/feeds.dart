import 'package:flutter/material.dart';

class FeedsPage extends StatefulWidget {
  FeedsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text("Feeds"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: (){

              },
            ),
          ],
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Card(
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: (){
                    print("Tapped");
                  },
                  child: Container(
                    width: 300,
                    height: 150,
                    child: Text("An article"),
                  ),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}