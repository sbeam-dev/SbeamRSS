import 'package:flutter/material.dart';
import '../models/sourcemodel.dart';
import '../models/feedmodel.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../databases/sourcedb.dart';


// ----------build list of source---------
class SourceListTile extends StatelessWidget {
  final RssSource source;
  const SourceListTile({this.source});
  @override
  Widget build(BuildContext context){
    return new Column(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
//            splashFactory: InkRipple.splashFactory,
            splashColor: Theme.of(context).accentColor.withAlpha(30),
            child: ListTile(
              title: Text("${source.name}", maxLines: 1, overflow: TextOverflow.ellipsis,),
              subtitle: Text("${source.url}", maxLines: 1, overflow: TextOverflow.ellipsis,),
              trailing: Icon(Icons.more_vert, color: (Theme.of(context).brightness == Brightness.light) ? Colors.black : Colors.white,),
            ),
            onTap: (){
              showModalBottomSheet(context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  builder: (BuildContext context){
                    return new SourceBottomSheet(source: source);
                  }
              );
            },
          ),
        ),
        Divider(
          height: 2,
          thickness: 1,
        )
      ],
    );
  }
}


class SourceBottomSheet extends StatelessWidget {
  final RssSource source;
  const SourceBottomSheet({this.source});
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.edit, color: Theme.of(context).accentColor,),
          title: Text("Edit Name"),
          onTap: (){
            Navigator.pop(context);
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context){
                return new EditBottomSheet(
                  source: source,
                  editType: 0,
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.link, color: Theme.of(context).accentColor,),
          title: Text("Edit URL"),
          onTap: (){
            Navigator.pop(context);
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context){
                return new EditBottomSheet(
                  source: source,
                  editType: 1,
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text("Delete this source", style: TextStyle(color: Colors.red),),
          onTap: (){
            ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
            pr.style(
              message: "Loading...",
              borderRadius: 10,
              backgroundColor: Theme.of(context).appBarTheme.color,
              progressWidget: Padding(
                child: CircularProgressIndicator(),
                padding: EdgeInsets.all(16),
              ),
              messageTextStyle: Theme.of(context).textTheme.headline6,
            );
            pr.show();
//            print("Delete ${widget.source.id}");
            Future.wait([Provider.of<SourceModel>(context, listen: false).deleteEntry(source.id),
              Provider.of<FeedModel>(context, listen: false).deleteSource(source.id)])
                .then((values) => pr.hide().then((isHidden){Navigator.pop(context);}));
          },
        )
      ],
    );
  }
}

Widget _buildSubItem(int index, var sourceDump){
  RssSource fetchedSource = sourceDump[index];
  return SourceListTile(source: fetchedSource);
}

// --------------Add button-----------
class AddSourceBottomSheet extends StatefulWidget {
  @override
  _AddSourceBottomSheet createState() => _AddSourceBottomSheet();
}

class _AddSourceBottomSheet extends State<AddSourceBottomSheet> {
  String inputName = "";
  String inputUrl = "";
  int changeColor;
  //int inputId;

  void toggleColor(int value) {
    setState(() {
      changeColor = value;
    });
  }

