import 'package:get/get.dart';

import 'zona_controller.dart';

class DistribuidorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ZonaControllerG());
  }
}
