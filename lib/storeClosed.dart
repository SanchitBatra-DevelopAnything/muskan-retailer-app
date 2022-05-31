import 'package:flutter/material.dart';

class BakeryClosed extends StatelessWidget {
  const BakeryClosed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              child: Image.asset("assets/snoozer.jpeg"),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Stored Closed , Will be back at 7AM",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
