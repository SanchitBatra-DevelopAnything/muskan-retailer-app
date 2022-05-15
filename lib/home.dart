import 'package:flutter/material.dart';
import 'package:muskan_shop/login.dart';
import 'package:muskan_shop/signup.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _activePage = "S";

  void changeForm(String value) {
    setState(() {
      _activePage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25),
          Image.asset(
            "assets/muskan.png",
            height: 100,
            width: 400,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Muskan Retailer",
            style: TextStyle(color: Colors.red),
          ),
          Divider(),
          SizedBox(height: 15),
          Container(
            child: _activePage == "S"
                ? SignUp(
                    onFormChange: () {
                      changeForm("L");
                    },
                  )
                : Login(
                    onFormChange: () {
                      changeForm("S");
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
