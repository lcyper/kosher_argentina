import 'package:flutter/material.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/screens/products_list_screen.dart';
import 'package:kosher_ar/services/categories_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: CategoriesService().getData(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data is Map) {
              Map _data = snapshot.data as Map;
              _data['categories'];
              // _data.containsKey('categories');
              List<Category> _categoriesList = _data['categories'];

              List<Product> _productsList = _data['products'];

              return ListView.builder(
                itemCount: _categoriesList.length,
                itemBuilder: (context, index) {
                  String _text = _categoriesList[index].name;
                  return Column(
                    children: [
                      ListTile(
                        title: Text(_text),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductsListScreen(
                                products: _productsList,
                                categoryId: _categoriesList[index].id,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        height: 0,
                      ),
                    ],
                  );
                },
              );
            }
            return Center(child: Text('Error: ${snapshot.data}'));
          },
        ),
      ),
    );
  }
}
