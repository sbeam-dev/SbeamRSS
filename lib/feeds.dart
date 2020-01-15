import 'package:flutter/material.dart';
import 'reader.dart';

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
          floating: true,
          snap: true,
          title: Text("Feeds", style: Theme.of(context).textTheme.title),
          centerTitle: true,
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen()));
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text("Title of the article"),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("The first few words of the article..."),
                                Text(""),
                                Text(
                                  "1 minutes ago",
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                                ),
                              ]
                          ),
                          contentPadding: EdgeInsets.all(8.0),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: (){},
                      ),
                    ],
                  )
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