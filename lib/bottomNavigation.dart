import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  final index;
  const BottomNavigator({Key? key, required this.index}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  var _currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
        if (index == 1) {
          Navigator.pushNamedAndRemoveUntil(
              context, "/customOrderOptions", (r) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/categories', (r) => false);
        }
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
