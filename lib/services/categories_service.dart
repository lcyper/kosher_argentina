import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';

class CategoriesService {
  final Dio _dio = Dio();

  getData() async {
    try {
      List _categoriesList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/categorias.php');
      List _productsList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/products.php');

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
