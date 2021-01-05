import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/models/readermodel.dart';
import 'package:flutter_app1/models/thememodel.dart';
import 'package:flutter_app1/models/sourcemodel.dart';
import 'package:flutter_app1/models/feedmodel.dart';
import 'package:flutter_app1/models/favmodel.dart';
import 'package:provider/provider.dart';
import 'interfaces/home.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
  new MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SourceModel()),
        ChangeNotifierProvider(create: (context) => FeedModel()),
        ChangeNotifierProvider(create: (context) => ReaderModel()),
        ChangeNotifierProvider(create: (context) => ThemeModel()),
        ChangeNotifierProvider(create: (context) => FavModel()),
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
        backgroundColor: Color(0xFFF5F5F6),
        // primaryColor: Color(0xFF1f8dd6),
        primaryColor: Color(0xFF65dcb7),
        primaryColorBrightness: Brightness.light,
        brightness: Brightness.light,
        accentColor: Color(0xFF489c81),
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black87),
            elevation: 4
        ),
        popupMenuTheme: PopupMenuThemeData(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            textStyle: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.black, fontSize: 16))
        ),
        textTheme: TextTheme(
          // headline4: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.black), fontSize: 30),
          headline6: GoogleFonts.getFont('Ubuntu', textStyle: TextStyle(color: Colors.black)),
          subtitle1: GoogleFonts.getFont('Noto Sans'),
          headline5: GoogleFonts.getFont('Noto Sans'),
          bodyText2: GoogleFonts.getFont('Noto Sans'),
        ),
        primaryTextTheme: TextTheme(
          headline6: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.black)),
          subtitle1: GoogleFonts.getFont('Noto Sans'),
          headline5: GoogleFonts.getFont('Noto Sans'),
        ),
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.getFont(
              'Noto Sans',
              textStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)
            )),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(16, 8, 16, 8)),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                // side: BorderSide(color: Colors.red)
            )),
            minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF65dcb7)),
            overlayColor: MaterialStateProperty.all<Color>(Color(0xFF489c81)),
          )
        ),
        // visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      darkTheme: ThemeData(
          backgroundColor: Color(0xFF181819),
          brightness: Brightness.dark,
          cardColor: Color(0xFF222223),
          primaryColor: Color(0xFF0e6d55),
          canvasColor: Color(0xFF202022),
          primaryColorBrightness: Brightness.light,
          accentColor: Color(0xFF489c81),
          appBarTheme: AppBarTheme(
              color: Color(0xFF202022),
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 4
          ),
          popupMenuTheme: PopupMenuThemeData(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              textStyle: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.white, fontSize: 16))
          ),
          textTheme: TextTheme(
            // headline4: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.white), fontSize: 30),
            headline6: GoogleFonts.getFont('Ubuntu', textStyle: TextStyle(color: Colors.white)),
            subtitle1: GoogleFonts.getFont('Noto Sans'),
            headline5: GoogleFonts.getFont('Noto Sans'),
            bodyText2: GoogleFonts.getFont('Noto Sans'),
          ),
          primaryTextTheme: TextTheme(
            headline6: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Colors.white)),
            subtitle1: GoogleFonts.getFont('Noto Sans'),
            headline5: GoogleFonts.getFont('Noto Sans'),
          ),
          pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder()}),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.getFont(
                  'Noto Sans',
                  textStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
              )),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(16, 8, 16, 8)),
              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                // side: BorderSide(color: Colors.red)
              )),
              minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0e6d55)),
              overlayColor: MaterialStateProperty.all<Color>(Color(0xFF489c81)),
            )
        ),
          // visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: MyHomePage(title: 'Home Page'),
      themeMode: (Provider.of<ThemeModel>(context).currentTheme == ThemeOptions.system) ? ThemeMode.system
          : ((Provider.of<ThemeModel>(context).currentTheme == ThemeOptions.light) ? ThemeMode.light : ThemeMode.dark),
    );
  }
}