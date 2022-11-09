import 'package:flutter/material.dart';
import 'package:muskan_shop/distributors/models/Distributor.dart';
import 'package:muskan_shop/models/shop.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../distributors/models/DistributorArea.dart';
import '../models/retailer.dart';

class AuthProvider with ChangeNotifier {
  List<Shop> _shops = [];
  List<Retailer> _retailers = [];
  String loggedInRetailer = "";
  String loggedInShop = "";
  String loggedInDistributor = "";
  String loggedInDistributorship = "";
  String appType = "";

  List<DistributorArea> _distributorships = [];
  List<Distributor> _distributors = [];

  List<Shop> get shops {
    return [..._shops];
  }

  List<String> get shopNames {
    return [..._shops].map((e) => e.shopName).toList();
  }

  List<Retailer> get retailers {
    return [..._retailers];
  }

  List<Distributor> get distributors {
    return [..._distributors];
  }

  List<String> get retailerNames {
    return [..._retailers].map((retailer) => retailer.retailerName).toList();
  }

  List<String> get distributorships {
    return [..._distributorships].map((e) => e.distributorship).toList();
  }

  Future<void> retailerSignUp(
      String retailerName, String shopAddress, String contactNumber) async {
    //send http post here.
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/retailerNotifications.json";
    await http.post(Uri.parse(url),
        body: json.encode({
          'retailerName': retailerName,
          'shopAddress': shopAddress,
          'mobileNumber': contactNumber
        }));
  }

  Future<void> DistributorSignUp(String distributorId, String distributorship,
      String contactNumber) async {
    //send http post here.
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/distributorNotifications.json";
    await http.post(Uri.parse(url),
        body: json.encode({
          'distributorId': distributorId,
          'distributorship': distributorship,
          'mobileNumber': contactNumber
        }));
  }

  void setLoggedInRetailerAndShop(String retailerName, String shopName) {
    this.loggedInRetailer = retailerName;
    this.loggedInShop = shopName;
    this.appType = "retailer";
    notifyListeners();
  }

  void setLoggedInDistributor(String distributorId, String distributorship) {
    this.loggedInDistributor = distributorId;
    this.loggedInDistributorship = distributorship;
    this.appType = "distributor";
    notifyListeners();
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
      _shops.sort(
        (a, b) => a.shopName.compareTo(b.shopName),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchRetailersFromDB() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Retailers.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Retailer> loadedRetailers = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((retailerId, retailerData) {
        loadedRetailers.add(Retailer(
            id: retailerId,
            shopAddress: retailerData['shopAddress'],
            retailerName: retailerData['retailerName']));
      });
      _retailers = loadedRetailers;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchDistributorsFromDB() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Distributors.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Distributor> loadedDistributors = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((distributorId, distributorData) {
        loadedDistributors.add(Distributor(
            id: distributorId,
            distributorship: distributorData['distributorship'],
            distributorId: distributorData['distributorId']));
      });
      _distributors = loadedDistributors;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchDistributorshipsFromDB() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Distributorships.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<DistributorArea> loadedAreas = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((areaId, areaData) {
        loadedAreas.add(DistributorArea(
          id: areaId,
          distributorship: areaData['distributorship'],
        ));
      });
      _distributorships = loadedAreas;
      _distributorships.sort(
        (a, b) => a.distributorship.trim().compareTo(b.distributorship.trim()),
      );
      notifyListeners();
      print("Fetched");
    } catch (error) {
      print("Failed");
      throw error;
    }
  }

  bool checkShopStatus(String openTime, String closedTime) {
    TimeOfDay timeNow = TimeOfDay.now();
    String openHr = openTime.substring(0, 2);
    String openMin = openTime.substring(3, 5);
    String openAmPm = openTime.substring(5);
    TimeOfDay timeOpen;
    if (openAmPm == "AM") {
      //am case
      if (openHr == "12") {
        //if 12AM then time is 00
        timeOpen = TimeOfDay(hour: 00, minute: int.parse(openMin));
      } else {
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      }
    } else {
      //pm case
      if (openHr == "12") {
//if 12PM means as it is
        timeOpen =
            TimeOfDay(hour: int.parse(openHr), minute: int.parse(openMin));
      } else {
//add +12 to conv time to 24hr format
        timeOpen =
            TimeOfDay(hour: int.parse(openHr) + 12, minute: int.parse(openMin));
      }
    }

    String closeHr = closedTime.substring(0, 2);
    String closeMin = closedTime.substring(3, 5);
    String closeAmPm = closedTime.substring(5);

    TimeOfDay timeClose;

    if (closeAmPm == "AM") {
      //am case
      if (closeHr == "12") {
        timeClose = TimeOfDay(hour: 0, minute: int.parse(closeMin));
      } else {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      }
    } else {
      //pm case
      if (closeHr == "12") {
        timeClose =
            TimeOfDay(hour: int.parse(closeHr), minute: int.parse(closeMin));
      } else {
        timeClose = TimeOfDay(
            hour: int.parse(closeHr) + 12, minute: int.parse(closeMin));
      }
    }

    int nowInMinutes = timeNow.hour * 60 + timeNow.minute;
    int openTimeInMinutes = timeOpen.hour * 60 + timeOpen.minute;
    int closeTimeInMinutes = timeClose.hour * 60 + timeClose.minute;

//handling day change ie pm to am
    if ((closeTimeInMinutes - openTimeInMinutes) < 0) {
      closeTimeInMinutes = closeTimeInMinutes + 1440;
      if (nowInMinutes >= 0 && nowInMinutes < openTimeInMinutes) {
        nowInMinutes = nowInMinutes + 1440;
      }
      if (openTimeInMinutes < nowInMinutes &&
          nowInMinutes < closeTimeInMinutes) {
        return true;
      }
    } else if (openTimeInMinutes < nowInMinutes &&
        nowInMinutes < closeTimeInMinutes) {
      return true;
    }

    return false;
  }
}
