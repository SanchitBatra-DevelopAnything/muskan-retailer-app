import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  List<regularOrder> _activeDistributorRegularOrders = [];
  List<regularOrder> _processedDistributorRegularOrders = [];
  List<regularOrder> _selectedDateActiveRegularDistributorOrders = [];

  List<regularOrder> get activeRegularOrders {
    //all just for ref.
    return [..._activeRegularOrders];
  }

  List<regularOrder> get activeDistributorRegularOrders {
    return [..._activeDistributorRegularOrders];
  }

  List<regularOrder> get selectedDateActiveDistributorOrders {
    return [..._selectedDateActiveRegularDistributorOrders];
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

  List<regularOrder> get processedDistributorRegularOrders {
    //already based on date on DB design.
    return [..._processedDistributorRegularOrders];
  }

  List<customOrder> get processedCustomOrders {
    //already based on date on DB design.
    return [..._processedCustomOrders];
  }

  List<regularOrder> get clubbedRegularOrders {
    //all useful regular orders for UI.
    return [..._selectedDateActiveRegularOrders, ..._processedRegularOrders];
  }

  List<regularOrder> get clubbedDistributorRegularOrders {
    //all useful regular orders for UI.
    return [
      ..._selectedDateActiveRegularDistributorOrders,
      ..._processedDistributorRegularOrders
    ];
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

  void filterDistributorOrders(String date) {
    _selectedDateActiveRegularDistributorOrders =
        _activeDistributorRegularOrders
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
    print(date);
    try {
      final response = await http.get(Uri.parse(url));
      final List<regularOrder> loadedRegularOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
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
      _processedRegularOrders = [];
      _processedRegularOrders = loadedRegularOrders
          .where((order) =>
              order.orderedBy.toString().toLowerCase().trim() ==
                  retailer.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  shop.toLowerCase().trim())
          .toList(); //already filtered for a particular selected date.
      print("final length = " + _processedRegularOrders.length.toString());
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProcessedRegularDistributorOrders(
      String date, String distributor, String distributorship) async {
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/ProcessedDistributorOrders/" +
            date +
            ".json";
    print(date);
    try {
      final response = await http.get(Uri.parse(url));
      final List<regularOrder> loadedRegularDistributorOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
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
        loadedRegularDistributorOrders.add(regularOrder(
            orderDate: orderData['orderDate'],
            orderTime: orderData['orderTime'],
            orderedBy: orderData['orderedBy'],
            status: "ACCEPTED",
            shopAddress: orderData['shopAddress'],
            items: items));
      });
      print("FULL PROCESSED LIST LENGTH = " +
          loadedRegularDistributorOrders.length.toString());

      _processedDistributorRegularOrders = [];
      _processedDistributorRegularOrders = loadedRegularDistributorOrders
          .where((order) =>
              order.orderedBy.toString().toLowerCase().trim() ==
                  distributor.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  distributorship.toLowerCase().trim())
          .toList(); //already filtered for a particular selected date.
      print("final length = " +
          _processedDistributorRegularOrders.length.toString());
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
            status: "ACCEPTED",
            shopAddress: orderData['shopAddress']));
      });
      _processedCustomOrders = [];
      _processedCustomOrders = loadedCustomOrders
          .where((order) =>
              order.orderedBy.toLowerCase().trim() ==
                  retailer.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  shop.toLowerCase().trim())
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
              status: "IN PROGRESS",
              photoOnCakeUrl: orderData['photoOnCakeUrl'],
              pounds: orderData['pounds'],
              shopAddress: orderData['shopAddress']));
        } else {
          print("REACHED REGULAR FETCH");
          List<RegularShopOrderItem> items = [];
          if (orderData['items'] != null) {
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
        }
      });
      _activeRegularOrders = [];
      _activeRegularOrders = loadedRegularOrders
          .where((order) =>
              order.orderedBy.toLowerCase().trim() ==
                  retailer.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  shop.toLowerCase().trim())
          .toList();
      _activeCustomOrders = [];
      _activeCustomOrders = loadedCustomOrders
          .where((order) =>
              order.orderedBy.toLowerCase().trim() ==
                  retailer.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  shop.toLowerCase().trim())
          .toList();
      print("OUT OF LOOP");
      notifyListeners();
    } catch (error) {
      print("ERROR IN FETCHING ORDER");
      throw error;
    }
  }

  Future<void> getActiveDistributorOrders(
      String distributor, String distributorship) async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/activeDistributorOrders.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<regularOrder> loadedRegularDistributorOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        print("REACHED REGULAR FETCH");
        List<RegularShopOrderItem> items = [];
        if (orderData['items'] != null) {
          orderData['items'].forEach((itemData) => {
                items.add(RegularShopOrderItem(
                    item: itemData['item'],
                    imageUrl: itemData['imageUrl'],
                    CategoryName: itemData['CategoryName'],
                    quantity: itemData['quantity'],
                    price: itemData['price']))
              });
          print("FOR EACH WORKED");
          loadedRegularDistributorOrders.add(regularOrder(
              orderDate: orderData['orderDate'],
              orderTime: orderData['orderTime'],
              orderedBy: orderData['orderedBy'],
              status: "IN PROGRESS",
              shopAddress: orderData['shopAddress'],
              items: items));
          print("ADDED A REGULAR ORDER");
        }
      });
      _activeDistributorRegularOrders = [];
      _activeDistributorRegularOrders = loadedRegularDistributorOrders
          .where((order) =>
              order.orderedBy.toLowerCase().trim() ==
                  distributor.toLowerCase().trim() &&
              order.shopAddress.toLowerCase().trim() ==
                  distributorship.toLowerCase().trim())
          .toList();
      print("OUT OF LOOP");
      notifyListeners();
    } catch (error) {
      print("ERROR IN FETCHING ORDER");
      throw error;
    }
  }
}
