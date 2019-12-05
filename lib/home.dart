import 'package:flutter/material.dart';
import 'subs.dart';
import 'settings.dart';
import 'feeds.dart';

// ------------Home--------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _drawerindex = 0;

  Widget _getMainPage(int i){
    switch(i) {
      case(0): return new FeedsPage();
      case(1): return new SubsPage();
      case(2): return new SettingsPage();
    }
    return Text("Error");
  }
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
                  setState(() => _drawerindex = 0);
                  Navigator.pop(context);
                },
              ),
              Divider(

              ),
              ListTile(
                leading: Icon(Icons.subscriptions),
                title: Text("Subscriptions"),
                onTap: (){
                  setState(() => _drawerindex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: (){
                  setState(() => _drawerindex = 2);
                  Navigator.pop(context);
                },
              ),
            ],
          )
      ),
      body: _getMainPage(_drawerindex),
    );
  }
}