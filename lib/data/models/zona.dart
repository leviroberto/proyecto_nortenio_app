import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class Zona {
  final int id, estado;
  final String zona, descripcion;
  final Usuario distribuidor;
  final Usuario usuario;

  final List<ZonaMotorizado> listaMotorizado;

  Zona(
      {this.id,
      this.zona,
      this.descripcion,
      this.estado,
      this.listaMotorizado,
      this.usuario,
      this.distribuidor});

  Zona copyWith({
    int id,
    int estado,
    String zona,
    String descripcion,
    List<ZonaMotorizado> listaMotorizado,
    Usuario distribuidor,
    Usuario usuario,
  }) {
    return Zona(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      zona: zona ?? this.zona,
      descripcion: descripcion ?? this.descripcion,
      listaMotorizado: listaMotorizado ?? this.listaMotorizado,
      distribuidor: distribuidor ?? this.distribuidor,
      usuario: usuario ?? this.usuario,
    );
  }

  factory Zona.fromJson(Map jsonData) {
    return Zona(
      id: Util.checkInteger(jsonData['id']),
      zona: Util.checkString(jsonData['zona']),
      descripcion: jsonData['descripcion'] ?? "",
      distribuidor: jsonData['distribuidor'] != null
          ? Usuario.fromJson(jsonData['distribuidor'])
          : null,
      estado: Util.checkInteger(jsonData['estado']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'zona': zona,
      'descripcion': descripcion,
      'distribuidor': distribuidor.toJson(),
      'estado': estado,
    };
  }

  String generarEstado() {
    return estado == 1 ? 'Activo' : 'Inactivo';
  }

  Color generarEstadoColor() {
    return estado == 1 ? Colores.colorBody : Colores.colorRojo;
  }
}
