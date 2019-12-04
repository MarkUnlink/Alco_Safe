import 'package:alco_safe/scan.dart';
import 'package:alco_safe/ui/background.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_button/spring_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { signedOut, signedIn }

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    getPref();
    super.initState();
  }

  BuildContext ptx;
  bool tes = true;

  var value;
  String name;
  LoginStatus _loginStatus = LoginStatus.signedIn;

  String username="", email="", fname="", sname="", cardno="";
  String link="";

  Widget background(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        'assets/images/pattern.png',
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar() {
    return new CircleAvatar(
      backgroundImage: new NetworkImage("https://alcosafe.000webhostapp.com/users/"+username+".jpg"),
      radius: 90.0,
    );
  }



  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      value = prefs.getInt("value");
      name = prefs.getString("name");

      _loginStatus = value == 1 ? LoginStatus.signedIn : LoginStatus.signedOut;
    });

  }

  Future<bool> getInfo() async {

    final res = await http
        .post("https://alcosafe.000webhostapp.com/profile.php", body: {
      "name": name,
    });

    var lis = json.decode(res.body);
    username = lis['username'];
    fname = lis['fname'];
    sname = lis['sname'];
    cardno = lis['cardno'];
    email = lis['email'];

    link= "https://alcosafe.000webhostapp.com/users/"+username+".jpg";

    // only for debug
    print(username);
    print(fname);
    print(sname);
    print(cardno);
    print(email);
    print(link);

    return tes;
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

  Widget run() {
    return FutureBuilder(
      future: getInfo(),
      // ignore: missing_return
      builder: (BuildContext context, snapshot) {
        if (snapshot.data.toString() == "true") {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  background(context),
                  Center(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildAvatar(),
                        SizedBox (
                          width: 1,
                          height: 15,
                        ),
                        Text(
                          fname+" "+sname,
                          style: new TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 1,
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Email address :", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                  Text(
                    email,
                    style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("User Name :", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                  Text(
                    username,
                    style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 1,
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("Credit Card :", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                  Text(
                    cardno,
                    style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 1,
                height: 150,
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 10,
              ),
              Text(
                username,
                style: new TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
            ],
          );
        }
      },
    );

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
          children: <Widget>[
            run(),
            SpringButton(
              SpringButtonType.OnlyScale,
              button(
                "Sign out",
                Colors.purpleAccent[700],
              ),
              onTapDown: (_) => signOut(),
            ),
          ],
        )
      ),
    );
  }
}