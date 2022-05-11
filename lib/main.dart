import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './home.dart';

import './providers/auth.dart';
import 'categories.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muskan Shop',
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/categories': (context) => Categories(),
        },
      ),
    );
  }
}
