import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muskan_shop/models/customOrder.dart';
import 'package:muskan_shop/models/regularOrder.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:muskan_shop/models/regularShopOrderItem.dart';

class OrderProvider with ChangeNotifier {
  List<regularOrder> _activeRegularOrders = [];
  List<customOrder> _activeCustomOrders = [];

  List<regularOrder> _processedRegularOrders = [];
  List<customOrder> _processedCustomOrders = [];

  List<regularOrder> get regularOrders {
    return [..._activeRegularOrders];
  }

  List<customOrder> get customOrders {
    return [..._activeCustomOrders];
  }

  Future<void> getProcessedRegularOrders(String date) async {
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/ProcessedShopOrders/" +
            date +
            ".json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<regularOrder> loadedRegularOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        List<RegularShopOrderItem> items = [];
        orderData['items'].forEach((itemData) => {
              items.add(RegularShopOrderItem(
                  item: itemData['item'],
                  imageUrl: itemData['imageUrl'],
                  CategoryName: itemData['CategoryName'],
                  quantity: itemData['quantity'],
                  price: itemData['price']))
            });
        loadedRegularOrders.add(regularOrder(
            orderDate: orderData['orderDate'],
            orderTime: orderData['orderTime'],
            orderedBy: orderData['orderedBy'],
            shopAddress: orderData['shopAddress'],
            items: items));
      });
      _processedRegularOrders =
          loadedRegularOrders; //already filtered for a particular selected date.
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProcessedCustomOrders(String date) async {
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/processedShopCustomOrders/" +
            date +
            ".json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<customOrder> loadedCustomOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        loadedCustomOrders.add(customOrder(
            cakeDescription: orderData['cakeDescription'],
            customType: orderData['customType'],
            flavour: orderData['flavour'],
            imgUrl: orderData['imgUrl'],
            orderDate: orderData['orderDate'],
            orderType: orderData['orderType'],
            orderKey: orderData['orderKey'],
            orderTime: orderData['orderTime'],
            orderedBy: orderData['orderedBy'],
            photoOnCakeUrl: orderData['photoOnCakeUrl'],
            pounds: orderData['pounds'],
            shopAddress: orderData['shopAddress']));
      });
      _processedCustomOrders = loadedCustomOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getActiveOrders() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/activeShopOrders.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<regularOrder> loadedRegularOrders = [];
      final List<customOrder> loadedCustomOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        if (orderData['customType'] != null) {
          print("REACHED CUSTOM FETCH");
          loadedCustomOrders.add(customOrder(
              cakeDescription: orderData['cakeDescription'],
              customType: orderData['customType'],
              flavour: orderData['flavour'],
              imgUrl: orderData['imgUrl'],
              orderDate: orderData['orderDate'],
              orderType: orderData['orderType'],
              orderKey: orderData['orderKey'],
              orderTime: orderData['orderTime'],
              orderedBy: orderData['orderedBy'],
              photoOnCakeUrl: orderData['photoOnCakeUrl'],
              pounds: orderData['pounds'],
              shopAddress: orderData['shopAddress']));
        } else {
          print("REACHED REGULAR FETCH");
          List<RegularShopOrderItem> items = [];
          orderData['items'].forEach((itemData) => {
                items.add(RegularShopOrderItem(
                    item: itemData['item'],
                    imageUrl: itemData['imageUrl'],
                    CategoryName: itemData['CategoryName'],
                    quantity: itemData['quantity'],
                    price: itemData['price']))
              });
          print("FOR EACH WORKED");
          loadedRegularOrders.add(regularOrder(
              orderDate: orderData['orderDate'],
              orderTime: orderData['orderTime'],
              orderedBy: orderData['orderedBy'],
              shopAddress: orderData['shopAddress'],
              items: items));
          print("ADDED A REGULAR ORDER");
        }
      });
      _activeRegularOrders = loadedRegularOrders;
      _activeCustomOrders = loadedCustomOrders;
      print("OUT OF LOOP");
      notifyListeners();
    } catch (error) {
      print("ERROR IN FETCHING ORDER");
      throw error;
    }
  }
}
