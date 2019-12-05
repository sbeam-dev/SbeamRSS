import 'package:flutter/material.dart';

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
                    child: Text("A Sub card"),
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