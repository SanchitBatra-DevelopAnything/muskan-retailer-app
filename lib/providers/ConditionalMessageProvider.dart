import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muskan_shop/models/conditionalMessage.dart';
import 'package:http/http.dart' as http;

class ConditionalMessageProvider with ChangeNotifier {
  ConditionalMessage _conditionalMessage =
      new ConditionalMessage(show: false, message: "", headline: "");

  ConditionalMessage get messageInfo {
    return _conditionalMessage;
  }

  Future<void> getMessageInfo() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/conditionalMessage.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<ConditionalMessage> loadedMessage = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print("REJECTED THE TAKE OF CONDITIONAL MESSAGE");
        return;
      }
      extractedData.forEach((msgId, msgData) {
        loadedMessage.add(ConditionalMessage(
            headline: msgData['headline'],
            show: msgData['show'],
            message: msgData['message']));
      });
      _conditionalMessage = loadedMessage[0];
      print("Set the conditional message successfully!");
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
