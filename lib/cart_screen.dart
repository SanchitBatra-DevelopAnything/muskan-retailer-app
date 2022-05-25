import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:muskan_shop/cartProductCard.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

void showOrderDialog(BuildContext context) {
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
          },
        )
      ],
    ),
  );
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartItemsList = Provider.of<CartProvider>(context).itemList;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
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
                      child: RaisedButton(
                          onPressed: () {
                            showOrderDialog(context);
                          },
                          color: Color.fromRGBO(51, 51, 51, 1),
                          child: AnimatedTextKit(
                              onTap: () {
                                showOrderDialog(context);
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
                              ])),
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
          Flexible(
              flex: 10,
              child: ListView.builder(
                  itemExtent: 100,
                  itemCount: cartItemsList.length,
                  itemBuilder: ((context, index) =>
                      CartProductCard(cartItem: cartItemsList[index])))),
          Flexible(
              child: Divider(
            thickness: 5,
            color: Colors.white,
          )),
          Flexible(
            child: Text(
              "TOTAL",
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
