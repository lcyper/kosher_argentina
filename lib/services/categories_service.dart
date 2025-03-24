import 'package:kosher_ar/helpers/get_data_from_url.dart';
import 'package:kosher_ar/models/category_model.dart';
import 'package:kosher_ar/models/product.dart';

class CategoriesService {
  Future<Map> getData() async {
    List categoriesList;
    List productsList;

    categoriesList = await getDataFromUrl<List>(
        'https://www.kosher.org.ar/api/categorias.php');
    productsList = await getDataFromUrl<List>(
        'https://www.kosher.org.ar/api/products.php');

    List<CategoryModel> categories = [];
    for (Map<String, dynamic> map in categoriesList) {
      categories.add(CategoryModel.fromMap(map));
    }

    List<Product> products = [];
    for (Map<String, dynamic> map in productsList) {
      map['supervision'] = 'ajdut_kosher.png';
      map['imagen'] =
          imageValue(map['imagen'], 'https://www.kosher.org.ar/images/');
      products.add(Product.fromMap(map));
    }

    return {
      'categories': categories,
      'products': products,
      'local': false,
    };
  }
}
