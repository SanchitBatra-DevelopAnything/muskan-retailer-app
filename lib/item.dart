// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item(
      {Key? key,
      required this.imgPath,
      required this.price,
      required this.itemName})
      : super(key: key);

  final String imgPath;
  final String price;
  final String itemName;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 15, left: 5, bottom: 5, right: 5),
        child: GestureDetector(
            onTap: () {},
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3.0,
                      blurRadius: 5.0,
                    )
                  ],
                  color: Color.fromRGBO(51, 51, 51, 0.8),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 5,
                      fit: FlexFit.tight,
                      child: Image.network(
                        imgPath,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                  color: Colors.red, strokeWidth: 5),
                            );
                          }
                        },
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        price,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          itemName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Flexible(child: Divider(), flex: 1),
                    Flexible(
                      child: Center(
                        child: RaisedButton(
                          child: Text("Add to cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )),
                          color: Colors.red,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ))));
  }
}
