import 'package:flutter/material.dart';
import 'models/sourcemodel.dart';
import 'package:provider/provider.dart';
import 'sourcedb.dart';


// ----------build list of source---------
class SourceListTile extends StatefulWidget {
  final RssSource source;
  const SourceListTile({this.source});
  @override
  _SourceListTileState createState() => _SourceListTileState();
}

class _SourceListTileState extends State<SourceListTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        child: ListTile(
          title: Text("${widget.source.name}"),
          subtitle: Text("${widget.source.url}"),
          trailing: Icon(Icons.more_vert),
        ),
        onTap: (){
          showModalBottomSheet(context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              builder: (BuildContext context){
                return SourceBottomSheet(source: widget.source);
            }
          );
        },
      ),
    );
  }
}

class SourceBottomSheet extends StatefulWidget {
  final RssSource source;
  const SourceBottomSheet({this.source});
  @override
  _SourceBottomSheet createState() => _SourceBottomSheet();
}

class _SourceBottomSheet extends State<SourceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: <Widget>[
        ListTile(
          leading: Icon(Icons.edit),
          title: Text("Edit Name"),
          onTap: (){
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context){
                return EditBottomSheet(
                  source: widget.source,
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
          leading: Icon(Icons.link),
          title: Text("Edit URL"),
          onTap: (){
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context){
                return EditBottomSheet(
                  source: widget.source,
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
            Provider.of<SourceModel>(context, listen: false).deleteEntry(widget.source.id);
            Navigator.pop(context);
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
  //int inputId;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text("New RSS Source",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "Name",
              ),
              onChanged: (text){inputName = text;},
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "URL",
              ),
              onChanged: (text){inputUrl = text;},
            ),
            ListTile(
              dense: true,
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: (){
                  Provider.of<SourceModel>(context, listen: false).addEntry(inputName, inputUrl);
                  Navigator.pop(context);
                },
              ),
            )
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

  String _titleGen(){
    switch(widget.editType){
      case 0: return "Edit Name";
      case 1: return "Edit URL";
    }
    return "ERROR";
  }

  String _inputTitleGen(){
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
        inputUrl = text;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    inputName = widget.source.name;
    inputUrl = widget.source.url;
    final controller = TextEditingController();
    controller.text = _defaultText();
    return SingleChildScrollView(
      child: Container(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Center(
                child: Text(_titleGen(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: _inputTitleGen(),
              ),
              onChanged: _dealInput,

            ),
            ListTile(
              dense: true,
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: (){
                  Provider.of<SourceModel>(context, listen: false).editEntry(widget.source.id, inputName, inputUrl);
                  Navigator.pop(context);
                },
              ),
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
            title: Text("Subscriptions",style: Theme.of(context).textTheme.title),
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
                          splashColor: Colors.blue.withAlpha(30),
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