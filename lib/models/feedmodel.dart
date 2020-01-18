import 'package:flutter/foundation.dart';
import '../feeddb.dart';

class FeedModel extends ChangeNotifier {
  List<FeedEntry> _feedDump;
  bool _isRefreshing;
  bool _isFinished;
  get isFinished => _isFinished;  //the var will only be read when the first 10 entries loaded successfully
  get feedDump =>_feedDump;

  FeedModel() {
    _isRefreshing = false;
    loadFeed();
  }

  Future<void> loadFeed() async {
    _feedDump = await FeedDBOperations.queryTenEntries();
    _isFinished = false;
//    print("loading check");
//    print(_feedDump[0].sourceID);
    notifyListeners();
  }

  Future<bool> loadMore() async {
    int _lastLoaded = feedDump.last.id;
    List<FeedEntry> _newDump = await FeedDBOperations.queryMore(_lastLoaded);
    if (_newDump.isEmpty) _isFinished = true;
    _feedDump.addAll(_newDump);
    return true;
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