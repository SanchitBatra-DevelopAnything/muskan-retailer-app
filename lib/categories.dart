import 'package:flutter/material.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    final categoryProviderObject =
        Provider.of<CategoriesProvider>(context, listen: false);
    final categories = categoryProviderObject.categories;
    return Scaffold(
      backgroundColor: Colors.yellow[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 35),
          Text(
            "Categories",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.all(5.0),
              itemCount: categories.length,
              itemBuilder: (ctx, i) => GridTile(
                child: Container(
                  color: Color.fromRGBO(128, 0, 0, 1),
                  child: Center(
                    child: Text(
                      categories[i].categoryName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5),
            ),
          )
        ],
      ),
    );
  }
}
