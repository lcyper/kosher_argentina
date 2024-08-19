import 'package:flutter/material.dart';
import 'package:kosher_ar/helpers/diacritics_aware_string.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class SearchProductsDelegate extends SearchDelegate<String> {
  final List<Product> allProducts;

  @override
  String get searchFieldLabel => 'Nombre/Marca/CodigoDeBarras';

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
    return IconButton(
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
    // TODO: add debounce

    List<Product> _filteredProducts = [];
    if (int.tryParse(_searchValue) != null) {
      // the _searchValue is a barcode.
      _filteredProducts = allProducts
          .where(
            (Product product) => product.barcode.contains(
              _searchValue,
            ),
          )
          .toList();
    } else {
      // search by product name-description
      _filteredProducts = allProducts.where(
        (Product product) {
          if (product.hide) {
            return false;
          }
          final String fullProductName =
              "${product.descripcion} ${product.marca} ${product.rubro}"
                  .withoutDiacriticalMarks
                  .toLowerCase();
          // Divide la consulta en palabras
          final queryWords = _searchValue.withoutDiacriticalMarks.split(' ');
          // Verifica si todas las palabras de la consulta están
          return queryWords.every((word) => fullProductName.contains(word));
        },
      ).toList();
    }
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('No hemos encontrado nada.'),
      );
    }

    return Scrollbar(
      child: ListView.builder(
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) =>
            ProductListTile(product: _filteredProducts[index]),
      ),
    );
  }
}
