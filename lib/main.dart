import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:muskan_shop/cart_screen.dart';
import 'package:muskan_shop/customOrderStatusView.dart';
import 'package:muskan_shop/distributors/distHome.dart';
import 'package:muskan_shop/itemDetail&Customize.dart';
import 'package:muskan_shop/orderDone.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:muskan_shop/providers/notificationManager.dart';
import 'package:muskan_shop/providers/order.dart';
import 'package:muskan_shop/regularOrderStatusView.dart';
import 'package:muskan_shop/storeClosed.dart';
import 'package:muskan_shop/subcategories.dart';
import 'package:muskan_shop/whoUser.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './home.dart';

import './providers/auth.dart';
import 'OrdersStatus.dart';
import 'categories.dart';
import 'customOrders/customCakeForm.dart';
import 'customOrders/customOptions.dart';
import 'items.dart';
import 'notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("items");
  LocalNotificationService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => AuthProvider()),
      ChangeNotifierProvider(
        create: (context) => CategoriesProvider(),
      ),
      ChangeNotifierProvider(create: (context) => CartProvider()),
      ChangeNotifierProvider(create: (context) => OrderProvider()),
      ChangeNotifierProvider(create: (context) => NotificationProvider())
    ], child: MaterialAppWithInitialRoute());
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

class MaterialAppWithInitialRoute extends StatelessWidget {
  Future<String> getInitialRoute() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    print("keyd");
    print(sp.getKeys());
    if (sp.containsKey('loggedInRetailer') ||
        sp.containsKey("loggedInDistributor")) {
      return '/categories';
    }
    return '/';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInitialRoute(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Muskan Shop',
              theme: ThemeData(primarySwatch: Colors.red),
              initialRoute: snapshot.data.toString(),
              routes: {
                '/': (context) => WhoIsUser(),
                '/categories': (context) => Categories(),
                '/subcategories': (context) => Subcategories(),
                '/items': (context) => Items(),
                '/item-detail': (context) => ItemDetail(),
                '/cart': (context) => CartScreen(),
                '/orderPlaced': (context) => OrderPlaced(),
                '/storeClosed': (context) => BakeryClosed(),
                '/customOrderOptions': (context) => CustomOrderOptions(),
                '/customCakeForm': (context) => CustomCakeForm(),
                '/myOrders': (context) => OrdersStatus(),
                '/regularOrderStatus': (context) => RegularOrderStatusView(),
                '/customOrderStatus': (context) => CustomOrderStatusView(),
                '/retailerHome': (context) => HomePage(),
                '/distributorHome': (context) => DistributorHome(),
              },
            );
          } else {
            print("idhar aaya");
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Muskan Shop',
              theme: ThemeData(primarySwatch: Colors.red),
              initialRoute: '/',
              routes: {
                '/': (context) => WhoIsUser(),
                '/categories': (context) => Categories(),
                '/subcategories': (context) => Subcategories(),
                '/items': (context) => Items(),
                '/item-detail': (context) => ItemDetail(),
                '/cart': (context) => CartScreen(),
                '/orderPlaced': (context) => OrderPlaced(),
                '/storeClosed': (context) => BakeryClosed(),
                '/customOrderOptions': (context) => CustomOrderOptions(),
                '/customCakeForm': (context) => CustomCakeForm(),
                '/myOrders': (context) => OrdersStatus(),
                '/regularOrderStatus': (context) => RegularOrderStatusView(),
                '/customOrderStatus': (context) => CustomOrderStatusView(),
                '/retailerHome': (context) => HomePage(),
                '/distributorHome': (context) => DistributorHome(),
              },
            );
          }
        } else {
          return CircularProgressIndicator();
        }
      }),
    );
  }
}
