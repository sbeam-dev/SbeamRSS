import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/interfaces/settings.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/feedmodel.dart';
import '../databases/feeddb.dart';
import '../models/sourcemodel.dart';
import 'reader.dart';
import 'package:time_formatter/time_formatter.dart';
import '../components/htmlparse.dart';
import 'package:provider/provider.dart';
import 'package:incrementally_loading_listview/incrementally_loading_listview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedsPage extends StatefulWidget {
  final ScrollController scrController;
  FeedsPage({Key key, this.scrController}) : super(key: key);

  @override
  _FeedsPageState createState() => _FeedsPageState();
}

class _FeedsPageState extends State<FeedsPage> {

  void ignoreDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('launched', true);
  }

  void launchDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool iflaunched = (prefs.getBool('launched') ?? false);
    if (iflaunched) {
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("Welcome to SbeamRSS!"),
              content: Column(
                children: <Widget>[
                  Text("For better user experience, please take time to read the docs.", style: TextStyle(fontFamily: 'sans'),)

                ],
                mainAxisSize: MainAxisSize.min,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Take me there"),
                  onPressed: (){
                    launch("https://github.com/sbeam-dev/SbeamRSS/wiki/Quick-start");
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text("Don't show again"),
                  onPressed: (){
                    ignoreDialog();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  @override

  void initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => launchDialog()
    );
  }

  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: NestedScrollView(
        controller: widget.scrController,
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            // floating: true,
            // snap: true,
            pinned: true,
            expandedHeight: 80,
            backgroundColor: Theme.of(context).backgroundColor,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double percent = ((constraints.maxHeight - kToolbarHeight - MediaQuery.of(context).padding.top) *
                    100 /
                    (80 - kToolbarHeight)); //change first number to reflect expanded height
                double dx = 0;
                dx = 18+(100 - percent)*(MediaQuery.of(context).size.width-36-54)*(0.005);
                // print(dx);
                // 54 is the width of text widget
                // print(constraints.maxHeight - kToolbarHeight);
                // print(percent);
                return Stack(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).appBarTheme.color.withOpacity(percent>100?0:((100-percent)/100)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: kToolbarHeight / 4, left: 0.0),
                      child: Transform.translate(
                        child: Transform.scale(
                          scale: 1+0.008*percent,
                          child: Text("Feeds", style: Theme.of(context).textTheme.headline6,),
                          alignment: Alignment.bottomLeft,
                        ),
                        offset:
                        Offset(dx, 4+constraints.maxHeight - kToolbarHeight),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      showSearch(
                          context: context,
                          delegate: FeedSearchDelegate(),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    },
                  ),
            ],
          ),
        ],
        body: Consumer<FeedModel>(
            builder: (context, feedModel, child){
              if(feedModel.feedDump == null || Provider.of<SourceModel>(context).sourceDump == null) {
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
                          return Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                                child: Icon(FlutterIcons.folder_open_o_faw, size: 64,
                                  color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                                ),
                              ),
                              Text("No articles.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                                fontSize: 24
                              )),),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Text("Swipe down to refresh.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                    color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                                    fontSize: 20
                                )),),
                              )
                            ],
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
                          return new FeedCard(entry: feedModel.feedDump[index], index: index,);
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
//                        print(index);
                        return new FeedCard(entry: feedModel.feedDump[index], index: index,);
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

class FeedCard extends StatefulWidget {
  FeedCard({Key key, this.entry, this.index}) : super(key: key);
  final FeedEntry entry;
  final int index;
  @override
  _FeedCardState createState() => new _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
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
//    print("Start building...");
    String sourceName;
//    print(Provider.of<SourceModel>(context, listen: false).sourceDump);
    for (final source in Provider.of<SourceModel>(context, listen: false).sourceDump) {
//      print("looping");
      if (source.id == widget.entry.sourceID) {
        sourceName = source.name;
        break;
      }
    }
//    print("Reached before actual widgets");
    String headImageSrc = HtmlParsing.headImage(widget.entry.description);
//    print(headImageSrc);
    if (headImageSrc == null || headImageSrc == "") {
      return Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            child: InkWell(
              splashColor: Theme.of(context).accentColor.withAlpha(30),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: widget.entry, sourceName: sourceName,)));
