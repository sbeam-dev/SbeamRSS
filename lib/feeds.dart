import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/feedmodel.dart';
import 'models/sourcemodel.dart';
import 'reader.dart';
import 'package:time_formatter/time_formatter.dart';
import 'htmlparse.dart';
import 'feeddb.dart';
import 'package:provider/provider.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';

class FeedsPage extends StatefulWidget {
  FeedsPage({Key key}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("Feeds", style: Theme.of(context).textTheme.title),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: (){
                  Provider.of<FeedModel>(context, listen: false).refreshFeed();
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Loading...(It may take a long time for new entries to appear.)")));
                },
              )
            ],
          ),
        ],
        body: Consumer<FeedModel>(
            builder: (context, feedModel, child){
              if(feedModel.feedDump == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int _len = feedModel.feedDump.length;
                if (_len == 0) {
                  return RefreshIndicator(
                    displacement: 20,
                    onRefresh: Provider.of<FeedModel>(context, listen: false).refreshFeed,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: InkWell(
                              splashColor: Colors.blue.withAlpha(30),
                              onTap: (){},
                              child: ListTile(
                                title: Text("No articles. Press the button to refresh."),
                              ),
                            ),
                          );
                        },
                        itemCount: 1,
                    ),
                  );
                } else if (_len < 10) {
                  return RefreshIndicator(
                    displacement: 20,
                    onRefresh: Provider.of<FeedModel>(context, listen: false).refreshFeed,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int index) {
                          return FeedCard(entry: feedModel.feedDump[index]);
                        },
                        itemCount: _len,
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    displacement: 20,
                    onRefresh: Provider.of<FeedModel>(context, listen: false).refreshFeed,
                    child: IncrementallyLoadingListView(
                      padding: EdgeInsets.zero,
                      hasMore: () => !feedModel.isFinished,
                      itemCount: () => feedModel.feedDump.length,
                      loadMore: feedModel.loadMore,
                      itemBuilder: (context, index) {
                        return FeedCard(entry: feedModel.feedDump[index]);
                      },
                    ),
                  );
                }
              }
            },
          ),
      )
    );
  }
}

class FeedCard extends StatelessWidget {
  FeedCard({Key key, this.entry}) : super(key: key);
  final FeedEntry entry;

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(
        r"<[^>]*>",
        multiLine: true,
        caseSensitive: true
    );

    return htmlText.replaceAll(exp, '');
  }

  @override
  Widget build(BuildContext context) {
    String sourceName;
    for (final source in Provider.of<SourceModel>(context, listen: false).sourceDump) {
      if (source.id == entry.sourceID) {
        sourceName = source.name;
        break;
      }
    }
    return Column(
      children: <Widget>[
        Card(
          color: Theme.of(context).backgroundColor,
          elevation: 0,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: entry, sourceName: sourceName,)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: Text("From " + sourceName,
                      style: TextStyle(fontSize: 14, fontFamily: "NotoSans"), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 6),
                  child: Text(entry.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "NotoSans"), maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(removeAllHtmlTags(entry.description),style: TextStyle(fontSize: 16, fontFamily: "serif"), maxLines: 4, overflow: TextOverflow.ellipsis),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        formatTime(entry.getTime * 1000),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(
                        height: 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: Icon(Icons.more_vert),
                          onPressed: (){},
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