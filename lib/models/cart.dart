final String tableCart = 'cart';

class CartFields {
  static final List<String> values = [
    /// Add all fields
    id, itemId, title, quantity, price, parentCategoryType,
    parentSubcategoryType, imageUrl, totalPrice
  ];

  static final String id = "_id";
  static final String itemId = "itemId";
  static final String title = "title";
  static final String quantity = "quantity";
  static final String price = "price";
  static final String parentSubcategoryType = "parentSubcategoryType";
  static final String imageUrl = "imageUrl";
  static final String parentCategoryType = "parentCategoryType";
  static final String totalPrice = "totalPrice";
}

class CartItem {
  final int? id;
  final String itemId;
  final String title;
  final double quantity;
  final String price;
  final String parentSubcategoryType;
  final String imageUrl;
  final String parentCategoryType;
  final double totalPrice;

  CartItem(
      {required this.id,
      required this.itemId,
      required this.title,
      required this.imageUrl,
      required this.parentCategoryType,
      required this.parentSubcategoryType,
      required this.quantity,
      required this.totalPrice,
      required this.price});

  CartItem copy({
    int? id,
    String? itemId,
    String? imageUrl,
    double? quantity,
    String? price,
    String? parentCategoryType,
    String? parentSubcategoryType,
    String? title,
    double? totalPrice,
  }) =>
      CartItem(
        id: id ?? this.id,
        itemId: itemId ?? this.itemId,
        imageUrl: imageUrl ?? this.imageUrl,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        totalPrice: totalPrice ?? this.totalPrice,
        parentCategoryType: parentCategoryType ?? this.parentCategoryType,
        parentSubcategoryType:
            parentSubcategoryType ?? this.parentSubcategoryType,
        title: title ?? this.title,
      );

  static CartItem fromJson(Map<String, Object?> json) => CartItem(
        id: json[CartFields.id] as int?,
        itemId: json[CartFields.itemId] as String,
        imageUrl: json[CartFields.imageUrl] as String,
        title: json[CartFields.title] as String,
        parentCategoryType: json[CartFields.parentCategoryType] as String,
        parentSubcategoryType: json[CartFields.parentSubcategoryType] as String,
        quantity: json[CartFields.quantity] as double,
        price: json[CartFields.price] as String,
        totalPrice: json[CartFields.totalPrice] as double,
      );

  Map<String, Object?> toJson() => {
        CartFields.id: id,
        CartFields.title: title,
        CartFields.itemId: itemId,
        CartFields.quantity: quantity,
        CartFields.price: price,
        CartFields.parentCategoryType: parentCategoryType,
        CartFields.imageUrl: imageUrl,
        CartFields.parentSubcategoryType: parentSubcategoryType,
        CartFields.totalPrice: totalPrice,
      };
}
