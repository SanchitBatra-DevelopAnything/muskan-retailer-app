import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:muskan_shop/subcategories.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthProvider()),
        ChangeNotifierProvider.value(
          value: CategoriesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muskan Shop',
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/categories': (context) => Categories(),
          '/subcategories': (context) => Subcategories(),
        },
      ),
    );
  }
}
