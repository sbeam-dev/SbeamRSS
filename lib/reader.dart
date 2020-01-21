import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'feeddb.dart';

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
                        child: Text(entry.title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.4)),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                        child: Text(entry.author + ' from ' + sourceName, style: TextStyle(fontFamily: "serif", fontSize: 15)),
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
