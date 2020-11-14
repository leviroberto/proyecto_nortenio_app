import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/principal_api_G.dart';

class PrincipalRepositoryG {
  final PrincipalApiG _api = Get.find<PrincipalApiG>();

  Future<dynamic> zonas() {
    return _api.zonas();
  }

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> catosPrincipal() {
    return _api.catosPrincipal();
  }

  Future<dynamic> puntoVentasPorZona({int zona}) {
    return _api.puntoVentasPorZona(zona: zona);
  }
}
