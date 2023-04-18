import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:muskan_shop/providers/auth.dart';
import 'package:muskan_shop/providers/notificationManager.dart';
import 'package:provider/provider.dart';

class notificationBanner extends StatefulWidget {
  const notificationBanner({Key? key}) : super(key: key);

  @override
  State<notificationBanner> createState() => _notificationBannerState();
}

class _notificationBannerState extends State<notificationBanner> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final appType = Provider.of<AuthProvider>(context).appType;
    final retailerName = Provider.of<AuthProvider>(context).loggedInRetailer;
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    final distributorName =
        Provider.of<AuthProvider>(context).loggedInDistributor;

    final shopName = Provider.of<AuthProvider>(context).loggedInShop;
    final distributorship =
        Provider.of<AuthProvider>(context).loggedInDistributorship;

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
                onPressed: () async {
                  setState(
                    () {
                      _isLoading = true;
                    },
                  );
                  if (appType == "retailer") {
                    await notificationProvider.getDeviceTokenToSendNotification(
                        retailerName, shopName, "R");
                  } else {
                    await notificationProvider.getDeviceTokenToSendNotification(
                        distributorName, distributorship, "D");
                  }
                },
              )
            : Container(),
      ],
    );
  }
}
