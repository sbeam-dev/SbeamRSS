import 'package:flutter/material.dart';
import 'subs.dart';
import 'settings.dart';
import 'feeds.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

// ------------Home--------------
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _getMainPage(int i){
    switch(i) {
      case(0): return new FeedsPage();
      case(1): return new SubsPage();
      case(2): return new SettingsPage();
    }
    return Text("Error");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            _getMainPage(0),
            _getMainPage(1),
            _getMainPage(2),
          ],
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.rss_feed, title: "Feeds"),
          TabData(iconData: Icons.radio, title: "Source"),
          TabData(iconData: Icons.settings, title: "Settings")
        ],
        onTabChangedListener: (position) {
          setState(() {
            _currentIndex = position;
            _pageController.jumpToPage(position);
          });
        },
      ),
    );
  }
}