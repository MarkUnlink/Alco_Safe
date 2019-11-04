import 'dart:async';
import 'package:alco_safe/qrCodeReader.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';

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

void scanQR(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QrScanner()),
  );
}

void addCart(context) {


}

class _ScanState extends State<Scan> {

  String result = "churchill !";

  Future openReader() async {

  }


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
                Image.asset('assets/images/qr-code.png',
                  height: 190,
                  width: 190,),
                SpringButton(
                  SpringButtonType.OnlyScale,
                  button(
                    "scan QR-code",
                    Colors.red[700],
                  ),
                  onTapDown: (_) => scanQR(context),
                ),
                SpringButton(
                  SpringButtonType.OnlyScale,
                  button(
                    "add to Cart",
                    Colors.green[900],
                  ),
                  onTapDown: (_) => addCart(context),
                ),
              ],
            ),
        ),
    );
  }
}