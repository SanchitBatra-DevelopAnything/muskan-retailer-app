import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:provider/provider.dart';

class CustomCakeForm extends StatefulWidget {
  const CustomCakeForm({Key? key}) : super(key: key);

  @override
  _CustomCakeFormState createState() => _CustomCakeFormState();
}

class _CustomCakeFormState extends State<CustomCakeForm> {
  File? _pickedImage;

  File? _photoOnCake;
  num? pounds = 1;
  String? flavour;

  bool _isUploading = false;
  bool _isFetchingUrl = false;
  bool _isPlacingOrder = false;

  var cakeDescriptionController = TextEditingController();

  void _pickImage(String sourceOfImage) async {
    if (sourceOfImage == 'Camera') {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _pickedImage = pickedImage;
      });
    } else {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  void _pickPhotoOnCake(String sourceOfImage) async {
    if (sourceOfImage == 'Camera') {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _photoOnCake = pickedImage;
      });
    } else {
      final pickedImage =
          await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _photoOnCake = pickedImage;
      });
    }
  }

  void placeCustomOrder(BuildContext context, String orderType) async {
    if (_pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(
            milliseconds: 700,
          ),
          content: Text("Please Upload cake image")));
      return;
    }

    if (orderType.toLowerCase() == "photo cakes") {
      if (_photoOnCake == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(
              milliseconds: 700,
            ),
            content: Text("Please Upload photo image")));
        return;
      }
    }

    if (cakeDescriptionController.text.trim() == '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(
            milliseconds: 700,
          ),
          content: Text("Please provide cake description")));
      return;
    }

    final shopKeeper =
        Provider.of<AuthProvider>(context, listen: false).loggedInRetailer;
    final shop = Provider.of<AuthProvider>(context, listen: false).loggedInShop;

    final date = DateTime.now().toString();

    final timeArrayComponent =
        DateFormat.yMEd().add_jms().format(DateTime.now()).split(" ");
    final time = timeArrayComponent[timeArrayComponent.length - 2] +
        " " +
        timeArrayComponent[timeArrayComponent.length - 1];

    setState(() {
      _isUploading = true;
      _isFetchingUrl = false;
      _isPlacingOrder = false;
    });

    final ref = FirebaseStorage.instance
        .ref()
        .child('custom_orders')
        .child(shopKeeper + "--" + shop + "--" + date + ".jpg");

    await ref.putFile(_pickedImage!).onComplete;

    setState(() {
      _isFetchingUrl = true;
      _isPlacingOrder = false;
      _isUploading = false;
    });

    final imgUrl = await ref.getDownloadURL();

    var photoOnCakeUrl = "not-uploaded";

    if (_photoOnCake != null) {
      await ref.putFile(_photoOnCake!).onComplete;
      photoOnCakeUrl = await ref.getDownloadURL();
    }

    setState(() {
      _isPlacingOrder = true;
      _isUploading = false;
      _isFetchingUrl = false;
    });

    Provider.of<CartProvider>(context, listen: false)
        .PlaceCustomOrder(
            cakeDescription: cakeDescriptionController.text.trim(),
            cakeUrl: imgUrl,
            pounds: pounds,
            photoOnCakeUrl: photoOnCakeUrl,
            loggedInRetailer: shopKeeper.toUpperCase(),
            orderType: orderType,
            shopAddress: shop.toUpperCase(),
            time: time)
        .then((_) => {
              if (mounted)
                {
                  setState(() => {
                        _isPlacingOrder = false,
                        _isFetchingUrl = false,
                        _isUploading = false
                      }),
                },
              Navigator.pushNamedAndRemoveUntil(
                  context, "/orderPlaced", (r) => false)
            });

    print("ORDER PLACED");
  }

  @override
  Widget build(BuildContext context) {
    final orderTypeMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final orderType = orderTypeMap['orderType'];
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Are you sure want to leave?'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          willLeave = true;
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('No'))
                  ],
                ));
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(orderType!,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      "Cake Image",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: Container(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CircleAvatar(
                              backgroundColor: Color.fromRGBO(51, 51, 51, 1),
                              backgroundImage: _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : Image.asset("assets/default.png").image),
                        ),
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            _pickImage('Gallery');
                          },
                          child: Text(
                            "Gallery Image",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            _pickImage('Camera');
                          },
                          child: Text(
                            "Camera Image",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  orderType.toLowerCase() == "photo cakes"
                      ? Flexible(
                          child: Text(
                            "Photo Image",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container(height: 0),
                  orderType.toLowerCase() == "photo cakes"
                      ? Flexible(
                          flex: 2,
                          child: Container(
                            height: 200,
                            width: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromRGBO(51, 51, 51, 1),
                                  backgroundImage: _photoOnCake != null
                                      ? FileImage(_photoOnCake!)
                                      : Image.asset("assets/default.png")
                                          .image),
                            ),
                          ))
                      : Container(height: 0),
                  orderType.toLowerCase() == "photo cakes"
                      ? SizedBox(
                          height: 15,
                        )
                      : Container(
                          height: 0,
                        ),
                  orderType.toLowerCase() == "photo cakes"
                      ? Flexible(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                color: Colors.red,
                                onPressed: () {
                                  _pickPhotoOnCake('Gallery');
                                },
                                child: Text(
                                  "Gallery Image",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                              RaisedButton(
                                color: Colors.red,
                                onPressed: () {
                                  _pickPhotoOnCake('Camera');
                                },
                                child: Text(
                                  "Camera Image",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(height: 0),
                  orderType.toLowerCase() == "photo cakes"
                      ? SizedBox(
                          height: 15,
                        )
                      : Container(height: 0),
                  Flexible(
                    flex: 3,
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        style: TextStyle(fontSize: 18),
                        minLines: 1,
                        maxLines: null,
                        controller: cakeDescriptionController,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            hintText: "Enter cake description here",
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 18),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: Text("POUNDS : "),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      height: 50,
                      child: NumberInputWithIncrementDecrement(
                        controller: TextEditingController(),
                        min: 1,
                        max: 10,
                        initialValue: 1,
                        onIncrement: (value) {
                          pounds = value;
                        },
                        onDecrement: (value) {
                          pounds = value;
                        },
                        scaleHeight: 1,
                        scaleWidth: 1,
                        incIconSize: 15,
                        decIconSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Flexible(
                    child: RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "Place Order",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        placeCustomOrder(context, orderType);
                      },
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: _isUploading
                          ? Text(
                              "Uploading Image.. Large images might take some time.",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          : _isFetchingUrl
                              ? Text(
                                  "Fetching the url..",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )
                              : _isPlacingOrder
                                  ? Text(
                                      "Placing your order....",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(
                                      height: 1,
                                    ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
