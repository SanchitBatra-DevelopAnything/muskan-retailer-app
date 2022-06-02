import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:muskan_shop/badge.dart';
import 'package:muskan_shop/models/category.dart';
import 'package:muskan_shop/providers/cart.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  var isLoading = false;
  var _isFirstTime = true;
  var _currentIndex = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      Provider.of<CategoriesProvider>(context, listen: false)
          .fetchCategoriesFromDB()
          .then((_) => {
                if (mounted)
                  {
                    setState(() {
                      isLoading = false;
                    })
                  }
              });
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
    return Scaffold(
      backgroundColor: Color.fromARGB(137, 43, 40, 40),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        unselectedItemColor: Colors.white,
        unselectedFontSize: 14,
        backgroundColor: Colors.black54,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bakery_dining,
                color: Colors.white,
              ),
              label: "Regular Orders"),
          BottomNavigationBarItem(
              backgroundColor: Colors.black54,
              icon: Icon(Icons.cake_outlined, color: Colors.white),
              label: "Custom Orders")
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              strokeWidth: 5,
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                Padding(
                  padding: EdgeInsets.only(left: 23, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
                  ),
                ),
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
                          child: Text(
                            categories[i].categoryName,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                backgroundColor: Colors.black54),
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
    );
  }
}
