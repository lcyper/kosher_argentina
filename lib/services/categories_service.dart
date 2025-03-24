import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/category_model.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoriesService {
  final Dio _dio = Dio();

  Future<Map> getData() async {
    List categoriesList;
    List productsList;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      categoriesList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/categorias.php');
      productsList =
          await _getDataFromUrl('https://www.kosher.org.ar/api/products.php');

      prefs.setString('categoriesList', jsonEncode(categoriesList)); //await
      prefs.setString('productsList', jsonEncode(productsList)); //await
      debugPrint('Guardando datos en shared preferences');

      List<CategoryModel> categories0 = [];
      for (Map<String, dynamic> map in categoriesList) {
        categories0.add(CategoryModel.fromMap(map));
      }

      List<Product> products0 = [];
      for (Map<String, dynamic> map in productsList) {
        map['supervision'] = 'ajdut_kosher.png';
        map['imagen'] =
            imageValue(map['imagen'], 'https://www.kosher.org.ar/images/');
        products0.add(Product.fromMap(map));
      }

      return {
        'categories': categories0,
        'products': products0,
        'local': false,
      };
    } catch (e) {
      String? categories = prefs.getString('categoriesList');
      String? products = prefs.getString('productsList');

      if (categories != null && products != null) {
        debugPrint('Trayendo datos desde shared preferences');
        categoriesList = jsonDecode(categories);
        productsList = jsonDecode(products);

        List<CategoryModel> categories0 = [];
        for (Map<String, dynamic> map in categoriesList) {
          categories0.add(CategoryModel.fromMap(map));
        }

        List<Product> products0 = [];
        for (Map<String, dynamic> map in productsList) {
          products0.add(Product.fromMap(map));
        }

        return {
          'categories': categories0,
          'products': products0,
          'local': true,
        };
      }

      debugPrint('Error: $e');
      return {'Error': 'Tienes internet? Entonces es un error del Servidor.'};
    }
  }

  Future<List> _getDataFromUrl(String url) async {
    try {
      Response response = await _dio.get(url);
      return jsonDecode(response.data) as List;
    } catch (e) {
      debugPrint(e.toString());
      throw 'Error al traer los datos.';
    }
  }
}
