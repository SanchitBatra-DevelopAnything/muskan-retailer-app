import 'package:flutter/material.dart';
import 'package:muskan_shop/models/customOrder.dart';

class CustomOrderStatusView extends StatelessWidget {
  const CustomOrderStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)!.settings.arguments as customOrder;
    final status = order.status;
    final cakePhoto = order.imgUrl;
    var photo = order.photoOnCakeUrl;
    if (photo.toLowerCase() == "not-uploaded") {
      photo = "";
    }
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
                        "DETAILS",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        status!,
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
          SizedBox(
            height: 15,
          ),
          Center(
            child: Container(
              height: 300,
              width: 310,
              child: Image.network(
                order.imgUrl,
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
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Flavour : " + order.flavour,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Pound : " + order.pounds.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Description : " + order.cakeDescription,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
