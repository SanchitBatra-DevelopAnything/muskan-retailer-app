import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final String price;
  final String imageUrl;
  final String parentCategoryType;

  CartItem(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.parentCategoryType,
      required this.quantity,
      required this.price});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items = {}; //product db id as key.

  Map<String, CartItem> get items {
    return {..._items!};
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

  void removeItem(String itemId) {
    if (checkInCart(itemId)) {
      _items!.remove(itemId);
      notifyListeners();
    }
  }

  void addItem(String itemId, String price, int quantity, String title,
      String imgPath, String parentCategory) {
    if (_items!.containsKey(itemId)) {
      //change quantity..
      _items!.update(
          itemId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.id,
              imageUrl: existingCartItem.imageUrl,
              parentCategoryType: existingCartItem.parentCategoryType,
              price: existingCartItem.price,
              quantity: quantity));
    } else {
      _items!.putIfAbsent(
          itemId,
          () => CartItem(
              id: itemId + "-CART",
              price: price,
              title: title,
              quantity: 1,
              imageUrl: imgPath,
              parentCategoryType: parentCategory));
    }
    notifyListeners();
  }
}
