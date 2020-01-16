import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'feeddb.dart';

class ReaderScreen extends StatelessWidget {
  ReaderScreen({Key key, this.entry}) : super(key: key);
  final FeedEntry entry;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Readerscreen', style: Theme.of(context).textTheme.title),
    ),
    body: ListView(
      children: <Widget>[
        Html(
          data: entry.description,
          onLinkTap: (url) => showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('onTapUrl'),
              content: Text(url),
            ),
          ),
          style: {
            "html": Style(
              backgroundColor: Theme.of(context).backgroundColor,
            ),
            "p": Style(
              fontSize: FontSize.larger,
              fontFamily: 'serif'
            ),
          },
        ),
      ],
    )
  );
}