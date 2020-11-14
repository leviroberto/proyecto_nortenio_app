import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/usuario.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/providers/remote/gerente/distribuidor_api_G.dart';

class DistribuidorRepositoryG {
  final DistribuidorApiG _api = Get.find<DistribuidorApiG>();

  Future<dynamic> usuarios({@required int tipoUsuario, int cantidad}) {
    return _api.usuarios(tipoUsuario: tipoUsuario, cantidad: cantidad);
  }

  Future<dynamic> distribuidores() {
    return _api.distribuidores();
  }

  Future<dynamic> usuariosPorDistribuidor({@required int tipoUsuario}) {
    return _api.usuarios(tipoUsuario: tipoUsuario);
  }

  Future<dynamic> buscarDni({@required String dni}) {
    return _api.buscarDni(dni: dni);
  }

  Future<dynamic> estaRegistradoDni({@required String dni}) {
    return _api.estaRegistradoDni(dni: dni);
  }

  Future<dynamic> registrar({@required Usuario usuario}) {
    return _api.registrar(usuario: usuario);
  }

  Future<dynamic> actualizar({@required Usuario usuario}) {
    return _api.actualizar(usuario: usuario);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }

  Future<dynamic> obtenerZonaPorMotorizado({int distribuidor}) {
    return _api.obtenerZonaPorMotorizado(id: distribuidor);
  }
}
