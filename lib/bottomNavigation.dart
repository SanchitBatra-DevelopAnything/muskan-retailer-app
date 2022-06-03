import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      unselectedItemColor: Colors.white,
      unselectedFontSize: 15,
      iconSize: 25,
      backgroundColor: Colors.black54,
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.cake,
              color: Colors.white,
            ),
            label: "Regular Orders"),
        BottomNavigationBarItem(
            icon: Icon(Icons.image, color: Colors.white),
            label: "Custom Orders")
      ],
    );
  }
}
