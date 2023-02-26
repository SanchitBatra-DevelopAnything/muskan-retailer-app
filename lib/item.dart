// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:muskan_shop/cakeCustomizePopup.dart';
import 'package:muskan_shop/itemQuantityCounter.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

class Item extends StatefulWidget {
  const Item(
      {Key? key,
      required this.imgPath,
      required this.price,
      required this.itemName,
      required this.cakeFlavour,
      required this.designCategory,
      required this.itemId,
      required this.distributorItemName,
      required this.distributorPrice,
      required this.minPounds})
      : super(key: key);

  final String imgPath;
  final String price;
  final String itemName;
  final String cakeFlavour;
  final String designCategory;
  final String itemId;
  final dynamic minPounds;
  final dynamic distributorItemName;
  final String distributorPrice;

  @override
  State<Item> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  var _isInCart;
  var _quantity;

  @override
  void initState() {
    super.initState();
  }

  openCakeCustomizePopup(
      BuildContext context,
      String imgUrl,
      String price,
      String itemName,
      String ItemId,
      String cakeFlavour,
      dynamic minPounds,
      String design) {
    return showDialog(
        context: context,
        builder: (context) {
          return CakeCustomizePopup(
            imgUrl: imgUrl,
            itemId: ItemId,
            itemName: itemName,
            designCategory: design,
            cakeFlavour: cakeFlavour,
            ReferencePrice: price,
            minPounds: minPounds,
          );
        });
  }

  getPrice() {
    final parentCategory =
        Provider.of<CategoriesProvider>(context, listen: false)
            .activeCategoryName;
    final parentSubcategory =
        Provider.of<CategoriesProvider>(context, listen: false)
            .activeSubcategoryName;
    final appType = Provider.of<AuthProvider>(context, listen: false).appType;

    if (appType == "distributor") {
      return widget.distributorPrice + "";
    } else {
      return (parentCategory!.toUpperCase() == "CAKES & PASTRIES") ||
              (parentCategory.toUpperCase() == "CAKES")
          ? widget.price + " / pd."
          : (parentSubcategory!.toUpperCase() == "PATTIES")
              ? widget.price + " / dozen."
              : widget.price + "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    _isInCart = cartProviderObject.checkInCart(widget.itemId);
    _isInCart
        ? _quantity = cartProviderObject.getQuantity(widget.itemId)
        : _quantity = 0;
    final parentCategory =
        Provider.of<CategoriesProvider>(context, listen: false)
            .activeCategoryName;
    final parentSubcategory =
        Provider.of<CategoriesProvider>(context, listen: false)
            .activeSubcategoryName;
    final appType = Provider.of<AuthProvider>(context, listen: false).appType;
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 5, bottom: 5, right: 5),
        child: GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0,
                    )
                  ],
                  color: Color.fromRGBO(51, 51, 51, 0.8),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/item-detail', arguments: {
                            'imgPath': widget.imgPath,
                            'price': getPrice(),
                            'itemName': appType == "retailer"
                                ? widget.itemName
                                : widget.distributorItemName,
                            'cakeFlavour': widget.cakeFlavour,
                            'designCategory': widget.designCategory,
                            'minPounds': widget.minPounds
                          });
                        },
                        child: Hero(
                          tag: widget.imgPath,
                          child: Image.network(
                            widget.imgPath,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.red, strokeWidth: 5),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        getPrice(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          appType == "retailer"
                              ? widget.itemName.toLowerCase()
                              : widget.distributorItemName
                                  .toString()
                                  .toLowerCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Flexible(child: Divider(), flex: 1),
                    Flexible(
                      flex: 2,
                      child: Center(
                          child: (parentCategory!.toUpperCase() ==
                                      "CAKES & PASTRIES" ||
                                  parentCategory.toUpperCase() == "CAKES")
                              ? RaisedButton(
                                  onPressed: () {
                                    openCakeCustomizePopup(
                                        context,
                                        widget.imgPath,
                                        widget.price,
                                        widget.itemName,
                                        widget.itemId,
                                        widget.cakeFlavour,
                                        widget.minPounds,
                                        widget.designCategory);
                                  },
                                  child: Text("Select",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  color: Colors.red)
                              : !_isInCart
                                  ? RaisedButton(
                                      child: Text("Add to cart",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          )),
                                      color: Colors.red,
                                      onPressed: () {
                                        cartProviderObject.addItem(
                                            widget.itemId,
                                            appType == "retailer"
                                                ? widget.price
                                                : widget.distributorPrice,
                                            parentSubcategory!.toUpperCase() ==
                                                    "PATTIES"
                                                ? 0.5
                                                : 1,
                                            appType == "retailer"
                                                ? widget.itemName
                                                : widget.distributorItemName
                                                    .toString(),
                                            widget.imgPath,
                                            parentCategory,
                                            parentSubcategory);
                                        setState(() {
                                          _isInCart = true;
                                        });
                                      },
                                    )
                                  : CountButtonView(
                                      itemId: widget.itemId,
                                      parentCategory: parentCategory,
                                      parentSubcategory: parentSubcategory!,
                                      onChange: (count) => {
                                            if (count == 0)
                                              {
                                                cartProviderObject
                                                    .removeItem(widget.itemId),
                                                setState(
                                                    () => {_isInCart = false})
                                              }
                                            else if (count > 0)
                                              {
                                                cartProviderObject.addItem(
                                                    widget.itemId,
                                                    appType == "retailer"
                                                        ? widget.price
                                                        : widget
                                                            .distributorPrice,
                                                    count,
                                                    appType == "retailer"
                                                        ? widget.itemName
                                                            .toLowerCase()
                                                        : widget
                                                            .distributorItemName
                                                            .toString()
                                                            .toLowerCase(),
                                                    widget.imgPath,
                                                    parentCategory,
                                                    parentSubcategory)
                                              }
                                          })),
                    )
                  ],
                ))));
  }
}
