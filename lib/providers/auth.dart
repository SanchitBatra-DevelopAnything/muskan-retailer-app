import 'package:flutter/material.dart';
import 'package:muskan_shop/models/shop.dart';

import 'package:provider/provider.dart';

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

  void retailerSignUp(String retailerName, String shopAddress) {
    //send http post here.
    print("SIGNED UP LOGIC HERE");
    print(retailerName);
    print(shopAddress);
  }
}
