import 'dart:convert';
import '../conexion.dart';
import 'package:http/http.dart' as http;

class PrincipalApiG {
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

  Future<dynamic> catosPrincipal() async {
    String url = Conexion.conexion() + "datos-prinicpal-gerente";
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

  Future<dynamic> puntoVentasPorZona({int zona}) async {
    String url = Conexion.conexion() + "punto-venta-por-zona-contar/$zona";
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
