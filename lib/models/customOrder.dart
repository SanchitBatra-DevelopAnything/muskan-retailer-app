class customOrder {
  String cakeDescription;
  String customType;
  String flavour;
  String imgUrl;
  String orderDate;
  String orderKey;
  String orderTime;
  String orderType;
  String orderedBy;
  String photoOnCakeUrl;
  dynamic pounds;
  String shopAddress;
  String? status;

  customOrder(
      {required this.cakeDescription,
      required this.customType,
      required this.flavour,
      required this.imgUrl,
      required this.orderDate,
      required this.orderType,
      required this.orderKey,
      required this.orderTime,
      required this.orderedBy,
      required this.photoOnCakeUrl,
      required this.pounds,
      this.status,
      required this.shopAddress});
}
