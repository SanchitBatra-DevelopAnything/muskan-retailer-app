import 'package:flutter/material.dart';

class RegularShopOrderItem {
  final String item;
  final double quantity;
  final double price;
  final String imageUrl;
  final String CategoryName;

  RegularShopOrderItem(
      {required this.item,
      required this.imageUrl,
      required this.CategoryName,
      required this.quantity,
      required this.price});

  Map toJson() => {
        'item': this.item,
        'imageUrl': this.imageUrl,
        'CategoryName': this.CategoryName,
        'quantity': this.quantity,
        'price': this.price,
      };
}
