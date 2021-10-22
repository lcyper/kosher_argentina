import 'dart:convert';

class Category {
  final String id;
  final String description;
  final String name;

  Category(this.id, this.description, this.name);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': description,
      'nombre': name,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      map['id']??'',
      map['descripcion']??'',
      map['nombre']??'',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}
