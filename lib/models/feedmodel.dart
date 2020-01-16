import 'package:flutter/foundation.dart';
import 'package:flutter_app1/feeddb.dart';

class FeedModel extends ChangeNotifier {
  List<FeedEntry> _feedDump;
  get feedDump =>_feedDump;

  FeedModel() {
    loadFeed();
  }

  Future<void> loadFeed() async {
    _feedDump = await FeedDBOperations.queryTenEntries();
//    print("loading check");
//    print(_feedDump[0].sourceID);
    notifyListeners();
  }

  Future<void> refreshFeed() async {
//    print("called");
    await FeedDBOperations.refreshToDB();
//    print("refreshed");
    loadFeed();
  }
}