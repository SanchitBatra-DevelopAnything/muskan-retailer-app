import 'package:flutter/material.dart';
import 'package:muskan_shop/models/regularOrder.dart';
import 'package:muskan_shop/models/regularShopOrderItem.dart';

class RegularOrderStatusView extends StatelessWidget {
  const RegularOrderStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as regularOrder;
    List<RegularShopOrderItem> items = routeArgs.items;
    String status = routeArgs.status!;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
          ),
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
                        "ITEMS",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        status,
                        style: TextStyle(
                            color: status == "ACCEPTED"
                                ? Colors.green
                                : Colors.orangeAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      flex: 3,
                    )
                  ],
                ),
              )),
          Divider(
            thickness: 3,
            color: Colors.white,
          ),
          Flexible(
            flex: 10,
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: ((context, index) => ListTile(
                      title: Text(
                        items[index].item,
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(items[index].quantity.toString(),
                          style: TextStyle(color: Colors.white)),
                    ))),
          )
        ],
      ),
    );
  }
}
