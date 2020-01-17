import 'package:flutter/foundation.dart';
import 'package:flutter_app1/sourcedb.dart';

import '../sourcedb.dart';

class SourceModel extends ChangeNotifier{
  List<RssSource> _sourceDump;
  int _listLen = 0;
  get sourceDump => _sourceDump;
  get listLen => _listLen;

  set sourceDump(List<RssSource> newDump) {
    _sourceDump = newDump;
    notifyListeners();
  }

  SourceModel(){
    loadData();
  }

  Future<void> loadData() async {
    _sourceDump = await SourceDBOperations.querySourceDatabase();
    _listLen = _sourceDump.length;
    notifyListeners();
  }

  Future<void> addEntry(String name, String address) async {
    await SourceDBOperations.addSourceToDB(name, address);
    await loadData();
  }

  Future<void> deleteEntry(int delId) async {
    await SourceDBOperations.deleteSourceDB(delId);
    await loadData();
  }
  
  Future<void> editEntry(int id, String name, String url) async{
    await SourceDBOperations.editSourceDB(id, name, url);
    await loadData();
  }
}