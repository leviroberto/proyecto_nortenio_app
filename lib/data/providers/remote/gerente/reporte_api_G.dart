import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../conexion.dart';
import 'package:http/http.dart' as http;

class ReporteApiG {
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

  Future<dynamic> cargarBilletePuntoVentaPorEdicion({int edicion}) async {
    String url = Conexion.conexion() +
        "billete-distribuidor-billete-puntos-venta-reporte/$edicion";
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
