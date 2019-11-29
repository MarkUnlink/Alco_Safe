import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class Scan extends StatefulWidget {
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
void addCart() {


}

class _ScanState extends State<Scan> {

  String result = "-scan QR or Bar code-";
  bool found=false;
  String name="fetching item...", price="fetching price...";

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      bool f = await checkItem();
      setState(() {
        result = qrResult;
        found = f;
      });
      String nam = await getName();
      String pri = await getPrice();
      setState(() {
        name = nam;
        price = pri;
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
        result = "Unknown Error $ex";
      });
    }
  }


  // ==========================================================================

  Future<bool> checkItem() async {
    final response = await http
        .post("https://alcosafe.000webhostapp.com/getCode.php", body: {
      "pcode": result,
    });

    bool s;
    if (response.body == 'success') {
      s = true;
    }
    else {
      s = false;
    }
    print(s);
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

  Future<String> getPrice() async{
    String p;
    final res = await http
        .post("https://alcosafe.000webhostapp.com/fetchDrinks.php", body: {
      "pcode": result,
    });
    var lis = json.decode(res.body);
    p = lis['price'];

    print(p);
    return p;
  }


  Widget displayImage() {
    return FutureBuilder(
      future: checkItem(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data.toString() == "true") {
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
              Text(
                "Ksh: "+price,
                style: new TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "add to Cart",
                  Colors.green[900],
                ),
                onTap: addCart,
              ),
            ],
          );
        } else {
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
                SpringButton(
                  SpringButtonType.OnlyScale,
                  button(
                    "scan code",
                    Colors.red[700],
                  ),
                  onTap: () {
                    _scanQR();
                  },
                ),
              ],
            ),
        ),
    );
  }
}