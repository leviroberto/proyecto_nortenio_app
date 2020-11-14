import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';

import 'package:http/http.dart' as http;

import '../conexion.dart';

class MotorizadoApiD {
  Future<dynamic> usuariosPorMotorizado({@required int zona}) async {
    String url = Conexion.conexion() + "zona-motorizado-por-zona";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "zonas_id": zona,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> usuariosPorDistribuidor({int tipoUsuario}) async {
    String url =
        Conexion.conexion() + "obtener-lista-usuarios-por-tipo/$tipoUsuario";
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> estaRegistradoDni({String dni}) async {
    String url = Conexion.conexion() + "esta-registrado-dni/$dni";
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> buscarDni({String dni}) async {
    String url = Conexion.conexion() + "buscarDni/$dni";
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> registrar({ZonaMotorizado zonaMotorizado}) async {
    String url = Conexion.conexion() + "zona-motorizado-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "genero": zonaMotorizado.motorizado.genero,
            "apellidos": zonaMotorizado.motorizado.apellidos,
            "nombre": zonaMotorizado.motorizado.nombre,
            "fecha_nacimiento": zonaMotorizado.motorizado.fechaNacimiento,
            "dni": zonaMotorizado.motorizado.dni,
            "celular": zonaMotorizado.motorizado.celular,
            "direccion": zonaMotorizado.motorizado.direccion,
            "correo_electronico": zonaMotorizado.motorizado.correoElectronico,
            "username": zonaMotorizado.motorizado.username,
            "password": zonaMotorizado.motorizado.password,
            "nombre_completo": zonaMotorizado.motorizado.nombreCompleto,
            "tipo_usuarios_id": zonaMotorizado.motorizado.tipoUsuario.id,
            "zonas_id": zonaMotorizado.zona,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> actualizar({ZonaMotorizado zonaMotorizado}) async {
    String url = Conexion.conexion() + "zona-motorizado-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": zonaMotorizado.motorizado.id,
            "genero": zonaMotorizado.motorizado.genero,
            "apellidos": zonaMotorizado.motorizado.apellidos,
            "nombre": zonaMotorizado.motorizado.nombre,
            "fecha_nacimiento": zonaMotorizado.motorizado.fechaNacimiento,
            "dni": zonaMotorizado.motorizado.dni,
            "celular": zonaMotorizado.motorizado.celular,
            "direccion": zonaMotorizado.motorizado.direccion,
            "correo_electronico": zonaMotorizado.motorizado.correoElectronico,
            "username": zonaMotorizado.motorizado.username,
            "estado": zonaMotorizado.motorizado.estado,
            "nombre_completo": zonaMotorizado.motorizado.nombreCompleto,
            "zonas_motorizado_id": zonaMotorizado.id,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> eliminar({int id}) async {
    String url = Conexion.conexion() + "zona-motorizado-eliminar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": id,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> obtenerZonaPorDistribuidor({int id}) async {
    String url = Conexion.conexion() + "zona-por-distribuidor";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": id,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> obtenerZonaPorMotorizado({int id}) async {
    String url = Conexion.conexion() + "zona-por-motorizado";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": id,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
