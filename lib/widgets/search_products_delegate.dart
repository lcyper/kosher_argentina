import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class SearchProductsDelegate extends SearchDelegate<String> {
  final List<Product> allProducts;

  @override
  final String searchFieldLabel = 'Nombre/Marca/CodigoDeBarras';

  SearchProductsDelegate(this.allProducts);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close_rounded)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    String _searchValue = query;
    _searchValue = _searchValue.trim();

    List<Product> _filteredProducts = [];
    if (int.tryParse(_searchValue) != null) {
      _filteredProducts = allProducts
          .where(
            (Product product) => product.barcode.contains(
              _searchValue,
            ),
          )
          .toList();
    } else {
      _filteredProducts.addAll(allProducts
          .where(
            (Product product) =>
                product.descripcion.toLowerCase().contains(
                      _searchValue.toLowerCase(),
                    ) ||
                product.marca.toLowerCase().contains(
                      _searchValue.toLowerCase(),
                    ),
          )
          .toList());
    }
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('No hemos encontrado nada.'),
      );
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) => ProductListTile(
          filteredProducts: _filteredProducts,
          index: index,
        ),
      ),
    );
  }
}
