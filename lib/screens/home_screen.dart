import 'package:flutter/material.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/screens/products_list_screen.dart';
import 'package:kosher_ar/services/categories_service.dart';
import 'package:kosher_ar/widgets/search_products_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> _productsList=[];

    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showSearch<String>(
                context: context,
                delegate: SearchProductsDelegate(_productsList),
              );
            },
          ),
        ],
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

              _productsList = _data['products'];

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

  Drawer _drawer() {
    // TODO: value, onTopNavigatorPageName
    List<String> _menuOptions = [
      'Supervisaciones',
      'Donaciones',
      'Configuracion',
      'Repostar Bug',
      'Contacto'
    ];
    return Drawer(
      backgroundColor: Colors.orange,
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                'Menu',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          ..._menuOptions
              .map((option) => ListTile(
                    title: Text(option),
                    onTap: () {},
                  ))
              .toList()
        ],
      ),
    );
  }
}
