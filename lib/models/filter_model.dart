import 'package:flutter/cupertino.dart';
import 'package:kosher_ar/models/product.dart';

class FilterModel {
  final String name;
  bool isActive;
  final void Function(Product product, bool isActive) toggleShown;
  final void Function(bool isActive, List<FilterModel> filters) onChange;
  StateSetter? setState;

  FilterModel({
    required this.name,
    required this.isActive,
    required this.toggleShown,
    required this.onChange,
  });

}
