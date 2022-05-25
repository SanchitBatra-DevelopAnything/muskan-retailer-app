import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String price;
  final String imageUrl;
  final String parentCategoryType;
  final double totalPrice;

  CartItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.parentCategoryType,
      required this.quantity,
      required this.totalPrice,
      required this.price});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items = {}; //product db id as key.

  List<CartItem> _itemList = [];

  Map<String, CartItem> get items {
    return {..._items!};
  }

  List<CartItem> get itemList {
    return [..._itemList];
  }

  int get itemCount {
    if (_items == null) {
      return 0;
    }
    return _items!.length;
  }

  bool checkInCart(String itemId) {
    return _items!.containsKey(itemId);
  }

  int getQuantity(String itemId) {
    if (checkInCart(itemId)) {
      CartItem? item = _items![itemId];
      return item!.quantity;
    } else {
      return 0;
    }
  }

  double getTotalOrderPrice() {
    double totalPrice = 0;
    _itemList.forEach((element) {
      totalPrice += element.totalPrice;
    });
    return totalPrice;
  }

  void removeItem(String itemId) {
    if (checkInCart(itemId)) {
      _items!.remove(itemId);
      formCartList();
      notifyListeners();
    }
  }

  void formCartList() {
    _itemList = [];
    this._items!.forEach((key, value) {
      _itemList.add(CartItem(
          id: key,
          totalPrice: value.totalPrice,
          imageUrl: value.imageUrl,
          parentCategoryType: value.parentCategoryType,
          price: value.price,
          quantity: value.quantity,
          title: value.title));
    });
    notifyListeners();
  }

  double getPriceFromString(String price) {
    var p = price.substring(3);
    return double.parse(p);
  }

  void addItem(String itemId, String price, int quantity, String title,
      String imgPath, String parentCategory) {
    if (_items!.containsKey(itemId)) {
      //change quantity..
      _items!.update(
          itemId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              totalPrice: getPriceFromString(existingCartItem.price) * quantity,
              title: existingCartItem.title,
              imageUrl: existingCartItem.imageUrl,
              parentCategoryType: existingCartItem.parentCategoryType,
              price: existingCartItem.price,
              quantity: quantity));
    } else {
      _items!.putIfAbsent(
          itemId,
          () => CartItem(
              id: itemId + "-CART",
              totalPrice: getPriceFromString(price) * 1,
              price: price,
              title: title,
              quantity: 1,
              imageUrl: imgPath,
              parentCategoryType: parentCategory));
    }
    formCartList();
    notifyListeners();
  }
}
