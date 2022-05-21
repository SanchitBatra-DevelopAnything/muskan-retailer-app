import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem>? _items; //product db id as key.

  Map<String, CartItem> get items {
    return {..._items!};
  }

  void addItem(String itemId, double price, String title) {
    if (_items!.containsKey(itemId)) {
      //change quantity..
      _items!.update(
          itemId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.id,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items!.putIfAbsent(
          itemId,
          () => CartItem(
              id: itemId + "-CART", price: price, title: title, quantity: 1));
    }
    notifyListeners();
  }
}
