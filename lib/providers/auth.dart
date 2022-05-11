import 'package:flutter/material.dart';
import 'package:muskan_shop/models/shop.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  List<Shop> _shops = [];

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

  Future<void> fetchShopsFromDB() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Shops.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Shop> loadedShops = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((shopId, shopData) {
        loadedShops.add(Shop(
            id: shopId,
            shopName: shopData['shopName'],
            area: shopData['areaName']));
      });
      _shops = loadedShops;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
