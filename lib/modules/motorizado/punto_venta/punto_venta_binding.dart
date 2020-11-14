import 'package:get/get.dart';

import 'punto_venta_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PuntoVentaControllerM());
  }
}
