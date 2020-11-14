import 'package:get/get.dart';

import 'billete_punto_venta_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BilletePuntoVentaControllerM());
  }
}
