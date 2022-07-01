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
  var _activePage = "L";

  void changeForm(String value) {
    setState(() {
      _activePage = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          Image.asset(
            "assets/logo.jpg",
            height: 100,
            width: double.infinity,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Muskan Retailer",
            style: TextStyle(color: Colors.white),
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
