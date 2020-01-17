import 'package:flutter/foundation.dart';
import 'package:flutter_app1/feeddb.dart';

class FeedModel extends ChangeNotifier {
  List<FeedEntry> _feedDump;
  bool _isRefreshing;
  get feedDump =>_feedDump;

  FeedModel() {
    _isRefreshing = false;
    loadFeed();
  }

  Future<void> loadFeed() async {
    _feedDump = await FeedDBOperations.queryTenEntries();
//    print("loading check");
//    print(_feedDump[0].sourceID);
    notifyListeners();
  }

  Future<bool> loadMore() async {

  }

  Future<void> refreshFeed() async {
//    print("called");
    if (_isRefreshing) return;
    _isRefreshing = true;
    await FeedDBOperations.refreshToDB();
    _isRefreshing = false;
//    print("refreshed");
    loadFeed();
  }
}