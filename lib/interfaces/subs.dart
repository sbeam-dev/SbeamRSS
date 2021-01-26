import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app1/components/opmlparser.dart';
import 'package:flutter_app1/interfaces/settings.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import '../models/sourcemodel.dart';
import '../models/feedmodel.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../databases/sourcedb.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// ----------build list of source---------
class SourceListTile extends StatelessWidget {
  final RssSource source;
  const SourceListTile({this.source});
  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTileCard(
        baseColor: Theme.of(context).cardColor,
        initialElevation: 0.5,
        elevation: 1.5,
        contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        title: Text(source.name, maxLines: 1, overflow: TextOverflow.ellipsis),
        leading: CircleAvatar(child: Text(source.name[0]),),
        initiallyExpanded: false,
        children: [
          ListTile(
              title: Text(source.url, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyText2,),
              leading: Transform.translate(
                offset: Offset(10,0),
                child: Icon(FlutterIcons.link_2_fea, size: 22,),
              ),
              contentPadding: EdgeInsets.fromLTRB(14, 0, 16, 0),
              dense: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 6, 4),
                    child: OutlinedButton(
                      child: Text("Edit name", style: TextStyle(color: Theme.of(context).accentColor),),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
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
                      style: OutlinedButton.styleFrom(
                        // padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(6, 0, 12, 4),
                    child: OutlinedButton(
                      child: Text("Edit url", style: TextStyle(color: Theme.of(context).accentColor)),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
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
                      style: OutlinedButton.styleFrom(
                        // padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                          )
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 16, 0),
                child: OutlinedButton(
                  child: Text("Delete"),
                  onPressed: () {
                    ProgressDialog pr = new ProgressDialog(context,
                        type: ProgressDialogType.Normal, isDismissible: false);
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
                    Future.wait([
                      Provider.of<SourceModel>(context, listen: false)
                          .deleteEntry(source.id),
                      Provider.of<FeedModel>(context, listen: false)
                          .deleteSource(source.id)
                    ]).then((values) => pr.hide().then((isHidden) {
                      Navigator.pop(context);
                    }));
                  },
                  style: OutlinedButton.styleFrom(
                    // padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)
                      ),
                      primary: Colors.red
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}


// --------------Add button-----------
class AddTile extends StatelessWidget {

  Future<int> importFile(sourcemodel) async {
    //return 0 when success, -1 when cancelled, other when error
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['opml'],
    );
    if(result != null) {
      File file = File(result.files.single.path);
      // print("Selected!");
      // call import
      String opml = file.readAsStringSync();
      OPMLParser.parseOPML(opml).forEach((element) {
        Provider.of<SourceModel>(context, listen: false).addEntry(element.name, element.url);
      });
      Fluttertoast.showToast(msg: "Loaded!");
      return 0;
    } else {
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ElevatedButton(
              onPressed: (){
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return AddSourceBottomSheet();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              },
              child: Text("ADD RSS SOURCE", style: TextStyle(color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white),)
          ),
        ),
        LayoutBuilder(
            builder: (context, constraint){
              double buttonWidth = (constraint.maxWidth-30)/2;
              return ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: buttonWidth,
                    child: OutlinedButton(
                      onPressed: (){
                        ProgressDialog pr = new ProgressDialog(context,
                            type: ProgressDialogType.Normal,
                            isDismissible: false);
                        pr.style(
                            message: "Loading...",
                            borderRadius: 10,
                            backgroundColor:
                            Theme.of(context).appBarTheme.color,
                            progressWidget: Padding(
                              child: CircularProgressIndicator(),
                              padding: EdgeInsets.all(16),
                            ),
                            messageTextStyle:
                            Theme.of(context).textTheme.headline6);
                        pr.show();
                        importFile(Provider.of<SourceModel>(context, listen: false)).then(
                            (value){pr.hide();}
                        );

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FlutterIcons.import_mco,
                            color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white,
                          ),
                          Text("Import", style: TextStyle(color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white),)
                        ],
                      ),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.getFont(
                            'Noto Sans',
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                        )),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(16, 8, 16, 8)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Color(0xFF489c81))
                        )),
                        // minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
                        // backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0e6d55)),
                        // overlayColor: MaterialStateProperty.all<Color>(Color(0xFF489c81)),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: buttonWidth,
                    child: OutlinedButton(
                      onPressed: () async{
                        String output = OPMLParser.generateOPML(Provider.of<SourceModel>(context, listen: false).sourceDump);
                        String dir = (await getExternalStorageDirectory()).path;
                        File file = new File("$dir/rss.opml");
                        file.writeAsStringSync(output);
                        Fluttertoast.showToast(msg: "Saved to $dir/rss.opml");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FlutterIcons.export_mco,
                            color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white,
                          ),
                          Text("Export", style: TextStyle(color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white),)
                        ],
                      ),
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.getFont(
                            'Noto Sans',
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                        )),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(16, 8, 16, 8)),
                        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: BorderSide(color: Color(0xFF489c81))
                        )),
                        // minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(48)),
                        // backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF0e6d55)),
                        // overlayColor: MaterialStateProperty.all<Color>(Color(0xFF489c81)),
                      ),

                    ),
                  )
                ],
              );
            }
        ),
      ],
    );
  }
}


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
                child: Text(
                  "New RSS Source",
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
                onChanged: (text) {
                  inputName = text;
                },
              ),
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            ),
            Padding(
              child: TextField(
                // style: TextStyle(fontFamily: 'sans'),
                decoration: InputDecoration(
                    labelText: "URL",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                    prefixIcon:
                        Icon(FlutterIcons.link_mco, color: Theme.of(context).accentColor)),
                onChanged: (text) {
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
                    color: changeColor == 1
                        ? Theme.of(context).accentColor
                        : Colors.transparent,
                    shape: CircleBorder(),
                  ),
                  child: IconButton(
                    iconSize: 24,
                    icon: Icon(
                      FlutterIcons.md_checkmark_ion,
                      color: changeColor == 0
                          ? Theme.of(context).appBarTheme.iconTheme.color
                          : Colors.white,
                    ),
                    onPressed: changeColor == 0
                        ? null
                        : () {
                            ProgressDialog pr = new ProgressDialog(context,
                                type: ProgressDialogType.Normal,
                                isDismissible: false);
                            pr.style(
                                message: "Loading...",
                                borderRadius: 10,
                                backgroundColor:
                                    Theme.of(context).appBarTheme.color,
                                progressWidget: Padding(
                                  child: CircularProgressIndicator(),
                                  padding: EdgeInsets.all(16),
                                ),
                                messageTextStyle:
                                    Theme.of(context).textTheme.headline6);
                            pr.show();
                            Provider.of<SourceModel>(context, listen: false)
                                .checkEntry(inputUrl)
                                .then((value) {
                              if (value == false) {
                                pr.hide().then((isHidden) {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return new AlertDialog(
                                          title: Text("URL not valid!"),
                                          content: Text(
                                              "Check your URL, or the webfeed server is temporarily unavailable.",
                                              style: TextStyle(
                                                  fontFamily: 'sans')),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        );
                                      });
                                });
                              } else {
                                Provider.of<SourceModel>(context, listen: false)
                                    .addEntry(inputName, inputUrl)
                                    .then((value) {
                                  pr.hide().then((isHidden) {
                                    Navigator.pop(context);
                                  });
                                });
                              }
                            });
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
class EditBottomSheet extends StatefulWidget {
  final RssSource source;
  final int editType; //0 - Edit Name, 1 - Edit URL
  EditBottomSheet({this.source, this.editType});

  @override
  _EditBottomSheet createState() => _EditBottomSheet();
}

class _EditBottomSheet extends State<EditBottomSheet> {
  String inputName;
  String inputUrl;
  TextEditingController controller;

  String _titleGen() {
    switch (widget.editType) {
      case 0:
        return "Edit Name";
      case 1:
        return "Edit URL";
    }
    return "ERROR";
  }

  String _defaultText() {
    switch (widget.editType) {
      case 0:
        return inputName;
      case 1:
        return inputUrl;
    }
    return "ERROR";
  }

  void _dealInput(String text) {
    switch (widget.editType) {
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
                child: Text(
                  _titleGen(),
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
                    prefixIcon: Icon(
                      Icons.edit,
                      color: Theme.of(context).accentColor,
                    )),
                onChanged: _dealInput,
              ),
            ),
            ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  iconSize: 24,
                  onPressed: () {
                    if (widget.editType == 0) {
                      Provider.of<SourceModel>(context, listen: false)
                          .editEntry(widget.source.id, inputName, inputUrl);
                      Navigator.pop(context);
                    } else {
                      ProgressDialog pr = new ProgressDialog(context,
                          type: ProgressDialogType.Normal,
                          isDismissible: false);
                      pr.style(
                          message: "Loading...",
                          borderRadius: 10,
                          backgroundColor: Theme.of(context).appBarTheme.color,
                          progressWidget: Padding(
                            child: CircularProgressIndicator(),
                            padding: EdgeInsets.all(16),
                          ),
                          messageTextStyle:
                              Theme.of(context).textTheme.headline6);
                      pr.show();
                      Provider.of<SourceModel>(context, listen: false)
                          .checkEntry(inputUrl)
                          .then((value) {
//                                print(inputUrl);
                        if (value == false) {
                          pr.hide().then((isHidden) {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return new AlertDialog(
                                    title: Text("URL not valid!"),
                                    content: Text(
                                        "Check your URL, or the webfeed server is temporarily unavailable.",
                                        style: TextStyle(fontFamily: 'sans')),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                          });
                        } else {
                          Provider.of<SourceModel>(context, listen: false)
                              .editEntry(widget.source.id, inputName, inputUrl)
                              .then((value) {
                            pr.hide().then((isHidden) {
                              Navigator.pop(context);
                            });
                          });
                        }
                      });
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
            pinned: true,
            expandedHeight: 80,
            backgroundColor: Theme.of(context).backgroundColor,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double percent = ((constraints.maxHeight - kToolbarHeight - MediaQuery.of(context).padding.top) *
                    100 /
                    (80 - kToolbarHeight)); //change first number to reflect expanded height
                double dx = 0;
                dx = 18+(100 - percent)*(MediaQuery.of(context).size.width-36-122)*(0.005);
                // print(dx);
                // 12x is the width of text widget
                // print(constraints.maxHeight - kToolbarHeight);
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
                          child: Text("Subscriptions", style: Theme.of(context).textTheme.headline6,),
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
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                },
              ),
            ],
          ),
          Consumer<SourceModel>(
            builder: (context, sourceModel, child) {
              if (sourceModel.sourceDump == null) {
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
                      if (index == 1) return AddTile();
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 32, 0, 16),
                            child: Icon(FlutterIcons.radio_fea, size: 64,
                              color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                            ),
                          ),
                          Text("Empty here.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                              color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                              fontSize: 24
                          )),),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
                            child: Text("Tap the button to add source.", style: GoogleFonts.ubuntu(textStyle: TextStyle(
                                color: (Theme.of(context).brightness==Brightness.light)?Colors.black54:Colors.white54,
                                fontSize: 20
                            )),),
                          )
                        ],
                      );
                    },
                    childCount: 2,
                  ),
                );
              } else {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == sourceModel.listLen) return AddTile();
                      return SourceListTile(
                          source: sourceModel.sourceDump[index]);
                      // return _buildSubItem(index, sourceModel.sourceDump);
                    },
                    childCount: sourceModel.listLen+1,
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
