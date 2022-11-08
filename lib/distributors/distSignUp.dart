import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class DistributorSignup extends StatefulWidget {
  final VoidCallback? onFormChange;
  const DistributorSignup({Key? key, @required this.onFormChange})
      : super(key: key);

  @override
  _DistributorSignupState createState() => _DistributorSignupState();
}

class _DistributorSignupState extends State<DistributorSignup> {
  var distributorIdController = TextEditingController();
  var contactNumberController = TextEditingController();
  String? selectedDistributorship;
  bool _isSigningUp = false;
  bool _isFirstTime = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      Provider.of<AuthProvider>(context).fetchDistributorshipsFromDB();
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void signup() {
    if (selectedDistributorship == null ||
        distributorIdController.text == null ||
        distributorIdController.text == "" ||
        contactNumberController.text == "" ||
        contactNumberController.text == null) {
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    Provider.of<AuthProvider>(context, listen: false)
        .DistributorSignUp(distributorIdController.text,
            selectedDistributorship!, contactNumberController.text)
        .then((_) => {
              setState(() => {_isSigningUp = false}),
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
              distributorIdController.text = '';
              contactNumberController.text = '';
              selectedDistributorship = null;
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    ).then((_) {
      setState(() {
        _isSigningUp = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthProviderObject = Provider.of<AuthProvider>(context);
    final distributorships = AuthProviderObject.distributorships;
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
          "Select your area from the dropdown below",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
        ),
        Container(
          width: 300,
          child: DropdownButton<String>(
              items: distributorships.map(buildMenuItem).toList(),
              isExpanded: true,
              dropdownColor: Colors.black,
              iconSize: 36,
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
              value: selectedDistributorship,
              style: TextStyle(color: Colors.white),
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
            _isSigningUp
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
              onPressed: widget.onFormChange,
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
