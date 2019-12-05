import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sbeam RSS Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: FlutterLogo(),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
            ),
            Divider(
              
            ),
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close Drawer'),
              onTap: () {
                // change app state...
                Navigator.pop(context); // close the drawer
              },
            ),
          ],
        )
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: Text("Home"),
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
                      child: Text("card"),
                    ),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      )

    );
  }
}