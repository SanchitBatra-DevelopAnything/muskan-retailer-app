import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  bool notificationAlreadySetup = false;

  Future<void> getDeviceTokenToSendNotification(name, shop, appType) async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    var deviceTokenToSendPushNotification = token.toString();

    if (appType == "D") {
      shop = "DISTRIBUTOR-" + shop;
    }

    var url = Uri.parse(
        'https://muskan-admin-app-default-rtdb.firebaseio.com/notificationTokens/' +
            shop +
            "/" +
            name +
            ".json");
    try {
      await http.patch(url,
          body: json.encode({"token": deviceTokenToSendPushNotification}));
      notificationAlreadySetup = true;
      await setNotificationStatus();
      notifyListeners();
    } catch (error) {
      print("UNABLE TO PATCH NOTIFICATION TOKEN");
      print(error);
    }
  }

  Future<void> setNotificationStatus() async {
    print("Setting status = true");
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("notificationAlreadySetup_2", true);
    this.notificationAlreadySetup = true;
    notifyListeners();
  }

  Future<void> checkNotificationSetupOnInitialLoad() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("notificationAlreadySetup_2")) {
      print(
          "already there status = true ho chuka hai , no need to display banner");
      this.notificationAlreadySetup = true;
    } else if (sp.containsKey("loggedInDistributor")) {
      this.notificationAlreadySetup = false;
    }
    notifyListeners();
  }
}