  @override
  void initState() {
    changeColor = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Container(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text("New RSS Source",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Padding(
              child: TextField(
                style: TextStyle(fontFamily: 'sans'),
                decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.note, color: Theme.of(context).accentColor,)
                ),
                onChanged: (text){inputName = text;},
              ),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
            Padding(
              child: TextField(
                style: TextStyle(fontFamily: 'sans'),
                decoration: InputDecoration(
                    labelText: "URL",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon: Icon(Icons.link, color: Theme.of(context).accentColor)
                ),
                onChanged: (text){
                  inputUrl = text;
                  if (text != "" && changeColor == 0) {
                    toggleColor(1);
                  } else if (text == "" && changeColor == 1) {
                    toggleColor(0);
                  }
                  },
              ),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
            ButtonBar(
              children: <Widget>[
                Ink(
                  decoration: ShapeDecoration(
                    color: changeColor == 1 ? Colors.lightBlue:Colors.transparent,
                    shape: CircleBorder(),

                  ),
                  child: IconButton(
                    iconSize: 24,
                    icon: Icon(
                      Icons.send,
                      color: changeColor == 0 ? Theme.of(context).appBarTheme.iconTheme.color : Colors.white,
                    ),
                    onPressed: changeColor == 0 ? null : (){
                      ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
                      pr.style(
                        message: "Loading...",
                        borderRadius: 10,
                        backgroundColor: Theme.of(context).appBarTheme.color,
                        progressWidget: Padding(
                          child: CircularProgressIndicator(),
                          padding: EdgeInsets.all(16),
                        ),
                        messageTextStyle: Theme.of(context).textTheme.headline6
                      );
                      pr.show();
                      Provider.of<SourceModel>(context, listen: false).checkEntry(inputUrl).then(
                              (value) {
                                if (value == false) {
                                  pr.hide().then((isHidden){
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return new AlertDialog(
                                            title: Text("URL not valid!"),
                                            content: Text("Check your URL, or the webfeed server is temporarily unavailable.", style: TextStyle(fontFamily: 'sans')),
                                            actions: <Widget>[
                                              FlatButton(
                                                child: Text('OK'),
                                                onPressed: (){Navigator.pop(context);},
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  });
                                } else {
                                  Provider.of<SourceModel>(context, listen: false).addEntry(inputName, inputUrl).then(
                                      (value) {
                                        pr.hide().then((isHidden){
                                          Navigator.pop(context);
                                        });
                                        }
                                  );
                                }
                              }
                              );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// --------------Edit---------------
class EditBottomSheet extends StatefulWidget{
  final RssSource source;
  final int editType;//0 - Edit Name, 1 - Edit URL
  EditBottomSheet({this.source, this.editType});

  @override
  _EditBottomSheet createState() => _EditBottomSheet();
}

class _EditBottomSheet extends State<EditBottomSheet>{
  String inputName;
  String inputUrl;
  TextEditingController controller;

  String _titleGen(){
    switch(widget.editType){
      case 0: return "Edit Name";
      case 1: return "Edit URL";
    }
    return "ERROR";
  }


  String _defaultText(){
    switch(widget.editType){
      case 0: return inputName;
      case 1: return inputUrl;
    }
    return "ERROR";
  }

  void _dealInput(String text){
    switch(widget.editType){
      case 0:
        inputName = text;
        break;
      case 1:
//        print("set!");
        inputUrl = text;
//        print(inputUrl);
        break;
    }
  }

  @override
  void initState() {
    inputName = widget.source.name;
    inputUrl = widget.source.url;
    controller = TextEditingController();
    controller.text = _defaultText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: Container(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(_titleGen(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                      style: TextStyle(fontFamily: 'sans'),
                      controller: controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                          prefixIcon: Icon(Icons.edit, color: Theme.of(context).accentColor,)
                      ),
                      onChanged: _dealInput,
                ),
            ),
            ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  iconSize: 24,
                  onPressed: (){
                    if(widget.editType == 0) {
                      Provider.of<SourceModel>(context, listen: false).editEntry(widget.source.id, inputName, inputUrl);
                      Navigator.pop(context);
                    } else {
                      ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false);
                      pr.style(
                          message: "Loading...",
                          borderRadius: 10,
                          backgroundColor: Theme.of(context).appBarTheme.color,
                          progressWidget: Padding(
                            child: CircularProgressIndicator(),
                            padding: EdgeInsets.all(16),
                          ),
                          messageTextStyle: Theme.of(context).textTheme.headline6
                      );
                      pr.show();
                      Provider.of<SourceModel>(context, listen: false).checkEntry(inputUrl).then(
                              (value) {
//                                print(inputUrl);
                            if (value == false) {
                              pr.hide().then((isHidden){
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return new AlertDialog(
                                        title: Text("URL not valid!"),
                                        content: Text("Check your URL, or the webfeed server is temporarily unavailable.", style: TextStyle(fontFamily: 'sans')),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: (){Navigator.pop(context);},
                                          )
                                        ],
                                      );
                                    }
                                );
                              });
                            } else {
                              Provider.of<SourceModel>(context, listen: false).editEntry(widget.source.id, inputName, inputUrl).then(
                                      (value) {
                                    pr.hide().then((isHidden){
                                      Navigator.pop(context);
                                    });
                                  }
                              );
                            }
                          }
                      );
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ---------------Page--------------
class SubsPage extends StatefulWidget {
  SubsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SubsPageState createState() => _SubsPageState();
}

class _SubsPageState extends State<SubsPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            title: Text("Subscriptions",style: Theme.of(context).textTheme.headline6),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: (){
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context){
                      return AddSourceBottomSheet();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ],
          ),
          Consumer<SourceModel>(
            builder: (context, sourceModel, child){
              if(sourceModel.sourceDump == null) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return CircularProgressIndicator();
                    },
                    childCount: 1,
                  ),
                );
              } else if (sourceModel.listLen == 0) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          splashColor: Theme.of(context).accentColor.withAlpha(30),
                          onTap: (){},
                          child: ListTile(
                            title: Text("No subscribed RSS source."),
                          ),
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _buildSubItem(index, sourceModel.sourceDump);
                    },
                    childCount: sourceModel.listLen,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}