import 'package:muskan_shop/models/regularShopOrderItem.dart';

class regularOrder {
  String orderDate;
  String orderTime;
  String orderedBy;
  String shopAddress;
  dynamic totalPrice;
  List<RegularShopOrderItem> items;

  regularOrder(
      {required this.orderDate,
      required this.orderTime,
      required this.orderedBy,
      required this.shopAddress,
      required this.items});
}
