import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

import 'providers/categories_provider.dart';

class Items extends StatefulWidget {
  const Items({Key? key}) : super(key: key);

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  @override
  Widget build(BuildContext context) {
    final CategoriesProviderObject = Provider.of<CategoriesProvider>(context);
    final sub = CategoriesProviderObject.activeSubcategoryName;
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(title: Text(sub!)),
      body: Column(children: [
        Container(
          color: Colors.red,
          child: Center(
              child: Card(
            color: Colors.grey,
            child:
                TextField(decoration: InputDecoration(label: Text("Search"))),
          )),
        )
      ]),
    );
  }
}
