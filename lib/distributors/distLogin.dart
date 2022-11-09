import 'package:flutter/material.dart';
import 'package:muskan_shop/distributors/models/Distributor.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DistributorLogin extends StatefulWidget {
  final VoidCallback? onFormChange;
  const DistributorLogin({Key? key, @required this.onFormChange})
      : super(key: key);

  @override
  _DistributorLoginState createState() => _DistributorLoginState();
}

class _DistributorLoginState extends State<DistributorLogin> {
  var distributorIdController = new TextEditingController();
  var passwordController = new TextEditingController();
  String? selectedDistributorship;

  bool _isFirstTime = true;
  bool _invalidLogin = false;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!mounted) {
      return;
    }
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context, listen: false)
          .fetchDistributorshipsFromDB();
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      Provider.of<AuthProvider>(context, listen: false)
          .fetchDistributorsFromDB();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void login(List<Distributor> distributors) {
    var isPresent = false;
    distributors.forEach((distributor) {
      // print("RETAILER INFORMATION");
      // print(retailer.retailerName + "--" + retailer.shopAddress);
      if (distributorIdController.text.trim().toLowerCase() ==
              distributor.distributorId.toLowerCase() &&
          selectedDistributorship == distributor.distributorship) {
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
        // set the loggedIn shopkeeper and the shop.
        Provider.of<AuthProvider>(context, listen: false)
            .setLoggedInDistributor(distributorIdController.text.toUpperCase(),
                selectedDistributorship!);
        Navigator.of(context).pushReplacementNamed('/categories');
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
    final distributorships = AuthProviderObject.distributorships;
    final distributors = AuthProviderObject.distributors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Login",
          style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        Container(
          width: 350,
          child: TextField(
            controller: distributorIdController,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: "Distributor ID",
              labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Select your area from the dropdown below",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        Container(
          width: 300,
          child: DropdownButton<String>(
              items: distributorships.map(buildMenuItem).toList(),
              isExpanded: true,
              iconSize: 36,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              value: selectedDistributorship,
              onChanged: (value) => {
                    setState(() => {
                          this.selectedDistributorship = value,
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
                      login(distributors);
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
