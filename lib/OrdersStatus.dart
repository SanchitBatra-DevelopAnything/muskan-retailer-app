import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/order.dart';
import 'package:provider/provider.dart';

import 'badge.dart';

class OrdersStatus extends StatefulWidget {
  const OrdersStatus({Key? key}) : super(key: key);

  @override
  State<OrdersStatus> createState() => _OrdersStatusState();
}

class _OrdersStatusState extends State<OrdersStatus> {
  var _isLoading = false;
  var _isFirstTime = true;
  var _toggled = false;
  DateTime _dateTime = DateTime.now();
  var selectedDate = "";
  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      setState(() {
        _isLoading = true;
      });
      selectedDate = _dateTime.day.toString() +
          _dateTime.month.toString() +
          _dateTime.year.toString();
      allStuff(selectedDate);
      _isFirstTime = false;
    }
    super.didChangeDependencies();
  }

  moveToItems(BuildContext context, String order) {}

  Future<void> allStuff(String date) async {
    setState(() {
      _isLoading = true;
    });
    Provider.of<OrderProvider>(context, listen: false)
        .getActiveOrders()
        .then((value) => {
              Provider.of<OrderProvider>(context, listen: false)
                  .getProcessedRegularOrders(date)
                  .then((value) => {
                        Provider.of<OrderProvider>(context, listen: false)
                            .getProcessedCustomOrders(date)
                            .then((value) => {
                                  Provider.of<OrderProvider>(context,
                                          listen: false)
                                      .filterOrders(date)
                                })
                            .then((value) => {
                                  setState((() => {_isLoading = false}))
                                })
                      })
            });
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(Duration(days: 3)),
            lastDate: DateTime.now())
        .then((value) => {
              if (value == null)
                {
                  // do processing for orders for the date today..
                  allStuff(DateTime.now().day.toString() +
                      DateTime.now().month.toString() +
                      DateTime.now().year.toString())
                }
              else
                {allStuff(getCalendarDate(value.toString()))}
            });
  }

  String getCalendarDate(String value) {
    var year = value.toString().split(" ")[0].split("-")[0];
    var month = value.toString().split(" ")[0].split("-")[1];
    var day = value.toString().split(" ")[0].split("-")[2];

    if (month.length == 2 && month[0] == '0') {
      month = month[1].toString();
    }

    return day.toString() + month.toString() + year.toString();
  }

  void moveToCart(BuildContext context) {}
  @override
  Widget build(BuildContext context) {
    var orders = Provider.of<OrderProvider>(context).processedRegularOrders;
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
                              child: IconButton(
                            icon: Icon(Icons.calendar_month),
                            color: Colors.white,
                            iconSize: 30,
                            onPressed: () {
                              _showDatePicker(context);
                            },
                          ))
                        ],
                      ),
                    ),
                  ),
                  SwitchListTile(
                      activeColor: Colors.green,
                      title: Text(
                        "Show Custom Orders",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      value: _toggled,
                      onChanged: (bool value) {
                        setState(() {
                          _toggled = value;
                        });
                      }),
                  Flexible(
                    flex: 10,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            moveToItems(context, "jdkajs");
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
                                  orders[index].orderDate +
                                      "-" +
                                      orders[index].orderTime,
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
