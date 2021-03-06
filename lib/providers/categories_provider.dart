import 'package:flutter/material.dart';
import 'package:muskan_shop/categories.dart';
import 'package:muskan_shop/models/category.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:muskan_shop/models/designCategory.dart';
import 'package:muskan_shop/models/flavour.dart';
import 'package:muskan_shop/models/subcategory.dart';

import '../models/item.dart';

class CategoriesProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Item> _activeSubcategoryItems = [];
  List<Item> _activeSubcategoryFilteredItems = [];
  List<Item> _activeDirectVarietyItems = [];
  List<Item> _activeDirectVarietyFilteredItems = [];

  List<CakeFlavour> _allFlavours = [];
  List<CakeDesignCategory> _allCakeDesignCategories = [];

  List<Subcategory> _subCategories = [];
  List<String> _flavourNamesOnly = [];

  List<String> get flavourNames {
    return [..._flavourNamesOnly];
  }

  formFlavourNames() {
    _flavourNamesOnly = _allFlavours.map((flvr) => flvr.flavourName!).toList();
  }

  List<Category> get categories {
    return [..._categories];
  }

  List<CakeFlavour> get allFlavours {
    return [..._allFlavours];
  }

  List<CakeDesignCategory> get allDesignCategories {
    return [..._allCakeDesignCategories];
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

  Future<void> getAllCakeFlavours() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/cakeFlavours.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<CakeFlavour> loadedCakeFlavours = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((flavourId, flavourData) {
        loadedCakeFlavours.add(CakeFlavour(
            customerPrice: flavourData['customerPrice'],
            shopPrice: flavourData['shopPrice'],
            flavourName: flavourData['flavourName']));
      });
      _allFlavours = loadedCakeFlavours;
      formFlavourNames();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getAllCakeDesigns() async {
    const url =
        "https://muskan-admin-app-default-rtdb.firebaseio.com/cakeDesignCategories.json";
    try {
      final response = await http.get(Uri.parse(url));
      final List<CakeDesignCategory> loadedCakeDesigns = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((cakeDesignId, cakeDesignData) {
        loadedCakeDesigns.add(CakeDesignCategory(
            customerPrice: cakeDesignData['customerPrice'],
            shopPrice: cakeDesignData['shopPrice'],
            designCategoryName: cakeDesignData['flavourName']));
      });
      _allCakeDesignCategories = loadedCakeDesigns;
      notifyListeners();
    } catch (error) {
      throw error;
    }
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

  dynamic getCakePrice(String selectedFlavour, String designCategoryOfCake,
      dynamic poundsForCake) {
    dynamic price = 0;

    if (selectedFlavour == "ALL FLAVOURS") {
      selectedFlavour = "PINEAPPLE";
    }

    //price due to flavour.
    for (var i = 0; i < _allFlavours.length; i++) {
      if (_allFlavours[i].flavourName.toString().toUpperCase() ==
          selectedFlavour.toString().toUpperCase()) {
        price += _allFlavours[i].shopPrice;
        break;
      }
    }

    //price due to designCategory.
    for (var i = 0; i < _allCakeDesignCategories.length; i++) {
      if (_allCakeDesignCategories[i]
              .designCategoryName
              .toString()
              .toUpperCase() ==
          designCategoryOfCake.toString().toUpperCase()) {
        price += _allCakeDesignCategories[i].shopPrice;
        break;
      }
    }

    // price due to pounds of cake.
    return price * poundsForCake;
  }
}
