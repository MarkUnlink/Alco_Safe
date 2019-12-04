import 'package:alco_safe/scan.dart';
import 'package:alco_safe/vars/variables.dart';
import 'package:flutter/material.dart';
import 'package:spring_button/spring_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {

  Future<bool> checkCount() async{
    bool s;
    if (Variable.count > 0) {
      s = true;
    }
    else {
      s = false;
    }
    print(s);
    return s;
  }

  Widget buildItems(BuildContext context, int index) {
    return Card(
      child: SizedBox(
        height: 73,
        child: ListView(
          children: <Widget>[
            ListTile (
              leading: CachedNetworkImage(
                height: 65,
                width: 65,
                imageUrl: "https://alcosafe.000webhostapp.com/images/"+Variable.barcodes[index]+".jpg",
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
              title: Text(Variable.items[index],
                  style: new TextStyle(color: Colors.blueGrey, fontSize: 22.0,fontWeight: FontWeight.bold)
              ),
              subtitle: Text("Ksh. " +Variable.prices[index],
                  style: new TextStyle(color: Colors.green[900], fontSize: 19.0,)
              ),
              trailing: Icon(Icons.cancel),
              onTap: () {
                setState(() {
                  Variable.items.removeAt(index);
                  Variable.prices.removeAt(index);
                  Variable.barcodes.removeAt(index);
                  Variable.total= Variable.total-int.parse(Variable.prices[index]);
                  Variable.count--;
                  interface();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void finish() {

  }

  Widget interface() {
    return FutureBuilder(
      future: checkCount(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.data.toString() == "true") {
          return Column(
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 20,
              ),
              Expanded(
                  child: ListView.builder(
                    itemBuilder: buildItems,
                    itemCount: Variable.items.length,
                  ),
              ),
              Text("Total  :   Ksh. "+Variable.total.toString(),
                  style: new TextStyle(color: Colors.green[900], fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              SizedBox (
                width: 1,
                height: 20,
              ),
              SpringButton(
                SpringButtonType.OnlyScale,
                button(
                  "buy products",
                  Colors.green[900],
                ),
                onTap: finish,
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox (
                width: 1,
                height: 20,
              ),
              Text(
                "No items in cart",
                style: new TextStyle(fontSize: 33.0, fontWeight: FontWeight.bold, color: Colors.green[800]),
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
        child: interface(),
      ),
    );
  }
}