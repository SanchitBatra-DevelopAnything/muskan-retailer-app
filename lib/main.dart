import 'dart:io';

import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:muskan_shop/subcategories.dart';
import 'package:provider/provider.dart';
import './home.dart';

import './providers/auth.dart';
import 'categories.dart';
import 'items.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
          '/items': (context) => Items(),
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
