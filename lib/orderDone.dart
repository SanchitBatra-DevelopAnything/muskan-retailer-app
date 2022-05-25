import 'package:flutter/material.dart';

class OrderPlaced extends StatelessWidget {
  const OrderPlaced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/categories');
    });

    return Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Image.asset('assets/order.gif'),
                    height: 200,
                    width: 300),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "ORDER PLACED SUCCESSFULLY!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ]),
        ));
  }
}
