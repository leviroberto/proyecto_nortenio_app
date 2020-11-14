import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:proyect_nortenio_app/utils/util.dart';

class PuntoVenta {
  int estado, id;
  final String razonSocial,
      ruc,
      referencia,
      corrreoElectronico,
      telefono,
      celular,
      propietario;
  final Zona zona;
  final Usuario usuario;

  final Geolocalizacion geolocalizacion;

  PuntoVenta(
      {this.id,
      this.razonSocial,
      this.ruc,
      this.referencia,
      this.corrreoElectronico,
      this.telefono,
      this.celular,
      this.propietario,
      this.estado,
      this.usuario,
      this.geolocalizacion,
      this.zona});

  PuntoVenta copyWith({
    int estado,
    int id,
    String razonSocial,
    String ruc,
    String direccion,
    String referencia,
    String corrreoElectronico,
    String telefono,
    String celular,
    String departamento,
    String propietario,
    String provincia,
    String distrito,
    Usuario usuario,
    Geolocalizacion geolocalizacion,
    Zona zona,
  }) {
    return PuntoVenta(
      id: id ?? this.id,
      estado: estado ?? this.estado,
      geolocalizacion: geolocalizacion ?? this.geolocalizacion,
      zona: zona ?? this.zona,
      razonSocial: razonSocial ?? this.razonSocial,
      ruc: ruc ?? this.ruc,
      referencia: referencia ?? this.referencia,
      corrreoElectronico: corrreoElectronico ?? this.corrreoElectronico,
      telefono: telefono ?? this.telefono,
      celular: celular ?? this.celular,
      propietario: propietario ?? this.propietario,
      usuario: usuario ?? this.usuario,
    );
  }

  factory PuntoVenta.fromJson(Map jsonData) {
    return PuntoVenta(
      id: Util.checkInteger(jsonData['id']),
      razonSocial: Util.checkString(jsonData['razon_social']),
      ruc: Util.checkString(jsonData['ruc']),
      referencia: Util.checkString(jsonData['referencia']),
      corrreoElectronico: Util.checkString(jsonData['correo_electronico']),
      telefono: Util.checkString(jsonData['telefono']),
      celular: Util.checkString(jsonData['celular']),
      propietario: Util.checkString(jsonData['propietario']),
      estado: Util.checkInteger(jsonData['estado']),
      geolocalizacion: Geolocalizacion.fromJson(jsonData['geolocalizacion']),
      zona: Zona.fromJson(jsonData['zona']),
    );
  }

  Map toJson() {
    return {
      'id': id,
      'razon_social': razonSocial,
      'ruc': ruc,
      'referencia': referencia,
      'correo_electronico': corrreoElectronico,
      'telefono': telefono,
      'celular': celular,
      'propietario': propietario,
      'estado': estado,
      'geolocalizacion': geolocalizacion.toJson(),
      'zona': zona.toJson(),
    };
  }

  String generarEstado() {
    return estado == 1 ? "Activo" : "Inactivo";
  }

  Color generarEstadoColor() {
    return estado == 1 ? Colors.green : Colors.red;
  }
}
