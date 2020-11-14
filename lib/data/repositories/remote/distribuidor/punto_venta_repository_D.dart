import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/geolocalizacion.dart';
import 'package:proyect_nortenio_app/data/models/punto_venta.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/punto_venta_api_D.dart';

class PuntoVentaRepositoryD {
  final PuntoVentaApiD _api = Get.find<PuntoVentaApiD>();

  Future<dynamic> puntoVentas() {
    return _api.puntoVentas();
  }

  Future<dynamic> puntoVentasPorZona({@required int zona}) {
    return _api.puntoVentasPorZona(zona: zona);
  }

  Future<dynamic> obtenerZonaPorDistribuidor({@required int distribuidor}) {
    return _api.obtenerZonaPorDistribuidor(distribuidor: distribuidor);
  }

  Future<dynamic> listaMotorizadosYDistribuidores() {
    return _api.listaMotorizadosYDistribuidores();
  }

  Future<dynamic> registrar({@required PuntoVenta puntoVenta}) {
    return _api.registrar(puntoVenta: puntoVenta);
  }

  Future<dynamic> actualizar({@required PuntoVenta puntoVenta}) {
    return _api.actualizar(puntoVenta: puntoVenta);
  }

  Future<dynamic> actualizarGeolocalizacion(
      {@required Geolocalizacion geolocalizacion}) {
    return _api.actualizarGeolocalizacion(geolocalizacion: geolocalizacion);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }

  Future<dynamic> estaRegistradoRuc({String ruc}) {
    return _api.estaRegistradoRuc(ruc: ruc);
  }

  Future<dynamic> buscarRuc({String ruc}) {
    return _api.buscarRuc(ruc: ruc);
  }

  Future<dynamic> zonas() {
    return _api.zonas();
  }

  Future<dynamic> provincias({String departamento}) {
    return _api.provincias(departamento: departamento);
  }

  Future<dynamic> distritos({int provincia}) {
    return _api.distritos(provincia: provincia);
  }
}
