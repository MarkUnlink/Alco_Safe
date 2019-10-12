import 'package:alco_safe/cart.dart';
import 'package:alco_safe/profile.dart';
import 'package:alco_safe/scan.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alco Safe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Pages(title: 'alcoHome'),
    );
  }
}

class Pages extends StatefulWidget {
  Pages({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Pages> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('alco Safe'),
          backgroundColor: Colors.black,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            pageChanged(index);
          },
          children: <Widget>[
            Scan(),
            Cart(),
            Profile(),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          iconSize: 30,
          selectedIndex: currentIndex,
          showElevation: true,
          onItemSelected: (index) => setState(() {
            currentIndex = index;
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.camera_enhance),
              title: Text('Scan'),
              activeColor: Colors.red,
              inactiveColor: Colors.blueGrey,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.account_balance_wallet),
              title: Text('Cart'),
              activeColor: Colors.green,
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

