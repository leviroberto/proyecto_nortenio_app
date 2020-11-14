import 'dart:convert';

import 'package:proyect_nortenio_app/data/models/usuario.dart';

import '../conexion.dart';
import 'package:http/http.dart' as http;

class DistribuidorApiG {
  Future<dynamic> usuarios({int tipoUsuario, int cantidad}) async {
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

  Future<dynamic> distribuidores() async {
    String url = Conexion.conexion() + "usuario-distribuidor";
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

  Future<dynamic> registrar({Usuario usuario}) async {
    String url = Conexion.conexion() + "usuario-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "genero": usuario.genero,
            "tipo_documento": usuario.tipoDocumento,
            "apellidos": usuario.apellidos,
            "nombre": usuario.nombre,
            "fecha_nacimiento": usuario.fechaNacimiento,
            "dni": usuario.dni,
            "celular": usuario.celular,
            "direccion": usuario.direccion,
            "correo_electronico": usuario.correoElectronico,
            "username": usuario.username,
            "password": usuario.password,
            "nombre_completo": usuario.nombreCompleto,
            "tipo_usuarios_id": usuario.tipoUsuario.id,
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

  Future<dynamic> actualizar({Usuario usuario}) async {
    String url = Conexion.conexion() + "usuario-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": usuario.id,
            "genero": usuario.genero,
            "apellidos": usuario.apellidos,
            "nombre": usuario.nombre,
            "fecha_nacimiento": usuario.fechaNacimiento,
            "tipo_documento": usuario.tipoDocumento,
            "dni": usuario.dni,
            "celular": usuario.celular,
            "direccion": usuario.direccion,
            "correo_electronico": usuario.correoElectronico,
            "username": usuario.username,
            "estado": usuario.estado,
            "nombre_completo": usuario.nombreCompleto,
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
    String url = Conexion.conexion() + "usuario-eliminar";

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
    String url = Conexion.conexion() + "usuario-zona-por-motorizado/$id";
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
}
