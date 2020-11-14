import 'package:get/get.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/models/zonaMotorizado.dart';
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/motorizado_api_D.dart';

class MotorizadoRepositoryD {
  final MotorizadoApiD _api = Get.find<MotorizadoApiD>();

  Future<dynamic> usuariosPorMotorizado({@required int zona}) {
    return _api.usuariosPorMotorizado(zona: zona);
  }

  Future<dynamic> buscarDni({@required String dni}) {
    return _api.buscarDni(dni: dni);
  }

  Future<dynamic> estaRegistradoDni({@required String dni}) {
    return _api.estaRegistradoDni(dni: dni);
  }

  Future<dynamic> registrar({@required ZonaMotorizado zonaMotorizado}) {
    return _api.registrar(zonaMotorizado: zonaMotorizado);
  }

  Future<dynamic> actualizar({@required ZonaMotorizado zonaMotorizado}) {
    return _api.actualizar(zonaMotorizado: zonaMotorizado);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }

  Future<dynamic> obtenerZonaPorDistribuidor({int motorizado}) {
    return _api.obtenerZonaPorDistribuidor(id: motorizado);
  }

  Future<dynamic> obtenerZonaPorMotorizado({int motorizado}) {
    return _api.obtenerZonaPorMotorizado(id: motorizado);
  }
}
