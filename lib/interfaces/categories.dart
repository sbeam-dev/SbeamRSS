import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  var _box;
  List _catlist;

  void _handleDelete(int index) {
    setState(() {
      _catlist.removeAt(index);
      _box.write('list', _catlist);
    });
  }

  @override
  void initState() {
    _box = GetStorage('categories');
    _box.writeIfNull('list', []);
    // _box.write('list', []);
    _catlist = _box.read('list');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories", style: Theme.of(context).primaryTextTheme.headline6),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: (){
                String input;
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return new SingleChildScrollView(
                      child: Container(
                        padding:
                        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Center(
                                child: Text(
                                  "New Category",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                            ),
                            Padding(
                              child: TextField(
                                // style: TextStyle(fontFamily: 'sans'),
                                decoration: InputDecoration(
                                    labelText: "Name",
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.all(8),
                                    prefixIcon: Icon(
                                      FlutterIcons.pencil_mco,
                                      color: Theme.of(context).accentColor,
                                    )),
                                onChanged: (String text){
                                  input = text;
                                },
                              ),
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            ),
                            ButtonBar(
                              children: <Widget>[
                                Ink(
                                  child: IconButton(
                                    iconSize: 24,
                                    icon: Icon(
                                      FlutterIcons.md_checkmark_ion,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        _catlist.add(input);
                                        _box.write('list', _catlist);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
              icon: Icon(Icons.add)
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.zero,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white:Theme.of(context).backgroundColor,
        child: CategoriesList(catlist: _catlist, delCallback: _handleDelete,),
      ),
    );
  }
}


class CategoriesList extends StatelessWidget {
  List catlist;
  final ValueChanged<int> delCallback;
  CategoriesList({Key key, @required this.catlist, @required this.delCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (catlist.length == 0) {
      return Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 64, 0, 16),
              child: Icon(Icons.category, size: 64,
                color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
              ),
            ),
            Text("Empty here.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                fontSize: 24
            )),),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: Text("Tap the button to add category.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                  color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                  fontSize: 20
              )),),
            )
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: catlist.length,
        itemBuilder: (BuildContext context, int index){
          return ListTile(
            leading: Icon(MaterialCommunityIcons.tag, color: Colors.primaries[index % Colors.primaries.length],),
            title: Text(catlist[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red,),
              onPressed: (){
                delCallback(index);
              },
            ),
          );
        },
      );
    }
  }
}