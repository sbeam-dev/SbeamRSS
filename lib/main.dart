import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/models/readermodel.dart';
import 'package:flutter_app1/models/thememodel.dart';
import 'package:flutter_app1/models/sourcemodel.dart';
import 'package:flutter_app1/models/feedmodel.dart';
import 'package:provider/provider.dart';
import 'interfaces/home.dart';

void main() => runApp(
  new MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SourceModel()),
        ChangeNotifierProvider(create: (context) => FeedModel()),
        ChangeNotifierProvider(create: (context) => ReaderModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
      ],
      child: MyApp(),
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sbeam RSS Reader',
      theme: ThemeData(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black54),
            elevation: 4
        ),
        popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            textStyle: TextStyle(fontFamily: "NotoSans", color: Colors.black, fontSize: 16)
        ),
        textTheme: TextTheme(
          headline6: TextStyle(fontFamily: "NotoSans", color: Colors.black),
          subtitle1: TextStyle(fontFamily: "NotoSans"),
          headline5: TextStyle(fontFamily: "NotoSans"),
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(fontFamily: "NotoSans", color: Colors.black),
          subtitle1: TextStyle(fontFamily: "NotoSans"),
          headline5: TextStyle(fontFamily: "NotoSans"),
        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
      darkTheme: ThemeData(
          backgroundColor: Color(0xFF121212),
          brightness: Brightness.dark,
          cardColor: Color(0xFF272727),
          appBarTheme: AppBarTheme(
              color: Color(0xFF383838),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 4
          ),
          popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              textStyle: TextStyle(fontFamily: "NotoSans", color: Colors.white, fontSize: 16)
          ),
          textTheme: TextTheme(
            headline6: TextStyle(fontFamily: "NotoSans", color: Colors.white),
            subtitle1: TextStyle(fontFamily: "NotoSans"),
            headline5: TextStyle(fontFamily: "NotoSans"),
          ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(fontFamily: "NotoSans", color: Colors.white),
            subtitle1: TextStyle(fontFamily: "NotoSans"),
            headline5: TextStyle(fontFamily: "NotoSans"),
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
      ),
      home: MyHomePage(title: 'Home Page'),
      themeMode: (Provider.of<ThemeModel>(context).currentTheme == ThemeOptions.system) ? ThemeMode.system
          : ((Provider.of<ThemeModel>(context).currentTheme == ThemeOptions.light) ? ThemeMode.light : ThemeMode.dark),
    );
  }
}