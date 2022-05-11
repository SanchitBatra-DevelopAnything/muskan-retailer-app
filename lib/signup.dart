import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var retailerNameController = TextEditingController();
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
        retailerNameController.text == "") {
      return;
    }

    setState(() {
      isSigningUp = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .retailerSignUp(retailerNameController.text, selectedShop!)
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
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'Okay',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              retailerNameController.text = '';
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
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        Container(
          width: 350,
          child: TextField(
            controller: retailerNameController,
            style: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: "Retailer Name",
              labelStyle: const TextStyle(fontSize: 25),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Select the shop from the dropdown below",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Container(
          width: 300,
          child: DropdownButton<String>(
              items: shops.map(buildMenuItem).toList(),
              isExpanded: true,
              iconSize: 36,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              value: selectedShop,
              onChanged: (value) => {
                    setState(() => {
                          this.selectedShop = value,
                        })
                  }),
        ),
        SizedBox(
          height: 10,
        ),
        // RaisedButton(
        //     onPressed: () {},
        //     child: Text(
        //       "Sign Up",
        //       style: TextStyle(fontSize: 20, color: Colors.white),
        //     ),
        //     color: Colors.red),
        // SizedBox(height: 5),
        // RaisedButton(
        //     onPressed: () {},
        //     child: Text(
        //       "Move to Login",
        //       style: TextStyle(fontSize: 20, color: Colors.white),
        //     ),
        //     color: Colors.red),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isSigningUp
                ? CircularProgressIndicator()
                : RaisedButton(
                    onPressed: signup,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.red,
                  ),
            RaisedButton(
              onPressed: () {},
              child: Text(
                "Move to Login",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.red,
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
