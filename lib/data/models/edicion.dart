import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';

class Edicion {
  int id, estado;
  final String descripcion, fechaInicio, fechaFin, numero;
  final Usuario usuario;

  Edicion({
    this.id = -1,
    this.numero = "",
    this.estado = 1,
    this.descripcion = "",
    this.fechaInicio = "",
    this.fechaFin = "",
    this.usuario,
  });

  String formatFecha() {
    return "${this.fechaInicio} hasta ${this.fechaFin}";
  }

  Edicion copyWith({
    int numero,
    int id,
    String estado,
    String descripcion,
    String fechaInicio,
    String fechaFin,
    Usuario usuario,
  }) {
    return Edicion(
        id: id ?? this.id,
        numero: numero ?? this.numero,
        estado: estado ?? this.estado,
        descripcion: descripcion ?? this.descripcion,
        fechaInicio: fechaInicio ?? this.fechaInicio,
        fechaFin: fechaFin ?? this.fechaFin,
        usuario: usuario ?? this.usuario);
  }

  factory Edicion.fromJson(Map jsonData) {
    return Edicion(
      id: jsonData['id'] ?? "",
      numero: jsonData['numero'] ?? "",
      estado: jsonData['estado'] ?? "",
      descripcion: jsonData['descripcion'] ?? "",
      fechaInicio: jsonData['fecha_inicio'] ?? "",
      fechaFin: jsonData['fecha_fin'] ?? "",
    );
  }

  Map toJson() {
    return {
      'id': id,
      'numero': numero,
      'estado': estado,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
    };
  }

  bool estaActivador() {
    return estado == 1;
  }

  String formarFechaInicio() {
    return fechaInicio;
  }

  String formarFechaFin() {
    return fechaFin;
  }

  String formarFecha() {
    return fechaInicio + "  " + fechaFin;
  }

  String formarEstado() {
    return estado == 1 ? 'Activo' : 'Terminado';
  }

  Color formarColor() {
    return estado == 1 ? Colors.green : Colors.red;
  }
}
