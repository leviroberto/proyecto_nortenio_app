import 'dart:convert';

import 'package:flutter/material.dart';

import '../conexion.dart';
import 'package:http/http.dart' as http;

class PrincipalDistribuidorApi {
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

  Future<dynamic> datosPrincipal({@required int zona}) async {
    String url = Conexion.conexion() + "datos-principal-distribuidor/$zona";
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

  Future<dynamic> datosPrincipalDistribuidor() async {
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
}
