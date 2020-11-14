import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'conexion.dart';
import 'package:http/http.dart' as http;

class BilletePuntoVentaApiD {
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

  Future<dynamic> puntoVentas(
      {@required int zona, @required int edicion}) async {
    String url = Conexion.conexion() + "billete-punto-venta-punto-ventas";

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

  Future<dynamic> motorizados({@required int zona}) async {
    String url = Conexion.conexion() + "billete-punto-venta-motorizados";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "zona": zona,
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

  Future<dynamic> obtenerZonaPorDistribuidor(
      {@required int distribuidor}) async {
    String url =
        Conexion.conexion() + "punto-venta-zona-por-distribuidor/$distribuidor";
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

  Future<dynamic> obtenerZonaPorMotorizado({@required int motorizado}) async {
    String url =
        Conexion.conexion() + "punto-venta-zona-por-motorizado/$motorizado";
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
    String url = Conexion.conexion() + "billete-punto-venta-por-edicion";

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

  Future<dynamic> configuracion() async {
    String url = Conexion.conexion() + "configuracion-index";
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

  Future<dynamic> registrar({BilletePuntoVenta billetePuntoVenta}) async {
    String url = Conexion.conexion() + "billete-punto-venta-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "recibo_inicial": billetePuntoVenta.reciboInicial,
            "recibo_final": billetePuntoVenta.reciboFinal,
            "zona_motorizados_id": billetePuntoVenta.zonaMotorizado.id,
            "cantidad_vendida": billetePuntoVenta.cantidadVendida,
            "cantidad_devuelto": billetePuntoVenta.cantidadDevuelto,
            "cantidad_extraviada": billetePuntoVenta.cantidadExtraviada,
            "porcentaje_descuento": billetePuntoVenta.porcentajeDescuento,
            "estado": billetePuntoVenta.estado,
            "punto_ventas_id": billetePuntoVenta.puntoVenta.id,
            "edicions_id": billetePuntoVenta.edicion.id,
            "created_by": billetePuntoVenta.usuario.id,
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

  Future<dynamic> actualizar({BilletePuntoVenta billetePuntoVenta}) async {
    String url = Conexion.conexion() + "billete-punto-venta-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": billetePuntoVenta.id,
            "fecha_fin_entrega": billetePuntoVenta.fechaFinEntrega,
            "zona_motorizados_id": billetePuntoVenta.zonaMotorizado.id,
            "recibo_inicial": billetePuntoVenta.reciboInicial,
            "recibo_final": billetePuntoVenta.reciboFinal,
            "cantidad_vendida": billetePuntoVenta.cantidadVendida,
            "cantidad_devuelto": billetePuntoVenta.cantidadDevuelto,
            "cantidad_extraviada": billetePuntoVenta.cantidadExtraviada,
            "porcentaje_descuento": billetePuntoVenta.porcentajeDescuento,
            "estado": billetePuntoVenta.estado,
            "precio_billete_extraviado":
                billetePuntoVenta.precioBilleteExtraviado,
            "precio_billete": billetePuntoVenta.precioBillete,
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

  Future<dynamic> actualizarRecojo(
      {BilletePuntoVenta billetePuntoVenta}) async {
    String url = Conexion.conexion() + "billete-punto-venta-actualizar-recojo";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": billetePuntoVenta.id,
            "fecha_fin_recojo": billetePuntoVenta.fechaIFinRecojo,
            "fecha_inicio_recojo": billetePuntoVenta.fechaInicioRecojo,
            "recibo_inicial": billetePuntoVenta.reciboInicial,
            "recibo_final": billetePuntoVenta.reciboFinal,
            "cantidad_vendida": billetePuntoVenta.cantidadVendida,
            "cantidad_devuelto": billetePuntoVenta.cantidadDevuelto,
            "cantidad_extraviada": billetePuntoVenta.cantidadExtraviada,
            "porcentaje_descuento": billetePuntoVenta.porcentajeDescuento,
            "estado": billetePuntoVenta.estado,
            "precio_billete_extraviado":
                billetePuntoVenta.precioBilleteExtraviado,
            "precio_billete": billetePuntoVenta.precioBillete,
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

  Future<dynamic> actualizarEntrega(
      {BilletePuntoVenta billetePuntoVenta}) async {
    String url = Conexion.conexion() + "billete-punto-venta-actualizar-entrega";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": billetePuntoVenta.id,
            "fecha_fin_entrega": billetePuntoVenta.fechaFinEntrega,
            "fecha_inicio_entrega": billetePuntoVenta.fechaInicioEntrega,
            "recibo_inicial": billetePuntoVenta.reciboInicial,
            "recibo_final": billetePuntoVenta.reciboFinal,
            "estado": billetePuntoVenta.estado,
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
    String url = Conexion.conexion() + "billete-punto-venta-eliminar";

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
}
