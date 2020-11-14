import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/edicion.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/providers/remote/gerente/edicion_api_G.dart';

class EdicionRepositoryG {
  final EdicionApiG _api = Get.find<EdicionApiG>();

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> registrar({@required Edicion edicion}) {
    return _api.registrar(edicion: edicion);
  }

  Future<dynamic> actualizar({@required Edicion edicion}) {
    return _api.actualizar(edicion: edicion);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }

  Future<dynamic> verificarEdicionesActivos() {
    return _api.verificarEdicionesActivos();
  }
}
