import 'package:flutter/material.dart';
import 'package:muskan_shop/signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Column(
        children: [
          SizedBox(height: 25),
          Image.asset("assets/muskan.png"),
          SizedBox(
            height: 5,
          ),
          Text(
            "Muskan Retailer",
            style: TextStyle(color: Colors.red),
          ),
          Divider(),
          SizedBox(height: 35),
          Container(
            child: SignUp(),
          ),
        ],
      ),
    );
  }
}
