import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import '../conexion.dart';
import 'package:http/http.dart' as http;

class BilleteDistribuidorApiG {
  Future<dynamic> billeteDistribuidores({@required int edicion}) async {
    String url = Conexion.conexion() + "billete-distribuidor/$edicion";
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

  Future<dynamic> billetePorEdicion({@required int edicion}) async {
    String url =
        Conexion.conexion() + "billete-distribuidor-por-edicion/$edicion";
    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> billetesPorDistribuidor({@required int edicion}) async {
    String url = Conexion.conexion() + "billetes/$edicion";
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

  Future<dynamic> zonas({int edicion}) async {
    String url = Conexion.conexion() + "billete-distribuidor-zonas/$edicion";
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
    String url = Conexion.conexion() + "billete-distribuidor-ediciones";
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

  Future<dynamic> billetesDistribuidorPorEdicion(
      {@required int edicion}) async {
    String url =
        Conexion.conexion() + "billete-distribuidor-por-edicion/$edicion";
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

  Future<dynamic> billetePuntoVentas({@required int id}) async {
    String url =
        Conexion.conexion() + "billete-distribuidor-billete-puntos-venta/$id";
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

  Future<dynamic> registrar({BilleteDistribuidor billete}) async {
    String url = Conexion.conexion() + "billete-distribuidor-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "fecha": billete.fechaFin,
            "recibo_inicial": billete.reciboInicial,
            "recibo_final": billete.reciboFinal,
            "cantidad_vendida": billete.cantidadVendida,
            "cantidad_devuelto": billete.cantidadDevuelto,
            "porcentaje_descuento": billete.porcentajeDescuento,
            "estado": billete.estado,
            "zonas_id": billete.zona.id,
            "edicions_id": billete.edicion.id,
            "created_by": billete.usuario.id,
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

  Future<dynamic> actualizar({BilleteDistribuidor billete}) async {
    String url = Conexion.conexion() + "billete-distribuidor-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": billete.id,
            "recibo_inicial": billete.reciboInicial,
            "recibo_final": billete.reciboFinal,
            "estado": billete.estado,
            "zonas_id": billete.zona.id,
            "edicions_id": billete.edicion.id,
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

  Future<dynamic> enviarNotificacion(
      {String token, String titulo, String body, dynamic tipo}) async {
    String url = Conexion.conexion() + "enviar-notificacion";
    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "token": token,
            "titulo": titulo,
            "body": body,
            "tipo": tipo,
          }),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  Future<dynamic> eliminar({int id}) async {
    String url = Conexion.conexion() + "billete-distribuidor-eliminar";

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
