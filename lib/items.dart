import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'badge.dart';
import 'item.dart';
import 'providers/categories_provider.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var searchItemController = TextEditingController();
  var _isLoading = false;
  var _isFirstTime = true;
  var _loadDirectVariety = false;
  var _isSearching = false;
  var _cakeCategoryOpened = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      setState(() {
        _isLoading = true;
      });
      if (Provider.of<CategoriesProvider>(context, listen: false)
              .activeSubcategoryName!
              .toUpperCase() ==
          "DIRECT VARIETY") {
        Provider.of<CategoriesProvider>(context, listen: false)
            .getItemsForDirectVariety()
            .then((value) => setState(
                () => {_isLoading = false, _loadDirectVariety = true}));
      } else {
        Provider.of<CategoriesProvider>(context, listen: false)
            .getItemsForSubcategory()
            .then((value) => setState(
                () => {_isLoading = false, _loadDirectVariety = false}));
      }
      var categorySelected =
          Provider.of<CategoriesProvider>(context, listen: false)
              .activeCategoryName!
              .toUpperCase();
      if ((categorySelected == "CAKES & PASTRIES") ||
          (categorySelected == "CAKES")) {
        Provider.of<CategoriesProvider>(context, listen: false)
            .getAllCakeFlavours()
            .then((_) => Provider.of<CategoriesProvider>(context, listen: false)
                .getAllCakeDesigns());
      }
    }
    _isFirstTime = false;
    super.didChangeDependencies();
  }

  void onSearch(String text) {
    if (_loadDirectVariety) {
      Provider.of<CategoriesProvider>(context, listen: false)
          .filterDirectVariety(text);
    } else {
      Provider.of<CategoriesProvider>(context, listen: false)
          .filterSubcategoryItems(text);
    }
  }

  void moveToCart(BuildContext context) {
    Navigator.of(context).pushNamed('/cart');
  }

  checkMinimumPoundValue(dynamic value) {
    if (value == "-1" || value == -1) {
      return "NO LIMIT ON SIZE";
    } else if (value == null || value == "null") {
      return "1";
    } else if (value == 1) {
      return "1";
    } else {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesProviderObject = Provider.of<CategoriesProvider>(context);
    final sub = CategoriesProviderObject.activeSubcategoryName;
    final cat = CategoriesProviderObject.activeCategoryName;
    final itemsUnderSubcategory =
        CategoriesProviderObject.activeSubcategoryFilteredItems;
    var directVarietyItems =
        CategoriesProviderObject.activeDirectVarietyFilteredItems;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 5,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Container(
                  height: 100,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2, top: 25),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 1,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_new),
                              color: Colors.white,
                              iconSize: 20,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )),
                        Flexible(
                          flex: 5,
                          fit: FlexFit.tight,
                          child: SizedBox(
                            height: 45,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextField(
                                onTap: () {
                                  setState(() {
                                    _isSearching = true;
                                  });
                                },
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                controller: searchItemController,
                                onChanged: (text) {
                                  onSearch(text);
                                },
                                decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(10),
                                    hintText:
                                        "Search for ${sub.toString().toLowerCase()}"),
                              ),
                              elevation: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        if (_isSearching)
                          Flexible(
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                searchItemController.clear();
                                onSearch('');
                                setState(() {
                                  _isSearching = false;
                                });
                              },
                            ),
                          ),
                        Flexible(
                          child: Consumer<CartProvider>(
                            builder: (_, cart, ch) => Badge(
                              child: ch,
                              value: cart.itemCount.toString(),
                              color: Colors.red,
                            ),
                            child: IconButton(
                              onPressed: () {
                                moveToCart(context);
                              },
                              icon: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (ctx, index) => _loadDirectVariety
                          ? Item(
                              imgPath: directVarietyItems[index].imageUrl,
                              itemId: directVarietyItems[index].itemId,
                              price: ((cat!.toUpperCase() == "CAKES") ||
                                      (cat.toUpperCase() == "CAKES & PASTRIES"))
                                  ? "Rs." +
                                      CategoriesProviderObject.getCakePrice(
                                              directVarietyItems[index]
                                                  .cakeFlavour,
                                              directVarietyItems[index]
                                                  .designCategory,
                                              1)
                                          .toString()
                                  : "Rs." +
                                      directVarietyItems[index]
                                          .shopPrice
                                          .toString(),
                              itemName: directVarietyItems[index].itemName,
                              cakeFlavour:
                                  directVarietyItems[index].cakeFlavour,
                              designCategory:
                                  directVarietyItems[index].designCategory,
                              minPounds: checkMinimumPoundValue(
                                  directVarietyItems[index].minPounds),
                            )
                          : Item(
                              imgPath: itemsUnderSubcategory[index].imageUrl,
                              itemId: itemsUnderSubcategory[index].itemId,
                              price: ((cat!.toUpperCase() == "CAKES") ||
                                      (cat.toUpperCase() == "CAKES & PASTRIES"))
                                  ? "Rs." +
                                      CategoriesProviderObject.getCakePrice(
                                              itemsUnderSubcategory[index]
                                                  .cakeFlavour,
                                              itemsUnderSubcategory[index]
                                                  .designCategory,
                                              1)
                                          .toString()
                                  : "Rs." +
                                      itemsUnderSubcategory[index]
                                          .shopPrice
                                          .toString(),
                              itemName: itemsUnderSubcategory[index].itemName,
                              cakeFlavour:
                                  itemsUnderSubcategory[index].cakeFlavour,
                              minPounds: checkMinimumPoundValue(
                                  itemsUnderSubcategory[index].minPounds),
                              designCategory:
                                  itemsUnderSubcategory[index].designCategory),
                      itemCount: _loadDirectVariety
                          ? directVarietyItems.length
                          : itemsUnderSubcategory.length,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
