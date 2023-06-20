import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';

class SignUp extends StatefulWidget {
  final VoidCallback? onFormChange;
  const SignUp({Key? key, @required this.onFormChange}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var retailerNameController = TextEditingController();
  var contactNumberController = TextEditingController();
  String? selectedShop;
  bool isSigningUp = false;
  bool _isFirstTime = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context).fetchShopsFromDB();
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void signup() {
    if (selectedShop == null ||
        retailerNameController.text == null ||
        retailerNameController.text == "" ||
        contactNumberController.text == "" ||
        contactNumberController.text == null) {
      return;
    }

    setState(() {
      isSigningUp = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .retailerSignUp(retailerNameController.text, selectedShop!,
            contactNumberController.text)
        .then((_) => {
              setState(() => {isSigningUp = false}),
              showAlertBox()
            });
  }

  showAlertBox() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Signed Up!',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "You will be able to login once admin approves your request",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text(
              'Okay',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              retailerNameController.text = '';
              contactNumberController.text = '';
              selectedShop = null;
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    ).then((_) {
      setState(() {
        isSigningUp = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthProviderObject = Provider.of<AuthProvider>(context);
    final shops = AuthProviderObject.shopNames;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Sign Up",
          style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        Container(
          width: 350,
          child: TextField(
            controller: retailerNameController,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: "Retailer Name",
              labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: 350,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: contactNumberController,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: "Contact Number",
              labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Select the shop from the dropdown below",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        Container(
          width: 300,
          child: DropdownButton<String>(
              items: shops.map(buildMenuItem).toList(),
              isExpanded: true,
              dropdownColor: Colors.black,
              iconSize: 36,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              value: selectedShop,
              style: TextStyle(color: Colors.white),
              onChanged: (value) => {
                    setState(() => {
                          this.selectedShop = value,
                        })
                  }),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isSigningUp
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signup,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
            ElevatedButton(
              onPressed: widget.onFormChange,
              child: Text(
                "Move to Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        )
      ],
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(item,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        )));
