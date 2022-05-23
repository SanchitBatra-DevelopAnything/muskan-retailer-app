import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:provider/provider.dart';

typedef void CountButtonClickCallBack(int count);

class CountButtonView extends StatefulWidget {
  final String itemId;
  final CountButtonClickCallBack onChange;

  const CountButtonView(
      {Key? key, required this.itemId, required this.onChange})
      : super(key: key);

  @override
  _CountButtonViewState createState() => _CountButtonViewState();
}

class _CountButtonViewState extends State<CountButtonView> {
  int quantity = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void updateCount(int addValue) {
    if (quantity + addValue == 0) {
      setState(() {
        quantity = 0;
      });
    }
    if (quantity + addValue > 0) {
      setState(() {
        quantity += addValue;
      });
    }

    if (widget.onChange != null) {
      widget.onChange(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    var count = Provider.of<CartProvider>(context, listen: false)
        .getQuantity(widget.itemId);
    setState(() {
      quantity = count;
    });
    print("RECEIVED COUNT IN BASKET = " + count.toString());
    return SizedBox(
      width: 120.0,
      height: 50.0,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(22.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    updateCount(-1);
                  },
                  child: Container(
                      width: 50.0,
                      child: Center(
                          child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
              Container(
                child: Center(
                    child: Text(
                  '$quantity',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                )),
              ),
              GestureDetector(
                  onTap: () {
                    updateCount(1);
                  },
                  child: Container(
                      width: 50.0,
                      child: Center(
                          child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )))),
            ],
          ),
        ),
      ),
    );
  }
}
