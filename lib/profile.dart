import 'package:alco_safe/scan.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_button/spring_button.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { signedOut, signedIn }

class _ProfileState extends State<Profile> {
  BuildContext ptx;

  var value;
  String name;
  LoginStatus _loginStatus = LoginStatus.signedIn;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      name = preferences.get("name");

      _loginStatus = value == 1 ? LoginStatus.signedIn : LoginStatus.signedOut;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.commit();
      preferences.clear();

      _loginStatus = LoginStatus.signedOut;
      Navigator.of(ptx).pushReplacementNamed("/login");

    });
  }

  @override
  Widget build(BuildContext context) {
    ptx = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("profile"),
        elevation: 0,
        backgroundColor: const Color(0x6a1b9a).withOpacity(0.8),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/qr-code.png',
              height: 190,
              width: 190,),
            SpringButton(
              SpringButtonType.OnlyScale,
              button(
                "Sign out",
                Colors.purpleAccent[700],
              ),
              onTapDown: (_) => signOut(),
            ),
          ],
        ),
      ),
    );
  }
}