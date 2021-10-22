import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';

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
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            print(_filteredProducts[index].imagen);
            return ListTile(
              title: Text(_filteredProducts[index].descripcion),
              subtitle: Text(_filteredProducts[index].marca),
              leading: FadeInImage.assetNetwork(
                placeholder: '/assets/images/loading.gif',
                image: _filteredProducts[index].imagen,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset('/assets/images/loading.gif'),
              ),
            );
          },
        ),
      ),
    );
  }
}
