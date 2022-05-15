import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoriesProvider>(context);
    final parentCategoryName = categoryProvider.activeCategoryName;
    final parentCategoryKey = categoryProvider.activeCategoryKey;
    final subCategories = categoryProvider.subCategories;
    return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: Text(
            parentCategoryName.toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  color: Colors.red,
                ),
              )
            : ListView.builder(
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 100,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 15,
                      color: Color.fromRGBO(51, 51, 51, 1),
                      margin: EdgeInsets.only(left: 30, right: 30, top: 15),
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
                  );
                },
              ));
  }
}
