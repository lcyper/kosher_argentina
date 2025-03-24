// To parse this JSON data, do
//
//     final alertModel = alertModelFromJson(jsonString);

// import 'dart:convert';

// List<AlertModel> alertsModelFromJson(String str) => List<AlertModel>.from(json.decode(str).map((x) => AlertModel.fromJson(x)));

// String alertsModelToJson(List<AlertModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlertModel {
    final String descripcion;
    final DateTime fechaUltimaModificacion;
    final String id;
    final String mostrar;
    final String nombre;

    AlertModel({
        required this.descripcion,
        required this.fechaUltimaModificacion,
        required this.id,
        required this.mostrar,
        required this.nombre,
    });

    AlertModel copyWith({
        String? descripcion,
        DateTime? fechaUltimaModificacion,
        String? id,
        String? mostrar,
        String? nombre,
    }) => 
        AlertModel(
            descripcion: descripcion ?? this.descripcion,
            fechaUltimaModificacion: fechaUltimaModificacion ?? this.fechaUltimaModificacion,
            id: id ?? this.id,
            mostrar: mostrar ?? this.mostrar,
            nombre: nombre ?? this.nombre,
        );

    factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        descripcion: json["descripcion"],
        fechaUltimaModificacion: DateTime.parse(json["fechaUltimaModificacion"]),
        id: json["id"],
        mostrar: json["mostrar"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
        "fechaUltimaModificacion": fechaUltimaModificacion.toIso8601String(),
        "id": id,
        "mostrar": mostrar,
        "nombre": nombre,
    };
}
