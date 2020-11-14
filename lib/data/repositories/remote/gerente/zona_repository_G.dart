import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/models/zona.dart';
import 'package:meta/meta.dart' show required;
import 'package:proyect_nortenio_app/data/providers/remote/gerente/zona_api_G.dart';

class ZonaRepositoryG {
  final ZonaApiG _api = Get.find<ZonaApiG>();

  Future<dynamic> zonas({@required int pagina}) {
    return _api.zonas(pagina: pagina);
  }

  Future<dynamic> distribuidores() {
    return _api.distribuidores();
  }

  Future<dynamic> registrar({@required Zona zona}) {
    return _api.registrar(zona: zona);
  }

  Future<dynamic> actualizar({@required Zona zona}) {
    return _api.actualizar(zona: zona);
  }

  Future<dynamic> eliminar({@required int id}) {
    return _api.eliminar(id: id);
  }
}
