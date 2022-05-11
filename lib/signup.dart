import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var retailerNameController = TextEditingController();

  var shops = ["RAJ NAGAR", "SHASHTRI NAGAR", "KAVI NAGAR", "QUIRKY PERKY"];
  String? selectedShop;

  @override
  Widget build(BuildContext context) {
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
        RaisedButton(
            onPressed: () {},
            child: Text(
              "Sign Up",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            color: Colors.red),
        SizedBox(height: 5),
        RaisedButton(
            onPressed: () {},
            child: Text(
              "Move to Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            color: Colors.red),
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
