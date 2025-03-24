import 'package:flutter/material.dart';
import 'package:kosher_ar/models/category_model.dart';
import 'package:kosher_ar/models/product.dart';
import 'package:kosher_ar/widgets/product_list_tile.dart';

class ProductsListScreen extends StatelessWidget {
  final List<Product> products;
  final CategoryModel category;

  ProductsListScreen({Key? key, required this.products, required this.category})
      : super(key: key);

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Product> filteredProducts = products.where((Product product) {
      if (product.hide) {
        return false;
      }
      return product.rubroId == category.id;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          softWrap: true,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          textScaler: const TextScaler.linear(0.8),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Scrollbar(
          controller: scrollController,
          interactive: true,
          radius: const Radius.circular(8),
          thickness: 8,
          child: ListView.builder(
            controller: scrollController,
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductListTile(product: filteredProducts[index]);
            },
          ),
        ),
      ),
    );
  }
}
