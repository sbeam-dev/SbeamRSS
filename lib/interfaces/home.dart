import 'package:flutter/material.dart';
import 'subs.dart';
import 'settings.dart';
import 'feeds.dart';
import 'favorite.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final ScrollController _feedScroller = ScrollController();

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
      case(0): return new FeedsPage(scrController: _feedScroller,);
      case(1): return new SubsPage();
      case(2): return new FavPage();
      case(3): return new SettingsPage();
    }
    return Text("Error");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          physics: new NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            _getMainPage(0),
            _getMainPage(1),
            _getMainPage(2),
            _getMainPage(3),
          ],
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        margin: EdgeInsets.fromLTRB(28, 8, 28, 8),
        currentIndex: _currentIndex,
        onTap: (int index){
          _currentIndex = index;
          _pageController.jumpToPage(index);
        },
        items: [
          SalomonBottomBarItem(
              icon: GestureDetector(
                child: FaIcon(FontAwesomeIcons.rss),
                onDoubleTap: (){
                  _feedScroller.animateTo(
                      0.0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                  );
                },
              ),
              title: GestureDetector(
                child: Text("Feeds"),
                onDoubleTap: (){
                  _feedScroller.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                },
              ),
              selectedColor: Colors.orange
          ),
          SalomonBottomBarItem(
              icon: FaIcon(FontAwesomeIcons.newspaper),
              title: Text('Source'),
              selectedColor: Colors.blue
          ),
          SalomonBottomBarItem(
              icon: FaIcon(FontAwesomeIcons.heart),
              title: Text('Favorites'),
              selectedColor: Colors.pink
          ),
          SalomonBottomBarItem(
              icon: FaIcon(FontAwesomeIcons.cog),
              title: Text('Settings'),
              selectedColor: Colors.teal
          ),
        ],
        selectedItemColor: Theme.of(context).accentColor,
        unselectedItemColor: Theme.of(context).appBarTheme.iconTheme.color,
      ),
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Theme.of(context).appBarTheme.color,
//         unselectedLabelStyle: TextStyle(fontFamily: "NotoSans", color: Theme.of(context).appBarTheme.iconTheme.color),
//         selectedLabelStyle: TextStyle(fontFamily: "NotoSans"),
//         selectedItemColor: Theme.of(context).accentColor,
//         unselectedItemColor: Theme.of(context).appBarTheme.iconTheme.color,
//         showUnselectedLabels: true,
// //        backgroundColor: Colors.white,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.rss_feed),
//             title: Text('Feeds'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.radio),
//             title: Text('Source'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite),
//             title: Text('Favorites'),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             title: Text('Settings'),
//           ),
//         ],
//         currentIndex: _currentIndex,
//         onTap: (int index){
//           _currentIndex = index;
//           _pageController.jumpToPage(index);
//         },
//       ),
    );
  }
}