import 'package:flutter/foundation.dart';
import 'package:flutter_app1/feeddb.dart';

class FeedModel extends ChangeNotifier {
  List<FeedEntry> _feedDump;
  get feedDump =>_feedDump;

  FeedModel() {
    loadFeed();
  }

  Future<void> loadFeed() async {

  }

  Future<void> refreshFeed() async {
    FeedDBOperations.refreshToDB();
    loadFeed();
  }
}