import 'package:flutter/material.dart';
import 'package:muskan_shop/models/category.dart';
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

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isFirstTime) {
      setState(() {
        isLoading = true;
      });
      Provider.of<CategoriesProvider>(context)
          .fetchCategoriesFromDB()
          .then((_) => {
                setState(() {
                  isLoading = false;
                })
              });
    }
    _isFirstTime = false; //never run the above if again.
    super.didChangeDependencies();
  }

  void moveToSubcategories(BuildContext context, Category selectedCategory) {
    Provider.of<CategoriesProvider>(context, listen: false)
        .setactiveCategoryKey = selectedCategory.id;
    Provider.of<CategoriesProvider>(context, listen: false)
        .setactiveCategoryName = selectedCategory.categoryName;
    Navigator.of(context).pushNamed('/subcategories');
  }

  @override
  Widget build(BuildContext context) {
    final categoryProviderObject =
        Provider.of<CategoriesProvider>(context, listen: false);
    final categories = categoryProviderObject.categories;
    return Scaffold(
      backgroundColor: Color.fromARGB(137, 43, 40, 40),
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
                  child: Text(
                    "Categories".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal),
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
