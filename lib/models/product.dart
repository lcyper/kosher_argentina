import 'dart:convert';

String _imageValue(String value) {
  if (value.contains('undefined') || value.contains('null')) {
    return '';
  }
  return 'https://www.kosher.org.ar/images/$value';
}

class Product {
  final String id;
  final String sintacc;
  final String descripcion;
  final String marca;
  final String barcode;
  final String rubroId;
  final String imagen;
  final String codigoNombre;
  final String codigoId;
  final String codigoCodigo;
  final String lecheparveId;
  final String lecheparve;
  final String lecheparveCodigo;
  final String rubro;
  final String supervicion = 'ajdut_kosher.png';
  Product({
    required this.id,
    required this.sintacc,
    required this.descripcion,
    required this.marca,
    required this.barcode,
    required this.rubroId,
    required this.imagen,
    required this.codigoNombre,
    required this.codigoId,
    required this.codigoCodigo,
    required this.lecheparveId,
    required this.lecheparve,
    required this.lecheparveCodigo,
    required this.rubro,
  });

  Product copyWith({
    String? id,
    String? sintacc,
    String? descripcion,
    String? marca,
    String? barcode,
    String? rubroId,
    String? imagen,
    String? codigoNombre,
    String? codigoId,
    String? codigoCodigo,
    String? lecheparveId,
    String? lecheparve,
    String? lecheparveCodigo,
    String? rubro,
  }) {
    return Product(
      id: id ?? this.id,
      sintacc: sintacc ?? this.sintacc,
      descripcion: descripcion ?? this.descripcion,
      marca: marca ?? this.marca,
      barcode: barcode ?? this.barcode,
      rubroId: rubroId ?? this.rubroId,
      imagen: imagen ?? this.imagen,
      codigoNombre: codigoNombre ?? this.codigoNombre,
      codigoId: codigoId ?? this.codigoId,
      codigoCodigo: codigoCodigo ?? this.codigoCodigo,
      lecheparveId: lecheparveId ?? this.lecheparveId,
      lecheparve: lecheparve ?? this.lecheparve,
      lecheparveCodigo: lecheparveCodigo ?? this.lecheparveCodigo,
      rubro: rubro ?? this.rubro,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sintacc': sintacc,
      'descripcion': descripcion,
      'marca': marca,
      'barcode': barcode,
      'rubroId': rubroId,
      'imagen': imagen,
      'codigoNombre': codigoNombre,
      'codigoId': codigoId,
      'codigoCodigo': codigoCodigo,
      'lecheparveId': lecheparveId,
      'lecheparve': lecheparve,
      'lecheparveCodigo': lecheparveCodigo,
      'rubro': rubro,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      sintacc: map['sintacc'] ?? '',
      descripcion: map['descripcion'] ?? '',
      marca: map['marca'] ?? '',
      barcode: map['barcode'] ?? '',
      rubroId: map['rubroId'] ?? '',
      imagen: _imageValue(map['imagen']),
      codigoNombre: map['codigoNombre'] ?? '',
      codigoId: map['codigoId'] ?? '',
      codigoCodigo: map['codigoCodigo'] ?? '',
      lecheparveId: map['lecheparveId'] ?? '',
      lecheparve: map['lecheparve'] ?? '',
      lecheparveCodigo: map['lecheparveCodigo'] ?? '',
      rubro: map['rubro'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id, sintacc: $sintacc, descripcion: $descripcion, marca: $marca, barcode: $barcode, rubroId: $rubroId, imagen: $imagen, codigoNombre: $codigoNombre, codigoId: $codigoId, codigoCodigo: $codigoCodigo, lecheparveId: $lecheparveId, lecheparve: $lecheparve, lecheparveCodigo: $lecheparveCodigo, rubro: $rubro)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.sintacc == sintacc &&
        other.descripcion == descripcion &&
        other.marca == marca &&
        other.barcode == barcode &&
        other.rubroId == rubroId &&
        other.imagen == imagen &&
        other.codigoNombre == codigoNombre &&
        other.codigoId == codigoId &&
        other.codigoCodigo == codigoCodigo &&
        other.lecheparveId == lecheparveId &&
        other.lecheparve == lecheparve &&
        other.lecheparveCodigo == lecheparveCodigo &&
        other.rubro == rubro;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        sintacc.hashCode ^
        descripcion.hashCode ^
        marca.hashCode ^
        barcode.hashCode ^
        rubroId.hashCode ^
        imagen.hashCode ^
        codigoNombre.hashCode ^
        codigoId.hashCode ^
        codigoCodigo.hashCode ^
        lecheparveId.hashCode ^
        lecheparve.hashCode ^
        lecheparveCodigo.hashCode ^
        rubro.hashCode;
  }
}
