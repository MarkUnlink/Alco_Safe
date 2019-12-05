import 'package:alco_safe/profile.dart';
import 'package:alco_safe/scan.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BuildContext ctx;

  int currentIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Widget> pages = [
    Scan(
      key: PageStorageKey('Page1'),
    ),
    Profile(
      key: PageStorageKey('Page2'),
    ),
  ];
  final PageStorageBucket bucket = PageStorageBucket();


  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Colors.white,
        body: PageStorage(
          child: pages[currentIndex],
          bucket: bucket,
        ),

        bottomNavigationBar: BottomNavyBar(
          iconSize: 30,
          selectedIndex: currentIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.camera_enhance),
              title: Text('Scan'),
              activeColor: Colors.red,
              inactiveColor: Colors.blueGrey,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
              activeColor: Colors.purpleAccent,
              inactiveColor: Colors.blueGrey,
            ),
          ],
        )
    );
  }
}

