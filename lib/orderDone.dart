import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class OrderPlaced extends StatefulWidget {
  const OrderPlaced({Key? key}) : super(key: key);

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  void initState() {
    // TODO: implement initState
    final player = AudioCache();
    player.play('orderDone.mp3');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
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
