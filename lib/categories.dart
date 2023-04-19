import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muskan_shop/badge.dart';
import 'package:muskan_shop/models/category.dart';
import 'package:muskan_shop/notificationBanner.dart';
import 'package:muskan_shop/providers/auth.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:muskan_shop/providers/notificationManager.dart';
import 'package:muskan_shop/shimmerBody.dart';
import 'package:new_version_plus/new_version_plus.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_redirect/store_redirect.dart';

import 'bottomNavigation.dart';
import 'package:flutter/widgets.dart';

import 'notificationservice/local_notification_service.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var isLoading = false;
  var _isFirstTime = true;
  var appType = "retailer";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //NOTIFICATION WORK
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      // var retailer = "";

      // var shop = "";

      // var distributor = "";
      // var distributorship = "";

      doAuthStuff().then((_) => {
            Provider.of<CategoriesProvider>(context, listen: false)
                .fetchCategoriesFromDB(
                    Provider.of<AuthProvider>(context, listen: false).appType)
                .then((_) => {
                      if (mounted)
                        {
                          fetchCartBasedOnAppType(
                                  Provider.of<AuthProvider>(context,
                                      listen: false),
                                  Provider.of<CartProvider>(context,
                                      listen: false))
                              .then(
                            (value) async => {
                              setState(() {
                                isLoading = false;
                              }),
                              _checkVersion(),
                              await Provider.of<NotificationProvider>(context,
                                      listen: false)
                                  .checkNotificationSetupOnInitialLoad(),
                            },
                          )
                        }
                    })
          });

      // Future.wait([
      //   fetchCategoriesFromDB(appType),
      //   Future.delayed(Duration(microseconds: 1)),
      //   fetchCartBasedOnAppType(
      //       Provider.of<AuthProvider>(context, listen: false),
      //       Provider.of<CartProvider>(context, listen: false))
      // ]);

      // _checkVersion();

      bool shopOpened = Provider.of<AuthProvider>(context, listen: false)
          .checkShopStatus("09:00PM", "06:00AM");
      if (shopOpened) {
        Future.delayed(
            const Duration(seconds: 2), () => {showAlertBox(context)});
      }
    }
    // _checkVersion();
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  // Future<void> fetchCategoriesFromDB(String appType) {
  //   return Provider.of<CategoriesProvider>(context, listen: false)
  //       .fetchCategoriesFromDB(appType);
  // }

  Future<void> doAuthStuff() async {
    var authObject = Provider.of<AuthProvider>(context, listen: false);
    await authObject.setAppTypeOnInitialLoad();
    print(authObject.appType + " is been set as apptype");
    if (authObject.appType == "retailer") {
      await authObject.loadLoggedInRetailerAndShop();
      print(authObject.loggedInRetailer + " & " + authObject.loggedInShop);
    } else if (authObject.appType == "distributor") {
      await authObject.loadLoggedInDistributorData();
      print(authObject.loggedInDistributor +
          " &&& " +
          authObject.loggedInDistributorship);
    }
  }

  Future<void> fetchCartBasedOnAppType(
      AuthProvider authProviderObject, CartProvider cartProviderObject) {
    if (authProviderObject.appType != "distributor") {
      return cartProviderObject.fetchCartFromDB(
          authProviderObject.loggedInRetailer, authProviderObject.loggedInShop);
    } else {
      return cartProviderObject.fetchCartFromDB(
          authProviderObject.loggedInDistributor,
          authProviderObject.loggedInDistributorship);
    }
  }

  void _checkVersion() async {
    final newVersion = NewVersionPlus(
      androidId: "com.muskan.shop",
    );
    final status = await newVersion.getVersionStatus();
    if (status!.localVersion != status.storeVersion) {
      //   newVersion.showUpdateDialog(
      //       context: context,
      //       versionStatus: status,
      //       dialogText:
      //           "Please update your app from ${status.localVersion} to ${status.storeVersion}");
      showUpdateBox(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  showAlertBox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'CLOSED AFTER 10:30pm',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "You can still place your order. Your order will be accepted after 6:00am.",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'OK',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  Future<bool> logout() async {
    return Provider.of<AuthProvider>(context, listen: false).logout();
  }

  showLogoutBox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Logout?',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'YES',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () async {
              bool cleared = await logout();
              if (cleared) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
          ),
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'NO',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  showUpdateBox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'App needs an update',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Please update to avoid issues",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          RaisedButton(
            color: Colors.green,
            child: const Text(
              'UPDATE',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              StoreRedirect.redirect(androidAppId: 'com.muskan.shop');
            },
          )
        ],
      ),
    );
  }

  void moveToSubcategories(BuildContext context, Category selectedCategory) {
    Provider.of<CategoriesProvider>(context, listen: false)
        .setactiveCategoryKey = selectedCategory.id;
    Provider.of<CategoriesProvider>(context, listen: false)
        .setactiveCategoryName = selectedCategory.categoryName;
    Navigator.of(context).pushNamed('/subcategories');
  }

  void moveToCart(BuildContext context) {
    Navigator.of(context).pushNamed('/cart');
  }

  @override
  Widget build(BuildContext context) {
    final categoryProviderObject =
        Provider.of<CategoriesProvider>(context, listen: false);
    final categories = categoryProviderObject.categories;

    final appType = Provider.of<AuthProvider>(context, listen: false).appType;
    final alreadyNotificationSetup =
        Provider.of<NotificationProvider>(context).notificationAlreadySetup;
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
                          SystemNavigator
                              .pop(); //yahan app band ho jaani chahiye! , autoLogin ke baad autoLoad se jab back jaara hu to whoUser() dikhra h dont know y! , isliye yhan forcefully quit kro.
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
        backgroundColor: Color.fromARGB(137, 43, 40, 40),
        bottomNavigationBar: appType != "distributor"
            ? BottomNavigator(
                index: 0,
              )
            : null,
        body: isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 23, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ShimmerBody(
                          height: 45,
                          width: 160,
                        ),
                        ShimmerBody(
                          height: 20,
                          width: 50,
                        ),
                        ShimmerBody(
                          height: 20,
                          width: 50,
                        ),
                        ShimmerBody(
                          height: 20,
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Flexible(
                    child: GridView.builder(
                      itemBuilder: (ctx, i) =>
                          ShimmerBody(height: 300, width: 300),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                      itemCount: 8,
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsets.only(left: 23, top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Categories".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                        ),
                        Tooltip(
                          message: "My Orders",
                          verticalOffset: 24,
                          height: 30,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/myOrders');
                            },
                            icon: Icon(
                              Icons.shopping_bag,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                          ),
                        ),
                        Consumer<CartProvider>(
                          builder: (_, cart, ch) => Badge(
                            child: ch,
                            value: cart.itemCount.toString(),
                            color: Colors.red,
                          ),
                          child: IconButton(
                            onPressed: () {
                              moveToCart(context);
                            },
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                          ),
                        ),
                        Tooltip(
                          message: "Logout",
                          verticalOffset: 24,
                          height: 30,
                          child: IconButton(
                            onPressed: () {
                              showLogoutBox(context);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            iconSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  !alreadyNotificationSetup
                      ? notificationBanner()
                      : Container(),
                  Flexible(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: categories.length,
                      itemBuilder: (ctx, i) => Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          GestureDetector(
                            onTap: () {
                              moveToSubcategories(context, categories[i]);
                            },
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: Card(
                                semanticContainer: true,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  categories[i].imageUrl,
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null
                                        ? child
                                        : LinearProgressIndicator(
                                            backgroundColor: Colors.black12,
                                          );
                                  },
                                  fit: BoxFit.fill,
                                  semanticLabel: categories[i].categoryName,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 15,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0, bottom: 5.0),
                            child: GestureDetector(
                              child: Text(
                                categories[i].categoryName.toUpperCase() ==
                                        "CAKES & PASTRIES"
                                    ? "CAKES"
                                    : categories[i].categoryName,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    backgroundColor: Colors.black54),
                              ),
                              onTap: () {
                                moveToSubcategories(context, categories[i]);
                              },
                            ),
                          )
                        ],
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
