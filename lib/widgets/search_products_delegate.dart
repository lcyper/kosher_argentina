import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class SearchProductsDelegate extends SearchDelegate<String> {
  final List<Product> allProducts;

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
    final List<Product> _filteredProducts = allProducts
        .where(
          (Product product) => product.descripcion.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();

    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('No hemos encontrado nada.'),
      );
    }

    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) => ProductListTile(
        filteredProducts: _filteredProducts,
        index: index,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Product> _filteredProducts = allProducts
        .where(
          (Product product) => product.descripcion.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    if (_filteredProducts.isEmpty) {
      return const Center(
        child: Text('No hemos encontrado nada.'),
      );
    }
    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) => ProductListTile(
        filteredProducts: _filteredProducts,
        index: index,
      ),
    );
  }
}
