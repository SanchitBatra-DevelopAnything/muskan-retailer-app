import 'item.dart';

class Subcategory {
  String subcategoryName;
  String subcategoryId;

  List<Item>? items;

  Subcategory(
      {required this.subcategoryId, required this.subcategoryName, items});
}
