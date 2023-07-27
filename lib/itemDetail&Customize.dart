import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    final CategoriesProviderObj = Provider.of<CategoriesProvider>(context);
    final openedCategoryName =
        CategoriesProviderObj.activeCategoryName.toString();
    final imgPathMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, top: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      iconSize: 25),
                  Text(
                    "Details",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 5,
              fit: FlexFit.loose,
              child: Container(
                  width: double.infinity,
                  child: Hero(
                    tag: imgPathMap['imgPath'].toString(),
                    child: CachedNetworkImage(
                      imageUrl: imgPathMap['imgPath'].toString(),
                      fit: BoxFit.fill,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SpinKitPulse(
                        color: Colors.red,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
            ),
            Flexible(
              flex: 3,
              fit: (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                      openedCategoryName.toUpperCase() == "CAKES")
                  ? FlexFit.tight
                  : FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  imgPathMap['itemName'].toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Flexible(
              flex: 1,
              fit: (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                      openedCategoryName.toUpperCase() == "CAKES")
                  ? FlexFit.tight
                  : FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Price : " + imgPathMap['price'].toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              fit: (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                      openedCategoryName.toUpperCase() == "CAKES")
                  ? FlexFit.tight
                  : FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "MRP : " + imgPathMap['MRP'].toString().toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
            (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                    openedCategoryName.toUpperCase() == "CAKES")
                ? Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Flavour : " +
                            imgPathMap['cakeFlavour'].toString().toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                : SizedBox(height: 1),
            (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                    openedCategoryName.toUpperCase() == "CAKES")
                ? Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "DesignCategory : " +
                            imgPathMap['designCategory']
                                .toString()
                                .toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                : SizedBox(height: 1),
            (openedCategoryName.toUpperCase() == "CAKES & PASTRIES" ||
                    openedCategoryName.toUpperCase() == "CAKES")
                ? Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Minimum wt. (pounds): " +
                            imgPathMap['minPounds'].toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  )
                : SizedBox(height: 1),
            // Flexible(
            //     flex: 3,
            //     fit: FlexFit.tight,
            //     child: Center(
            //         child: RaisedButton(
            //             onPressed: () {},
            //             child: Text("Add To Cart",
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 20,
            //                     fontWeight: FontWeight.bold)),
            //             color: Colors.red)))
          ],
        ),
      ),
    );
  }
}
