import 'dart:convert';

import 'package:proyect_nortenio_app/data/models/zona.dart';

import '../conexion.dart';
import 'package:http/http.dart' as http;

class ZonaApiG {
  Future<dynamic> zonas({int pagina}) async {
    String url = Conexion.conexion() + "zona/$pagina";
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
    String url = Conexion.conexion() + "zona-distribuidor";
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

  Future<dynamic> registrar({Zona zona}) async {
    String url = Conexion.conexion() + "zona-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "zona": zona.zona,
            "descripcion": zona.descripcion,
            "estado": zona.estado,
            "distribuidores_id":
                zona.distribuidor != null ? zona.distribuidor.id : null,
            "created_by": zona.usuario.id,
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

  Future<dynamic> actualizar({Zona zona}) async {
    String url = Conexion.conexion() + "zona-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": zona.id,
            "zona": zona.zona,
            "descripcion": zona.descripcion,
            "estado": zona.estado,
            "distribuidores_id":
                zona.distribuidor != null ? zona.distribuidor.id : null,
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
    String url = Conexion.conexion() + "zona-eliminar";

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
