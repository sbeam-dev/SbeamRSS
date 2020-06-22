import 'package:flutter/foundation.dart';
import 'package:flutter_app1/databases/feeddb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../databases/favdb.dart';

class FavModel extends ChangeNotifier {
  List<FavEntry> _feedDump;
  get feedDump =>_feedDump;

  FavModel() {
    loadFav();
  }

  Future<void> loadFav() async {
    _feedDump = await FavDBOperations.queryEntries();
    notifyListeners();
  }

  Future<int> addFav(FeedEntry entry) async { //1 for exist 0 for non-exist
    int res = await FavDBOperations.addFeedToDB(entry);
    loadFav();
    if (res == 1){
      Fluttertoast.showToast(
          msg: "Already exists in favorites!",
      );
    } else {
      Fluttertoast.showToast(
        msg: "Added to favorites!",
      );
    }

//    print("$res");
    return res;
  }

  Future<void> deleteFav(String link) async {
    await FavDBOperations.deleteFeedToDB(link);
    Fluttertoast.showToast(
      msg: "Deleted!",
    );
    loadFav();
  }
}