import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'providers/categories_provider.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  var searchItemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CategoriesProviderObject = Provider.of<CategoriesProvider>(context);
    final sub = CategoriesProviderObject.activeSubcategoryName;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),
          Flexible(
            flex: 1,
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
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: TextField(
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          controller: searchItemController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            label: Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Search items here",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
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
        ],
      ),
    );
  }
}
