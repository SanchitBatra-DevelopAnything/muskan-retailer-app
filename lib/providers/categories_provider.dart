import 'package:flutter/material.dart';
import 'package:muskan_shop/categories.dart';
import 'package:muskan_shop/models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muskan_shop/models/subcategory.dart';

import '../models/item.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Item> _activeSubcategoryItems = [];
  List<Item> _activeDirectVarietyItems = [];

  List<Subcategory> _subCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Item> get activeDirectVarietyItems {
    return [..._activeDirectVarietyItems];
  }

  List<Subcategory> get subCategories {
    return [..._subCategories];
  }

  List<Item> get activeSubcategoryItems {
    return [..._activeSubcategoryItems];
  }

  String? activeCategoryKey = '';
  String? activeCategoryName = '';

  String? activeSubcategoryKey = '';
  String? activeSubcategoryName = '';

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

  Future<void> getItemsForDirectVariety() async {
    _activeDirectVarietyItems = [];
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Categories/" +
            activeCategoryKey! +
            "/Items.json";

    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final List<Item> loadedItems = [];
      if (response.body == null) {
        _activeDirectVarietyItems = [];
        notifyListeners();
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((ItemId, ItemData) {
        loadedItems.add(Item(
            cakeFlavour: ItemData['cakeFlavour'],
            shopPrice: ItemData['shopPrice'],
            itemName: ItemData['itemName'],
            subcategoryName: ItemData['subcategoryName'],
            imageUrl: ItemData['imageUrl'],
            customerPrice: ItemData['customerPrice'],
            minPounds: ItemData['minPounds'],
            offer: ItemData['offer'],
            designCategory: ItemData['designCategory']));
      });
      _activeDirectVarietyItems = loadedItems;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> getItemsForSubcategory() async {
    var url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/Categories/" +
            activeCategoryKey! +
            "/Subcategories/" +
            activeSubcategoryKey! +
            "/Items.json";

    print(url);
    try {
      final response = await http.get(Uri.parse(url));
      final List<Item> loadedItems = [];
      if (response.body == null) {
        _activeSubcategoryItems = [];
        notifyListeners();
        return;
      }
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((ItemId, ItemData) {
        loadedItems.add(Item(
            cakeFlavour: ItemData['cakeFlavour'],
            shopPrice: ItemData['shopPrice'],
            itemName: ItemData['itemName'],
            subcategoryName: ItemData['subcategoryName'],
            imageUrl: ItemData['imageUrl'],
            customerPrice: ItemData['customerPrice'],
            minPounds: ItemData['minPounds'],
            offer: ItemData['offer'],
            designCategory: ItemData['designCategory']));
      });
      _activeSubcategoryItems = loadedItems;
      notifyListeners();
    } catch (error) {
      print(error);
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

  set setActiveSubcategoryKey(String id) {
    activeSubcategoryKey = id;
    notifyListeners();
  }

  set setActiveSubcategoryName(String categoryName) {
    activeSubcategoryName = categoryName;
    notifyListeners();
  }
}
