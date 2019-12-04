import 'package:alco_safe/home.dart';
import 'package:flutter/material.dart';

import 'package:alco_safe/register.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

//      Tracks signed in status
enum LoginStatus { signedOut, signedIn }

class _LoginState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.signedOut;
  final _key = new GlobalKey<FormState>();
  BuildContext ctx;


  TextEditingController email = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  //      Only logs in after validations have been done
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  //    Login function
  Future<List> login() async {
    final response = await http
        .post("https://alcosafe.000webhostapp.com/login.php", body: {
      "email": email.text,
      "password": pass.text
    });

    String message = response.body;
    String username = email.text.toString();
    //String message = response.toString();

    if (response.body == 'success') {
      setState(() {
        _loginStatus = LoginStatus.signedIn;
        value = 1;
      });

      print(message);
      print(username);
      loginToast(message);
      savePref(value, username);
      Navigator.of(ctx).pushReplacementNamed("/home");

    } else if (response.body == "invalid"){
      print(message);
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red[900],
        textColor: Colors.white);
  }

  savePref(int value, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt("value", value);
      prefs.setString("name", name);
      prefs.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signedIn : LoginStatus.signedOut;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    switch (_loginStatus) {
      case LoginStatus.signedOut:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(15.0),
              children: <Widget>[
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                    color: Colors.white,
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/logo.png',
                            height: 200,
                            width: 200,),
                          SizedBox(
                            height: 20,
                            child: Text(
                              "alcohol verification app",
                              style: TextStyle(
                                  color: Colors.blue[900], fontSize: 16.0),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 35.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          //card for Email TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              controller: email,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "enter your username or email";
                                }
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding:
                                    EdgeInsets.only(left: 20, right: 15),
                                    child:
                                    Icon(Icons.person, color: Colors.blue),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                  labelText: "Email/ Username"),
                            ),
                          ),
                          // Card for password TextFormField
                          Card(
                            elevation: 6.0,
                            child: TextFormField(
                              controller: pass,
                              validator: (e) {
                                if (e.isEmpty) {
                                  return "Password Required";
                                }
                              },
                              obscureText: _secureText,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.security,
                                      color: Colors.blue),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                contentPadding: EdgeInsets.all(18),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          FlatButton(
                              child: Text(
                                "new user? create account",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              textColor: Colors.blue[800],
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Register()),
                                );
                              }),

                          Padding(
                            padding: EdgeInsets.all(14.0),
                          ),

                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                height: 44.0,
                                child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15.0)),
                                    child: Text(
                                      "Login",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    textColor: Colors.white,
                                    color: Colors.blue[800],
                                    onPressed: () {
                                      check();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        break;

      case LoginStatus.signedIn:
        return Home();
//        return ProfilePage(signOut);
        break;
    }
  }
}