//                softSetRead(1);
                Provider.of<FeedModel>(context, listen: false).setRead(widget.entry, 1, widget.index);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Text(sourceName,
                        style: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Theme.of(context).accentColor,fontSize: 15),),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text(widget.entry.title,
                        style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: (Theme.of(context).brightness == Brightness.light) ?
                            (Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0 ? Colors.black : Colors.black54) :
                            (Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0 ? Colors.white : Colors.white70)
                        ),),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(removeAllHtmlTags(widget.entry.description),
                        style: GoogleFonts.sourceSansPro(textStyle: TextStyle(fontSize: 17)),
                        maxLines: 5, overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          formatTime(widget.entry.getTime * 1000),
                          style: GoogleFonts.notoSans(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,
                            color: Theme.of(context).brightness==Brightness.light?Colors.black87:Colors.white70
                          )),
                        ),
                        SizedBox(
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            icon: Icon(Icons.more_vert),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  builder: (BuildContext context) => FeedBottomSheet(
                                    entry: widget.entry,
                                    sourceName: sourceName,
                                    index: widget.index,
                                    )
                              );
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
            thickness: 1,
            indent: 0,
            endIndent: 0,
          )
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            child: InkWell(
              splashColor: Theme.of(context).accentColor.withAlpha(30),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: widget.entry, sourceName: sourceName,)));
//                softSetRead(1);
                Provider.of<FeedModel>(context, listen: false).setRead(widget.entry, 1, widget.index);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  LayoutBuilder(
                      builder: (context, constraint){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: FittedBox(
                                  child: CachedNetworkImage(
                                    imageUrl: headImageSrc,
                                    placeholder: (context, url) => Image.memory(kTransparentImage),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                            ),
                          ],
                        );
                      }
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Text(sourceName,
                        style: GoogleFonts.getFont('Noto Sans', textStyle: TextStyle(color: Theme.of(context).accentColor,fontSize: 15),),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
                    child: Text(widget.entry.title,
                        style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: (Theme.of(context).brightness == Brightness.light) ?
                            (Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0 ? Colors.black : Colors.black54) :
                            (Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0 ? Colors.white : Colors.white70)
                        )),
                        maxLines: 3, overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 4, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          formatTime(widget.entry.getTime * 1000),
                          style: GoogleFonts.notoSans(textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w300,
                              color: Theme.of(context).brightness==Brightness.light?Colors.black87:Colors.white70
                          )),
                        ),
                        SizedBox(
                          height: 32,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 18,
                            icon: Icon(Icons.more_vert),
                            onPressed: (){
                              showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  builder: (BuildContext context) => FeedBottomSheet(
                                    entry: widget.entry,
                                    sourceName: sourceName,
                                    index: widget.index
                                    )
                              );
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
            thickness: 1,
            indent: 0,
            endIndent: 0,
          )
        ],
      );
    }
  }
}

class FeedBottomSheet extends StatefulWidget {
  final FeedEntry entry;
  final String sourceName;
  final int index;
  const FeedBottomSheet({this.entry, this.sourceName, this.index});
  @override
  _FeedBottomSheetState createState() => _FeedBottomSheetState();
}

