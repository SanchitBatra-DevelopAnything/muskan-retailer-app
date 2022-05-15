import 'package:flutter/material.dart';
import 'package:muskan_shop/categories.dart';
import 'package:muskan_shop/models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muskan_shop/models/subcategory.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Subcategory> _subCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Subcategory> get subCategories {
    return [..._subCategories];
  }

  String? activeCategoryKey = '';
  String? activeCategoryName = '';

  Future<void> fetchCategoriesFromDB() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Categories.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Category> loadedCategories = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((categoryId, categoryData) {
        loadedCategories.add(Category(
            id: categoryId,
            categoryName: categoryData['categoryName'],
            imageUrl: categoryData['imageUrl']));
      });
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAndLoadSubcategoriesAndItems() async {
    print("PARENT CATEGORY NAME :" + activeCategoryName.toString());
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Categories/" +
            activeCategoryKey! +
            "/Subcategories.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<Subcategory> loadedSubCategories = [];
      loadedSubCategories.add(Subcategory(
          subcategoryId: activeCategoryKey!,
          subcategoryName: "DIRECT VARIETY"));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        _subCategories = loadedSubCategories;
        notifyListeners();
        return;
      }
      extractedData.forEach((SubCategoryId, SubCategoryData) {
        loadedSubCategories.add(Subcategory(
            subcategoryId: SubCategoryId,
            items: SubCategoryData['Items'],
            subcategoryName:
                SubCategoryData['subcategoryName'].toString().toUpperCase()));
      });
      _subCategories = loadedSubCategories;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  set setactiveCategoryKey(String id) {
    activeCategoryKey = id;
    notifyListeners();
  }

  set setactiveCategoryName(String categoryName) {
    activeCategoryName = categoryName;
    notifyListeners();
  }
}
