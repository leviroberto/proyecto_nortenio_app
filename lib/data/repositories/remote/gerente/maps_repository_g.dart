import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/maps_api_G.dart';

class MapsRepositoryG {
  final MapsApiG _api = Get.find<MapsApiG>();

  Future<dynamic> edicionesPorAnio({@required int anio}) {
    return _api.edicionesPorAnio(anio: anio);
  }

  Future<dynamic> zonas() {
    return _api.zonas();
  }

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> billetePuntoVentaPorEdicion(
      {@required int edicion, @required int zona}) {
    return _api.billetePuntoVentaPorEdicion(edicion: edicion, zona: zona);
  }
}
