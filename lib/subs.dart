import 'package:flutter/material.dart';

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
                return SourceBottomSheet();
            }
          );
        },
      ),
    );
  }
}

class SourceBottomSheet extends StatefulWidget {
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

          },
        ),
        ListTile(
          leading: Icon(Icons.link),
          title: Text("Edit URL"),
          onTap: (){

          },
        ),
        ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text("Delete this source", style: TextStyle(color: Colors.red),),
          onTap: (){

          },
        )
      ],
    );
  }
}

Widget _buildSubItem(int index, var sourcedump){
  if (sourcedump == null) return null;
  if (sourcedump.isEmpty) return null;
  if (sourcedump[index] == null) {
    return null;
  }
  RssSource fetchedsource = sourcedump[index];
  return SourceListTile(source: fetchedsource,);
}

// --------------Add button-----------
class AddSourceBottomSheet extends StatefulWidget {
  @override
  _AddSourceBottomSheet createState() => _AddSourceBottomSheet();
}

class _AddSourceBottomSheet extends State<AddSourceBottomSheet> {
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
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "URL",
              ),
            ),
            ListTile(
              dense: true,
              trailing: IconButton(
                icon: Icon(Icons.check),
                onPressed: (){},
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
  var _sourcedump;
  @override
  void initState() {
    SourceDBOperations.querySourceDatabase().then(
        (result){
          setState(() {
            _sourcedump = result;
          });
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text("Subscriptions"),
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
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (_sourcedump == null) return null;
                  return _buildSubItem(index, _sourcedump);
            },
          ),
        ),
      ],
    );
  }
}