import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var retailerNameController = TextEditingController();
  String? selectedShop;
  var isLoading = false;

  void login() {
    Navigator.of(context).pushReplacementNamed("/categories");
  }

  @override
  Widget build(BuildContext context) {
    final AuthProviderObject = Provider.of<AuthProvider>(context);
    final shops = AuthProviderObject.shopNames;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isLoading
                ? CircularProgressIndicator()
                : RaisedButton(
                    onPressed: login,
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.red,
                  ),
            RaisedButton(
              onPressed: () {},
              child: Text(
                "Move to SignUp",
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
