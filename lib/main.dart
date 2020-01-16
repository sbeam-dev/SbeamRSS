import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/models/sourcemodel.dart';
import 'package:flutter_app1/models/feedmodel.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SourceModel()),
        ChangeNotifierProvider(create: (context) => FeedModel())
      ],
      child:  MaterialApp(
        title: 'Sbeam RSS Reader',
        theme: ThemeData(
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          appBarTheme: AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: Colors.black54),
              elevation: 4
          ),
        ),
        darkTheme: ThemeData(
          backgroundColor: Color(0xFF121212),
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(
              color: Color(0xFF121212),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 4
          ),
        ),
        home: MyHomePage(title: 'Home Page'),
      ),
    );
  }
}