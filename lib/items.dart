import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final CategoriesProviderObject = Provider.of<CategoriesProvider>(context);
    final sub = CategoriesProviderObject.activeSubcategoryName;
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
                        Flexible(
                            child: IconButton(
                          iconSize: 30,
                          icon: Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ))
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
                              price: "Rs." +
                                  directVarietyItems[index]
                                      .shopPrice
                                      .toString(),
                              itemName: directVarietyItems[index].itemName,
                            )
                          : Item(
                              imgPath: itemsUnderSubcategory[index].imageUrl,
                              price: "Rs." +
                                  itemsUnderSubcategory[index]
                                      .shopPrice
                                      .toString(),
                              itemName: itemsUnderSubcategory[index].itemName,
                            ),
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
