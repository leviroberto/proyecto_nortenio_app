import 'dart:convert';

import 'package:proyect_nortenio_app/data/models/edicion.dart';

import '../conexion.dart';
import 'package:http/http.dart' as http;

class EdicionApiG {
  Future<dynamic> ediciones() async {
    String url = Conexion.conexion() + "edicion";
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

  Future<dynamic> registrar({Edicion edicion}) async {
    String url = Conexion.conexion() + "edicion-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "numero": edicion.numero,
            "fecha_inicio": edicion.fechaInicio,
            "fecha_fin": edicion.fechaFin,
            "descripcion": edicion.descripcion,
            "created_by": edicion.usuario.id,
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

  Future<dynamic> actualizar({Edicion edicion}) async {
    String url = Conexion.conexion() + "edicion-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": edicion.id,
            "numero": edicion.numero,
            "fecha_inicio": edicion.fechaInicio,
            "fecha_fin": edicion.fechaFin,
            "estado": edicion.estado,
            "descripcion": edicion.descripcion,
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
    String url = Conexion.conexion() + "edicion-eliminar";

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

  Future verificarEdicionesActivos() async {
    String url = Conexion.conexion() + "edicion-activa";
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
