import 'package:flutter/material.dart';
import 'package:kosher_ar/helpers/debouncer.dart';
import 'package:kosher_ar/helpers/diacritics_aware_string.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class SearchProductsDelegate extends SearchDelegate<String> {
  final List<Product> allProducts;
  final scrollController = ScrollController();
  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));

  List<Product> _filteredProducts = [];
  String _lastQuery = '';

  @override
  void dispose() {
    _debouncer.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  String get searchFieldLabel => 'Nombre/Marca/CodigoDeBarras';

  SearchProductsDelegate(this.allProducts) {
    _filteredProducts = allProducts.where((p) => !p.hide).toList();
  }

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
        close(context, '');
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

  void _performSearch(String searchValue) {
    if (searchValue.isEmpty) {
      _filteredProducts = allProducts.where((p) => !p.hide).toList();
      return;
    }

    if (int.tryParse(searchValue) != null) {
      _filteredProducts = allProducts
          .where((Product product) => product.barcode.contains(searchValue))
          .toList();
    } else {
      _filteredProducts = allProducts.where((Product product) {
        if (product.hide) {
          return false;
        }
        final String fullProductName =
            "${product.descripcion} ${product.marca} ${product.rubro}"
                .withoutDiacriticalMarks
                .toLowerCase();
        final queryWords = searchValue.withoutDiacriticalMarks.split(' ');
        return queryWords
            .every((word) => fullProductName.contains(word.toLowerCase()));
      }).toList();
    }
  }

  Widget _buildList() {
    if (query != _lastQuery) {
      _lastQuery = query;
      _debouncer(() {
        _performSearch(query.trim());
      });
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _debouncer.isRunning,
      builder: (context, isRunning, child) {
        if (isRunning && query.isNotEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_filteredProducts.isEmpty) {
          return const Center(
            child: Text('No hemos encontrado nada.'),
          );
        }

        return Scrollbar(
          controller: scrollController,
          interactive: true,
          radius: const Radius.circular(8),
          thickness: 8,
          child: ListView.builder(
            controller: scrollController,
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) =>
                ProductListTile(product: _filteredProducts[index]),
          ),
        );
      },
    );
  }
}
