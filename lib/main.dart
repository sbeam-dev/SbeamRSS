import 'package:flutter/material.dart';
import 'package:flutter_app1/models/sourcemodel.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          primarySwatch: Colors.indigo,
          brightness: brightness,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black54),
            elevation: 4
          ),
        ),
        themedWidgetBuilder: (context, theme) {
          return new ChangeNotifierProvider.value(
            value: SourceModel(),
            child:  MaterialApp(
              title: 'Sbeam RSS Reader',
              theme: theme,
              home: MyHomePage(title: 'Home Page'),
            ),
          );
        }
    );
  }
}