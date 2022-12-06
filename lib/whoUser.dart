import 'package:flutter/material.dart';

class WhoIsUser extends StatefulWidget {
  const WhoIsUser({Key? key}) : super(key: key);

  @override
  _WhoIsUserState createState() => _WhoIsUserState();
}

class _WhoIsUserState extends State<WhoIsUser> {
  String userType = "Retailer";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        // show the confirm dialog
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Are you sure want to exit the app?'),
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
        backgroundColor: Colors.black12,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              "assets/logo.jpg",
              height: 100,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Use app as : ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 15),
            Container(
              child: RadioListTile(
                value: "Retailer",
                groupValue: userType,
                onChanged: (value) {
                  setState(() {
                    userType = value.toString();
                  });
                },
                activeColor: Colors.red,
                title: Text(
                  "Retailer",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Select this if you are a retailer",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: RadioListTile(
                value: "Distributor",
                groupValue: userType,
                onChanged: null,
                // onChanged: (value) {
                //   setState(() {
                //     userType = value.toString();
                //   });
                // },
                title: Text(
                  "Distributor (Launching Soon)",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                activeColor: Colors.red,
                subtitle: Text(
                  "Select this if you are a distributor",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: () {
                userType.toLowerCase() == "retailer"
                    ? Navigator.of(context)
                        .pushReplacementNamed("/retailerHome")
                    : Navigator.of(context)
                        .pushReplacementNamed("/distributorHome");
              },
              color: Colors.red,
              child: Text(
                "PROCEED",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
