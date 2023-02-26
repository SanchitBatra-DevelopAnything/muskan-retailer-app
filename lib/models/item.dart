class Item {
  final String itemId;
  dynamic cakeFlavour;
  dynamic customerPrice;
  dynamic designCategory;
  dynamic imageUrl;
  dynamic itemName;
  dynamic minPounds;
  dynamic offer;
  dynamic shopPrice;
  dynamic subcategoryName;
  dynamic distributorItemName;
  dynamic distributorPrice;

  Item(
      {required this.cakeFlavour,
      required this.customerPrice,
      required this.designCategory,
      required this.imageUrl,
      required this.itemName,
      required this.minPounds,
      required this.offer,
      required this.itemId,
      required this.shopPrice,
      required this.subcategoryName,
      required this.distributorItemName,
      required this.distributorPrice});
}
