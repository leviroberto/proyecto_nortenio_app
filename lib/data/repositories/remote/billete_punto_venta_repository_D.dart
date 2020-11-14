import 'package:get/get.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/models/billete_punto_venta.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/billete_distribuidor_api_G.dart';
import 'package:proyect_nortenio_app/data/providers/remote/motorizado_perfil_api.dart';

class BilletePuntoVentaRepositoryD {
  final BilletePuntoVentaApiD _api = Get.find<BilletePuntoVentaApiD>();
  final BilleteDistribuidorApiG _apiDistribuidor =
      Get.find<BilleteDistribuidorApiG>();

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> obtenerZonaPorDistribuidor({@required int distribuidor}) {
    return _api.obtenerZonaPorDistribuidor(distribuidor: distribuidor);
  }

  Future<dynamic> obtenerZonaPorMotorizado({@required int motorizado}) {
    return _api.obtenerZonaPorMotorizado(motorizado: motorizado);
  }

  Future<dynamic> billetePorEdicion({@required int edicion}) {
    return _apiDistribuidor.billetePorEdicion(edicion: edicion);
  }

  Future<dynamic> puntoVentas({@required int zona, @required int edicion}) {
    return _api.puntoVentas(zona: zona, edicion: edicion);
  }

  Future<dynamic> motorizados({@required int zona}) {
    return _api.motorizados(
      zona: zona,
    );
  }

  Future<dynamic> billetePuntoVentaPorEdicion(
      {@required int edicion, @required int zona}) {
    return _api.billetePuntoVentaPorEdicion(edicion: edicion, zona: zona);
  }

  Future<dynamic> configuracion() {
    return _api.configuracion();
  }

  Future<dynamic> registrar({@required BilletePuntoVenta billetePuntoVenta}) {
    return _api.registrar(billetePuntoVenta: billetePuntoVenta);
  }

  Future<dynamic> actualizar({@required BilletePuntoVenta billetePuntoVenta}) {
    return _api.actualizar(billetePuntoVenta: billetePuntoVenta);
  }

  Future<dynamic> actualizarRecojo(
      {@required BilletePuntoVenta billetePuntoVenta}) {
    return _api.actualizarRecojo(billetePuntoVenta: billetePuntoVenta);
  }

  Future<dynamic> actualizarEntrega(
      {@required BilletePuntoVenta billetePuntoVenta}) {
    return _api.actualizarEntrega(billetePuntoVenta: billetePuntoVenta);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }

  Future<dynamic> enviarNotificacion(
      {String token, String titulo, String body, dynamic tipo}) {
    return _api.enviarNotificacion(
        token: token, body: body, titulo: titulo, tipo: tipo);
  }
}
