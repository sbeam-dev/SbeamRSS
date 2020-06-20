import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app1/models/favmodel.dart';
import 'package:flutter_app1/databases/favdb.dart';
import 'reader.dart';
import 'package:time_formatter/time_formatter.dart';

class FavPage extends StatefulWidget {
  FavPage({Key key}) : super(key: key);
  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites", style: Theme.of(context).textTheme.headline6),
        centerTitle: true,
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Consumer<FavModel>(
          builder: (context, favModel, child){
            if(favModel.feedDump == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              int _len = favModel.feedDump.length;
              if (_len == 0) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: (){},
                        child: ListTile(
                          title: Text("Empty here."),
                        ),
                      ),
                    );
                  },
                  itemCount: 1,
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    return new FavCard(entry: favModel.feedDump[index], index: index,);
                  },
                  itemCount: _len,
                );
              }
            }
          },
        ),
      ),
    );
  }
}


class FavCard extends StatefulWidget {
  FavCard({Key key, this.entry, this.index}) : super(key: key);
  final FavEntry entry;
  final int index;
  @override
  _FavCardState createState() => new _FavCardState();
}

class _FavCardState extends State<FavCard> {
  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    return htmlText.replaceAll(exp, '');
  }

  @override
  void initState() {
//    _currentReadState = widget.entry.readState;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          color: Theme.of(context).backgroundColor,
          elevation: 0,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: widget.entry.toFeedEntry(), sourceName: "Favorites",)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Text(widget.entry.title,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "NotoSans",
                          color: (Theme.of(context).brightness == Brightness.light) ?
                          (Colors.black) :
                          (Colors.white)
                      ),
                      maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(removeAllHtmlTags(widget.entry.description),style: TextStyle(fontSize: 16, fontFamily: "serif"), maxLines: 4, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        formatTime(widget.entry.getTime * 1000),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            Provider.of<FavModel>(context, listen: false).deleteFav(widget.entry.link);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 8,
          thickness: 2,
          indent: 16,
          endIndent: 16,
        )
      ],
    );
  }
}