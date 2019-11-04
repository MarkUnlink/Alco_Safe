import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { signedOut, signedIn }

class _ProfileState extends State<Profile> {

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
      preferences.setString("email", null);
      preferences.setString("id", null);

      preferences.commit();
      _loginStatus = LoginStatus.signedOut;



    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("profile"),
        elevation: 0,
        backgroundColor: const Color(0x6a1b9a).withOpacity(0.8),
      ),
      body: Center(

      ),
    );
  }
}