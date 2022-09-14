import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:muskan_shop/models/customOrder.dart';
import 'package:muskan_shop/models/regularOrder.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:muskan_shop/models/regularShopOrderItem.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<regularOrder> _activeRegularOrders = [];
  List<customOrder> _activeCustomOrders = [];

  List<regularOrder> _processedRegularOrders = [];
  List<customOrder> _processedCustomOrders = [];

  List<regularOrder> _selectedDateActiveRegularOrders = [];
  List<customOrder> _selectedDateActiveCustomOrders = [];

  List<regularOrder> get activeRegularOrders {
    //all just for ref.
    return [..._activeRegularOrders];
  }

  List<customOrder> get activeCustomOrders {
    //all just for ref.
    return [..._activeCustomOrders];
  }

  List<regularOrder> get selectedDateActiveRegularOrders {
    //useful for a particular date.
    return [..._selectedDateActiveRegularOrders];
  }

  List<customOrder> get selectedDateActiveCustomOrders {
    //useful for a particular date.
    return [..._selectedDateActiveCustomOrders];
  }

  List<regularOrder> get processedRegularOrders {
    //already based on date on DB design.
    return [..._processedRegularOrders];
  }

  List<customOrder> get processedCustomOrders {
    //already based on date on DB design.
    return [..._processedCustomOrders];
  }

  List<regularOrder> get clubbedRegularOrders {
    //all useful regular orders for UI.
    return [..._selectedDateActiveRegularOrders, ..._processedRegularOrders];
  }

  List<customOrder> get clubbedCustomOrders {
    //all useful custom orders for UI.
    return [..._selectedDateActiveCustomOrders, ..._processedCustomOrders];
  }

  void filterOrders(String date) {
    _selectedDateActiveRegularOrders = _activeRegularOrders
        .where((order) => order.orderDate.toString() == date.toString())
        .toList();

    _selectedDateActiveCustomOrders = _activeCustomOrders
        .where((order) => order.orderDate.toString() == date.toString())
        .toList();
    notifyListeners();
  }

  Future<void> getProcessedRegularOrders(
      String date, String retailer, String shop) async {
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
            status: "ACCEPTED",
            shopAddress: orderData['shopAddress'],
            items: items));
      });
      print("FULL PROCESSED LIST LENGTH = " +
          loadedRegularOrders.length.toString());

      _processedRegularOrders = loadedRegularOrders
          .where((order) =>
              order.orderedBy.toString().toLowerCase() ==
                  retailer.toLowerCase() &&
              order.shopAddress.toLowerCase() == shop.toLowerCase())
          .toList();
      print("PROCESSED REGS FETCHED WITH LENGTH ON" +
          date +
          "LENGTH = " +
          _processedRegularOrders.length
              .toString()); //already filtered for a particular selected date.
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProcessedCustomOrders(
      String date, String retailer, String shop) async {
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
      _processedCustomOrders = loadedCustomOrders
          .where((order) =>
              order.orderedBy.toLowerCase() == retailer.toLowerCase() &&
              order.shopAddress.toLowerCase() == shop.toLowerCase())
          .toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getActiveOrders(String retailer, String shop) async {
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
              status: "IN PROGRESS",
              shopAddress: orderData['shopAddress'],
              items: items));
          print("ADDED A REGULAR ORDER");
        }
      });
      _activeRegularOrders = loadedRegularOrders
          .where((order) =>
              order.orderedBy.toLowerCase() == retailer.toLowerCase() &&
              order.shopAddress.toLowerCase() == shop.toLowerCase())
          .toList();
      _activeCustomOrders = loadedCustomOrders
          .where((order) =>
              order.orderedBy.toLowerCase() == retailer.toLowerCase() &&
              order.shopAddress.toLowerCase() == shop.toLowerCase())
          .toList();
      print("OUT OF LOOP");
      notifyListeners();
    } catch (error) {
      print("ERROR IN FETCHING ORDER");
      throw error;
    }
  }
}
