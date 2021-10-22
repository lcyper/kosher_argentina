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
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _filteredProducts.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(_filteredProducts[index].descripcion),
                  subtitle: Text(
                      '${_filteredProducts[index].marca} - ${_filteredProducts[index].codigoNombre}'),
                  trailing: Image.asset(
                      'assets/iconos_certificaciones/${_filteredProducts[index].supervicion}'),
                  leading: SizedBox(
                    width: 50,
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.fitWidth,
                      placeholder: 'assets/images/loading.gif',
                      image: _filteredProducts[index].imagen,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Container(),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
