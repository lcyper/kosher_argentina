import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile({
    Key? key,
    required List<Product> filteredProducts,
    required int index
  }) : _filteredProducts = filteredProducts,_index=index, super(key: key);

  final List<Product> _filteredProducts;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(_filteredProducts[_index].descripcion),
          subtitle: Text(
              '${_filteredProducts[_index].marca} - ${_filteredProducts[_index].codigoNombre}'),
          trailing: Image.asset(
              'assets/iconos_certificaciones/${_filteredProducts[_index].supervicion}'),
          leading: SizedBox(
            width: 50,
            child: FadeInImage.assetNetwork(
              fit: BoxFit.fitWidth,
              placeholder: 'assets/images/loading.gif',
              image: _filteredProducts[_index].imagen,
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
  }
}