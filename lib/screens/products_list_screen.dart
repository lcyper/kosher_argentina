import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class ProductsListScreen extends StatelessWidget {
  final List<Product> products;
  final String categoryId;

  const ProductsListScreen(
      {Key? key, required this.products, required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> _filteredProducts = products
        .where((Product product) => product.rubroId == categoryId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            return ProductListTile(
              filteredProducts: _filteredProducts,
              index: index,
            );
          },
        ),
      ),
    );
  }
}
