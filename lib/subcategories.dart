import 'package:flutter/material.dart';
import 'package:muskan_shop/models/subcategory.dart';
import 'package:muskan_shop/providers/categories_provider.dart';
import 'package:provider/provider.dart';

class Subcategories extends StatefulWidget {
  const Subcategories({Key? key}) : super(key: key);

  @override
  _SubcategoriesState createState() => _SubcategoriesState();
}

class _SubcategoriesState extends State<Subcategories> {
  var _isLoading = false;
  var _isFirstTime = true;

  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isFirstTime) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<CategoriesProvider>(context, listen: false)
          .getAndLoadSubcategoriesAndItems()
          .then((_) => {
                setState(() {
                  _isLoading = false;
                })
              });
    }
    _isFirstTime = false;
    //active category key is already there in provider.
    super.didChangeDependencies();
  }

  void moveToItems(BuildContext context, Subcategory selectedSubcategory) {
    Provider.of<CategoriesProvider>(context, listen: false)
        .activeSubcategoryKey = selectedSubcategory.subcategoryId;

    Provider.of<CategoriesProvider>(context, listen: false)
        .activeSubcategoryName = selectedSubcategory.subcategoryName;

    Navigator.of(context).pushNamed('/items');
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoriesProvider>(context);
    final parentCategoryName = categoryProvider.activeCategoryName;
    final parentCategoryKey = categoryProvider.activeCategoryKey;
    final subCategories = categoryProvider.subCategories;
    return Scaffold(
        backgroundColor: Colors.black54,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.red,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35),
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2),
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                color: Colors.white,
                                iconSize: 20,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )),
                          Flexible(
                            flex: 5,
                            fit: FlexFit.tight,
                            child: Text(
                              parentCategoryName.toString().toUpperCase(),
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                          Flexible(
                              child: IconButton(
                            iconSize: 30,
                            icon: Icon(
                              Icons.shopping_cart,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ))
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 10,
                    child: ListView.builder(
                      itemCount: subCategories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            moveToItems(context, subCategories[index]);
                          },
                          child: Container(
                            height: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              elevation: 15,
                              color: Color.fromRGBO(51, 51, 51, 1),
                              margin:
                                  EdgeInsets.only(left: 30, right: 30, top: 15),
                              child: ListTile(
                                trailing: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  subCategories[index].subcategoryName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}
