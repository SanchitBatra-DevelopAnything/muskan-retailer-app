import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          SizedBox(height: 35),
          Flexible(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: 2, top: 25),
              child: Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new),
                        color: Colors.white,
                        iconSize: 20,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )),
                  Flexible(
                    flex: 5,
                    fit: FlexFit.tight,
                    child: Text(
                      "CART",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
