import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../conexion.dart';
import 'package:http/http.dart' as http;

class MapsApiG {
  Future<dynamic> edicionesPorAnio({@required int anio}) async {
    String url = Conexion.conexion() + "billete-distribuidor/$anio";
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

  Future<dynamic> zonas() async {
    String url = Conexion.conexion() + "zona";
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

  Future<dynamic> billetePuntoVentaPorEdicion(
      {@required int edicion, @required int zona}) async {
    String url = Conexion.conexion() + "billete-punto-venta-por-edicion-maps";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "zona": zona,
            "edicion": edicion,
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
