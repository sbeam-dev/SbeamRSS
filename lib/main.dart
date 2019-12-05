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
      routes: <String, WidgetBuilder>{
        '/subs': (BuildContext context) => SubsPage(title: "Subscriptions"),
        '/settings': (BuildContext context) => SettingsPage(title: "Settings"),
      },
    );
  }
}


// ------------Home--------------
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
              leading: Icon(Icons.rss_feed),
              title: Text("My feeds"),
              onTap: (){
                Navigator.pushNamed(context, '/');
              },
            ),
            Divider(
              
            ),
            ListTile(
              leading: Icon(Icons.subscriptions),
              title: Text("Subscriptions"),
              onTap: (){
                Navigator.pushNamed(context, '/subs');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: (){
                Navigator.pushNamed(context, '/settings');
              },
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
      )

    );
  }
}


// --------------Subscriptions------------
class SubsPage extends StatefulWidget {
  SubsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SubsPageState createState() => _SubsPageState();
}

class _SubsPageState extends State<SubsPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(

        drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: FlutterLogo(),
                ),
                ListTile(
                  leading: Icon(Icons.rss_feed),
                  title: Text("My feeds"),
                  onTap: (){
                    Navigator.pushNamed(context, '/');
                  },
                ),
                Divider(

                ),
                ListTile(
                  leading: Icon(Icons.subscriptions),
                  title: Text("Subscriptions"),
                  onTap: (){
                    Navigator.pushNamed(context, '/subs');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  onTap: (){
                    Navigator.pushNamed(context, '/settings');
                  },
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
              title: Text("Subscriptions"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: (){

                  },
                ),
              ],
            ),

          ],
        )

    );
  }
}

// -------------Settings-------------------
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}