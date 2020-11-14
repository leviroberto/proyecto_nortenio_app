import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';

import 'package:http/http.dart' as http;

import '../conexion.dart';

class PuntoVentaApiD {
  Future<dynamic> puntoVentas() async {
    String url = Conexion.conexion() + "punto-venta";
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
    String url = Conexion.conexion() + "punto-venta-por-zona/$zona";
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

  Future<dynamic> obtenerZonaPorDistribuidor({int distribuidor}) async {
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

  Future<dynamic> listaMotorizadosYDistribuidores() async {
    String url = Conexion.conexion() + "punto-venta-motorizado-y-distribuidor";
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

  Future<dynamic> registrar({PuntoVenta puntoVenta}) async {
    String url = Conexion.conexion() + "punto-venta-registrar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "razon_social": puntoVenta.razonSocial,
            "ruc": puntoVenta.ruc,
            "correo_electronico": puntoVenta.corrreoElectronico,
            "telefono": puntoVenta.telefono,
            "celular": puntoVenta.celular,
            "propietario": puntoVenta.propietario,
            "referencia": puntoVenta.referencia,
            "estado": puntoVenta.estado,
            "created_by": puntoVenta.usuario.id,
            "zonas_id": puntoVenta.zona != null ? puntoVenta.zona.id : null,
            "created_by": puntoVenta.usuario.id,
            "direccion": puntoVenta.geolocalizacion.direccion,
            "departamento": puntoVenta.geolocalizacion.departamento,
            "provincia": puntoVenta.geolocalizacion.provincia,
            "pais": puntoVenta.geolocalizacion.pais,
            "distrito": puntoVenta.geolocalizacion.distrito,
            "longitud": puntoVenta.geolocalizacion.longitud,
            "latitud": puntoVenta.geolocalizacion.latitud,
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

  Future<dynamic> actualizar({PuntoVenta puntoVenta}) async {
    String url = Conexion.conexion() + "punto-venta-actualizar";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": puntoVenta.id,
            "razon_social": puntoVenta.razonSocial,
            "ruc": puntoVenta.ruc,
            "correo_electronico": puntoVenta.corrreoElectronico,
            "telefono": puntoVenta.telefono,
            "celular": puntoVenta.celular,
            "propietario": puntoVenta.propietario,
            "referencia": puntoVenta.referencia,
            "estado": puntoVenta.estado,
            "created_by": puntoVenta.usuario.id,
            "zonas_id": puntoVenta.zona != null ? puntoVenta.zona.id : null,
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

  Future<dynamic> actualizarGeolocalizacion(
      {@required Geolocalizacion geolocalizacion}) async {
    String url = Conexion.conexion() + "punto-venta-actualizar-geolocalizacion";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "id": geolocalizacion.id,
            "direccion": geolocalizacion.direccion,
            "departamento": geolocalizacion.departamento,
            "provincia": geolocalizacion.provincia,
            "pais": geolocalizacion.pais,
            "distrito": geolocalizacion.distrito,
            "latitud": geolocalizacion.latitud,
            "longitud": geolocalizacion.longitud,
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
    String url = Conexion.conexion() + "punto-venta-eliminar";

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

  Future<dynamic> estaRegistradoRuc({String ruc}) async {
    String url =
        Conexion.conexion() + "punto-venta-verificar-registrado-ruc/$ruc";
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

  Future<dynamic> buscarRuc({String ruc}) async {
    String url = "https://api.sunat.cloud/ruc/$ruc";
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
    String url = Conexion.conexion() + "punto-venta-zonas";
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

  Future<dynamic> provincias({String departamento}) async {
    String url = Conexion.conexion() + "obtener-provincias/$departamento";
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

  Future<dynamic> distritos({int provincia}) async {
    String url = Conexion.conexion() + "obtener-distrito";

    try {
      final http.Response response = await http.post(url,
          body: jsonEncode({
            "provincia": provincia,
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
