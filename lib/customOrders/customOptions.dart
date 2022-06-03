import 'package:flutter/material.dart';

import '../bottomNavigation.dart';

class CustomOrderOptions extends StatelessWidget {
  const CustomOrderOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(137, 43, 40, 40),
        bottomNavigationBar: BottomNavigator(
          index: 1,
        ),
        body: Center(
          child: Text(
            "Custom oRDER",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
