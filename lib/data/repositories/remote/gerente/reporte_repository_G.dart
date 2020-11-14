import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/remote/gerente/reporte_api_G.dart';

class ReporteRepositoryG {
  final ReporteApiG _api = Get.find<ReporteApiG>();

  Future<dynamic> edicionesPorAnio({@required int anio}) {
    return _api.edicionesPorAnio(anio: anio);
  }

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> cargarBilletePuntoVentaPorEdicion({@required int edicion}) {
    return _api.cargarBilletePuntoVentaPorEdicion(edicion: edicion);
  }
}
