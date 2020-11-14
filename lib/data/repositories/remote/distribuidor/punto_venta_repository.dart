import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:proyect_nortenio_app/data/providers/remote/distribuidor/principal_distribuidor_api.dart';

class PrincipalDistribuidorRepository {
  final PrincipalDistribuidorApi _api = Get.find<PrincipalDistribuidorApi>();

  Future<dynamic> ediciones() {
    return _api.ediciones();
  }

  Future<dynamic> datosPrincipal({@required int zona}) {
    return _api.datosPrincipal(zona: zona);
  }

  Future<dynamic> datosPrincipalDistribuidor() {
    return _api.ediciones();
  }
}
