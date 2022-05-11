import 'package:flutter/material.dart';
import 'package:muskan_shop/models/shop.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  List<Shop> _shops = [
    Shop(id: "1", shopName: "KAVI NAGAR", area: "ghzb"),
    Shop(id: "2", shopName: "SHASHTRI NAGAR", area: "ghzb")
  ];

  List<Shop> get shops {
    return [..._shops];
  }

  List<String> get shopNames {
    return [..._shops].map((e) => e.shopName).toList();
  }

  Future<void> retailerSignUp(String retailerName, String shopAddress) async {
    //send http post here.
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/retailerNotifications.json";
    await http.post(Uri.parse(url),
        body: json.encode(
            {'retailerName': retailerName, 'shopAddress': shopAddress}));
  }
}
