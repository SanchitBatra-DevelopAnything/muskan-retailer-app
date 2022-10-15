import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class DistributorLogin extends StatefulWidget {
  const DistributorLogin({Key? key}) : super(key: key);

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
      Provider.of<AuthProvider>(context, listen: false)
          .fetchDistributorAreasFromDB();
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
