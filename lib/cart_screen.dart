import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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
  var _isSavingCart = false;

  void showOrderDialog(BuildContext context, CartProvider cartObject) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Order Checkout!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Confirm?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text(
              'No',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
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
              final retailer = Provider.of<AuthProvider>(context, listen: false)
                  .loggedInRetailer;
              final shop = Provider.of<AuthProvider>(context, listen: false)
                  .loggedInShop;
              final timeArrayComponent =
                  DateFormat.yMEd().add_jms().format(DateTime.now()).split(" ");
              final time = timeArrayComponent[timeArrayComponent.length - 2] +
                  " " +
                  timeArrayComponent[timeArrayComponent.length - 1];
              final distributorship =
                  Provider.of<AuthProvider>(context, listen: false)
                      .loggedInDistributorship;
              final distributor =
                  Provider.of<AuthProvider>(context, listen: false)
                      .loggedInDistributor;
              final appType =
                  Provider.of<AuthProvider>(context, listen: false).appType;
              if (appType != "distributor") {
                cartObject.PlaceShopOrder(shop, shopkeeper, time).then((_) => {
                      cartObject.clearCart(),
                      cartObject.deleteCartOnDB(retailer, shop).then((value) =>
                          {
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/orderPlaced", (r) => false)
                          })
                    });
              } else {
                cartObject.PlaceDistributorOrder(
                        distributorship, distributor, time)
                    .then((_) => {
                          cartObject.clearCart(),
                          cartObject
                              .deleteCartOnDB(distributorship, distributor)
                              .then((value) => {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/orderPlaced", (r) => false)
                                  })
                        });
              }
            },
          ),
        ],
      ),
    );
  }

  void showSaveCartDialog(BuildContext context, CartProvider cartObject,
      String retailer, String shop) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Save Cart?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Saved cart items will remain after you close the app.",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text(
              'No',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isSavingCart = true;
              });
              cartObject.deleteCartOnDB(retailer, shop).then((value) =>
                  cartObject.saveCart(retailer, shop).then((value) => {
                        setState(() => _isSavingCart = false),
                      }));
            },
          ),
        ],
      ),
    );
  }

  saveCartBasedOnAppType(
      AuthProvider authProviderObject, CartProvider cartProviderObject) async {
    if (authProviderObject.appType != "distributor") {
      await cartProviderObject.saveCart(
          authProviderObject.loggedInRetailer, authProviderObject.loggedInShop);
    } else {
      await cartProviderObject.saveCart(authProviderObject.loggedInDistributor,
          authProviderObject.loggedInDistributorship);
    }
  }

  deleteCartBasedOnAppType(
      AuthProvider authProviderObject, CartProvider cartProviderObject) async {
    if (authProviderObject.appType != "distributor") {
      await cartProviderObject.deleteCartOnDB(
          authProviderObject.loggedInRetailer, authProviderObject.loggedInShop);
    } else {
      await cartProviderObject.deleteCartOnDB(
          authProviderObject.loggedInDistributor,
          authProviderObject.loggedInDistributorship);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderObject = Provider.of<CartProvider>(context);
    final cartItemsList = cartProviderObject.itemList;
    final totalItems = cartItemsList.length;
    var totalOrderPrice = cartProviderObject.getTotalOrderPrice();
    final authProviderObject =
        Provider.of<AuthProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _isSavingCart = true;
        });
        await saveCartBasedOnAppType(authProviderObject, cartProviderObject);
        setState(() {
          _isSavingCart = false;
        });
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: _isPlacingOrder
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'animations/delivery.json',
                    reverse: true,
                    repeat: true,
                    fit: BoxFit.cover,
                  ),
                  // Center(
                  //   child: CircularProgressIndicator(
                  //     color: Colors.red,
                  //     strokeWidth: 5,
                  //   ),
                  // ),
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
                                onPressed: () async {
                                  if (cartItemsList.length == 0) {
                                    setState(() {
                                      _isSavingCart = true;
                                    });
                                    await deleteCartBasedOnAppType(
                                        authProviderObject, cartProviderObject);
                                    setState(() {
                                      _isSavingCart = false;
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    setState(() {
                                      _isSavingCart = true;
                                    });
                                    await saveCartBasedOnAppType(
                                        authProviderObject, cartProviderObject);
                                    setState(() {
                                      _isSavingCart = false;
                                    });
                                    Navigator.of(context).pop();
                                  }
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
                                  ? ElevatedButton(
                                      onPressed: () {
                                        showOrderDialog(
                                            context, cartProviderObject);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Color.fromRGBO(51, 51, 51, 1),
                                      ),
                                      child: AnimatedTextKit(
                                          onTap: () {
                                            deleteCartBasedOnAppType(
                                                    authProviderObject,
                                                    cartProviderObject)
                                                .then((_) => {
                                                      showOrderDialog(context,
                                                          cartProviderObject)
                                                    });
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
                  _isSavingCart
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.red),
                        )
                      : totalItems != 0
                          ? Flexible(
                              flex: 10,
                              child: ListView.builder(
                                  itemExtent: 100,
                                  itemCount: cartItemsList.length,
                                  itemBuilder: ((context, index) =>
                                      CartProductCard(
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
      ),
    );
  }
}
