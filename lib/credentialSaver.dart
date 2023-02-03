import 'dart:async';

import 'package:flutter/material.dart';

class CredentialSaverAnimation extends StatefulWidget {
  const CredentialSaverAnimation({
    Key? key,
  }) : super(key: key);

  @override
  _CredentialSaverAnimationState createState() =>
      _CredentialSaverAnimationState();
}

class _CredentialSaverAnimationState extends State<CredentialSaverAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  // var percentageValue;
  // Timer _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {});

  @override
  void initState() {
    // TODO: implement initState
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/categories', (route) => false);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          backgroundColor: Colors.black,
          value: controller.value,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'Saving Credentials for Better Experience...',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
