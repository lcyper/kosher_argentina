import 'package:flutter/material.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/screens/barcode_scanner_screen.dart';
import 'package:kosher_ar/screens/products_list_screen.dart';
import 'package:kosher_ar/services/categories_service.dart';
import 'package:kosher_ar/widgets/search_products_delegate.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Product> _productsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _drawer(),
      appBar: AppBar(
        title: const Text('Categorias'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearchDelegate(context);
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
              _productsList.clear();
              _productsList.addAll(_data['products']);
              // _showIfIsLocal(context, _data['local']);

              return RefreshIndicator(
                onRefresh: () async {
                  var _data = await CategoriesService().getData();
                  if (_data is Map) {
                    _categoriesList = _data['categories'];
                    _productsList.clear();
                    _productsList.addAll(_data['products']);
                    _showIfIsLocal(context, _data['local']);
                  }
                },
                child: Scrollbar(
                  child: ListView.builder(
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
                  ),
                ),
              );
            }
            return Center(child: Text('Error: ${snapshot.data}'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String barcodeScanResponse = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BarcodeScannerScreen(),
                  )) ??
              '';
          if (barcodeScanResponse.length > 6) {
            showSearchDelegate(context, barcodeScanResponse);
          }
        },
        tooltip: 'Barcode Scann',
        child: const Icon(
          Icons.center_focus_strong_rounded,
          size: 36,
          color: Colors.white,
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
      // backgroundColor: Colors.orange,
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

  showSearchDelegate(context, [String query = '']) async {
    await showSearch<String>(
      context: context,
      query: query,
      delegate: SearchProductsDelegate(_productsList),
    );
  }

  void _showIfIsLocal(context, bool _isLocal) {
    String _content = _isLocal ? 'Datos locales' : 'Datos de Internet';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_content),
      duration: const Duration(seconds: 2),
    ));
  }
}
