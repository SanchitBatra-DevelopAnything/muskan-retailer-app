import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      notifyListeners();
    } catch (error) {
      print("UNABLE TO POST NOTIFICATION TOKEN");
      print(error);
    }
  }
}
