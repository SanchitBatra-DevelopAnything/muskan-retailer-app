import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:provider/provider.dart';

import 'badge.dart';

class OrdersStatus extends StatefulWidget {
  const OrdersStatus({Key? key}) : super(key: key);

  @override
  State<OrdersStatus> createState() => _OrdersStatusState();
}

class _OrdersStatusState extends State<OrdersStatus> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  var _isLoading = false;
  var orders = ["1", "2", "3"];

  moveToItems(BuildContext context, String order) {}

  void moveToCart(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black54,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.red,
                ),
              )
            : Column(
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
                            child: Text(
                              "MY ORDERS",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal),
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
                    flex: 10,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            moveToItems(context, orders[index]);
                          },
                          child: Container(
                            height: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 15,
                              color: Color.fromRGBO(51, 51, 51, 1),
                              margin:
                                  EdgeInsets.only(left: 30, right: 30, top: 15),
                              child: ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  "Order No.1",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "IN PROGRESS",
                                  style: TextStyle(
                                      color: Colors.orangeAccent, fontSize: 18),
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
