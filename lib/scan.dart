import 'dart:async';
import 'dart:convert';
import 'package:alco_safe/vars/variables.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

import 'package:url_launcher/url_launcher.dart';

class Scan extends StatefulWidget {
  const Scan({Key key}) : super(key: key);
  @override
  _ScanState createState() => _ScanState();
}


Widget button(String text, Color color) {
  return Padding(
    padding: EdgeInsets.all(12.5),
    child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}

// =============================================================================


class _ScanState extends State<Scan> {

  String result = "-scan QR or Bar code-";
  String name="fetching item...", man="fetching man. date...", exp="fetching exp. date...";

  String prefix= "Illegal Code : ";

  String message = "The indicated barcode has been found on an unregistered bottle. This "
      "business may be selling counterfeit or illegal alcohol.";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
      String nam = await getName();
      String ma = await getMan();
      String ex = await getExp();
      setState(() {
        name = nam;
        man = ma;
        exp= ex;
      });

    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "nothing scanned";
      });
    } catch (ex) {
      setState(() {
        print(ex);
        //result = "Error : $ex";
      });
    }
  }


  // ==========================================================================

  Future<String> checkItem() async {
    final response = await http
        .post("https://alcosafe.000webhostapp.com/getCode.php", body: {
      "pcode": result,
    });

    String s = "hello";

    if (isNumeric(result)) {
      if (response.body == "success") {
        s = "true";
      }
      if (response.body == "invalid") {
        s = "false";
      }
    }



    print(s);
    print(isNumeric(result));
    return s;
  }

  Future<String> getName() async {
    String n;
    final res = await http
        .post("https://alcosafe.000webhostapp.com/fetchDrinks.php", body: {
      "pcode": result,
    });
    var lis = json.decode(res.body);
    n = lis['name'];

    print(n);
    return n;
  }

  Future<String> getMan() async{
    String m;
    final res = await http
        .post("https://alcosafe.000webhostapp.com/fetchDrinks.php", body: {
      "pcode": result,
    });
    var lis = json.decode(res.body);
    m = lis['man'];

    print(m);
    return m;
  }

  Future<String> getExp() async{
    String e;
    final res = await http
        .post("https://alcosafe.000webhostapp.com/fetchDrinks.php", body: {
      "pcode": result,
    });
    var lis = json.decode(res.body);
    e = lis['exp'];

    print(e);
    return e;
  }

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  report(String toMailId, String subject, String body) async{
    var url = 'mailto:$toMailId?subject=$subject&body=$body';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }

    alertDial(context);
  }

  Future<void> alertDial(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('send Email'),
          content: const Text('redirected to email app'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Widget displayImage() {
    return FutureBuilder(
      future: checkItem(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == "true") {
          return Column(
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 20,
              ),
              SizedBox (
                width: 190,
                height: 190,
                child: CachedNetworkImage(
                  imageUrl: "https://alcosafe.000webhostapp.com/images/"+result+".jpg",
                  placeholder: (context, url) => new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              Text(
                name,
                style: new TextStyle(fontSize: 33.0, fontWeight: FontWeight.bold, color: Colors.green[800]),
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              Text(
                "MAN. Date  : "+man,
                style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox (
                width: 1,
                height: 15,
              ),
              Text(
                "EXP. Date  : "+exp,
                style: new TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox (
                width: 1,
                height: 30,
              ),
              Text(
                "drink is registered in database",
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.green[900]),
              ),
              SizedBox (
                width: 1,
                height: 30,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "scan new code",
                  Colors.red[700],
                ),
                onTap: () {
                  _scanQR();
                },
              ),
            ],
          );

        } else if (snapshot.data == "false") {
          return Column(
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 20,
              ),
              SizedBox (
                width: 190,
                height: 190,
                child: Image.asset('assets/images/unknown.png',
                ),
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              Text(
                "UNREGISTERED BOTTLE",
                style: new TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.deepOrange[800]),
              ),
              SizedBox (
                width: 1,
                height: 15,
              ),
              Text(
                "code not found in database",
                style: new TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox (
                width: 1,
                height: 30,
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "report",
                  Colors.red[900],
                ),
                onTap: ()=> report("Churchilljamngeny@gmail.com", prefix+result, message),
              ),
              SizedBox (
                width: 1,
                height: 30,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "scan new code",
                  Colors.teal[700],
                ),
                onTap: () {
                  _scanQR();
                },
              ),
            ],
          );

        }  else {
          return Column(
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 20,
              ),
              SizedBox (
                width: 190,
                height: 190,
                child: Image.asset('assets/images/qrcode.png',
                ),
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              Text(
                "",
                style: new TextStyle(fontSize: 33.0, fontWeight: FontWeight.bold),
              ),
              Text(
                "",
                style: new TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SizedBox (
                width: 1,
                height: 50,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "scan code",
                  Colors.green[700],
                ),
                onTap: () {
                  _scanQR();
                },
              ),
            ],
          );
        }
      },
    );

  }

  // ==========================================================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("scan"),
        elevation: 0,
        backgroundColor: const Color(0xd50000).withOpacity(0.8),
      ),
      body: Center(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  result,
                  style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.red[900]),
                ),
                displayImage(),
              ],
            ),
        ),
    );
  }
}