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
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReaderScreen()));
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text("Title of the article"),
                        subtitle: Text("The first few words of the article..."),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "1 minutes ago",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: (){},
                          )
                        ],
                      )
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