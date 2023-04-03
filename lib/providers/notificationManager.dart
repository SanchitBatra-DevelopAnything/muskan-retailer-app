import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  bool notificationAlreadySetup = false;

  Future<void> getDeviceTokenToSendNotification(mame) async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    var deviceTokenToSendPushNotification = token.toString();

    var url = Uri.parse(
        'https://muskan-admin-app-default-rtdb.firebaseio.com/notificationTokens.json');
    try {
      await http.post(url,
          body: json.encode(
              {"token": deviceTokenToSendPushNotification, "name": mame}));
      notificationAlreadySetup = true;
      await setNotificationStatus();
      notifyListeners();
    } catch (error) {
      print("UNABLE TO POST NOTIFICATION TOKEN");
      print(error);
    }
  }

  Future<void> setNotificationStatus() async {
    print("Setting status = true");
    final SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("notificationAlreadySetup", true);
    this.notificationAlreadySetup = true;
    notifyListeners();
  }

  Future<void> checkNotificationSetupOnInitialLoad() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    if (sp.containsKey("notificationAlreadySetup")) {
      print(
          "already there status = true ho chuka hai , no need to display banner");
      this.notificationAlreadySetup = true;
    } else if (sp.containsKey("loggedInDistributor")) {
      this.notificationAlreadySetup = false;
    }
    notifyListeners();
  }
}
