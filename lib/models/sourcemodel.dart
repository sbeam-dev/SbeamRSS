import 'package:flutter/foundation.dart';
import 'package:flutter_app1/sourcedb.dart';

class SourceModel extends ChangeNotifier{
  List<RssSource> _sourcedump;
  int _listlen = 0;
  get sourcedump => _sourcedump;
  get listlen => _listlen;

  set sourcedump(List<RssSource> newdump) {
    _sourcedump = newdump;
    notifyListeners();
  }

  SourceModel(){
    loadData();
  }

  Future<void> loadData() async {
    sourcedump = await SourceDBOperations.querySourceDatabase();
    _listlen = _sourcedump.length;
  }

  Future<void> addEntry(RssSource newsource) async {
    await SourceDBOperations.addSourceToDB(newsource);
    _listlen++;
    _sourcedump.add(newsource);
    notifyListeners();
  }

  Future<void> deleteEntry(int delId) async {
    await SourceDBOperations.deleteSourceDB(delId);
    await loadData();
  }
}