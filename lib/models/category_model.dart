import 'dart:convert';

class CategoryModel {
  final String id;
  final String description;
  final String name;
  bool show = true;

  CategoryModel(this.id, this.description, this.name, this.show);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': description,
      'nombre': name,
      'show': show,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      map['id'] ?? '',
      map['descripcion'] ?? '',
      map['nombre'] ?? '',
      map['show'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));
}
