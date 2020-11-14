import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/utils/colores.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class ZonaMotorizado {
  final int id, estado;
  final Usuario motorizado;
  final String tipoDocumento;
  final int zona;

  ZonaMotorizado({
    this.tipoDocumento,
    this.id,
    this.motorizado,
    this.estado,
    this.zona,
  });

  ZonaMotorizado copyWith({
    int id,
    int estado,
    String tipoDocumento,
    Usuario motorizado,
    Usuario zona,
  }) {
    return ZonaMotorizado(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      tipoDocumento: tipoDocumento ?? this.tipoDocumento,
      motorizado: motorizado ?? this.motorizado,
      zona: zona ?? this.zona,
    );
  }

  factory ZonaMotorizado.fromJson(Map jsonData) {
    return ZonaMotorizado(
      id: Util.checkInteger(jsonData['id']),
      zona: Util.checkInteger(jsonData['zona']),
      motorizado: Usuario.fromJson(jsonData['motorizado']),
      estado: Util.checkInteger(jsonData['estado']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'zona': zona,
      'motorizado': motorizado.toJson(),
      'estado': estado,
    };
  }

  String generarEstado() {
    return estado == 1 ? "Activo" : "Inactivo";
  }

  Color generarEstadoColor() {
    return estado == 1 ? Colores.colorBody : Colores.colorRojo;
  }
}
