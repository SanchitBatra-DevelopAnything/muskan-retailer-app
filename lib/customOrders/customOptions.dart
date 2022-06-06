import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../badge.dart';
import '../bottomNavigation.dart';
import '../providers/cart.dart';

class CustomOrderOptions extends StatelessWidget {
  const CustomOrderOptions({Key? key}) : super(key: key);

  static const customOptions = ["Custom Cakes", "Photo Cakes"];
  void moveToCart(BuildContext context) {
    Navigator.of(context).pushNamed('/cart');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(137, 43, 40, 40),
        bottomNavigationBar: BottomNavigator(
          index: 1,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35),
            Padding(
              padding: EdgeInsets.only(left: 23, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Custom Orders".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
                  ),
                  Consumer<CartProvider>(
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
                ],
              ),
            ),
            Flexible(
              flex: 10,
              child: ListView.builder(
                itemCount: customOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 1) {
                        Navigator.of(context).pushNamed('/customCakeForm',
                            arguments: {'orderType': 'Photo Cakes'});
                      } else {
                        Navigator.of(context).pushNamed('/customCakeForm',
                            arguments: {'orderType': 'Regular Custom Cakes'});
                      }
                    },
                    child: Container(
                      height: 100,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 15,
                        color: Color.fromRGBO(51, 51, 51, 1),
                        margin: EdgeInsets.only(left: 30, right: 30, top: 15),
                        child: ListTile(
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.white,
                          ),
                          title: Text(
                            customOptions[index],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
