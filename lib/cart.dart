import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("cart"),
        elevation: 0,
        backgroundColor: const Color(0x1b5e20).withOpacity(0.8),
      ),
      body: Center(


      ),
    );
  }
}