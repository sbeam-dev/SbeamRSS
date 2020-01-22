import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'feeddb.dart';

enum menuItems { share, open, customize }

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


  ScrollController _scrollController;
  double _scrollValue = 0;
  _scrollListener() {
    setState(() {
      _scrollValue = (_scrollController.position.pixels - _scrollController.position.minScrollExtent)
          / (_scrollController.position.maxScrollExtent - _scrollController.position.minScrollExtent);
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var entry = widget.entry;
    var sourceName = widget.sourceName;
    return Scaffold(
        body: Container(
          color: Theme.of(context).backgroundColor,
          child: new CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                title: Text("Article", style: Theme.of(context).textTheme.title,),
                actions: <Widget>[
                  PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    onSelected: (menuItems selected) {
                      if (selected == menuItems.share) {
                        Share.share("Check out this RSS article (\"${entry.title}\") from $sourceName! ${entry.link}");
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<menuItems>>[
                      new PopupMenuItem<menuItems>(
                        value: menuItems.share,
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
                      new PopupMenuItem<menuItems>(
                        value: menuItems.open,
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
                      new PopupMenuItem<menuItems>(
                          value: menuItems.customize,
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
                        child: Text(entry.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.4, fontFamily: "NotoSans")),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Text(entry.author + ' from ' + sourceName, style: TextStyle(fontFamily: "NotoSans", fontSize: 15)),
                      ),
                      Divider(
                        indent: 16,
                        endIndent: 16,
                        thickness: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Html(
                          data: entry.description,
                          onLinkTap: (url) => _launchURL(url),
                          style: {
                            "html": Style(
                              backgroundColor: Theme.of(context).backgroundColor,
                            ),
                            "a": Style(
                                color: Theme.of(context).brightness == Brightness.dark ? Color(0xFF8BB3F4):Color(0xFF127ACA)
                            ),
                            "span": Style.fromTextStyle(
                                TextStyle(fontSize: 17, fontFamily: 'serif')
                            ),
                            "p": Style.fromTextStyle(
                                TextStyle(fontSize: 17, fontFamily: 'serif')
                            ),
                          },
                        ),
                      )
                    ]
                ),
              ),
            ],
          ),
        )
    );
  }
}
