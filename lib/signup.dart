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

  @override
  Widget build(BuildContext context) {
    final AuthProviderObject = Provider.of<AuthProvider>(context);
    final shops = AuthProviderObject.shopNames;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          child: TextField(
            controller: retailerNameController,
            decoration: InputDecoration(
              labelText: "Retailer Name",
              filled: false,
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
            RaisedButton(
              onPressed: () {},
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
          fontSize: 20,
        )));
