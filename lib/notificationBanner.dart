import 'package:flutter/material.dart';

class notificationBanner extends StatefulWidget {
  const notificationBanner({Key? key}) : super(key: key);

  @override
  State<notificationBanner> createState() => _notificationBannerState();
}

class _notificationBannerState extends State<notificationBanner> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MaterialBanner(
      leading: Icon(
        Icons.notification_important,
        color: Colors.white,
      ),
      backgroundColor: const Color(0xFFD2042D),
      content: !_isLoading ? Text("Set up notifications?") : Text("DONE!"),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
      actions: [
        !_isLoading
            ? TextButton(
                child: Text(
                  "YES",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });
                },
              )
            : Container(),
      ],
    );
  }
}
