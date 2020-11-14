import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/billete_distribuidor_.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/providers/remote/gerente/billete_distribuidor_api_G.dart';

class BilleteDistribuidorRepositoryG {
  final BilleteDistribuidorApiG _api = Get.find<BilleteDistribuidorApiG>();

  Future<dynamic> billetes({@required int edicion}) {
    return _api.billeteDistribuidores(edicion: edicion);
  }

  Future<dynamic> billetesPorDistribuidor({@required int edicion}) {
    return _api.billeteDistribuidores(edicion: edicion);
  }

  Future<dynamic> billetePorEdicion({@required int edicion}) {
    return _api.billetePorEdicion(edicion: edicion);
  }

  Future<dynamic> zonas({int edicion}) {
    return _api.zonas(edicion: edicion);
  }

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> billetesDistribuidorPorEdicion({@required int edicion}) {
    return _api.billetesDistribuidorPorEdicion(edicion: edicion);
  }

  Future<dynamic> billetePuntoVentas({@required int id}) {
    return _api.billetePuntoVentas(id: id);
  }

  Future<dynamic> registrar({@required BilleteDistribuidor billete}) {
    return _api.registrar(billete: billete);
  }

  Future<dynamic> enviarNotificacion(
      {String token, String titulo, String body, dynamic tipo}) {
    return _api.enviarNotificacion(
        token: token, body: body, titulo: titulo, tipo: tipo);
  }

  Future<dynamic> actualizar({@required BilleteDistribuidor billete}) {
    return _api.actualizar(billete: billete);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }
}