class _FeedBottomSheetState extends State<FeedBottomSheet> {

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 16, 0),
          leading: Icon(FlutterIcons.md_mail_unread_ion),
          title: Text((Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0) ? "Mark as read" : "Mark as unread"),
          onTap: (){
            Provider.of<FeedModel>(context).setRead(widget.entry, Provider.of<FeedModel>(context).feedDump[widget.index].readState == 0 ? 1 : 0, widget.index);
            Navigator.pop(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 16, 0),
          leading: Icon(FlutterIcons.md_share_ion),
          title: Text("Share..."),
          onTap: (){
            Share.share("Check out this RSS article (\"${widget.entry.title}\") from ${widget.sourceName}! ${widget.entry.link}");
            Navigator.pop(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 16, 0),
          leading: Icon(FlutterIcons.md_open_ion),
          title: Text("Open in browser..."),
          onTap: (){
            _launchURL(widget.entry.link);
            Navigator.pop(context);
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(20, 0, 16, 0),
          leading: Icon(FlutterIcons.md_heart_ion, color: Colors.pink,),
          title: Text("Add to favorites"),
          onTap: (){
            Provider.of<FavModel>(context, listen: false).addFav(widget.entry);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}

class FeedSearchDelegate extends SearchDelegate {

  Future<List<String>> getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = prefs.getStringList("searchHistory") ?? [];
    return searchHistory;
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light) {
      final ThemeData base = Theme.of(context);
      return base.copyWith(
        primaryColor: Colors.white,
        primaryIconTheme: base.iconTheme
      );
    } else {
      final ThemeData theme = Theme.of(context);
      return theme;
    }
  }

  @override
  List<Widget> buildActions(BuildContext context){
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder(
      stream: Stream.fromFuture(FeedDBOperations.searchFeedDB(query)),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError)
          return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none: return LoadingCard();
          case ConnectionState.waiting: return LoadingCard();
          case ConnectionState.active: return LoadingCard();
          case ConnectionState.done: {
            if (snapshot.data.isEmpty) {
              return new ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: (){},
                      child: ListTile(
                        title: Text("No result found."),
                      ),
                    ),
                  );
                },
                itemCount: 1,
              );
            } else {
              return new Container(
                color: Theme.of(context).backgroundColor,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return new ResultFeedCard(entry: snapshot.data[index]);
                    }
                ),
              );
            }
          }
        }
        return null;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: getHistory(),
      builder: (context, snapshot){
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index){
                if (index == 0) {
                  return ListTile(
                    leading: Icon(Icons.info),
                    title: Text("Keywords seperated by spaces, case sensitive", style: TextStyle(fontFamily: "sans"),),
                  );
                } else {
                  return ListTile(
                    leading: Icon(Icons.restore),
                    title: Text(snapshot.data[index-1]),
                    onTap: (){
                      query = snapshot.data[index-1];
                      showResults(context);
                    },
                  );
                }
              }
          );
        } else {
          return ListTile(
            leading: Icon(Icons.info),
            title: Text("Keywords seperated by spaces, case sensitive", style: TextStyle(fontFamily: "sans"),),
          );
        }
      },
    );
  }
}

class ResultFeedCard extends StatefulWidget {
  ResultFeedCard({Key key, this.entry}) : super(key: key);
  final FeedEntry entry;
  @override
  _ResultFeedCardState createState() => new _ResultFeedCardState();
}

class _ResultFeedCardState extends State<ResultFeedCard> {
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
      if (source.id == widget.entry.sourceID) {
        sourceName = source.name;
        break;
      }
    }
    String headImageSrc = HtmlParsing.headImage(widget.entry.description);
//    print(headImageSrc);
    if (headImageSrc == null || headImageSrc == "") {
      return Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: widget.entry, sourceName: sourceName,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                      child: Text("From " + sourceName,
                          style: Theme.of(context).textTheme.bodyText2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 6),
                    child: Text(widget.entry.title,
                        style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: (Theme.of(context).brightness == Brightness.light) ?
                            (Colors.black) :
                            (Colors.white)
                        )),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(removeAllHtmlTags(widget.entry.description),style: TextStyle(fontSize: 16, fontFamily: "serif"), maxLines: 4, overflow: TextOverflow.ellipsis),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 4, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          formatTime(widget.entry.getTime * 1000),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
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
    } else {
      return Column(
        children: <Widget>[
          Card(
            color: Theme.of(context).backgroundColor,
            elevation: 0,
            child: InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReaderScreen(entry: widget.entry, sourceName: sourceName,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: Text("From " + sourceName,
                                    style: Theme.of(context).textTheme.bodyText2, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.left)
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 6),
                              child: Text(widget.entry.title,
                                  style: GoogleFonts.getFont("Noto Sans", textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                                      color: (Theme.of(context).brightness == Brightness.light) ?
                                      (Colors.black) :
                                      (Colors.white)
                                  ),),
                                  maxLines: 3, overflow: TextOverflow.ellipsis),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Text(removeAllHtmlTags(widget.entry.description),style: TextStyle(fontSize: 16, fontFamily: "serif"), maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 140,
                        width: 140,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                          child: ExtendedImage.network(
//                            headImageSrc,
//                            cache: true,
//                          ),
                          child: CachedNetworkImage(
                            imageUrl: headImageSrc,
                            placeholder: (context, url) => Image.memory(kTransparentImage),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 4, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          formatTime(widget.entry.getTime * 1000),
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
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
}

class LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: (){},
            child: ListTile(
              title: Text("Loading..."),
            ),
          ),
        );
      },
      itemCount: 1,
    );
  }
}