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
  List<Item> _activeSubcategoryFilteredItems = [];
  List<Item> _activeDirectVarietyItems = [];
  List<Item> _activeDirectVarietyFilteredItems = [];

  List<Subcategory> _subCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Item> get activeDirectVarietyItems {
    return [..._activeDirectVarietyItems];
  }

  List<Item> get activeDirectVarietyFilteredItems {
    return [..._activeDirectVarietyFilteredItems];
  }

  List<Item> get activeSubcategoryFilteredItems {
    return [..._activeSubcategoryFilteredItems];
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

  void filterDirectVariety(String searchFor) {
    if (searchFor == '') {
      _activeDirectVarietyFilteredItems = [..._activeDirectVarietyItems];
      notifyListeners();
      return;
    }
    _activeDirectVarietyFilteredItems = [];
    _activeDirectVarietyFilteredItems = [
      ..._activeDirectVarietyItems
          .where((item) => item.itemName
              .toString()
              .toLowerCase()
              .contains(searchFor.toLowerCase()))
          .toList()
    ];
    notifyListeners();
  }

  void filterSubcategoryItems(String searchFor) {
    if (searchFor == '') {
      _activeSubcategoryFilteredItems = [..._activeSubcategoryItems];
      notifyListeners();
      return;
    }
    _activeSubcategoryFilteredItems = [];
    _activeSubcategoryFilteredItems = [
      ..._activeSubcategoryItems
          .where((item) => item.itemName
              .toString()
              .toLowerCase()
              .contains(searchFor.toLowerCase()))
          .toList()
    ];
    notifyListeners();
  }

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
            itemId: ItemId,
            cakeFlavour: ItemData['cakeFlavour'],
            shopPrice: ItemData['shopPrice'],
            itemName: ItemData['itemName'],
            subcategoryName: ItemData['subcategoryName'],
            imageUrl: ItemData['imageUrl'],
            customerPrice: ItemData['customerPrice'],
            minPounds: ItemData['minPounds'] ==
                    null //cakes me jisme nhi doge ye value , wo infinity , other items will be not-valid and items with min pounds will have the value.
                ? 1
                : ItemData['minPounds'],
            offer: ItemData['offer'],
            designCategory: ItemData['designCategory']));
      });
      _activeDirectVarietyItems = loadedItems;
      _activeDirectVarietyFilteredItems = [..._activeDirectVarietyItems];
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
            itemId: ItemId,
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
      _activeSubcategoryFilteredItems = [..._activeSubcategoryItems];
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
