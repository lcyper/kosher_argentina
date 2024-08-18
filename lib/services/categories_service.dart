import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  final Dio _dio = Dio();

  Future<Map> getData() async {
    List _categoriesList;
    List _productsList;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      _categoriesList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/categorias.php');
      _productsList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/products.php');

      prefs.setString('categoriesList', jsonEncode(_categoriesList)); //await
      prefs.setString('productsList', jsonEncode(_productsList)); //await
      debugPrint('Guardando datos en shared preferences');

      List<Category> _categories = [];
      for (Map<String, dynamic> map in _categoriesList) {
        _categories.add(Category.fromMap(map));
      }

      List<Product> _products = [];
      for (Map<String, dynamic> map in _productsList) {
        map['supervicion'] = 'ajdut_kosher.png';
        map['imagen'] =
            imageValue(map['imagen'], 'https://www.kosher.org.ar/images/');
        _products.add(Product.fromMap(map));
      }

      return {'categories': _categories, 'products': _products, 'local': false};
    } catch (e) {
      String? categories = prefs.getString('categoriesList');
      String? products = prefs.getString('productsList');

      if (categories != null && products != null) {
        debugPrint('Trayendo datos desde shared preferences');
        _categoriesList = jsonDecode(categories);
        _productsList = jsonDecode(products);

        List<Category> _categories = [];
        for (Map<String, dynamic> map in _categoriesList) {
          _categories.add(Category.fromMap(map));
        }

        List<Product> _products = [];
        for (Map<String, dynamic> map in _productsList) {
          _products.add(Product.fromMap(map));
        }

        return {
          'categories': _categories,
          'products': _products,
          'local': true
        };
      }

      debugPrint('Error: ' + e.toString());
      return {'Error': 'Tienes internet? Entonces es un error del Servidor.'};
    }
  }

  Future<List> _getDataFromUrl(String url) async {
    Response _response = await _dio.get(url);
    return jsonDecode(_response.data) as List;
  }
}
