import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  final Dio _dio = Dio();

  getData() async {
    try {
      List _categoriesList;
      List _productsList;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? categories = prefs.getString('categoriesList');
      String? products = prefs.getString('productsList');
      if (categories != null && products != null) {
        debugPrint('Trayendo datos desde shared preferences');
        _categoriesList = jsonDecode(categories);
        _productsList = jsonDecode(products);
      } else {
        _categoriesList = await _getDataFromUrl(
            'https://www.kosher.org.ar/api/categorias.php');
        _productsList =
            await _getDataFromUrl('https://www.kosher.org.ar/api/products.php');

        prefs.setString('categoriesList', jsonEncode(_categoriesList)); //await
        prefs.setString('productsList', jsonEncode(_productsList)); //await
        debugPrint('Guardando datos en shared preferences');
      }

      List<Category> _categories = [];
      for (Map<String, dynamic> map in _categoriesList) {
        _categories.add(Category.fromMap(map));
      }

      List<Product> _products = [];
      for (Map<String, dynamic> map in _productsList) {
        _products.add(Product.fromMap(map));
      }

      return {'categories': _categories, 'products': _products};
    } catch (e) {
      debugPrint('Error: ' + e.toString());
      return e.toString();
    }
  }

  Future<List> _getDataFromUrl(String url) async {
    Response _response = await _dio.get(url);
    return jsonDecode(_response.data) as List;
  }
}
