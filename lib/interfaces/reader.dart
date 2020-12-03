import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:provider/provider.dart';
import '../models/readermodel.dart';
import '../databases/feeddb.dart';

enum MenuItems { share, open, customize }

class ReaderScreen extends StatefulWidget {
  ReaderScreen({Key key, this.entry, this.sourceName}) : super(key: key);
  final FeedEntry entry;
  final String sourceName;

  @override
  _ReaderScreenState createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return;
    }
  }

  String _toHTML(String str) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );
    if (str.contains(exp)) return str;
    return '<p>' + str + '</p>';
  }

//  ScrollController _scrollController;
  double _scrollValue = 0;
//  _scrollListener() {
//    setState(() {
//      _scrollValue = (_scrollController.position.pixels - _scrollController.position.minScrollExtent)
//          / (_scrollController.position.maxScrollExtent - _scrollController.position.minScrollExtent);
//    });
//  }

  @override
  void initState() {
//    _scrollController = ScrollController();
//    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  String fontToGoogle(String font) {
    switch (font) {
      case "serif": return "Noto Serif";
      case "sans": return "Roboto";
      case "NotoSans": return "Noto Sans";
    }
    return "Noto Serif";
  }

  @override
  Widget build(BuildContext context) {
    var entry = widget.entry;
    var sourceName = widget.sourceName;
    return Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: new NotificationListener<ScrollEndNotification>(
            onNotification: (notification){
              setState(() {
                _scrollValue = (notification.metrics.pixels - notification.metrics.minScrollExtent) /
                    (notification.metrics.maxScrollExtent - notification.metrics.minScrollExtent);
                if (_scrollValue.isNaN || _scrollValue.isInfinite) _scrollValue = 0;
              });
              return true;
            },
            child: CustomScrollView(
//            controller: _scrollController,
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  title: Text("Article", style: Theme.of(context).textTheme.headline6,),
                  actions: <Widget>[
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      onSelected: (MenuItems selected) {
                        if (selected == MenuItems.share) {
                          Share.share("Check out this RSS article (\"${entry.title}\") from $sourceName! ${entry.link}");
                        } else if (selected == MenuItems.open) {
                          _launchURL(entry.link);
                        } else if (selected == MenuItems.customize) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomizeSheet();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItems>>[
                        new PopupMenuItem<MenuItems>(
                            value: MenuItems.share,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Icon(Icons.share),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text("Share..."),
                                ),
                              ],
                            )
                        ),
                        new PopupMenuItem<MenuItems>(
                          value: MenuItems.open,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(Icons.open_in_new),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text("Open link..."),
                              ),
                            ],
                          ),
                        ),
                        new PopupMenuItem<MenuItems>(
                            value: MenuItems.customize,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  child: Icon(Icons.text_fields),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: Text("Customize"),
                                ),
                              ],
                            )
                        )
                      ],
                    )
                  ],
                bottom: PreferredSize(
                  child: SizedBox(
                    child: LinearProgressIndicator(value: _scrollValue),
                    height: 2.0,
                  ),
                  preferredSize: Size.fromHeight(2.0),
                ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(entry.title, style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.4))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                          child: Text(entry.author + ' from ' + sourceName, style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 15))),
                        ),
                        Divider(
                          indent: 16,
                          endIndent: 16,
                          thickness: 2,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Consumer<ReaderModel>(
                            builder: (context, readerModel, child){
                              return Html(
                                data: _toHTML(entry.description),
                                onLinkTap: (url) => _launchURL(url),
                                style: {
                                  "html": Style(
                                    backgroundColor: Theme.of(context).backgroundColor,
                                  ),
                                  "a": Style(
                                      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF8BB3F4):Color(0xFF127ACA)
                                  ),
                                  "span": Style.fromTextStyle(
                                      GoogleFonts.getFont(fontToGoogle(readerModel.fontFamily), textStyle: TextStyle(fontSize: readerModel.fontSize))
                                  ),
                                  "p": Style.fromTextStyle(
                                      GoogleFonts.getFont(fontToGoogle(readerModel.fontFamily), textStyle: TextStyle(fontSize: readerModel.fontSize))
                                  ),
                                },
                              );
                            },
                          ),
                        )
                      ]
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

enum RadioItem { sans, serif, noto }

class CustomizeSheet extends StatefulWidget {
  @override
  _CustomizeSheetState createState() => new _CustomizeSheetState();
}

class _CustomizeSheetState extends State<CustomizeSheet> {
  String _currentFont;
  RadioItem _currentRadioItem;

  _onRadioChanged(RadioItem value) {
    Provider.of<ReaderModel>(context, listen: false).changeFont(value);
    setState(() {
      _currentRadioItem = value;
      if (value == RadioItem.serif) {
        _currentFont = "serif";
      } else if (value == RadioItem.sans) {
        _currentFont = "sans";
      } else {
        _currentFont = "NotoSans";
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _currentFont = Provider.of<ReaderModel>(context).fontFamily;
    if (_currentFont == "sans") {
      _currentRadioItem = RadioItem.sans;
    } else if (_currentFont == "serif") {
      _currentRadioItem = RadioItem.serif;
    } else if (_currentFont == "NotoSans") {
      _currentRadioItem = RadioItem.noto;
    } else {
      _currentRadioItem = RadioItem.serif;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
          leading: Icon(Icons.format_size),
          title: Text("Font Size", style: GoogleFonts.notoSans(),),
          trailing: SizedBox(
            width: 125,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: (){
                    Provider.of<ReaderModel>(context, listen: false).decreaseSize();
                  },
                ),
                Text(Provider.of<ReaderModel>(context).fontSize.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    Provider.of<ReaderModel>(context, listen: false).addSize();
                  },
                )
              ],
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.font_download),
          title: Text("Font Family:", style: GoogleFonts.notoSans(),),
        ),
        RadioListTile<RadioItem>(
          title: Text("Serif (Default)", style: GoogleFonts.notoSerif(),),
          value: RadioItem.serif,
          groupValue: _currentRadioItem,
          onChanged: _onRadioChanged
        ),
        RadioListTile<RadioItem>(
          title: Text("Roboto", style: GoogleFonts.roboto(),),
          value: RadioItem.sans,
          groupValue: _currentRadioItem,
          onChanged: _onRadioChanged,
        ),
        RadioListTile<RadioItem>(
          title: Text("Noto Sans", style: GoogleFonts.notoSans(),),
          value: RadioItem.noto,
          groupValue: _currentRadioItem,
          onChanged: _onRadioChanged,
        )
      ],
    );
  }
}