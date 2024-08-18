import 'package:kosher_ar/models/product.dart';

class Filter {
  final String name;
  bool isActive;
  final void Function(Product product, bool isActive, List<Filter> filters)
      toggleShown;

  Filter({
    required this.name,
    required this.isActive,
    required this.toggleShown,
  });
}
