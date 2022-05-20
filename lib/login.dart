import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:provider/provider.dart';

import 'models/retailer.dart';

class Login extends StatefulWidget {
  final VoidCallback? onFormChange;
  const Login({Key? key, @required this.onFormChange}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var retailerNameController = TextEditingController();
  String? selectedShop;
  var isLoading = true;
  bool _isFirstTime = true;
  bool _invalidLogin = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!mounted) {
      return;
    }
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context, listen: false).fetchShopsFromDB();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Provider.of<AuthProvider>(context, listen: false).fetchRetailersFromDB();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void login(List<Retailer> retailers) {
    var isPresent = false;
    retailers.forEach((retailer) {
      // print("RETAILER INFORMATION");
      // print(retailer.retailerName + "--" + retailer.shopAddress);
      if (retailerNameController.text.trim().toLowerCase() ==
              retailer.retailerName.toLowerCase() &&
          selectedShop == retailer.shopAddress) {
        // print("Compared " +
        //     retailerNameController.text.toLowerCase() +
        //     " to " +
        //     retailer.retailerName +
        //     " & " +
        //     selectedShop! +
        //     " to " +
        //     retailer.shopAddress);
        isPresent = true;
      }
      if (isPresent) {
        if (mounted) {
          setState(() {
            _invalidLogin = false;
          });
        }
        Navigator.of(context).pushReplacementNamed("/categories");
      } else {
        if (mounted) {
          setState(() {
            _invalidLogin = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthProviderObject = Provider.of<AuthProvider>(context);
    final shops = AuthProviderObject.shopNames;
    final retailers = AuthProviderObject.retailers;
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
                    onPressed: () {
                      login(retailers);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.red,
                  ),
            RaisedButton(
              onPressed: widget.onFormChange,
              child: Text(
                "Move to SignUp",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              color: Colors.red,
            ),
          ],
        ),
        _invalidLogin
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Invalid Login :(",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Container()
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
