import 'package:get/get.dart';

import 'reporte_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReporteControllerg());
  }
}
