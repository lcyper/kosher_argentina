import 'package:flutter/material.dart';
import 'package:kosher_ar/models/category.dart';
import 'package:kosher_ar/models/filter.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/screens/barcode_scanner_screen.dart';
import 'package:kosher_ar/screens/products_list_screen.dart';
import 'package:kosher_ar/services/categories_service.dart';
import 'package:kosher_ar/widgets/search_products_delegate.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Product> _productsList = [];

  final List<Filter> productsConfiguration = [
    Filter(
        name: 'Solo Pesaj',
        isActive: false,
        toggleShown: (product, isSelected, activeFilters) {
          // handled in toggleProductsVisibility
          if (isSelected && !product.rubro.contains('Pesaj')) {
            product.hide = true;
          }
        }),
    Filter(
      name: 'Solo Sin Tacc',
      isActive: false,
      toggleShown: (product, isSelected, activeFilters) {
        if (product.sintacc == 'No') {
          product.hide = true;
        }
      },
    ),
    Filter(
      name: 'Solo Mehadrin',
      isActive: false,
      toggleShown: (product, isSelected, activeFilters) {
        if (isSelected) {
          for (Filter filter in activeFilters) {
            if (filter.isActive) {
              if (filter.name == 'B60' ||
                  filter.name == 'Leche en Polvo' ||
                  filter.name == 'Leche Común' ||
                  filter.name == 'Kelim Lacteo') {
                filter.isActive = false;
              }
            }
          }
          if (product.codigoCodigo != 'M') {
            product.hide = true;
          }
        }
      },
    ),
    Filter(
      name: 'B60',
      isActive: true,
      toggleShown: (product, isSelected, activeFilters) {
        if (product.codigoCodigo == 'B60') {
          product.hide = isSelected;
        }
      },
    ),
    Filter(
      name: 'Leche Común',
      isActive: true,
      toggleShown: (product, isSelected, activeFilters) {
        if (isSelected &&
            (product.lecheparveCodigo != 'JI' ||
                product.lecheparveCodigo != 'PARVE')) {
          product.hide = true;
        }
      },
    ),
    Filter(
      name: 'Leche en Polvo',
      isActive: true,
      toggleShown: (product, isSelected, activeFilters) {
        if (product.lecheparveCodigo == 'LP') {
          product.hide = isSelected;
        }
      },
    ),
    Filter(
      name: 'Kelim Lacteo',
      isActive: true,
      toggleShown: (product, isSelected, activeFilters) {
        if (isSelected && product.lecheparveCodigo == 'KL') {
          product.hide = false;
        }
      },
    ),
  ];

  List<Filter> getActiveFilters() {
    List<Filter> activeFilters = [];
    for (Filter filter in productsConfiguration) {
      if (filter.isActive) {
        activeFilters.add(filter);
      }
    }
    return activeFilters;
  }

  bool isFilterPesajActive() {
    final Filter pesajFilter =
        productsConfiguration.firstWhere((filter) => filter.name == 'Pesaj');
    return pesajFilter.isActive;
  }

  toggleShown({
    required List<Product> products,
    required Filter currentFilter,
  }) {
    final bool isSelected = currentFilter.isActive;
    List<Filter> activeFilters = getActiveFilters();
    for (Product product in products) {
      if (product.rubro.contains('NOPUBLICAR')) {
        // hide products that not need to be shown
        continue;
      }
      product.hide = false;
      currentFilter.toggleShown(product, isSelected, activeFilters);
    }
    return products;
  }

  initFilters() {
    final List<Filter> activeFilters = getActiveFilters();
    for (var product in _productsList) {
      if (product.rubro.contains('NOPUBLICAR')) {
        // hide products that not need to be shown
        product.hide = true;
        continue;
      }
      for (Filter filter in activeFilters) {
        filter.toggleShown(product, filter.isActive, activeFilters);
      }
    }
  }

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
          PopupMenuButton(
            position: PopupMenuPosition.under,
            onSelected: choiceAction,
            onCanceled: () {
              print('onCanceled');
            },
            icon: const Icon(Icons.settings),
            itemBuilder: (
              BuildContext context,
            ) {
              final popupMenuItemList = <PopupMenuItem>[];
              for (Filter filter in productsConfiguration) {
                popupMenuItemList.add(PopupMenuItem(
                  // value: filter,
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return SwitchListTile.adaptive(
                        value: filter.isActive,
                        onChanged: (isActive) {
                          filter.isActive = isActive;
                          toggleShown(
                            products: _productsList,
                            currentFilter: filter,
                          );
                          setState(() {});
                        },
                        title: Text(filter.name),
                      );
                    },
                  ),
                ));
              }
              return popupMenuItemList;
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
              initFilters();
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
                                    category: _categoriesList[index],
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
        backgroundColor: Colors.orange,
        shape: const CircleBorder(),
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
