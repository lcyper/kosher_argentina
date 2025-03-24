import 'package:flutter/material.dart';
import 'package:kosher_ar/helpers/is_html_empty.dart';
import 'package:kosher_ar/models/category_model.dart';
import 'package:kosher_ar/models/filter_model.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/screens/alerts_screen.dart';
import 'package:kosher_ar/screens/barcode_scanner_screen.dart';
import 'package:kosher_ar/screens/products_list_screen.dart';
import 'package:kosher_ar/services/categories_service.dart';
import 'package:kosher_ar/widgets/search_products_delegate.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<Product> _productsList = [];
  final List<CategoryModel> _categoriesList = [];
  final scrollController = ScrollController();

  List<FilterModel> getActiveFilters() {
    List<FilterModel> activeFilters = [];
    for (FilterModel filter in productsConfiguration) {
      if (filter.isActive) {
        activeFilters.add(filter);
      }
    }
    return activeFilters;
  }

  // bool isFilterPesajActive() {
  //   final Filter pesajFilter =
  //       productsConfiguration.firstWhere((filter) => filter.name == 'Pesaj');
  //   return pesajFilter.isActive;
  // }

  void toggleProductsToShow() {
    for (Product product in _productsList) {
      if (product.rubro.contains('NOPUBLICAR')) {
        // hide products that not need to be shown
        continue;
      }
      product.hide = false;

      for (final FilterModel filter in productsConfiguration) {
        filter.toggleShown(product, filter.isActive);
      }
    }
  }

  initFilters() {
    // final List<Filter> activeFilters = getActiveFilters();
    for (var product in _productsList) {
      if (product.rubro.contains('NOPUBLICAR')) {
        // hide products that not need to be shown
        product.hide = true;
        continue;
      }
      for (FilterModel filter in productsConfiguration) {
        filter.toggleShown(product, filter.isActive);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      showIgnore: false,
      child: Scaffold(
        // drawer: appDrawer(),
        appBar: AppBar(
          title: const Text('Categorias'),
          actions: <Widget>[
            IconButton(
              tooltip: 'Alertas',
              icon: const Icon(Icons.notifications),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlertsScreen(),
                ));
              },
            ),
            IconButton(
              tooltip: 'Buscar',
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearchDelegate(context);
              },
            ),
            PopupMenuButton(
              position: PopupMenuPosition.under,
              onCanceled: () {
                toggleProductsToShow();
              },
              icon: const Icon(Icons.settings),
              itemBuilder: (
                BuildContext context,
              ) {
                final popupMenuItemList = <PopupMenuItem>[];
                for (FilterModel filter in productsConfiguration) {
                  popupMenuItemList.add(PopupMenuItem(
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        filter.setState = setState;
                        return SwitchListTile.adaptive(
                          value: filter.isActive,
                          onChanged: (isActive) {
                            filter.onChange(isActive, productsConfiguration);
                            setState(() {
                              filter.isActive = isActive;
                            });
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
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              if (snapshot.data is Map) {
                Map data = snapshot.data as Map;
                _loadData(context, data);

                return RefreshIndicator(
                  onRefresh: () async {
                    Map data0 = await CategoriesService().getData();
                    _loadData(context, data0);
                  },
                  child: Scrollbar(
                    controller: scrollController,
                    interactive: true,
                    radius: const Radius.circular(8),
                    thickness: 8,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _categoriesList.length,
                      itemBuilder: (context, index) {
                        String text = _categoriesList[index].name;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(text),
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

  void _showIfIsLocal(context, bool isLocal) {
    String content = isLocal
        ? 'Productos Cargados sin Internet'
        : 'Productos Cargados de Internet';
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 2),
    ));
  }

  void _loadData(BuildContext context, Map data) {
    _categoriesList.clear();
    _categoriesList.addAll(data['categories']);
    _productsList.clear();
    _productsList.addAll(data['products']);
    initFilters();
    Future.delayed(const Duration(milliseconds: 500), () {
      _showIfIsLocal(context, data['local']);
    });
    // TODO: mostrar solamente categorias que tengan productos activos. (firstWhere isActive)
    // for (final Category category in _categoriesList) {
    //   try {
    //     _productsList.firstWhere((Product product) =>
    //         product.hide == false && product.rubroId == category.id);
    //   } catch (e) {
    //     category.show = false;
    //   }
    // }
    for (final CategoryModel category in _categoriesList) {
      // añadir la descripcion de cada categoria como un producto.
      if (isHtmlEmpty(category.description) ||
          !category.description.contains(' ')) {
        continue;
      }
      _productsList.insert(
        0,
        Product(
          id: '${category.id}-description',
          sintacc: 'no',
          descripcion: category.description,
          marca: '',
          barcode: '',
          imagen: '',
          codigoNombre: 'Description: ${category.name}',
          codigoId: '',
          codigoCodigo: '',
          lecheparveId: '',
          lecheparve: '',
          lecheparveCodigo: '',
          rubroId: category.id,
          rubro: category.name,
          supervision: 'ajdut_kosher.png',
        ),
      );
    }
  }
}

final List<FilterModel> productsConfiguration = [
  FilterModel(
    name: 'Solo Pesaj',
    isActive: false,
    toggleShown: (product, isActive) {
      // handled in toggleProductsVisibility
      if (isActive && !product.rubro.contains('Pesaj')) {
        product.hide = true;
      }
    },
    onChange: (bool isActive, List<FilterModel> filters) {
      if (isActive) return;
      for (final FilterModel filter in filters) {
        if (filter.name == 'Pesaj: SIN KITNIOT') {
          filter.isActive = false;
          filter.setState!(() {});
        }
      }
    },
  ),
  FilterModel(
    name: 'Pesaj: SIN KITNIOT',
    isActive: false,
    toggleShown: (product, isActive) {
      // handled in toggleProductsVisibility
      if (isActive && !product.marca.contains('SIN KITNIOT')) {
        product.hide = true;
      }
    },
    onChange: (bool isActive, List<FilterModel> filters) {
      if (!isActive) return;
      for (final FilterModel filter in filters) {
        if (filter.name == 'Solo Pesaj') {
          filter.isActive = true;
          filter.setState!(() {});
        }
      }
    },
  ),
  FilterModel(
    name: 'Solo Sin Tacc',
    isActive: false,
    toggleShown: (product, isActive) {
      if (isActive && product.sintacc == 'No') {
        product.hide = true;
      }
    },
    onChange: (bool isActive, List<FilterModel> filters) {},
  ),
  FilterModel(
    name: 'Solo Mehadrin',
    isActive: false,
    toggleShown: (product, isSelected) {
      if (isSelected && product.codigoCodigo != 'M') {
        product.hide = true;
      }
    },
    onChange: (bool isActive, List<FilterModel> filters) {
      if (!isActive) return;
      for (FilterModel filter in filters) {
        if (filter.name == 'Kosher Parve' ||
            filter.name == 'B60' ||
            filter.name == 'Leche Común' ||
            filter.name == 'Leche en Polvo' ||
            filter.name == 'Kelim Lacteo' ||
            filter.name == 'Leche Batel') {
          filter.isActive = false;
          filter.setState!(() {});
        }
      }
    },
  ),
  FilterModel(
    name: 'Kosher Parve',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive &&
          product.lecheparveCodigo == 'PARVE' &&
          product.codigoCodigo.isEmpty) {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
  FilterModel(
    name: 'B60',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive && product.codigoCodigo == 'B60') {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
  FilterModel(
    name: 'Leche Común',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive && (product.lecheparveCodigo == 'LC')) {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
  FilterModel(
    name: 'Leche en Polvo',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive && product.lecheparveCodigo == 'LP') {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
  FilterModel(
    name: 'Kelim Lacteo',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive && product.lecheparveCodigo == 'KL') {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
  FilterModel(
    name: 'Leche Batel',
    isActive: true,
    toggleShown: (product, isActive) {
      if (!isActive && product.lecheparveCodigo == 'LB') {
        product.hide = true;
      }
    },
    onChange: setMehadrinFilterOff,
  ),
];

void setMehadrinFilterOff(bool isActive, List<FilterModel> filters) {
  for (FilterModel filter in filters) {
    if (filter.name == 'Solo Mehadrin') {
      filter.isActive = false;
      filter.setState!(() {});
    }
  }
}
