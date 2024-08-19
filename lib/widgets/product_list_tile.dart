import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kosher_ar/models/product.dart';

class ProductListTile extends StatelessWidget {
  final Product product;
  const ProductListTile({
    Key? key,
    required this.product,
  }) : super(key: key);

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
                        product.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.rubro,
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
                    Text(product.codigoNombre),
                    Text(product.lecheparve),
                    Text(product.supervision),
                    Text('Sin Tacc: ${product.sintacc}'),
                  ],
                ),
              ),
            );
          },
          child: ListTile(
            title: Text(product.descripcion),
            subtitle: Column(
              children: [
                Text(
                    '${product.marca} - ${product.codigoNombre} - ${product.lecheparve}'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (product.barcode.length > 6)
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
                                  content: Text(product.barcode),
                                ));
                              },
                              icon: const Icon(
                                  Icons.center_focus_strong_rounded)),
                        ),
                      if (product.sintacc == 'Si')
                        SizedBox(
                          height: 30,
                          child: Image.asset(
                            'assets/iconos/gluten_free.png',
                            fit: BoxFit.fill,
                          ),
                        )
                      // Text(
                      //     'Codigo de Barras: ${product.barcode}'),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Image.asset(
                'assets/iconos_certificaciones/${product.supervision}'),
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
        imageUrl: product.imagen,
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
