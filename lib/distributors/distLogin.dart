import 'package:flutter/material.dart';
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
      //   Provider.of<AuthProvider>(context, listen: false)
      //       .fetchDistributorAreasFromDB();
      //   if (mounted) {
      //     setState(() {
      //       isLoading = true;
      //     });
      //   }
      //   Provider.of<AuthProvider>(context, listen: false)
      //       .fetchDistributorsFromDB();
      //   if (mounted) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //   }
    }
    _isFirstTime = false; //never run the above if again.
    isLoading = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
              labelText: "Distributor Id",
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
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              labelText: "password",
              labelStyle: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
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
                    onPressed: () {},
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
