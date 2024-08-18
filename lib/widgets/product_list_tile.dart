import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(
      {Key? key, required List<Product> filteredProducts, required int index})
      : _filteredProducts = filteredProducts,
        _index = index,
        super(key: key);

  final List<Product> _filteredProducts;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            await showDialog(
              barrierLabel: 'Imagen',
              context: context,
              builder: (context) => AlertDialog(
                title: Center(
                  child: Column(
                    children: [
                      Text(
                        _filteredProducts[_index].descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _filteredProducts[_index].rubro,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.w200),
                        overflow: TextOverflow.ellipsis,
                        textScaler: const TextScaler.linear(0.7),
                      ),
                    ],
                  ),
                ),
                contentPadding: const EdgeInsets.all(18),
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 100,
                ),
                content: Column(
                  children: [
                    SizedBox(height: 300, child: _productImage()),
                    Text(_filteredProducts[_index].codigoNombre),
                    Text(_filteredProducts[_index].lecheparve),
                    Text(_filteredProducts[_index].supervision),
                    Text('Sin Tacc: ${_filteredProducts[_index].sintacc}'),
                  ],
                ),
              ),
            );
          },
          child: ListTile(
            title: Text(_filteredProducts[_index].descripcion),
            subtitle: Column(
              children: [
                Text(
                    '${_filteredProducts[_index].marca} - ${_filteredProducts[_index].codigoNombre} - ${_filteredProducts[_index].lecheparve}'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_filteredProducts[_index].barcode.length > 6)
                        SizedBox(
                          height: 30,
                          child: IconButton(
                              iconSize: 30,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content:
                                      Text(_filteredProducts[_index].barcode),
                                ));
                              },
                              icon: const Icon(
                                  Icons.center_focus_strong_rounded)),
                        ),
                      if (_filteredProducts[_index].sintacc == 'Si')
                        SizedBox(
                          height: 30,
                          child: Image.asset(
                            'assets/iconos/gluten_free.png',
                            fit: BoxFit.fill,
                          ),
                        )
                      // Text(
                      //     'Codigo de Barras: ${_filteredProducts[_index].barcode}'),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Image.asset(
                'assets/iconos_certificaciones/${_filteredProducts[_index].supervision}'),
            leading: SizedBox(
              width: 50,
              child: _productImage(),
            ),

            // contentPadding:
            //     const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _productImage() => CachedNetworkImage(
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => Image.asset('assets/images/loading.gif'),
        imageUrl: _filteredProducts[_index].imagen,
        errorWidget: (context, url, error) => Container(),
        imageBuilder: (context, imageProvider) =>
            _imageBoxWidget(imageProvider),
      );

  Widget _imageBoxWidget(ImageProvider<Object> imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.scaleDown,
          ),
        ),
      );
}
