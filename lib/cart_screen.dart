import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:muskan_shop/cartProductCard.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isPlacingOrder = false;

  void showOrderDialog(BuildContext context, CartProvider cartObject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Order Checkout!',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Confirm?",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'No',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isPlacingOrder = true;
              });
              final shopkeeper =
                  Provider.of<AuthProvider>(context, listen: false)
                      .loggedInRetailer;
              final shop = Provider.of<AuthProvider>(context, listen: false)
                  .loggedInShop;
              final timeArrayComponent =
                  DateFormat.yMEd().add_jms().format(DateTime.now()).split(" ");
              final time = timeArrayComponent[timeArrayComponent.length - 2] +
                  " " +
                  timeArrayComponent[timeArrayComponent.length - 1];
              cartObject.PlaceShopOrder(shop, shopkeeper, time).then((_) => {
                    cartObject.clearCart(),
                    // setState(() {
                    //   _isPlacingOrder = false;
                    // }),
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/orderPlaced", (r) => false)
                  });
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    final cartItemsList = cartProviderObject.itemList;
    final totalItems = cartItemsList.length;
    var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    return Scaffold(
      backgroundColor: Colors.black54,
      body: _isPlacingOrder
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                    strokeWidth: 5,
                  ),
                ),
                Text(
                  "Placing Your Order...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            )
          : Column(
              children: [
                SizedBox(height: 35),
                Flexible(
                  flex: 2,
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
                          child: Text(
                            "YOUR CART",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal),
                          ),
                        ),
                        Spacer(),
                        Flexible(
                          flex: 4,
                          child: Container(
                            margin: EdgeInsets.only(right: 15),
                            width: 300,
                            height: 50,
                            child: totalItems != 0
                                ? RaisedButton(
                                    onPressed: () {
                                      showOrderDialog(
                                          context, cartProviderObject);
                                    },
                                    color: Color.fromRGBO(51, 51, 51, 1),
                                    child: AnimatedTextKit(
                                        onTap: () {
                                          showOrderDialog(
                                              context, cartProviderObject);
                                        },
                                        repeatForever: true,
                                        isRepeatingAnimation: true,
                                        animatedTexts: [
                                          TyperAnimatedText("Click here",
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                          TyperAnimatedText("Checkout",
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ]))
                                : SizedBox(
                                    height: 0,
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                  thickness: 5,
                ),
                totalItems != 0
                    ? Flexible(
                        flex: 10,
                        child: ListView.builder(
                            itemExtent: 100,
                            itemCount: cartItemsList.length,
                            itemBuilder: ((context, index) => CartProductCard(
                                cartItem: cartItemsList[index]))))
                    : Center(
                        child: Text(
                        "Cart is Empty.",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                Flexible(
                    child: Divider(
                  thickness: 5,
                  color: Colors.white,
                )),
                Flexible(
                  child: Text(
                    'TOTAL : Rs.${totalOrderPrice}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                )
              ],
            ),
    );
  }
}
