import 'package:flutter/material.dart';
import 'package:flutter_app1/models/sourcemodel.dart';
import 'package:provider/provider.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: SourceModel(),
        child:  MaterialApp(
          title: 'Sbeam RSS Reader',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Home Page'),
        ),
    );
  }
}